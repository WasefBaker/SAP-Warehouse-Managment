
CLASS zcl_wm_di_service_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_wm_di_service_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

*    DATA(lo_fake) = NEW zcl_wm_fake_stock_reader(
*      iv_quantity = 50
*    ).

    DATA(lo_reader) = NEW zcl_wm_db_stock_reader( ).

*    DATA(lo_service) =
*      NEW zcl_wm_stock_check_service(
*        io_stock_reader = lo_fake
*      ).

    DATA(lo_service) =
      NEW zcl_wm_stock_check_service(
        io_stock_reader = lo_reader
      ).

    DATA(lv_result) = lo_service->has_enough_stock(
      iv_material_id = 'MAT001'
      iv_bin_id      = 'A-01-01'
      iv_quantity    = 70
    ).

    IF lv_result = abap_true.
      out->write( 'Enough stock available!' ).
    ELSE.
      out->write( 'Not enough stock!' ).
    ENDIF.

  ENDMETHOD.

ENDCLASS.

