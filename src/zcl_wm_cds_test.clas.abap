CLASS zcl_wm_cds_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_wm_cds_test IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.
        SELECT FROM zi_wm_stock
        FIELDS MaterialId, BinId, Quantity
        INTO TABLE @DATA(lt_stock).

        out->write( lt_stock ).

    ENDMETHOD.
ENDCLASS.
