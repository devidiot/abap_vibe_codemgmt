# 개발 전 준비사항

RAP 기반 OData 개발을 시작하기 전에 아래 준비물이 필요합니다.

## 1. 시스템 환경
- S/4HANA 시스템 접근 권한
- ABAP 개발 패키지 권한
- 적절한 네임스페이스 또는 개발 영역

## 2. 도구
- VS Code
- ABAP 확장 기능 또는 ADT 연동 환경
- S/4HANA 연결 정보

## 3. 개발 대상
다음 기능을 포함하는 최소 스펙으로 시작하는 것이 좋습니다.
- CodeGroup CRUD
- Code CRUD
- CodeGroup과 Code의 1:N 관계
- 생성/수정 정보 컬럼
- 기본 validation
- OData 서비스 노출

## 4. 권장 개발 패키지 기준
- 패키지: ZRYAN_VIBE
- 최종 OData 엔티티/서비스 이름: ZVIBE_CODEMGMT
- 테이블 접두사: ZT_
- CDS 접두사: ZI_

## 5. 패키지 생성 여부
- ABAP 서버에 패키지 ZRYAN_VIBE가 이미 있어야 한다.
- 없으면 ADT 또는 SE80에서 먼저 생성해야 한다.
- 패키지가 없으면 테이블, CDS, Behavior, Service 객체를 생성할 수 없다.

## 5. 개발 체크포인트
- 테이블 생성 가능 여부
- CDS 활성화 가능 여부
- behavior 구현 가능 여부
- service binding 생성 가능 여부
- 테스트 가능 여부
