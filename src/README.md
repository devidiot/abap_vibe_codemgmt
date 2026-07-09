# RAP 구현 소스 (abapGit 리포지토리)

이 폴더는 abapGit이 SAP 시스템으로 pull하는 실제 소스 폴더다. `.abapgit.xml`(리포지토리 루트)이 이 폴더를 `STARTING_FOLDER`로 지정하고 있으므로, **모든 오브젝트 파일은 하위 폴더 없이 이 폴더 바로 아래에 평평하게(flat) 있어야 한다.** abapGit은 하위 폴더를 발견하면 그 이름을 서브패키지로 해석하므로, 임의로 폴더를 만들어 분류하면 pull이 깨진다.

## 포함 오브젝트
- `zt_vibe_codegroup.tabl.xml`, `zt_vibe_code.tabl.xml`: DDIC 테이블 (TABL, XML 메타데이터 직렬화)
- `zi_vibe_codegroup.ddls.asddls`, `zi_vibe_code.ddls.asddls`: CDS 뷰 (DDLS, 텍스트 소스)
- `zi_vibe_codegroup.bdef.asbdef`, `zi_vibe_code.bdef.asbdef`: Behavior Definition (텍스트 소스)
- `zbp_i_vibe_codegroup.clas.abap` + `.clas.xml`, `zbp_i_vibe_code.clas.abap` + `.clas.xml`: Behavior 구현 클래스 (소스 + 클래스 속성 메타데이터 쌍)
- `zui_vibe_codemgmt.srvd.srvd`: Service Definition (텍스트 소스)
- `zui_vibe_codemgmt.srvb.xml`: Service Binding (XML 메타데이터 직렬화)

## 신뢰도 주의 (중요)
`.tabl.xml`, `.clas.xml`, `.srvb.xml`은 텍스트 DDL이 아니라 SAP 내부 DDIC 구조(DD02V/DD09L/DD03P, VSEOCLASS, SRVB)를 그대로 XML로 옮긴 것이라, 실제 abapGit 직렬화 스키마와 완전히 동일한지 로컬에서 검증할 방법이 없다(라이브 SAP 시스템에 대한 실행 도구가 없음). 특히 **`zui_vibe_codemgmt.srvb.xml`이 가장 확신도가 낮다** — pull 시 이 오브젝트만 오류가 나면, 나머지(테이블/CDS/Behavior/Service Definition)를 먼저 활성화한 뒤 Service Binding만 ADT에서 수동으로 새로 만들어도 된다(마법사 몇 번 클릭이면 끝나는 간단한 작업).

## pull 순서 / 의존관계
abapGit은 기본적으로 오브젝트 간 의존관계(테이블→CDS→Behavior→Service)를 자동으로 파악해서 순서대로 처리한다. 만약 activation 오류가 나면 어떤 오브젝트에서 어떤 메시지가 났는지 그대로 알려주면 바로 원인 분석이 가능하다.

## 사용 방법
1. 이 리포지토리를 GitHub에 push한다 (사용자가 직접 수행).
2. ABAP 시스템에서 abapGit으로 해당 GitHub 리포지토리를 clone/pull하면서 대상 패키지를 `ZRYAN_VIBE`로 지정한다.
3. pull 완료 후 활성화 로그를 확인하고, 오류가 있으면 오브젝트별로 알려준다.
