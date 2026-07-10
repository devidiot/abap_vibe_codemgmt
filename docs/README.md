# Vibe 코딩 시작 가이드

이 폴더는 S/4HANA RAP 기반으로 "CodeGroup / Code" 관리 OData를 구현하기 위한 개발 문서 모음입니다.

## 목표
- CodeGroup와 Code를 계층 구조로 관리한다.
- 생성/수정 정보인 created_by, created_at, updated_by, updated_at를 포함한다.
- RAP 기반으로 OData 서비스로 노출한다.
- 최종 OData 엔티티/서비스 이름은 ZVIBE_CODEMGMT로 한다.
- 개발 패키지는 ZRYAN_VIBE로 한다.

## 문서 구성
- [01-adt-why-needed.md](01-adt-why-needed.md): VS Code에서 ADT가 왜 필요한지 설명
- [02-requirements.md](02-requirements.md): 개발 전 준비사항
- [03-data-model-spec.md](03-data-model-spec.md): 데이터 모델 스펙
- [04-rap-development-plan.md](04-rap-development-plan.md): RAP 구현 계획
- [05-object-naming-template.md](05-object-naming-template.md): 객체 명명 템플릿
- [06-table-and-cds-design.md](06-table-and-cds-design.md): 테이블 및 CDS 설계안
- [07-abap-server-checklist.md](07-abap-server-checklist.md): ABAP 서버 작업 체크리스트
- [08-rap-code-template.md](08-rap-code-template.md): RAP 코드 템플릿 (`src/`와 동기화된 실제 예시)

## 권장 개발 순서
1. 개발 패키지와 네임스페이스 확인
2. 테이블 설계
3. CDS 엔티티 및 관계 정의
4. RAP Behavior 정의
5. Service Definition / Binding 생성
6. 테스트 및 검증

## 권장 객체 접두사
- 테이블: Z... (단, `ZT_`처럼 "Z + 1~2글자 + 언더스코어" 형태는 금지 — 테이블은 16자 제한이며 `Z` 다음 2~3번째 자리에 언더스코어를 쓸 수 없는 옛 SE11 네이밍 제약이 있다. 예: `ZVIBE_CDGROUP`)
- CDS: ZI_...
- Behavior Definition: CDS 이름과 동일 (ZI_...)
- Behavior 구현 클래스: ZBP_I_...
- Service: ZUI_...
