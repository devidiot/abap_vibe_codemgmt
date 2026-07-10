# RAP 구현 소스 (abapGit 리포지토리)

이 폴더는 abapGit이 SAP 시스템으로 pull하는 실제 소스 폴더다. `.abapgit.xml`(리포지토리 루트)이 이 폴더를 `STARTING_FOLDER`로 지정하고 있으므로, **모든 오브젝트 파일은 하위 폴더 없이 이 폴더 바로 아래에 평평하게(flat) 있어야 한다.** abapGit은 하위 폴더를 발견하면 그 이름을 서브패키지로 해석하므로, 임의로 폴더를 만들어 분류하면 pull이 깨진다.

## 포함 오브젝트 (오브젝트당 소스 + 메타데이터 XML 쌍)
- `zvibe_cdgroup.tabl.xml`, `zvibe_code.tabl.xml`: DDIC 테이블 (TABL). 순수 XML 메타데이터 직렬화, 텍스트 소스 없음.
- `zi_vibe_codegroup.ddls.asddls` + `.ddls.xml`, `zi_vibe_code.ddls.asddls` + `.ddls.xml`: CDS 뷰 (DDLS). 텍스트 소스 + 메타데이터(설명, SOURCE_TYPE) 쌍.
- `zi_vibe_codegroup.bdef.asbdef` + `.bdef.xml`, `zi_vibe_code.bdef.asbdef` + `.bdef.xml`: Behavior Definition. 텍스트 소스 + 메타데이터 쌍.
- `zbp_i_vibe_codegroup.clas.abap` + `.clas.xml`, `zbp_i_vibe_code.clas.abap` + `.clas.xml`: Behavior 구현 클래스. 소스 + 클래스 속성(CATEGORY=06 Behavior Pool 등) 쌍.
- `zui_vibe_codemgmt.srvd.srvdsrv` + `.srvd.xml`: Service Definition. 텍스트 소스 + 메타데이터 쌍. (확장자가 `.srvd.srvd`가 아니라 `.srvd.srvdsrv`인 점 주의)
- `zui_vibe_codemgmt.srvb.xml`: Service Binding. 순수 XML 메타데이터, 텍스트 소스 없음.

## 신뢰도 근거
2026-07-09에 아래 실제 GitHub 리포지토리를 웹에서 직접 조회해 스키마를 대조했다:
- `SAP-samples/abap-platform-rap110`, `SAP-samples/abap-platform-rap630` (SAP 공식 튜토리얼 샘플)
- `Xexer/abap_rap_blog` (커뮤니티 RAP 예제)

이 과정에서 처음 작성했던 버전의 실수를 다수 발견해 수정했다: 테이블은 `POSITION` 필드가 아니라 `INTTYPE`/`INTLEN`/`MASK` 방식이었고, 관리 컬럼은 `SYUNAME`/직접 `UTCLONG`이 아니라 SAP 표준 RAP 데이터 엘리먼트(`ABP_CREATION_USER`, `ABP_CREATION_TSTMPL`, `ABP_LASTCHANGE_USER`, `ABP_LASTCHANGE_TSTMPL`)를 참조해야 했다. CDS/Behavior Definition/Service Definition은 텍스트 소스 외에 **별도 `.xml` 메타데이터 파일이 반드시 필요**했고(처음엔 없어도 되는 줄 알았다), Service Definition의 실제 확장자는 `.srvd.srvdsrv`였다(`.srvd.srvd` 아님). Service Binding XML도 훨씬 복잡한 `METADATA`/`CONTENT`/`SERVICES` 중첩 구조였다.

그럼에도 실제 pull로 끝까지 검증한 적은 없으므로, **`zui_vibe_codemgmt.srvb.xml`(가장 복잡한 구조)이 상대적으로 가장 신뢰도가 낮다.** pull 시 이 오브젝트만 오류가 나면, 나머지(테이블/CDS/Behavior/Service Definition)는 이미 반영됐을 것이므로 Service Binding만 ADT에서 수동으로 새로 만들어도 된다(마법사 몇 번 클릭이면 끝).

## 사용 방법
1. 이 리포지토리를 GitHub에 push한다 (사용자가 직접 수행).
2. ABAP 시스템에서 abapGit으로 해당 GitHub 리포지토리를 clone/pull하면서 대상 패키지를 `ZRYAN_VIBE`로 지정한다.
3. pull 완료 후 활성화 로그를 확인하고, 오류가 있으면 오브젝트별로 알려준다.
