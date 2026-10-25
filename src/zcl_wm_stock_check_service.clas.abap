
CLASS zcl_wm_stock_check_service DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS constructor
      IMPORTING
        io_stock_reader TYPE REF TO zif_wm_stock_reader.

    METHODS has_enough_stock
      IMPORTING
        iv_material_id TYPE zwm_stock-material_id
        iv_bin_id      TYPE zwm_stock-bin_id
        iv_quantity    TYPE zwm_stock-quantity
      RETURNING
        VALUE(rv_result) TYPE abap_boolean.

  PRIVATE SECTION.

    DATA mo_stock_reader TYPE REF TO zif_wm_stock_reader.

ENDCLASS.


CLASS zcl_wm_stock_check_service IMPLEMENTATION.

  METHOD constructor.

    mo_stock_reader = io_stock_reader.

  ENDMETHOD.


  METHOD has_enough_stock.

    rv_result = abap_false.

    IF iv_quantity <= 0.
      RETURN.
    ENDIF.

    DATA(lv_stock) = mo_stock_reader->get_stock(
      iv_material_id = iv_material_id
      iv_bin_id      = iv_bin_id
    ).

    IF lv_stock >= iv_quantity.
      rv_result = abap_true.
    ENDIF.

  ENDMETHOD.

ENDCLASS.

