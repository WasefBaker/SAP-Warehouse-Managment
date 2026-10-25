
CLASS zcl_wm_db_stock_reader DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES zif_wm_stock_reader.

ENDCLASS.


CLASS zcl_wm_db_stock_reader IMPLEMENTATION.

  METHOD zif_wm_stock_reader~get_stock.

    SELECT SINGLE quantity
      FROM zwm_stock
      WHERE material_id = @iv_material_id
        AND bin_id = @iv_bin_id
      INTO @rv_quantity.

  ENDMETHOD.

ENDCLASS.

