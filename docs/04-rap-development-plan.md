# RAP 구현 계획

이 프로젝트는 RAP managed 방식으로 구현하는 것을 기본으로 합니다.

## 1. 구현 단계
### 단계 1. 테이블 생성
- CodeGroup 테이블 생성
- Code 테이블 생성
- 관리 컬럼 포함

### 단계 2. CDS 엔티티 정의
- Root entity: CodeGroup
- Child entity: Code
- Composition 또는 Association 연결

### 단계 3. Behavior 정의
- managed 구현
- Root(ZI_VIBE_CODEGROUP), Child(ZI_VIBE_CODE) 각각 Behavior Definition(.bdef) 작성
- 생성/수정/삭제 처리 (Child는 Root composition을 통한 deep create로 생성)
- 관리 컬럼(created_by 등)은 CDS 주석 + `field ( readonly )`로 자동 처리
- 기본 validation 추가 (필수값 체크)

### 단계 4. Service 정의
- Service Definition 생성
- Service Binding 생성
- OData 서비스 노출

### 단계 5. 테스트
- 생성/조회/수정/삭제 확인
- 관계 데이터 확인
- 생성/수정 정보 확인

## 2. 권장 객체 예시
- 패키지: ZRYAN_VIBE
- OData 엔티티/서비스 이름: ZVIBE_CODEMGMT
- 테이블: ZT_VIBE_CDGROUP, ZT_VIBE_CODE
- CDS: ZI_VIBE_CODEGROUP, ZI_VIBE_CODE
- Behavior Definition: ZI_VIBE_CODEGROUP, ZI_VIBE_CODE
- Behavior 구현 클래스: ZBP_I_VIBE_CODEGROUP, ZBP_I_VIBE_CODE
- Service: ZUI_VIBE_CODEMGMT

## 3. 구현 시 주의점
- 관리 컬럼은 RAP managed semantics를 활용한다.
- 키 설계는 부모/자식 관계를 명확히 한다.
- ID 중복 방지는 테이블 기본키(PK)로 DB 레벨에서 보장되므로 Behavior에 별도 코드가 필요 없다.
- 서비스는 최소 기능부터 노출한다.

## 4. 완료 기준
- OData로 CodeGroup과 Code를 CRUD할 수 있다.
- 생성/수정 정보가 저장된다.
- 기본 관계가 정상 동작한다.
