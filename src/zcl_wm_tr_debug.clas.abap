
CLASS zcl_wm_tr_debug DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_wm_tr_debug IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_movement) =
      NEW zcl_wm_movement_service( ).

    DATA(lv_success) =
      lo_movement->create_movement(
        iv_material_id = 'MAT001'
        iv_bin_id      = 'A-02-02'
        iv_type        = 'TR'
        iv_quantity    = 3
        iv_source_bin  = 'A-01-01'
        iv_target_bin  = 'A-02-02'
      ).

    IF lv_success = 'X'.
      out->write( 'Movement creation: SUCCESS' ).
    ELSE.
      out->write( 'Movement creation: FAILED' ).
    ENDIF.

    SELECT FROM zwm_movement
      FIELDS movement_id,
             movement_type,
             material_id,
             source_bin,
             target_bin,
             quantity
      WHERE movement_type = 'TR'
      INTO TABLE @DATA(lt_movements).

    out->write( lt_movements ).

  ENDMETHOD.

ENDCLASS.

