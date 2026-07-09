# abap_vibe_codemgmt

S/4HANA RAP(ABAP RESTful Application Programming Model) 기반으로 "CodeGroup / Code" 마스터 데이터를 관리하는 OData 서비스의 **abapGit 리포지토리**다. `src/`를 GitHub에 push한 뒤, ABAP 시스템에서 abapGit으로 pull하여 패키지 `ZRYAN_VIBE`에 오브젝트를 일괄 반영하는 것을 전제로 한다.

## 이 저장소로 할 수 없는 것
- 로컬 빌드/테스트/린트 실행 (ABAP은 SAP 시스템 안에서만 컴파일된다)
- Syntax check, activation, abapGit deserialization 여부 확인 — 반드시 실제 시스템에서 pull/activate해봐야 확인된다
- 이 저장소에 있는 코드/XML이 "실행됨"을 검증한 적은 없다. 특히 `.tabl.xml`, `.clas.xml`, `.srvb.xml`은 텍스트 DDL이 아니라 SAP 내부 구조를 그대로 옮긴 XML이라 로컬에서 스키마를 검증할 방법이 없다. 문법/스키마는 알려진 abapGit 관례에 따라 작성했지만, 최종 확인은 실제 pull + activation이 유일한 근거다. pull 시 오류가 나면 오브젝트명과 메시지를 그대로 공유하면 바로 수정 가능하다.

## 핵심 명명 규칙
- 패키지: `ZRYAN_VIBE`
- OData 엔티티/서비스 이름: `ZVIBE_CODEMGMT`
- 테이블: `ZT_VIBE_CODEGROUP`, `ZT_VIBE_CODE` (접두사 `ZT_`)
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
- `src/zui_vibe_codemgmt.srvb.xml`은 abapGit의 SRVB 직렬화 스키마를 추정해서 작성한 것이라 신뢰도가 가장 낮다. pull 시 이 오브젝트만 오류가 나면, 나머지를 먼저 활성화한 뒤 Service Binding만 ADT에서 수동으로 새로 생성해도 된다.
- 패키지 `ZRYAN_VIBE`는 한때 "구조 패키지"로 설정되어 있어 개발 오브젝트 생성이 막혔던 이력이 있다(2026-07-09, `Structure packages cannot contain development objects`, PAK149). 현재는 개발 패키지로 변경 완료된 상태로 전달받았다.

## 이 저장소에서 작업할 때
- 문서(`docs/`)와 소스(`src/`)의 내용이 어긋나면 안 된다. 한쪽을 고치면 반드시 다른 쪽도 확인한다.
- 새 필드/엔티티를 추가할 때는 `03-data-model-spec.md`(스펙) → `06-table-and-cds-design.md`(설계) → `src/`(구현) → `08-rap-code-template.md`(예시) 순서로 반영한다.
