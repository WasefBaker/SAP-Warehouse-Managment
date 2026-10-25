
INTERFACE zif_wm_stock_reader
  PUBLIC.

  METHODS get_stock
    IMPORTING
      iv_material_id TYPE zwm_stock-material_id
      iv_bin_id      TYPE zwm_stock-bin_id
    RETURNING
      VALUE(rv_quantity) TYPE zwm_stock-quantity.

ENDINTERFACE.
