*"* use this source file for your ABAP unit test classes

CLASS ltc_stock_check DEFINITION
  FINAL FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    DATA mo_service TYPE REF TO zcl_wm_stock_check_service.

    METHODS setup.

    METHODS test_enough_stock FOR TESTING.
    METHODS test_not_enough_stock FOR TESTING.
    METHODS test_zero_quantity FOR TESTING.
    METHODS test_negative_quantity FOR TESTING.

ENDCLASS.


CLASS ltc_stock_check IMPLEMENTATION.

  METHOD setup.

    DATA(lo_fake) = NEW zcl_wm_fake_stock_reader(
      iv_quantity = 50
    ).

    mo_service = NEW zcl_wm_stock_check_service(
      io_stock_reader = lo_fake
    ).

  ENDMETHOD.


  METHOD test_enough_stock.

    DATA(lv_result) = mo_service->has_enough_stock(
      iv_material_id = 'MAT001'
      iv_bin_id      = 'A-01-01'
      iv_quantity    = 30
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_true
    ).

  ENDMETHOD.


  METHOD test_not_enough_stock.

    DATA(lv_result) = mo_service->has_enough_stock(
      iv_material_id = 'MAT001'
      iv_bin_id      = 'A-01-01'
      iv_quantity    = 70
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_false
    ).

  ENDMETHOD.


  METHOD test_zero_quantity.

    DATA(lv_result) = mo_service->has_enough_stock(
      iv_material_id = 'MAT001'
      iv_bin_id      = 'A-01-01'
      iv_quantity    = 0
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_false
    ).

  ENDMETHOD.


  METHOD test_negative_quantity.

    DATA(lv_result) = mo_service->has_enough_stock(
      iv_material_id = 'MAT001'
      iv_bin_id      = 'A-01-01'
      iv_quantity    = -5
    ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_false
    ).

  ENDMETHOD.

ENDCLASS.

