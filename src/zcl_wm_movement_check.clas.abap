
CLASS zcl_wm_movement_check DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.

CLASS zcl_wm_movement_check IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT FROM zwm_movement
      FIELDS movement_id,
             movement_type,
             material_id,
             source_bin,
             target_bin,
             quantity,
             created_at
      ORDER BY created_at DESCENDING
      INTO TABLE @DATA(lt_movements).

    out->write( 'All warehouse movements:' ).
    out->write( lt_movements ).

    SELECT FROM zwm_movement
      FIELDS COUNT( * )
      WHERE movement_type = 'TR'
      INTO @DATA(lv_count).

    out->write(
      |Transfer movements found: { lv_count }|
    ).

  ENDMETHOD.

ENDCLASS.

