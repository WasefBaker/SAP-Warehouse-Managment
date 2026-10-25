CLASS zcl_wm_stock_demo DEFINITION
  PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_wm_stock_demo IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.

    DATA lt_stock TYPE STANDARD TABLE
    OF zwm_stock WITH EMPTY KEY.

    lt_stock = VALUE #(

    ( material_id = 'MAT001'
      bin_id      = 'A-03-01'
      quantity    = 50
    )

    ( material_id = 'MAT002'
      bin_id      = 'A-01-02'
      quantity    = 60
    )

    ( material_id = 'MAT003'
      bin_id      = 'A-03-02'
      quantity    = 100
    )
    ).

    INSERT zwm_stock FROM TABLE @lt_stock
    ACCEPTING DUPLICATE KEYS.

    out->write( |Inserted stock records: { sy-dbcnt }| ).

    SELECT FROM zwm_stock
    FIELDS material_id, bin_id, quantity
    ORDER BY material_id, bin_id
    INTO TABLE @DATA(lt_result).

    out->write( lt_result ).

    ENDMETHOD.
ENDCLASS.
