
CLASS zcl_wm_transfer_error_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_wm_transfer_error_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_transfer) =
      NEW zcl_wm_transfer_service( ).

    TRY.

        DATA(lv_success) =
          lo_transfer->transfer_stock(
            iv_material_id = 'MAT001'
            iv_source_bin  = 'A-01-01'
            iv_target_bin  = 'A-02-02'
            iv_quantity    = 0
          ).

        IF lv_success = 'X'.
          out->write( 'Transfer successful!' ).
        ELSE.
          out->write( 'Transfer failed!' ).
        ENDIF.

      CATCH zcx_wm_error INTO DATA(lx_error).

        out->write(
          |Error: { lx_error->error_message }|
        ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.

