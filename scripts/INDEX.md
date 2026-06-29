# INDEX — scripts

<!-- [GENERATED] scripts/gen-index.sh — 이 라인 아래 수기편집 금지. 사람용 글은 PROSE 블록에. -->
<!-- PROSE:START -->
_이 폴더의 지도. 항목은 frontmatter에서 자동 등재된다._
<!-- PROSE:END -->

## Scripts
- `check-all.sh` — CI 진입점 — gen-index --verify + wiki-lint. 이게 fail이면 라운드/배포/커밋 미종료
- `gen-index.sh` — frontmatter → 모든 폴더 INDEX.md + 루트 llms.txt 자동생성(drift 구조적 차단). --verify=stale시 CI fail
- `install-hooks.sh` — git pre-commit hook 배선 — 규칙을 컨텍스트(권고)에서 강제(집행)로. 최초 1회
- `new-project.sh` — 스캐폴더 — --agent-only <name>(외부코드=brain+pointer) | --buildable <name>(자기완결 서브트리). stamp+INDEX재생성+notify
- `wiki-lint.sh` — 단일 chokepoint 린터 — frontmatter/헤드라인≤150/깨진[[link]]/freshness/size/dup/preload존재/죽은경로/고아/헌장 (bash3.2 호환)
