
CLASS zcl_wm_movement_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_wm_movement_test IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA(lo_service) =
      NEW zcl_wm_movement_service( ).

    DATA(lv_success) =
      lo_service->create_movement(
        iv_material_id = 'MAT001'
        iv_bin_id      = 'A-01-01'
        iv_type        = 'GR'
        iv_quantity    = 20
      ).

    IF lv_success = 'X'.
      out->write( 'Movement saved successfully!' ).
    ELSE.
      out->write( 'Movement could not be saved.' ).
    ENDIF.

    SELECT FROM zwm_movement
      FIELDS movement_id,
             material_id,
             bin_id,
             movement_type,
             quantity,
             created_at
      ORDER BY created_at DESCENDING
      INTO TABLE @DATA(lt_movements).

    out->write( lt_movements ).

  ENDMETHOD.

ENDCLASS.

