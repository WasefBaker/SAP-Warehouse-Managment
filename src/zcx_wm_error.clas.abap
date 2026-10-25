
CLASS zcx_wm_error DEFINITION
  PUBLIC
  INHERITING FROM cx_static_check
  CREATE PUBLIC.

  PUBLIC SECTION.

    DATA error_message TYPE string READ-ONLY.

    METHODS constructor
      IMPORTING
        iv_message TYPE string.

ENDCLASS.

CLASS zcx_wm_error IMPLEMENTATION.

  METHOD constructor ##ADT_SUPPRESS_GENERATION.

    super->constructor( ).

    error_message = iv_message.

  ENDMETHOD.

ENDCLASS.

