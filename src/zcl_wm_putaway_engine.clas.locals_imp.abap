*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations


CLASS ltc_putaway DEFINITION
  FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.

    METHODS test_valid_bin FOR TESTING.
    METHODS test_overweight FOR TESTING.
    METHODS test_wrong_category FOR TESTING.
    METHODS test_no_capacity FOR TESTING.

ENDCLASS.


CLASS ltc_putaway IMPLEMENTATION.

  METHOD test_valid_bin.

    DATA(ls_bin) =
      VALUE zcl_wm_putaway_engine=>ty_bin_check(
        free_capacity    = 50
        max_weight_kg    = 500
        used_weight_kg   = 100
        allowed_category = 'STANDARD'
      ).

    DATA(lv_result) =
      zcl_wm_putaway_engine=>is_bin_suitable(
        iv_quantity    = 40
        iv_unit_weight = 5
        iv_category    = 'STANDARD'
        is_bin         = ls_bin
      ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_true
    ).

  ENDMETHOD.

  METHOD test_overweight.

    DATA(ls_bin) =
      VALUE zcl_wm_putaway_engine=>ty_bin_check(
        free_capacity    = 50
        max_weight_kg    = 200
        used_weight_kg   = 100
        allowed_category = 'STANDARD'
      ).

    DATA(lv_result) =
      zcl_wm_putaway_engine=>is_bin_suitable(
        iv_quantity    = 40
        iv_unit_weight = 5
        iv_category    = 'STANDARD'
        is_bin         = ls_bin
      ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_false
    ).

  ENDMETHOD.

  METHOD test_wrong_category.

    DATA(ls_bin) =
      VALUE zcl_wm_putaway_engine=>ty_bin_check(
        free_capacity    = 50
        max_weight_kg    = 500
        used_weight_kg   = 0
        allowed_category = 'HEAVY'
      ).

    DATA(lv_result) =
      zcl_wm_putaway_engine=>is_bin_suitable(
        iv_quantity    = 40
        iv_unit_weight = 5
        iv_category    = 'STANDARD'
        is_bin         = ls_bin
      ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_false
    ).

  ENDMETHOD.

  METHOD test_no_capacity.

    DATA(ls_bin) =
      VALUE zcl_wm_putaway_engine=>ty_bin_check(
        free_capacity    = 20
        max_weight_kg    = 500
        used_weight_kg   = 0
        allowed_category = 'STANDARD'
      ).

    DATA(lv_result) =
      zcl_wm_putaway_engine=>is_bin_suitable(
        iv_quantity    = 40
        iv_unit_weight = 5
        iv_category    = 'STANDARD'
        is_bin         = ls_bin
      ).

    cl_abap_unit_assert=>assert_equals(
      act = lv_result
      exp = abap_false
    ).

  ENDMETHOD.

ENDCLASS.

