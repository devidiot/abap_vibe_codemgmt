CLASS zbp_i_vibe_code DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_vibe_code.

  PRIVATE SECTION.
    METHODS validateCodeValue FOR VALIDATE ON SAVE
      IMPORTING keys FOR Code~validateCodeValue.

ENDCLASS.

CLASS zbp_i_vibe_code IMPLEMENTATION.

  METHOD validateCodeValue.
    READ ENTITIES OF zi_vibe_code IN LOCAL MODE
      ENTITY Code
        FIELDS ( CodeValue )
        WITH CORRESPONDING #( keys )
      RESULT DATA(codes).

    LOOP AT codes INTO DATA(code) WHERE CodeValue IS INITIAL.
      APPEND VALUE #( %tky = code-%tky ) TO failed-code.
      APPEND VALUE #( %tky = code-%tky
                       %msg = new_message( id       = '00'
                                           number   = '001'
                                           severity = if_abap_behv_message=>severity-error
                                           v1       = 'CodeValue' )
                       %element-CodeValue = if_abap_boolean=>abap_true )
             TO reported-code.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
