
CLASS zcl_wm_transfer_service DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS transfer_stock
      IMPORTING
        iv_material_id TYPE zwm_stock-material_id
        iv_source_bin  TYPE zwm_stock-bin_id
        iv_target_bin  TYPE zwm_stock-bin_id
        iv_quantity    TYPE zwm_stock-quantity
      RETURNING
        VALUE(rv_success) TYPE abap_boolean
      RAISING
        zcx_wm_error.

ENDCLASS.

CLASS zcl_wm_transfer_service IMPLEMENTATION.

  METHOD transfer_stock.

    rv_success = ' '.

*    " Validate input
*    IF iv_quantity <= 0
*       OR iv_source_bin = iv_target_bin.
*      RETURN.
*    ENDIF.


    IF iv_quantity <= 0.
      RAISE EXCEPTION NEW zcx_wm_error(
        iv_message = 'Quantity must be greater than zero'
      ).
    ENDIF.

    IF iv_source_bin = iv_target_bin.
      RAISE EXCEPTION NEW zcx_wm_error(
        iv_message = 'Source and target bin must be different'
      ).
    ENDIF.


    " Check source stock
    SELECT SINGLE FROM zwm_stock
      FIELDS quantity
      WHERE material_id = @iv_material_id
        AND bin_id = @iv_source_bin
      INTO @DATA(lv_source_stock).

*    IF sy-subrc <> 0
*       OR lv_source_stock < iv_quantity.
*      RETURN.
*    ENDIF.


    IF sy-subrc <> 0
       OR lv_source_stock < iv_quantity.

      RAISE EXCEPTION NEW zcx_wm_error(
        iv_message = 'Insufficient stock'
      ).

    ENDIF.


    " Check target bin capacity
    SELECT SINGLE FROM zwm_storage_bin
      FIELDS capacity
      WHERE bin_id = @iv_target_bin
      INTO @DATA(lv_capacity).

*    IF sy-subrc <> 0.
*      RETURN.
*    ENDIF.


    IF sy-subrc <> 0.

      RAISE EXCEPTION NEW zcx_wm_error(
        iv_message = 'Target bin not found'
      ).

    ENDIF.


    " Calculate total target bin stock
    SELECT FROM zwm_stock
      FIELDS SUM( quantity )
      WHERE bin_id = @iv_target_bin
      INTO @DATA(lv_target_total).

*    IF lv_target_total + iv_quantity > lv_capacity.
*      RETURN.
*    ENDIF.


    IF lv_target_total + iv_quantity > lv_capacity.

      RAISE EXCEPTION NEW zcx_wm_error(
        iv_message = 'Target bin capacity exceeded'
      ).

    ENDIF.


    " Remove stock from source
    UPDATE zwm_stock
      SET quantity = quantity - @iv_quantity
      WHERE material_id = @iv_material_id
        AND bin_id = @iv_source_bin
        AND quantity >= @iv_quantity.

    IF sy-subrc <> 0.
      ROLLBACK WORK.
      RETURN.
    ENDIF.

    " Add stock to target
    UPDATE zwm_stock
      SET quantity = quantity + @iv_quantity
      WHERE material_id = @iv_material_id
        AND bin_id = @iv_target_bin.

    IF sy-subrc <> 0.

      DATA ls_stock TYPE zwm_stock.

      ls_stock-material_id = iv_material_id.
      ls_stock-bin_id      = iv_target_bin.
      ls_stock-quantity    = iv_quantity.

      INSERT zwm_stock FROM @ls_stock.

      IF sy-subrc <> 0.
        ROLLBACK WORK.
        RETURN.
      ENDIF.

    ENDIF.


    " Save transfer movement
    DATA(lo_movement) =
      NEW zcl_wm_movement_service( ).

    DATA(lv_movement_ok) =
      lo_movement->create_movement(
        iv_material_id = iv_material_id
        iv_bin_id      = iv_target_bin
        iv_type        = 'TR'
        iv_quantity    = iv_quantity
        iv_source_bin  = iv_source_bin
        iv_target_bin  = iv_target_bin
      ).

    IF lv_movement_ok <> 'X'.
      ROLLBACK WORK.
      RETURN.
    ENDIF.

    " Complete transaction
    COMMIT WORK.
    rv_success = 'X'.


  ENDMETHOD.

ENDCLASS.

