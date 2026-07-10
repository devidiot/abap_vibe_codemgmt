# RAP 코드 템플릿

이 문서는 실제 ABAP RAP 구현을 시작할 때 참고할 수 있는 기본 템플릿입니다. `src/` 폴더의 실제 소스와 항상 동일하게 유지합니다.

## 1. CDS Root Entity 예시
```abap
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vibe Code Group'
define root view entity ZI_VIBE_CODEGROUP
  as select from zvibe_cdgroup as CodeGroup
  composition [0..*] of ZI_VIBE_CODE as _Code
{
  key CodeGroup.code_group_id as CodeGroupID,
      CodeGroup.code_group_name as CodeGroupName,
      CodeGroup.description as Description,
      CodeGroup.is_active as IsActive,

      @Semantics.user.createdBy: true
      CodeGroup.created_by as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      CodeGroup.created_at as CreatedAt,
      @Semantics.user.lastChangedBy: true
      CodeGroup.updated_by as UpdatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      CodeGroup.updated_at as UpdatedAt,
      _Code
}
```

## 2. CDS Child Entity 예시
```abap
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Vibe Code'
define view entity ZI_VIBE_CODE
  as select from zvibe_code as Code
  association [1..1] to ZI_VIBE_CODEGROUP as _CodeGroup
    on $projection.CodeGroupID = _CodeGroup.CodeGroupID
{
  key Code.code_group_id as CodeGroupID,
  key Code.code_id as CodeID,
      Code.code_value as CodeValue,
      Code.description as Description,
      Code.is_active as IsActive,
      Code.sort_order as SortOrder,

      @Semantics.user.createdBy: true
      Code.created_by as CreatedBy,
      @Semantics.systemDateTime.createdAt: true
      Code.created_at as CreatedAt,
      @Semantics.user.lastChangedBy: true
      Code.updated_by as UpdatedBy,
      @Semantics.systemDateTime.lastChangedAt: true
      Code.updated_at as UpdatedAt,
      _CodeGroup
}
```

## 3. Behavior Definition 예시
### 3.1 Root (CodeGroup)
```abap
managed implementation in class zbp_i_vibe_codegroup unique;
strict ( 2 );

define behavior for ZI_VIBE_CODEGROUP alias CodeGroup
persistent table zvibe_cdgroup
lock master
etc
{
  create;
  update;
  delete;

  field ( mandatory ) CodeGroupID;
  field ( readonly )  CreatedBy, CreatedAt, UpdatedBy, UpdatedAt;

  validation validateCodeGroupName on save { create; update; }

  association _Code { create; }

  mapping for zvibe_cdgroup
  {
    CodeGroupID   = code_group_id;
    CodeGroupName = code_group_name;
    Description   = description;
    IsActive      = is_active;
    CreatedBy     = created_by;
    CreatedAt     = created_at;
    UpdatedBy     = updated_by;
    UpdatedAt     = updated_at;
  }
}
```

### 3.2 Child (Code)
```abap
managed implementation in class zbp_i_vibe_code unique;
strict ( 2 );

define behavior for ZI_VIBE_CODE alias Code
persistent table zvibe_code
lock dependent by _CodeGroup
etc
{
  update;
  delete;

  field ( mandatory ) CodeGroupID, CodeID;
  field ( readonly )  CreatedBy, CreatedAt, UpdatedBy, UpdatedAt;

  validation validateCodeValue on save { create; update; }

  association _CodeGroup;

  mapping for zvibe_code
  {
    CodeGroupID = code_group_id;
    CodeID      = code_id;
    CodeValue   = code_value;
    Description = description;
    IsActive    = is_active;
    SortOrder   = sort_order;
    CreatedBy   = created_by;
    CreatedAt   = created_at;
    UpdatedBy   = updated_by;
    UpdatedAt   = updated_at;
  }
}
```

Child 엔티티는 자체 `create` 오퍼레이션을 선언하지 않는다. Root의 `association _Code { create; }` 절을 통해 CodeGroup 생성 시(또는 딥 업데이트 시) 함께 생성되는 deep-create 방식을 사용한다.

## 4. Behavior 구현 클래스 예시
### 4.1 Root (CodeGroup)
```abap
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
```

### 4.2 Child (Code)
```abap
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
```

> 메시지는 표준 SY 메시지 클래스(`id = '00'`)를 임시로 사용한다. 운영 반영 전에는 전용 메시지 클래스(예: `ZVIBE_CODEMGMT`)를 만들어 교체하는 것을 권장한다.

## 5. Service Definition 예시
```abap
define service ZUI_VIBE_CODEMGMT {
  expose ZI_VIBE_CODEGROUP as CodeGroup;
  expose ZI_VIBE_CODE as Code;
}
```

## 6. 구현 시 주의점
- 관리 컬럼(created_by/at, updated_by/at)은 CDS의 `@Semantics...` 주석과 Behavior Definition의 `field ( readonly )`만으로 RAP 프레임워크가 자동으로 채운다. 별도 코드가 필요 없다.
- 관계는 composition으로 연결하고, Child 생성은 Root의 `association _Code { create; }`를 통한 딥 생성으로 처리한다.
- Child의 lock/authorization은 `lock dependent by _CodeGroup`으로 Root에 위임한다.
- ID 중복은 테이블 기본키(PK)로 DB 레벨에서 막히므로 Behavior에서 별도로 체크하지 않는다.
- 필수값(CodeGroupName, CodeValue) 검증은 `validation ... on save` + `FOR VALIDATE ON SAVE` 메서드로 구현한다.
- 서비스 이름은 ZVIBE_CODEMGMT로 통일한다.
- `authorization` 절은 현재 생략되어 있다(§7 체크리스트 참고). 운영 반영 전 반드시 보완한다.
