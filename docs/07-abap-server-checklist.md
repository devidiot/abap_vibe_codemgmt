# ABAP 서버에서 해야 할 일 체크리스트

이 문서는 RAP 기반 Code 관리 OData 구현이 완료된 이후, ABAP 서버에서 수행해야 할 작업을 정리한 문서입니다.

## 1. 패키지 확인
- 패키지 ZRYAN_VIBE가 ABAP 시스템에 존재하는지 확인한다.
- 패키지에 개발 객체를 생성할 권한이 있는지 확인한다.

## 2. 객체 생성 확인
다음 객체가 생성되고 활성화되어 있는지 확인한다.
- 테이블: ZT_VIBE_CODEGROUP
- 테이블: ZT_VIBE_CODE
- CDS 엔티티: ZI_VIBE_CODEGROUP
- CDS 엔티티: ZI_VIBE_CODE
- Behavior Definition: ZI_VIBE_CODEGROUP, ZI_VIBE_CODE
- Behavior 구현 클래스: ZBP_I_VIBE_CODEGROUP, ZBP_I_VIBE_CODE
- Service Definition: ZUI_VIBE_CODEMGMT
- Service Binding: ZUI_VIBE_CODEMGMT

## 3. 활성화 확인
- 각 ABAP 객체가 활성화되었는지 확인한다.
- syntax error가 없는지 확인한다.
- activation 오류가 있으면 수정한다.

## 4. 서비스 노출 확인
- Service Binding이 정상 등록되었는지 확인한다.
- OData 엔드포인트가 생성되었는지 확인한다.
- 브라우저 또는 Postman으로 서비스 호출이 가능한지 확인한다.

## 5. 데이터 등록 테스트
- CodeGroup 데이터를 생성한다.
- 해당 그룹 아래에 Code 데이터를 생성한다.
- 조회/수정/삭제가 정상 동작하는지 확인한다.
- CodeGroupName/CodeValue를 비워서 생성 시 validation 오류가 발생하는지 확인한다.
- 동일한 CodeGroupID/CodeID로 재생성 시 기본키 중복 오류가 발생하는지 확인한다.

## 6. 관리 컬럼 확인
- created_by, created_at, updated_by, updated_at 값이 저장되는지 확인한다.
- 생성 시점과 수정 시점이 올바르게 반영되는지 확인한다.

## 7. 권한 및 보안 확인
- 현재 템플릿은 `@AccessControl.authorizationCheck: #NOT_REQUIRED`로 권한 체크를 생략한 상태다. 운영 반영 전 실제 권한 객체(DCL)를 설계하고 Behavior Definition에 `authorization` 절을 추가해야 한다.
- 적절한 사용자 권한이 있는지 확인한다.
- 서비스 호출 시 권한 오류가 없는지 확인한다.

## 8. 운영 배포 전 최종 확인
- 개발 시스템에서 테스트 완료
- 필요한 transport 준비
- 운영 반영 여부 검토
