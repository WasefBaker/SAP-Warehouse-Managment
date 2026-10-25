
CLASS zcl_wm_putaway_engine DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_recommendation,
        bin_id         TYPE zwm_storage_bin-bin_id,
        free_capacity  TYPE i,
        remaining      TYPE i,
        incoming_weight TYPE p LENGTH 15 DECIMALS 3,
        reason          TYPE string,
      END OF ty_recommendation.

    METHODS recommend_bin
      IMPORTING
        iv_quantity TYPE i
      RETURNING
        VALUE(rs_result) TYPE ty_recommendation.

    METHODS recommend_for_material
      IMPORTING
         iv_material_id TYPE zwm_material-material_id
         iv_quantity    TYPE i
      RETURNING
         VALUE(rs_result) TYPE ty_recommendation.

    TYPES:
      BEGIN OF ty_bin_check,
        free_capacity    TYPE i,
        max_weight_kg    TYPE i,
        used_weight_kg   TYPE i,
        allowed_category TYPE char10,
      END OF ty_bin_check.

CLASS-METHODS is_bin_suitable
  IMPORTING
    iv_quantity      TYPE i
    iv_unit_weight   TYPE i
    iv_category      TYPE char10
    is_bin           TYPE ty_bin_check
  RETURNING
    VALUE(rv_suitable) TYPE abap_bool.


TYPES:
  BEGIN OF ty_bin_analysis,
    bin_id       TYPE zwm_storage_bin-bin_id,
    status       TYPE char10,
    reason       TYPE string,
    free_capacity TYPE i,
    remaining    TYPE i,
  END OF ty_bin_analysis.

TYPES tt_bin_analysis
  TYPE STANDARD TABLE OF ty_bin_analysis
  WITH EMPTY KEY.

METHODS analyze_putaway
  IMPORTING
    iv_material_id TYPE zwm_material-material_id
    iv_quantity    TYPE i
  RETURNING
    VALUE(rt_analysis) TYPE tt_bin_analysis.


ENDCLASS.


CLASS zcl_wm_putaway_engine IMPLEMENTATION.

  METHOD recommend_bin.

    CLEAR rs_result.

    IF iv_quantity <= 0.
      RETURN.
    ENDIF.

    SELECT FROM zwm_storage_bin AS bin
      LEFT OUTER JOIN zwm_stock AS stock
        ON bin~bin_id = stock~bin_id

      FIELDS
        bin~bin_id AS bin_id,
        bin~capacity AS capacity,
        SUM( stock~quantity ) AS used_capacity

      GROUP BY
        bin~bin_id,
        bin~capacity

      INTO TABLE @DATA(lt_bins).

    DATA(lv_best_remaining) = 2147483647.

    LOOP AT lt_bins INTO DATA(ls_bin).

      DATA(lv_free) =
        ls_bin-capacity - ls_bin-used_capacity.

      IF lv_free < iv_quantity.
        CONTINUE.
      ENDIF.

      DATA(lv_remaining) =
        lv_free - iv_quantity.

      IF lv_remaining < lv_best_remaining.

        lv_best_remaining = lv_remaining.

        rs_result-bin_id = ls_bin-bin_id.
        rs_result-free_capacity = lv_free.
        rs_result-remaining = lv_remaining.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.


METHOD is_bin_suitable.

  rv_suitable = abap_false.

  IF iv_quantity <= 0 OR iv_unit_weight <= 0.
    RETURN.
  ENDIF.

  IF iv_quantity > is_bin-free_capacity.
    RETURN.
  ENDIF.

  IF iv_category <> is_bin-allowed_category.
    RETURN.
  ENDIF.

  DATA(lv_required_weight) =
    CONV int8( iv_quantity ) * iv_unit_weight.

  DATA(lv_total_weight) =
    CONV int8( is_bin-used_weight_kg )
    + lv_required_weight.

  IF lv_total_weight > is_bin-max_weight_kg.
    RETURN.
  ENDIF.

  rv_suitable = abap_true.

ENDMETHOD.


METHOD recommend_for_material.

  CLEAR rs_result.

  IF iv_quantity <= 0.
    rs_result-reason = 'Invalid quantity'.
    RETURN.
  ENDIF.

  " 1. Materialeigenschaften lesen
  SELECT SINGLE
    FROM zwm_material
    FIELDS weight_kg, storage_category
    WHERE material_id = @iv_material_id
    INTO @DATA(ls_material).

  IF sy-subrc <> 0.
    rs_result-reason = 'Material not found'.
    RETURN.
  ENDIF.

  IF ls_material-weight_kg <= 0 OR
     ls_material-storage_category IS INITIAL.
    rs_result-reason = 'Material data incomplete'.
    RETURN.
  ENDIF.

  " 2. Eingangsgewicht berechnen
  DATA lv_incoming_weight
    TYPE p LENGTH 15 DECIMALS 3.

  lv_incoming_weight =
    ls_material-weight_kg * iv_quantity.

  rs_result-incoming_weight = lv_incoming_weight.

  " 3. Lagerplaetze lesen
  SELECT FROM zwm_storage_bin
    FIELDS bin_id,
           capacity,
           max_weight_kg,
           storage_category
    ORDER BY bin_id
    INTO TABLE @DATA(lt_bins).

  DATA lv_best_remaining TYPE i VALUE 2147483647.

  LOOP AT lt_bins INTO DATA(ls_bin).

    " 4. Lagerkategorie pruefen
    IF ls_bin-storage_category <>
       ls_material-storage_category.
      CONTINUE.
    ENDIF.

    " 5. Vorhandenen Bestand lesen
    SELECT FROM zwm_stock
      FIELDS material_id, quantity
      WHERE bin_id = @ls_bin-bin_id
      INTO TABLE @DATA(lt_stock).

    DATA lv_used_capacity TYPE i.
    DATA lv_used_weight
      TYPE p LENGTH 15 DECIMALS 3.

    CLEAR: lv_used_capacity, lv_used_weight.

    LOOP AT lt_stock INTO DATA(ls_stock).

      lv_used_capacity =
        lv_used_capacity + ls_stock-quantity.

      SELECT SINGLE
        FROM zwm_material
        FIELDS weight_kg
        WHERE material_id = @ls_stock-material_id
        INTO @DATA(lv_unit_weight).

      IF sy-subrc <> 0 OR lv_unit_weight <= 0.
        rs_result-reason =
          'Existing material weight missing'.
        CLEAR rs_result-bin_id.
        RETURN.
      ENDIF.

      lv_used_weight = lv_used_weight +
        ( lv_unit_weight * ls_stock-quantity ).

    ENDLOOP.

    " 6. Kapazitaet pruefen
    DATA(lv_free) =
      ls_bin-capacity - lv_used_capacity.

    IF lv_free < iv_quantity.
      CONTINUE.
    ENDIF.

    " 7. Gewicht pruefen
    IF lv_used_weight + lv_incoming_weight >
       ls_bin-max_weight_kg.
      CONTINUE.
    ENDIF.

    " 8. Best-Fit-Auswahl
    DATA(lv_remaining) = lv_free - iv_quantity.

    IF lv_remaining < lv_best_remaining.

      lv_best_remaining = lv_remaining.

      rs_result-bin_id = ls_bin-bin_id.
      rs_result-free_capacity = lv_free.
      rs_result-remaining = lv_remaining.

      rs_result-reason =
        'Best Fit: capacity, weight and category OK'.

    ENDIF.

  ENDLOOP.

  IF rs_result-bin_id IS INITIAL AND
     rs_result-reason IS INITIAL.
    rs_result-reason = 'No suitable storage bin'.
  ENDIF.

ENDMETHOD.



METHOD analyze_putaway.

  IF iv_quantity <= 0.
    RETURN.
  ENDIF.

  SELECT SINGLE FROM zwm_material
    FIELDS weight_kg, storage_category
    WHERE material_id = @iv_material_id
    INTO @DATA(ls_material).

  IF sy-subrc <> 0 OR
     ls_material-weight_kg <= 0 OR
     ls_material-storage_category IS INITIAL.
    RETURN.
  ENDIF.

  DATA lv_incoming_weight
    TYPE p LENGTH 15 DECIMALS 3.

  lv_incoming_weight =
    ls_material-weight_kg * iv_quantity.

  SELECT FROM zwm_storage_bin
    FIELDS bin_id, capacity,
           max_weight_kg, storage_category
    ORDER BY bin_id
    INTO TABLE @DATA(lt_bins).

  LOOP AT lt_bins INTO DATA(ls_bin).

    DATA(ls_analysis) =
      VALUE ty_bin_analysis(
        bin_id = ls_bin-bin_id
        status = 'REJECTED'
      ).

    IF ls_bin-storage_category <>
       ls_material-storage_category.

      ls_analysis-reason = 'Wrong storage category'.
      APPEND ls_analysis TO rt_analysis.
      CONTINUE.

    ENDIF.

    SELECT FROM zwm_stock
      FIELDS material_id, quantity
      WHERE bin_id = @ls_bin-bin_id
      INTO TABLE @DATA(lt_stock).

    DATA lv_used_capacity TYPE i.
    DATA lv_used_weight
      TYPE p LENGTH 15 DECIMALS 3.
    DATA lv_missing_weight TYPE abap_bool.

    CLEAR:
      lv_used_capacity,
      lv_used_weight,
      lv_missing_weight.

    LOOP AT lt_stock INTO DATA(ls_stock).

      lv_used_capacity =
        lv_used_capacity + ls_stock-quantity.

      SELECT SINGLE FROM zwm_material
        FIELDS weight_kg
        WHERE material_id = @ls_stock-material_id
        INTO @DATA(lv_weight).

      IF sy-subrc <> 0 OR lv_weight <= 0.
        lv_missing_weight = abap_true.
        EXIT.
      ENDIF.

      lv_used_weight = lv_used_weight +
        ( lv_weight * ls_stock-quantity ).

    ENDLOOP.

    IF lv_missing_weight = abap_true.
      ls_analysis-reason = 'Missing material weight'.
      APPEND ls_analysis TO rt_analysis.
      CONTINUE.
    ENDIF.

    ls_analysis-free_capacity =
      ls_bin-capacity - lv_used_capacity.

    IF ls_analysis-free_capacity < iv_quantity.

      ls_analysis-reason = 'Insufficient capacity'.

    ELSEIF lv_used_weight + lv_incoming_weight >
           ls_bin-max_weight_kg.

      ls_analysis-reason = 'Weight limit exceeded'.

    ELSE.

      ls_analysis-status = 'ACCEPTED'.
      ls_analysis-reason = 'All checks passed'.
      ls_analysis-remaining =
        ls_analysis-free_capacity - iv_quantity.

    ENDIF.

    APPEND ls_analysis TO rt_analysis.

  ENDLOOP.

ENDMETHOD.


ENDCLASS.

