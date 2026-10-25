
CLASS zcl_wm_fake_stock_reader DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    INTERFACES zif_wm_stock_reader.

    METHODS constructor
      IMPORTING
        iv_quantity TYPE zwm_stock-quantity.

  PRIVATE SECTION.

    DATA mv_quantity TYPE zwm_stock-quantity.

ENDCLASS.


CLASS zcl_wm_fake_stock_reader IMPLEMENTATION.

  METHOD constructor.

    mv_quantity = iv_quantity.

  ENDMETHOD.


  METHOD zif_wm_stock_reader~get_stock.

    rv_quantity = mv_quantity.

  ENDMETHOD.

ENDCLASS.

