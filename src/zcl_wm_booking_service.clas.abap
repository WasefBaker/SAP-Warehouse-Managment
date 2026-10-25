
CLASS zcl_wm_booking_service DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS post_goods_receipt
      IMPORTING
        iv_material_id TYPE zwm_stock-material_id
        iv_bin_id      TYPE zwm_stock-bin_id
        iv_quantity    TYPE zwm_stock-quantity
      RETURNING
        VALUE(rv_success) TYPE abap_boolean.


    METHODS post_goods_issue
      IMPORTING
        iv_material_id TYPE zwm_stock-material_id
        iv_bin_id      TYPE zwm_stock-bin_id
        iv_quantity    TYPE zwm_stock-quantity
      RETURNING
        VALUE(rv_success) TYPE abap_boolean.


ENDCLASS.

CLASS zcl_wm_booking_service IMPLEMENTATION.

  METHOD post_goods_receipt.

    rv_success = ' '.

    DATA(lo_stock) =
      NEW zcl_wm_stock_service( ).

    DATA(lo_movement) =
      NEW zcl_wm_movement_service( ).

    " Step 1: Update stock
    DATA(lv_stock_ok) =
      lo_stock->goods_receipt(
        iv_material_id = iv_material_id
        iv_bin_id      = iv_bin_id
        iv_quantity    = iv_quantity
      ).

    IF lv_stock_ok <> 'X'.
      ROLLBACK WORK.
      RETURN.
    ENDIF.

    " Step 2: Save movement history
    DATA(lv_movement_ok) =
      lo_movement->create_movement(
        iv_material_id = iv_material_id
        iv_bin_id      = iv_bin_id
        iv_type        = 'GR'
        iv_quantity    = iv_quantity
      ).

    IF lv_movement_ok <> 'X'.
      ROLLBACK WORK.
      RETURN.
    ENDIF.

    " Both operations succeeded
    COMMIT WORK.

    rv_success = 'X'.

  ENDMETHOD.


    METHOD post_goods_issue.

      rv_success = ' '.

      DATA(lo_stock) =
        NEW zcl_wm_stock_service( ).

      DATA(lo_movement) =
        NEW zcl_wm_movement_service( ).

      " Step 1: Reduce stock
      DATA(lv_stock_ok) =
        lo_stock->goods_issue(
          iv_material_id = iv_material_id
          iv_bin_id      = iv_bin_id
          iv_quantity    = iv_quantity
        ).

      IF lv_stock_ok <> 'X'.
        ROLLBACK WORK.
        RETURN.
      ENDIF.

      " Step 2: Save movement history
      DATA(lv_movement_ok) =
        lo_movement->create_movement(
          iv_material_id = iv_material_id
          iv_bin_id      = iv_bin_id
          iv_type        = 'GI'
          iv_quantity    = iv_quantity
        ).

      IF lv_movement_ok <> 'X'.
        ROLLBACK WORK.
        RETURN.
      ENDIF.

      " Both operations succeeded
      COMMIT WORK.

      rv_success = 'X'.

    ENDMETHOD.


ENDCLASS.

