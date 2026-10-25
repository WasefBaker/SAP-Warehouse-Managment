
CLASS zcl_wm_putaway_demo DEFINITION
  PUBLIC FINAL CREATE PUBLIC.

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.

ENDCLASS.


CLASS zcl_wm_putaway_demo IMPLEMENTATION.





METHOD if_oo_adt_classrun~main.

  DATA(lo_engine) = NEW zcl_wm_putaway_engine( ).

  DATA(ls_result) =
    lo_engine->recommend_for_material(
      iv_material_id = 'MAT004'
      iv_quantity    = 40
    ).

  out->write( '=== SMART PUTAWAY ===' ).

  IF ls_result-bin_id IS INITIAL.

    out->write( ls_result-reason ).

  ELSE.

    out->write(
      |Recommended Bin: { ls_result-bin_id }|
    ).

    out->write(
      |Incoming Weight: { ls_result-incoming_weight } kg|
    ).

    out->write(
      |Remaining Capacity: { ls_result-remaining }|
    ).

    out->write(
      |Reason: { ls_result-reason }|
    ).

  ENDIF.


out->write( '=== BIN ANALYSIS ===' ).

DATA(lt_analysis) =
  lo_engine->analyze_putaway(
    iv_material_id = 'MAT004'
    iv_quantity    = 40
  ).

LOOP AT lt_analysis INTO DATA(ls_analysis).

  out->write(
    |{ ls_analysis-bin_id }: |
    && |{ ls_analysis-status } - |
    && |{ ls_analysis-reason }|
  ).

ENDLOOP.

ENDMETHOD.





ENDCLASS.

