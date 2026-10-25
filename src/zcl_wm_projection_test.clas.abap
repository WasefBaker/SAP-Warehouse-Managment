CLASS zcl_wm_projection_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_wm_projection_test IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

        SELECT FROM zc_wm_stock
        FIELDS MaterialId,MaterialName, WarehouseId, BinId, Quantity, Unit
        ORDER BY MaterialId, BinId
        INTO TABLE @DATA(lt_stock).

        out->write( 'Warehouse Stock Projection:' ).
        out->write( lt_stock ).
    ENDMETHOD.
ENDCLASS.
