CLASS z_class_lager DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    INTERFACES if_oo_adt_classrun.
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS z_class_lager IMPLEMENTATION.
  METHOD if_oo_adt_classrun~main.
    out->write( 'Hello world updated!' ).
  ENDMETHOD.
ENDCLASS.
