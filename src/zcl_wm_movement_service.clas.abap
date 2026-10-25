
CLASS zcl_wm_movement_service DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.

    METHODS create_movement
      IMPORTING
        iv_material_id TYPE zwm_movement-material_id
        iv_bin_id      TYPE zwm_movement-bin_id
        iv_type        TYPE zwm_movement-movement_type
        iv_quantity    TYPE zwm_movement-quantity
        iv_source_bin  TYPE zwm_movement-source_bin OPTIONAL
        iv_target_bin  TYPE zwm_movement-target_bin OPTIONAL
      RETURNING
        VALUE(rv_success) TYPE abap_boolean.

ENDCLASS.

CLASS zcl_wm_movement_service IMPLEMENTATION.


    METHOD create_movement.

      rv_success = ' '.

      IF iv_quantity <= 0.
        RETURN.
      ENDIF.

      IF iv_type <> 'GR'
         AND iv_type <> 'GI'
         AND iv_type <> 'TR'.
        RETURN.
      ENDIF.

      IF iv_type = 'TR'.
        IF iv_source_bin IS INITIAL
           OR iv_target_bin IS INITIAL
           OR iv_source_bin = iv_target_bin.
          RETURN.
        ENDIF.
      ENDIF.

      TRY.
          DATA(lv_uuid) =
            cl_system_uuid=>create_uuid_c32_static( ).

          DATA ls_movement TYPE zwm_movement.

          ls_movement-movement_id   = lv_uuid.
          ls_movement-material_id   = iv_material_id.
          ls_movement-bin_id        = iv_bin_id.
          ls_movement-movement_type = iv_type.
          ls_movement-quantity      = iv_quantity.
          ls_movement-source_bin    = iv_source_bin.
          ls_movement-target_bin    = iv_target_bin.
          ls_movement-created_at    =
            utclong_current( ).

          INSERT zwm_movement FROM @ls_movement.

          IF sy-subrc = 0.
            rv_success = 'X'.
          ENDIF.

        CATCH cx_uuid_error.
          rv_success = ' '.
      ENDTRY.

    ENDMETHOD.


ENDCLASS.

