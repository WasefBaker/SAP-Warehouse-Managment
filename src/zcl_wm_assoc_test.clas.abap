CLASS zcl_wm_assoc_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_wm_assoc_test IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

        SELECT FROM zi_wm_stock_assoc
        FIELDS MaterialId, BinId, Quantity,
               \_Material-MaterialName AS MAterialName,
               \_StorageBin-WarehouseId AS WarehouseId
        ORDER BY MaterialId, BinId
        INTO TABLE @DATA(lt_stock).

        out->write( 'Warehouse Stock Associations: ' ).
        out->write( lt_stock ).
    ENDMETHOD.
ENDCLASS.
