
CLASS zcl_wm_stock_overview DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_wm_stock_overview IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    SELECT FROM zwm_stock AS s

      INNER JOIN zwm_material AS m
        ON s~material_id = m~material_id

      INNER JOIN zwm_storage_bin AS b
        ON s~bin_id = b~bin_id

      FIELDS
        s~material_id,
        m~name AS material_name,
        s~bin_id,
        b~warehouse_id,
        s~quantity,
        m~unit,
        b~capacity,
        b~capacity - s~quantity AS free_capacity

      ORDER BY s~material_id, s~bin_id

      INTO TABLE @DATA(lt_overview).

    out->write( 'Warehouse Stock Overview' ).
    out->write( lt_overview ).

  ENDMETHOD.

ENDCLASS.

