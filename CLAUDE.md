# abap_vibe_codemgmt

S/4HANA RAP(ABAP RESTful Application Programming Model) 기반으로 "CodeGroup / Code" 마스터 데이터를 관리하는 OData 서비스의 **abapGit 리포지토리**다. `src/`를 GitHub에 push한 뒤, ABAP 시스템에서 abapGit으로 pull하여 패키지 `ZRYAN_VIBE`에 오브젝트를 일괄 반영하는 것을 전제로 한다.

## 이 저장소로 할 수 없는 것
- 로컬 빌드/테스트/린트 실행 (ABAP은 SAP 시스템 안에서만 컴파일된다)
- Syntax check, activation, abapGit deserialization 여부 확인 — 반드시 실제 시스템에서 pull/activate해봐야 확인된다
- 이 저장소에 있는 코드/XML이 "실행됨"을 검증한 적은 없다. XML 계열 파일(`.tabl.xml`, `.clas.xml`, `.ddls.xml`, `.bdef.xml`, `.srvd.xml`, `.srvb.xml`)은 GitHub의 실제 abapGit 리포지토리(SAP 공식 샘플 `SAP-samples/abap-platform-rap110`, `SAP-samples/abap-platform-rap630`, 커뮤니티 `Xexer/abap_rap_blog` 등)에서 확인된 스키마를 그대로 따라 작성했다(2026-07-09 웹에서 직접 대조). 다만 필드명이 100% 우리 오브젝트와 일치하는 걸 실제 pull로 확인한 적은 없으므로, pull 시 오류가 나면 오브젝트명과 메시지를 그대로 공유하면 바로 수정 가능하다.

## 핵심 명명 규칙
- 패키지: `ZRYAN_VIBE`
- OData 엔티티/서비스 이름: `ZVIBE_CODEMGMT`
- 테이블: `ZT_VIBE_CDGROUP`, `ZT_VIBE_CODE` (접두사 `ZT_`)
- CDS 뷰: `ZI_VIBE_CODEGROUP`(root), `ZI_VIBE_CODE`(child) (접두사 `ZI_`)
- Behavior Definition: CDS 뷰와 동일한 이름 (`ZI_VIBE_CODEGROUP`, `ZI_VIBE_CODE`)
- Behavior 구현 클래스: `ZBP_I_VIBE_CODEGROUP`, `ZBP_I_VIBE_CODE` (접두사 `ZBP_I_`)
- Service Definition/Binding: `ZUI_VIBE_CODEMGMT` (접두사 `ZUI_`)

새 객체를 추가할 때는 위 접두사 규칙을 그대로 따른다.

## 구조
- `docs/`: 01~08번 순서로 읽는 설계 문서. `08-rap-code-template.md`는 `src/`의 실제 소스와 **항상 동기화**되어야 하는 참조 문서다 — `src/` 코드를 고치면 이 문서도 같이 고친다. abapGit의 `STARTING_FOLDER` 바깥에 있으므로 pull 대상에서 제외된다.
- `.abapgit.xml`: 리포지토리 루트 디스크립터. `STARTING_FOLDER`가 `/src/`를 가리킨다.
- `src/`: abapGit이 pull하는 실제 오브젝트 폴더. **반드시 flat 구조**(하위 폴더 금지 — abapGit이 하위 폴더를 서브패키지로 오인함). 오브젝트 간 생성/활성화 순서는 테이블 → CDS → Behavior Definition/구현 클래스 → Service Definition → Service Binding이며, abapGit이 pull 시 의존관계를 보고 자동으로 이 순서를 맞춘다.

## 데이터 모델
- `CodeGroup 1 : N Code`, composition으로 연결 (child는 root의 `association _Code { create; }`를 통한 deep-create로만 생성된다).
- 관리 컬럼(`created_by/at`, `updated_by/at`)은 CDS `@Semantics.user.createdBy` 등 주석 + Behavior Definition `field ( readonly )`만으로 RAP 프레임워크가 자동으로 채운다 — 커스텀 ABAP 코드를 짜지 않는다.
- ID 중복 방지는 테이블 기본키(PK)로 DB 레벨에서 보장된다 — Behavior에 중복 체크 코드를 넣지 않는다.
- 필수값 검증(`CodeGroupName`, `CodeValue` 등)만 `validation ... on save` + `FOR VALIDATE ON SAVE` 메서드로 구현한다.

## 알려진 한계 (운영 반영 전 반드시 보완)
- `@AccessControl.authorizationCheck: #NOT_REQUIRED`로 권한 체크를 생략한 상태다. 실제 권한 객체(DCL)를 설계하고 Behavior Definition에 `authorization` 절을 추가해야 한다.
- Validation 메시지가 표준 SY 메시지 클래스(`id = '00'`)를 임시로 사용 중이다. 전용 메시지 클래스(예: `ZVIBE_CODEMGMT`)로 교체해야 한다.
- `src/zui_vibe_codemgmt.srvb.xml`(Service Binding)이 XML 계열 중 가장 복잡한 구조(METADATA/CONTENT/SERVICES 중첩)라 상대적으로 신뢰도가 낮다. pull 시 이 오브젝트만 오류가 나면, 나머지를 먼저 활성화한 뒤 Service Binding만 ADT에서 수동으로 새로 생성해도 된다.
- `.ddls.baseinfo` 파일(ADT가 CDS 소스 분석 결과를 캐싱하는 JSON)은 의도적으로 포함하지 않았다 — 실제 리포지토리들에 존재하긴 하지만 ADT가 로컬에서 재생성하는 캐시성 파일로 보여서, 없어도 pull/activation 자체는 되는 것으로 판단했다. 만약 CDS 오브젝트에서만 이상 동작이 있으면 이 파일 누락을 의심할 것.
- 패키지 `ZRYAN_VIBE`는 한때 "구조 패키지"로 설정되어 있어 개발 오브젝트 생성이 막혔던 이력이 있다(2026-07-09, `Structure packages cannot contain development objects`, PAK149). 현재는 개발 패키지로 변경 완료된 상태로 전달받았다.
- 최초 `.abapgit.xml`을 오브젝트 직렬화 파일과 같은 `<abapGit><asx:abap>...` 이중 래퍼로 잘못 작성해서 `CX_XSLT_FORMAT_ERROR`가 발생했었다(2026-07-09). 리포지토리 루트 디스크립터는 `<asx:abap>`가 바로 루트여야 한다 — 오브젝트 파일들과 형식이 다르다는 점에 유의.
- **[해결됨] 테이블 생성 실패의 진짜 원인**: abapGit pull 시 CDS/Behavior/Service는 생성됐는데 CodeGroup 테이블만 오류 없이 조용히 생성되지 않았다(2026-07-10). ADT에서 수동 생성을 시도했을 때 `"17 characters exceed the maximum of 16 characters in field 'Name'"` 오류로 원인이 드러났다 — 원래 테이블명 `ZT_VIBE_CODEGROUP`이 17자였다. **클래식 ABAP Dictionary 테이블명은 16자 제한**이다(CDS 뷰/클래스/서비스 이름은 30자까지 가능한 것과 다르다). 그래서 CDS 엔티티 이름(`ZI_VIBE_CODEGROUP` 등)은 그대로 두고, 물리 테이블명만 `ZT_VIBE_CDGROUP`(15자)로 줄였다 — CDS `as select from`, Behavior Definition의 `persistent table`/`mapping for` 절도 함께 갱신했다. 새 테이블/엔티티를 추가할 때는 **테이블명은 16자 제한**이라는 점을 항상 먼저 확인할 것.
- ADT에는 테이블도 CDS처럼 텍스트 소스로 정의하는 방식이 있다는 것도 확인됨: `define table` DDL 문법(`@AbapCatalog.tableCategory` 등 주석 + `abap.clnt`/`abap.char(N)`/`abap.utclong` 같은 built-in 타입)으로 New Database Table의 source view에 그대로 붙여넣을 수 있다(3rd-party ADT 도구 `fr0ster/mcp-abap-adt`의 테스트 픽스처에서 동일 패턴이 10회 이상 반복 검증됨). abapGit이 막힐 때 수동 생성 대안으로 유효하다 — 이 경우 반드시 필드명(`mandt`, `code_group_id` 등)을 `src/*.tabl.xml`과 동일하게 맞춰서 이후 abapGit 재pull 시 충돌이 나지 않게 한다.

## 이 저장소에서 작업할 때
- 문서(`docs/`)와 소스(`src/`)의 내용이 어긋나면 안 된다. 한쪽을 고치면 반드시 다른 쪽도 확인한다.
- 새 필드/엔티티를 추가할 때는 `03-data-model-spec.md`(스펙) → `06-table-and-cds-design.md`(설계) → `src/`(구현) → `08-rap-code-template.md`(예시) 순서로 반영한다.
