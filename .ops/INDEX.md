# INDEX — .ops

<!-- [GENERATED] scripts/gen-index.sh — 이 라인 아래 수기편집 금지. 사람용 글은 PROSE 블록에. -->
<!-- PROSE:START -->
_이 폴더의 지도. 항목은 frontmatter에서 자동 등재된다._
<!-- PROSE:END -->

## Notes
- [[backlog]] — 의식적으로 이연한 항목 — audit≠constitution(감사가 권한 건 다 구현하지 않는다, 근거 갖춰 이연). 죽은 잔재 아님·추적됨
- [[bootstrap]] — [DRAFT] Day-1 시딩/마이그레이션 — 최소가용 플로어(AGENTS+INDEX+예시앱 worked+pdca)→기존 학습 엔트리 import 순서→점진확장. 빈 husk 방지
- [[git-conventions]] — git 충돌방지 — 단일 git DB·경로한정 add·핫스팟 single-writer·additive-only·worktree-per-agent 스코프브랜치·git 직렬화(kill-15+worktree remove)·rebase-before-merge
- [[memory-bridge]] — 라이브 메모리 3중 화해 — auto-memory(에이전트학습) · 외부 자격/수익SOT · agent-wiki(방법론+지식). 로드순서·쓰기권한·drift 방지
- [[model-tiering]] — 자원효율 모델 티어링 — Opus orchestrator/Haiku worker+1차스크리닝/다른패밀리 최종judge(self-pref 회피)·동시성캡·토큰/비용 원장·$ 킬스위치 임계
- [[notify]] — 텔레그램 마일스톤 notify(mcp telegram notify_user) — 트리거점(PDCA Act·배포·머지 완료)·1줄 보고·notify_user vs ask_user·캐시 TTL 5분 운영노트
- [[pruning]] — [DRAFT] 분기 pruning — 죽은잔재만 제거(audit≠constitution: 실기능은 근거+절차로 보존)·supersession 수명주기(정본 이동시 archive tombstone+리다이렉트 스텁)로 깨진링크 방지
- [[sot-registry]] — 단일 SOT 레지스트리 — 한 사실=한 정본노트 1:1 등록표 + 외부 소유경계(자격/페이아웃=외부 SOT owns·wiki는 point만). dup-SOT 방지의 마스터 인덱스
- [[token-budget]] — 토큰예산·절단가드 — 200줄/25KB(바이트) 먼저 도달 시 무음절단·한글3B/자→~8K자컷·@import=전량펼침(절약아님)·JIT/skill이 진짜 지연·compaction-on-write
