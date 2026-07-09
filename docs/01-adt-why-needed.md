# ADT가 왜 필요한가

VS Code 자체는 편집기이고, ABAP 개발을 위해서는 ABAP 백엔드와 연결되는 개발 도구가 필요합니다. 여기서 ADT가 핵심입니다.

## ADT란 무엇인가
ADT는 ABAP Development Tools의 약자입니다. ABAP 객체를 생성하고, 활성화하고, 검증하고, 배포하는 표준 개발 환경입니다.

## 왜 VS Code만으로는 부족한가
VS Code만으로는 아래 작업을 직접 처리하기 어렵습니다.
- ABAP DDIC 테이블 생성
- CDS 엔티티 생성
- RAP Behavior 구현
- Service Definition / Binding 생성
- 객체 활성화
- Syntax Check 및 런타임 테스트
- S/4HANA 시스템과의 연결

즉, VS Code는 코드 편집 도구이고, ADT는 ABAP 개발 생태계를 연결해 주는 실행 도구입니다.

## 실제로 필요한 이유
RAP 기반 개발에서는 다음 작업이 필요합니다.
1. S/4HANA 시스템에 ABAP 객체를 등록한다.
2. 객체를 활성화한다.
3. CDS와 Behavior가 올바르게 컴파일되는지 검증한다.
4. OData 서비스가 생성되는지 확인한다.
5. 테스트와 배포를 위해 ABAP 저장소와 연결한다.

이 과정은 Eclipse 기반 ADT가 가장 자연스럽게 지원합니다. VS Code에서 ABAP 확장 기능을 사용하더라도, 결국은 ABAP 시스템과의 개발 연동이 필요합니다.

## 한 줄 요약
- VS Code: 편집기
- ADT: ABAP 개발/연동/활성화/배포 도구
- RAP 개발: ADT가 없으면 개발 흐름이 완성되지 않는다
