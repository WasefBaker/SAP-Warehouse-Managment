CLASS zcl_wm_material_service DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

"Method to create new material
    METHODS create_material
        IMPORTING
            iv_material_id  TYPE zwm_material-material_id
            iv_name         TYPE zwm_material-name
            iv_quantity     TYPE zwm_material-quantity
            iv_unit         TYPE zwm_material-unit
        RETURNING VALUE(rv_success) TYPE abap_boolean.

"Method to read material
    METHODS get_material
        IMPORTING
            iv_material_id TYPE zwm_material-material_id
        RETURNING VALUE(rs_material) TYPE zwm_material.

"Method to update material
    METHODS update_material
        IMPORTING
            iv_material_id TYPE zwm_material-material_id
            iv_name         TYPE zwm_material-name
            iv_quantity     TYPE zwm_material-quantity
            iv_unit         TYPE zwm_material-unit
        RETURNING VALUE(rv_success) TYPE abap_boolean.

"Method to delete material
    METHODS delete_material
        IMPORTING
            iv_material_id TYPE zwm_material-material_id
        RETURNING VALUE(rv_success) TYPE abap_boolean.
ENDCLASS.



CLASS zcl_wm_material_service IMPLEMENTATION.
    METHOD create_material.
        DATA ls_material TYPE zwm_material.
        ls_material-material_id = iv_material_id.
        ls_material-name        = iv_name.
        ls_material-quantity    = iv_quantity.
        ls_material-unit        = iv_unit.

        INSERT zwm_material FROM @ls_material.

        IF sy-subrc = 0.
            rv_success = 'X'.
        ELSE.
            rv_success = ' '.
        ENDIF.
    ENDMETHOD.

    METHOD get_material.
        SELECT SINGLE from  zwm_material
        FIELDS * WHERE material_id = @iv_material_id
        INTO @rs_material.
    ENDMETHOD.

    METHOD update_material.
        rv_success = ' '.
        UPDATE zwm_material
        SET name = @iv_name,
            quantity = @iv_quantity,
            unit = @iv_unit
        WHERE material_id = @iv_material_id.

        IF sy-subrc = 0.
            rv_success = 'X'.
        ENDIF.
    ENDMETHOD.

    METHOD delete_material.
        rv_success = ' '.
        DELETE FROM zwm_material
        WHERE material_id = @iv_material_id.

        IF sy-subrc = 0.
            rv_success = 'X'.
        ENDIF.
    ENDMETHOD.

ENDCLASS.





