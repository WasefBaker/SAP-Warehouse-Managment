
CLASS zcl_wm_di_demo DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_wm_di_demo IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.

    DATA lo_reader TYPE REF TO zif_wm_stock_reader.

    lo_reader = NEW zcl_wm_fake_stock_reader(
      iv_quantity = 50
    ).

    DATA(lv_stock) = lo_reader->get_stock(
      iv_material_id = 'MAT001'
      iv_bin_id      = 'A-01-01'
    ).

    out->write(
      |Simulated stock: { lv_stock }|
    ).

  ENDMETHOD.

ENDCLASS.

