# 테이블 및 CDS 설계안

다음 기준으로 구현을 진행합니다.

## 1. 패키지 및 서비스 이름
- 패키지: ZRYAN_VIBE
- OData 엔티티/서비스 이름: ZVIBE_CODEMGMT

## 2. 테이블 설계안
### 2.1 코드 그룹 테이블
테이블명: ZVIBE_CDGROUP

필드:
- mandt: 클라이언트
- code_group_id: CHAR(20), 키
- code_group_name: CHAR(100)
- description: CHAR(255)
- is_active: CHAR(1), domain BOOLE ('X' / space)
- created_by: 데이터 엘리먼트 ABP_CREATION_USER
- created_at: 데이터 엘리먼트 ABP_CREATION_TSTMPL (UTCLONG 기반)
- updated_by: 데이터 엘리먼트 ABP_LASTCHANGE_USER
- updated_at: 데이터 엘리먼트 ABP_LASTCHANGE_TSTMPL (UTCLONG 기반)

### 2.2 코드 테이블
테이블명: ZVIBE_CODE

필드:
- mandt: 클라이언트
- code_group_id: CHAR(20), 키
- code_id: CHAR(20), 키
- code_value: CHAR(50)
- description: CHAR(255)
- is_active: CHAR(1), domain BOOLE ('X' / space)
- sort_order: NUMC(3)
- created_by: 데이터 엘리먼트 ABP_CREATION_USER
- created_at: 데이터 엘리먼트 ABP_CREATION_TSTMPL (UTCLONG 기반)
- updated_by: 데이터 엘리먼트 ABP_LASTCHANGE_USER
- updated_at: 데이터 엘리먼트 ABP_LASTCHANGE_TSTMPL (UTCLONG 기반)

## 3. CDS 엔티티 설계안
### 3.1 Root Entity
- 이름: ZI_VIBE_CODEGROUP
- 목적: CodeGroup 관리
- 키: code_group_id
- Behavior Definition: ZI_VIBE_CODEGROUP (zi_vibe_codegroup.bdef.asbdef)
- Behavior 구현 클래스: ZBP_I_VIBE_CODEGROUP

### 3.2 Child Entity
- 이름: ZI_VIBE_CODE
- 목적: Code 관리
- 키: code_group_id, code_id
- Behavior Definition: ZI_VIBE_CODE (zi_vibe_code.bdef.asbdef)
- Behavior 구현 클래스: ZBP_I_VIBE_CODE

## 4. 관계 설계
- CodeGroup 1 : N Code
- Code는 CodeGroup에 의존한다.
- Child의 lock/authorization은 `lock dependent by _CodeGroup`으로 부모에 위임한다.

## 5. RAP 처리 방식
- managed behavior 사용
- created_by/created_at/updated_by/updated_at은 CDS에 `@Semantics.user.createdBy` 등 관리 컬럼 주석을 달고, Behavior Definition에서 `field ( readonly )`로 지정하면 RAP 프레임워크가 자동으로 채워준다. 별도 ABAP 코드가 필요 없다.
- 관리 컬럼은 SAP가 RAP용으로 제공하는 표준 데이터 엘리먼트(`ABP_CREATION_USER`, `ABP_CREATION_TSTMPL`, `ABP_LASTCHANGE_USER`, `ABP_LASTCHANGE_TSTMPL`)를 그대로 참조한다. 필드명(CREATED_BY 등)은 자유롭게 짓되, 타입은 이 데이터 엘리먼트를 재사용해 UTCLONG 등 세부 타입을 직접 신경 쓰지 않는다.
- 필수값 검증(CodeGroupName, CodeValue)은 `validation ... on save` + 구현 클래스의 `FOR VALIDATE ON SAVE` 메서드로 구현한다.
- ID 중복 방지는 테이블 기본키(PK)로 DB 레벨에서 보장되므로 별도 중복 체크 로직은 불필요하다.
- CDS의 `@AccessControl.authorizationCheck: #NOT_REQUIRED`와 맞추어 Behavior Definition에도 `authorization` 절은 넣지 않았다. 운영 반영 전에는 실제 권한 객체를 설계하고 이 부분을 반드시 보완해야 한다.

## 6. 구현 순서
1. 테이블 생성
2. CDS 엔티티 정의
3. Behavior 구현
4. Service Definition / Binding 생성
5. OData 테스트
