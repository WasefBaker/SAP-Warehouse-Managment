CLASS zcl_material_demo DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
ENDCLASS.



CLASS zcl_material_demo IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
       TYPES: BEGIN OF ty_material,
              material_id TYPE c LENGTH 10,
              name        TYPE string,
              quantity    TYPE i,
       END OF ty_material.

       DATA lt_materials TYPE STANDARD TABLE OF zwm_material WITH EMPTY KEY.

       lt_materials = VALUE #(
            ( material_id = 'MAT001'
              name = 'Laptop'
              quantity = 15
              unit = 'PC' )
              ( material_id = 'MAT002'
              name = 'Monitor'
              quantity = 60
              unit = 'PC' )
              ( material_id = 'MAT003'
              name = 'Keyboard'
              quantity = 100
              unit = 'PC' )
              ).

*             out->write( '=== Warehouse Materials ===' ).

*             LOOP AT lt_materials INTO DATA(ls_material).
*                  out->write(
*                  |ID: { ls_material-material_id }| &&
*                  | Name: { ls_material-name }| &&
*                  | Stock: { ls_material-quantity }|
*                  ).
*              ENDLOOP.

                INSERT zwm_material FROM TABLE @lt_materials
                ACCEPTING DUPLICATE KEYS.

                out->write( |Inserted materials: { sy-dbcnt }| ).

                SELECT FROM zwm_material FIELDS material_id, name, quantity, unit
                INTO TABLE @DATA(lt_result).

                out->write( lt_result ).

  ENDMETHOD.
ENDCLASS.
