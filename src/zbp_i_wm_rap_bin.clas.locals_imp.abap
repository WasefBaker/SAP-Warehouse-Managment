CLASS lhc_Bin DEFINITION
  INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.

    METHODS get_global_authorizations
      FOR GLOBAL AUTHORIZATION
      IMPORTING REQUEST requested_authorizations
      FOR Bin RESULT result.

    METHODS validateCapacity
      FOR VALIDATE ON SAVE
      IMPORTING keys FOR Bin~validateCapacity.

ENDCLASS.


CLASS lhc_Bin IMPLEMENTATION.

  METHOD get_global_authorizations.

    IF requested_authorizations-%create = if_abap_behv=>mk-on.
      result-%create = if_abap_behv=>auth-allowed.
    ENDIF.

    IF requested_authorizations-%update = if_abap_behv=>mk-on.
      result-%update = if_abap_behv=>auth-allowed.
    ENDIF.

    IF requested_authorizations-%delete = if_abap_behv=>mk-on.
      result-%delete = if_abap_behv=>auth-allowed.
    ENDIF.

  ENDMETHOD.


  METHOD validateCapacity.

    READ ENTITIES OF ZI_WM_RAP_BIN IN LOCAL MODE
      ENTITY Bin
      FIELDS ( Capacity )
      WITH CORRESPONDING #( keys )
      RESULT DATA(bins).

    LOOP AT bins INTO DATA(bin).

      IF bin-Capacity <= 0.

        APPEND VALUE #(
          %tky = bin-%tky
        ) TO failed-bin.

        APPEND VALUE #(
          %tky = bin-%tky
          %msg = new_message(
            id       = 'ZWM_MSG'
            number   = '001'
            severity = if_abap_behv_message=>severity-error
          )
          %element-Capacity = if_abap_behv=>mk-on
        ) TO reported-bin.

      ENDIF.

    ENDLOOP.

  ENDMETHOD.

ENDCLASS.
