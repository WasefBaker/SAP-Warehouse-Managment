
CLASS ltc_transfer_test DEFINITION
  FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA mo_transfer TYPE REF TO zcl_wm_transfer_service.

    METHODS setup.
    METHODS teardown.

    METHODS test_invalid_quantity FOR TESTING.
    METHODS test_same_bin FOR TESTING.

ENDCLASS.


CLASS ltc_transfer_test IMPLEMENTATION.

  METHOD setup.
    mo_transfer = NEW zcl_wm_transfer_service( ).
  ENDMETHOD.

  METHOD teardown.
    CLEAR mo_transfer.
  ENDMETHOD.


  METHOD test_invalid_quantity.

    TRY.

        mo_transfer->transfer_stock(
          iv_material_id = 'MAT001'
          iv_source_bin  = 'A-01-01'
          iv_target_bin  = 'A-02-02'
          iv_quantity    = 0
        ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected exception was not raised'
        ).

      CATCH zcx_wm_error INTO DATA(lx_error).

        cl_abap_unit_assert=>assert_equals(
          act = lx_error->error_message
          exp = 'Quantity must be greater than zero'
        ).

    ENDTRY.

  ENDMETHOD.


  METHOD test_same_bin.

    TRY.

        mo_transfer->transfer_stock(
          iv_material_id = 'MAT001'
          iv_source_bin  = 'A-01-01'
          iv_target_bin  = 'A-01-01'
          iv_quantity    = 5
        ).

        cl_abap_unit_assert=>fail(
          msg = 'Expected exception was not raised'
        ).

      CATCH zcx_wm_error INTO DATA(lx_error).

        cl_abap_unit_assert=>assert_equals(
          act = lx_error->error_message
          exp = 'Source and target bin must be different'
        ).

    ENDTRY.

  ENDMETHOD.

ENDCLASS.

