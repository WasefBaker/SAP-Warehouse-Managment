
CLASS zcl_wm_exception_test DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

    METHODS check_quantity
      IMPORTING
        iv_quantity TYPE i
      RAISING
        zcx_wm_error.

ENDCLASS.

CLASS zcl_wm_exception_test IMPLEMENTATION.

  METHOD check_quantity.

    IF iv_quantity <= 0.

      RAISE EXCEPTION NEW zcx_wm_error(
        iv_message = 'Quantity must be greater than zero'
      ).

    ENDIF.

  ENDMETHOD.

  METHOD if_oo_adt_classrun~main.

    TRY.

        check_quantity(
          iv_quantity = 5
        ).

        out->write( 'Quantity is valid!' ).

      CATCH zcx_wm_error INTO DATA(lx_error).

        out->write( lx_error->error_message ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.

