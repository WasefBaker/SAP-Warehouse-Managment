
CLASS zcl_wm_booking_issue_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_wm_booking_issue_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_booking) =
      NEW zcl_wm_booking_service( ).

    DATA(lv_success) =
      lo_booking->post_goods_issue(
        iv_material_id = 'MAT001'
        iv_bin_id      = 'A-01-01'
        iv_quantity    = 1000
      ).

    IF lv_success = 'X'.
      out->write( 'Goods issue booking successful!' ).
    ELSE.
      out->write( 'Goods issue booking failed!' ).
    ENDIF.

    SELECT SINGLE FROM zwm_stock
      FIELDS quantity
      WHERE material_id = 'MAT001'
        AND bin_id = 'A-01-01'
      INTO @DATA(lv_stock).

    out->write( |Current stock: { lv_stock }| ).

    SELECT FROM zwm_movement
      FIELDS material_id,
             movement_type,
             quantity,
             created_at
      WHERE material_id = 'MAT001'
      ORDER BY created_at DESCENDING
      INTO TABLE @DATA(lt_movements).

    out->write( lt_movements ).

  ENDMETHOD.

ENDCLASS.

