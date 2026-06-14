CLASS zfirst_btp_class DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS zfirst_btp_class IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.

    tyPES: BEGIN OF ty_stud,
           id(2) type n,
           name(10) tYPE c,
           eND OF tY_STUD.

    dATA: it_stud tYPE ZSTUD_TABLE_TYPE.

    it_stud = vaLUE #( ( id = '01' name = 'Priya' )
                       ( id = '02' name = 'Ranjith' )
                       ( id = '03' name = 'Devaki' )
                       ( id = '04' name = 'Chandru' ) ).

    out->write( expoRTING data = it_stud ).

  ENDMETHOD.
ENDCLASS.
