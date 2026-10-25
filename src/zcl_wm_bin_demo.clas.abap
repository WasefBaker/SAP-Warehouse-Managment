CLASS zcl_wm_bin_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_wm_bin_demo IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

        DATA lt_bins TYPE STANDARD TABLE OF
        zwm_storage_bin WITH EMPTY KEY.

        lt_bins = VALUE #(
          ( bin_id = 'A-03-01'
            warehouse_id = 'WH01'
            description = 'Shelf A - Level 1'
            capacity = 100 )

           ( bin_id = 'A-03-02'
            warehouse_id = 'WH01'
            description = 'Shelf A - Level 2'
            capacity = 100 )

           ( bin_id = 'A-02-01'
            warehouse_id = 'WH01'
            description = 'Shelf B - Level 1'
            capacity = 150 )

            ( bin_id = 'A-02-02'
            warehouse_id = 'WH01'
            description = 'Shelf B - Level 2'
            capacity = 150 )
        ).

        INSERT zwm_storage_bin FROM
        TABLE @lt_bins ACCEPTING DUPLICATE KEYS.

        out->write( |Inserted storage bins. { sy-dbcnt }| ).

        SELECT FROM zwm_storage_bin
        FIELDS bin_id, warehouse_id, description, capacity
        ORDER BY bin_id INTO TABLE @DATA(lt_result).

        out->write( lt_result ).

   ENDMETHOD.
ENDCLASS.
