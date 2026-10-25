
CLASS zcl_wm_bin_capacity DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.

CLASS zcl_wm_bin_capacity IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.


SELECT FROM zwm_storage_bin AS b

  LEFT OUTER JOIN zwm_stock AS s
    ON b~bin_id = s~bin_id

  FIELDS
    b~bin_id,
    b~warehouse_id,
    b~capacity,

    SUM( s~quantity ) AS total_stock,

    b~capacity - SUM( s~quantity )
      AS free_capacity,

    CASE
      WHEN SUM( s~quantity ) = 0
        THEN 'EMPTY'

      WHEN SUM( s~quantity ) > b~capacity
        THEN 'OVER_CAPACITY'

      WHEN SUM( s~quantity ) = b~capacity
        THEN 'FULL'

      ELSE 'AVAILABLE'
    END AS bin_status

  GROUP BY
    b~bin_id,
    b~warehouse_id,
    b~capacity

  ORDER BY b~bin_id

  INTO TABLE @DATA(lt_capacity).


    out->write( 'Warehouse Bin Capacity' ).
    out->write( lt_capacity ).

  ENDMETHOD.

ENDCLASS.

