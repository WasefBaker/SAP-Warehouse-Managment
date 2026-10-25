CLASS zcl_wm_service_test DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.



CLASS zcl_wm_service_test IMPLEMENTATION.
    METHOD if_oo_adt_classrun~main.
        DATA(lo_service) =
            NEW zcl_wm_material_service( ).

"Test the Creat method
*        DATA(lv_success) =
*            lo_service->create_material(
*            iv_material_id = 'MAT004'
*            iv_name = 'Mouse'
*            iv_quantity = 25
*            iv_unit = 'PC'
*            ).

"Test the Update method
*         DATA(lv_success) =
*            lo_service->update_material(
*            iv_material_id = 'MAT004'
*            iv_name = 'Gaming Mouse'
*            iv_quantity = 40
*            iv_unit = 'PC'
*            ).


         DATA(lv_success) =
            lo_service->delete_material(
            iv_material_id = 'MAT004'
            ).

            IF lv_success = 'X'.
                out->write( 'Done successfully!' ).
            ELSE.
                out->write( 'Material already exists or OP failed.' ).
            ENDIF.

            DATA(ls_material) =
                lo_service->get_material( iv_material_id = 'MAT004' ).

            IF ls_material-material_id IS INITIAL.
                out->write( 'MAT004 no longer exists.' ).
            ELSE.
                out->write( 'Material still exists!' ).
            ENDIF.
        ENDMETHOD.
ENDCLASS.
