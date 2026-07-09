CLASS zbp_i_vibe_codegroup DEFINITION PUBLIC ABSTRACT FINAL FOR BEHAVIOR OF zi_vibe_codegroup.

  PRIVATE SECTION.
    METHODS validateCodeGroupName FOR VALIDATE ON SAVE
      IMPORTING keys FOR CodeGroup~validateCodeGroupName.

ENDCLASS.

CLASS zbp_i_vibe_codegroup IMPLEMENTATION.

  METHOD validateCodeGroupName.
    READ ENTITIES OF zi_vibe_codegroup IN LOCAL MODE
      ENTITY CodeGroup
        FIELDS ( CodeGroupName )
        WITH CORRESPONDING #( keys )
      RESULT DATA(codegroups).

    LOOP AT codegroups INTO DATA(codegroup) WHERE CodeGroupName IS INITIAL.
      APPEND VALUE #( %tky = codegroup-%tky ) TO failed-codegroup.
      APPEND VALUE #( %tky = codegroup-%tky
                       %msg = new_message( id       = '00'
                                           number   = '001'
                                           severity = if_abap_behv_message=>severity-error
                                           v1       = 'CodeGroupName' )
                       %element-CodeGroupName = if_abap_boolean=>abap_true )
             TO reported-codegroup.
    ENDLOOP.
  ENDMETHOD.

ENDCLASS.
