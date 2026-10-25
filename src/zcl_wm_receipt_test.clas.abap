CLASS zcl_wm_receipt_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_wm_receipt_test IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

    DATA(lo_service) =
        NEW zcl_wm_stock_service( ).

        DATA(lv_success) =
            lo_service->goods_receipt(
                iv_material_id = 'MAT001'
                iv_bin_id      = 'A-01-01'
                iv_quantity    = 20
            ).

            IF lv_success = 'X'.
                out->write( 'Goods receipt successful!' ).
            ELSE.
                out->write( 'Goods receipt failed!' ).
            ENDIF.

            SELECT SINGLE FROM zwm_stock
            FIELDS quantity
            WHERE material_id = 'MAT001'
            AND bin_id = 'A-01-01'
            INTO @DATA(lv_stock).

            out->write( |Current stock: { lv_stock }| ).

     ENDMETHOD.
ENDCLASS.
