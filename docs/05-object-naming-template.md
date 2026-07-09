# 객체 명명 템플릿

다음 이름으로 구현을 진행합니다.

## 기본 정보
- 패키지: ZRYAN_VIBE
- OData 엔티티/서비스 이름: ZVIBE_CODEMGMT

## 권장 객체 이름
- 테이블: ZT_VIBE_CODEGROUP
- 테이블: ZT_VIBE_CODE
- CDS Root Entity: ZI_VIBE_CODEGROUP
- CDS Child Entity: ZI_VIBE_CODE
- Behavior Definition: ZI_VIBE_CODEGROUP
- Behavior Definition: ZI_VIBE_CODE
- Behavior 구현 클래스: ZBP_I_VIBE_CODEGROUP
- Behavior 구현 클래스: ZBP_I_VIBE_CODE
- Service Definition: ZUI_VIBE_CODEMGMT
- Service Binding: ZUI_VIBE_CODEMGMT

## 생성 순서
1. 패키지 ZRYAN_VIBE가 ABAP 시스템에 존재하는지 확인
2. 테이블 생성
3. CDS 엔티티 생성 (Root → Child 순서)
4. Behavior Definition 및 구현 클래스 생성 (Root → Child 순서)
5. Service Definition / Binding 생성
6. OData 테스트

## 패키지 준비 여부
- 패키지 ZRYAN_VIBE가 없으면 먼저 생성해야 합니다.
- 패키지 생성은 ADT 또는 SE80에서 진행합니다.
- 생성 후에는 해당 패키지 아래에 테이블과 RAP 객체를 배치합니다.
