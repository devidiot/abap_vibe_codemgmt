# 데이터 모델 스펙

이 프로젝트는 CodeGroup / Code 구조로 관리하는 코드 마스터 모델을 구현합니다.

## 1. 엔티티 개요
### CodeGroup
CodeGroup은 코드 그룹 단위의 마스터 데이터입니다.

예시:
- HR_STATUS
- APPROVAL_TYPE
- PAYMENT_METHOD

### Code
Code는 특정 CodeGroup 아래의 코드 값입니다.

예시:
- HR_STATUS: A, B, C
- APPROVAL_TYPE: Y, N

## 2. 필드 정의
### CodeGroup 테이블
- code_group_id: 그룹 ID, 키
- code_group_name: 그룹명
- description: 설명
- is_active: 사용 여부
- created_by: 생성자
- created_at: 생성일시
- updated_by: 수정자
- updated_at: 수정일시

### Code 테이블
- code_group_id: CodeGroup 키 참조
- code_id: 코드 ID, 키
- code_value: 코드값
- description: 설명
- is_active: 사용 여부
- sort_order: 정렬 순서
- created_by: 생성자
- created_at: 생성일시
- updated_by: 수정자
- updated_at: 수정일시

## 3. 관계
- CodeGroup 1 : N Code
- Code는 반드시 CodeGroup에 속한다.

## 4. 기본 비즈니스 규칙
- CodeGroup ID는 중복될 수 없다.
- 같은 CodeGroup 내 Code ID는 중복될 수 없다.
- 필수값이 비어 있으면 안 된다.
- 비활성 코드는 조회 우선순위에서 제외할 수 있다.

## 5. 권장 테이블명 예시
- ZT_VIBE_CDGROUP
- ZT_VIBE_CODE

## 6. 구현 이름 기준
- 패키지: ZRYAN_VIBE
- OData 엔티티/서비스 이름: ZVIBE_CODEMGMT
- 기본 CDS 루트 엔티티: ZI_VIBE_CODEGROUP
