CLASS zcl_wm_stock_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    METHODS goods_receipt
        IMPORTING
            iv_material_id TYPE zwm_stock-material_id
            iv_bin_id      TYPE zwm_stock-bin_id
            iv_quantity    TYPE zwm_stock-quantity
        RETURNING VALUE(rv_success) TYPE abap_boolean.

    METHODS goods_issue
        IMPORTING
            iv_material_id TYPE zwm_stock-material_id
            iv_bin_id      TYPE zwm_stock-bin_id
            iv_quantity    TYPE zwm_stock-quantity
        RETURNING VALUE(rv_success) TYPE abap_boolean.
ENDCLASS.



CLASS zcl_wm_stock_service IMPLEMENTATION.
    METHOD goods_receipt.
        rv_success = ' '.
        IF iv_quantity <= 0.
            RETURN.
        ENDIF.

        "we check if the material exists
        SELECT SINGLE FROM zwm_material
        FIELDS material_id
        WHERE material_id = @iv_material_id
        INTO @DATA(lv_material_id).

        IF sy-subrc <> 0.
            RETURN.
        ENDIF.

        "we check the storage bin and capacity
        SELECT SINGLE FROM zwm_storage_bin
        FIELDS capacity
        WHERE bin_id = @iv_bin_id
        INTO @DATA(lv_capacity).

        IF sy-subrc <> 0.
            RETURN.
        ENDIF.

        "read current stock
        SELECT SINGLE FROM zwm_stock
        FIELDS quantity
        WHERE material_id = @iv_material_id
        AND bin_id = @iv_bin_id
        INTO @DATA(lv_current_stock).

        IF sy-subrc <> 0.
            RETURN.
        ENDIF.

        "check capacity
        IF lv_current_stock + iv_quantity > lv_capacity.
            RETURN.
        ENDIF.

        "update existing stock
        UPDATE zwm_stock
        SET quantity = quantity + @iv_quantity
        WHERE material_id = @iv_material_id
        AND bin_id = @iv_bin_id.

        IF sy-subrc = 0.
            rv_success = 'X'.
            RETURN.
        ENDIF.

        "Create new stock record if missing
        DATA ls_stock TYPE zwm_stock.
        ls_stock-material_id = iv_material_id.
        ls_stock-bin_id      = iv_bin_id.
        ls_stock-quantity    = iv_quantity.

        INSERT zwm_stock FROM @ls_stock.

        IF sy-subrc = 0.
            rv_success = 'X'.
        ENDIF.

    ENDMETHOD.


    METHOD goods_issue.
        rv_success = ' '.

        "check quantity
        IF iv_quantity <= 0.
            RETURN.
        ENDIF.

        "Reduce stock only if enough is available
        UPDATE zwm_stock
        SET quantity = quantity - @iv_quantity
        WHERE material_id = @iv_material_id
        AND bin_id = @iv_bin_id
        AND quantity >= @iv_quantity.

        IF sy-subrc = 0.
            rv_success = 'X'.
        ENDIF.
    ENDMETHOD.
ENDCLASS.
