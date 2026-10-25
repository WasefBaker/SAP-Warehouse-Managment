
CLASS zcl_wm_transfer_history_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_wm_transfer_history_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_transfer) =
      NEW zcl_wm_transfer_service( ).

    DATA(lv_success) =
      lo_transfer->transfer_stock(
        iv_material_id = 'MAT001'
        iv_source_bin  = 'A-01-01'
        iv_target_bin  = 'A-02-02'
        iv_quantity    = 3
      ).

    IF lv_success = 'X'.
      out->write( 'Transfer with history successful!' ).
    ELSE.
      out->write( 'Transfer failed!' ).
    ENDIF.

    SELECT FROM zwm_stock
      FIELDS material_id,
             bin_id,
             quantity
      WHERE material_id = 'MAT001'
      ORDER BY bin_id
      INTO TABLE @DATA(lt_stock).

    out->write( lt_stock ).

    SELECT FROM zwm_movement
      FIELDS movement_type,
             material_id,
             source_bin,
             target_bin,
             quantity,
             created_at
      WHERE movement_type = 'TR'
      ORDER BY created_at DESCENDING
      INTO TABLE @DATA(lt_movements).

    out->write( lt_movements ).

  ENDMETHOD.

ENDCLASS.

