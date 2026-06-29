# AGENTS.md — agent-wiki 헌장 (단일 정본 SOT)

> **이 한 파일이 규칙의 70~80%다.** 도구무관(Claude Code / Cursor / Codex / 사람 공용). 다른 진입점(`CLAUDE.md`)은 이걸 import 한다.
> 충돌 시 우선순위: 이 파일 > 폴더 `INDEX.md`의 로컬 주석 > 개별 노트 frontmatter.
> 이 저장소는 **자기 자신에게 규칙을 적용한다(dogfood)** — `scripts/check-all.sh`를 통과 못하면 커밋 금지.

---

## 1. 정체성 — 이게 뭐가
`agent-wiki`는 **지식 자산화 OS = "지식 공장"**. 흔어진 집단지성(하네스 노하우 + 도메인 지식 + 개인 운영지식)을
**검색 가능·링크된·검증된·토큰효율적** 자산으로 굳히고, 그 위에서 코어 에이전트가 일한다.
규모는 작게(알짜배기), 확장은 무한(이 폴더에서 바로 새 프로젝트/라인을 stamp).

**6폴더 멘탈모델 (이 순서로 외운다):**
| 폴더 | 한 단어 | 무엇 |
|---|---|---|
| `agents/` | **누가** | 코어 에이전트 — 프로젝트/라인별 비즈니스 로직 보유, wiki를 JIT로 끌어다 씀 |
| `wiki/` | **무엇을** | 지식 자산 — `domain/`(개발 공유) · `factory/`(제조) · `personal/`(개인 LLM wiki) |
| `harness/` | **어떻게** | 방법론 — `workflows/`(실행 how-to) · `patterns/`(개념·왜) |
| `projects/` | **어디서** | 프로젝트 미니 wiki(자기완결·자기유사) |
| `templates/` `prompts/` | **재료** | 부트스트랩 템플릿 + 예시 프롬프트(폴더트리 동봉) |
| `scripts/` `.ops/` `.claude/` | **위생·강제** | 생성/린트 CI + 운영 SOT + hook 강제 |

---

## 2. 7대 법칙 (Laws) — 전부 dogfood 대상

### L1. 단일 SOT chokepoint (문서판 단일소스 provider)
한 사실 = 한 노트에만 산다. 어디서나 `[[link]]`로 참조하고 **복붙 절대 금지**. → 상세 [[sot-registry]]
- 표면패치 = whack-a-mole. **단일소스가 근본.** 같은 값이 두 곳에 있으면 그게 버그다(`wiki-lint`의 dup-SOT가 잡는다).
- **외부 소유경계**: 자격증명/수익 같은 민감정보 = 외부 SOT 파일(`<your-secrets-sot>`) owns(wiki는 point만). 에이전트 학습 = auto-memory가 owns. 방법론+프로젝트지식 = **agent-wiki owns**. → [[memory-bridge]]

### L2. 프랙탈 INDEX + 위키링크 (자기유사 항해)
모든 폴더에 같은 모양 `INDEX.md`. 항목은 `- [[name]] — ≤150자 헤드라인` 1줄만. 루트 `INDEX.md`는 **인덱스의 인덱스**(본문 0).
- **고아노트 0**: 어떤 INDEX에서도 링크 안 되면 금지(`check-orphans`).
- ⚠️ `INDEX.md`·`llms.txt`는 **수기편집 금지** — `scripts/gen-index.sh`가 frontmatter에서 생성한다(상단 `[GENERATED]` 배너). 사람용 prose 서문만 롤업 위에 수기 유지.

### L3. frontmatter 계약 (전 노트 의무)
모든 `.md`는 [[note]] 템플릿의 frontmatter를 가진다: `name / description(≤150자) / type / track / status / owner / created / updated / source / links`.
- 에이전트는 **본문 전 frontmatter만 필터**로 노트를 선별(progressive disclosure·메타데이터=신호).
- `status`: `PROVEN`(실증·90점 통과) · `DRAFT`(미검증) · `DEPRECATED`(→ [[pruning]] tombstone).

### L4. Diátaxis × OPL 모드 비혼합 (한 파일 = 한 일)
`reference`/`howto` = **에이전트 검색면**(간결·독립소비·"위에서 본 대로" 크로스페이지 의존 금지).
`explanation`/`tutorial` = **사람용 서사**. 제조 `sop`/`opl`/`lesson`/`standard-work`도 같은 축.
- 한 문서가 4역할을 동시에 하려는 게 #1 문서 실패 모드. 분리 + 상호링크가 가치.

### L5. 검증-선-영속 (가짜0 금지)
실증(두눈 / 결정론 테스트 / D1 ground-truth) 없이 사실을 노트에 넣지 않는다.
- **CI-green ≠ correct**(타임존/DST류 의미버그는 통과한다) → 로직레벨 90점 적대리뷰 의무.
- **stale 노트는 없느니만 못하다**(능동 오도). `source:`가 가리키는 코드가 변하면 freshness-lint이 fail.
- 무음스킵 = vacuous green = 금지. 검증 불가 시 **loud skip-with-warning**.

### L6. 90점 적대 게이트 (evaluator-optimizer)
신규/수정 노트는 `verify`(실행증거) + `judge`(7축 JSON) + 결정론 lint를 통과해야 `PROVEN` 승격. → [[rubric]] [[evaluator-optimizer]]
- 7축: 정보위계 / 3초이해 / CTA / 가독성 / 일관성 / **정직성** / 예외처리.
- **종료조건 = 평균 ≥90 ∧ P0/P1 = 0 ∧ 반복상한(6)**. judge는 생성과 **다른 모델패밀리**(self-preference 회피).
- **audit ≠ constitution**: 감사는 헌법이 아니다. 실기능 필요권한은 축소 아닌 "근거+절차"로 정면돌파. 죽은 잔재만 제거.

### L7. 토큰예산 · 절단가드
- auto-memory류 인덱스는 **200줄 또는 25KB(바이트!) 중 먼저 도달 시 무음절단**. 한글 UTF-8 = 3B/자 → 실질 ~8K자에서 컷. → [[token-budget]]
- 헤드라인 ≤150자, `CLAUDE.md` ≤200줄. 노트가 임계 초과하면 **compaction-on-write**: 디테일을 자식노트+`[[link]]`로 쪼개고, 부모는 결정·버그·규칙만 남긴다.
- **JIT > 사전적재**: 가벼운 식별자(경로/쿼리/링크)만 컨텍스트에 두고 런타임에 본문을 끌어온다. `@import`는 런치 때 전량 펼쳐짐 = 토큰절약 아님.

---

## 3. 코어 에이전트 계약 (요약 — 상세 [[_AGENT_SPEC]])
- 코어 에이전트 = **상단·프로젝트단위·비즈로직 보유**. 사전적재는 자기 카드 + 프로젝트 `llms.txt`만, 나머지는 **JIT**(ripgrep-over-frontmatter로 search→get→reflect→answer, depth≤3).
- 검색 디테일은 sub-agent에 격리하고 **1~2k 토큰 요약만 회수**(컨텍스트 오염 방지).
- **dual-home 금지**: 외부코드 프로젝트 = `agents/<name>` + `wiki/domain`(brain+pointer). from-scratch = `projects/<name>` 자기완결 서브트리. 코어 에이전트는 항상 한 곳에만.
- 기존 에이전트 SKILL/루틴(심층-피드백·자가수복·멀티에이전트 빌드·다관점 토론 등 — *당신 환경의 것을 연결*)을 **호출·재사용**(중복구현 금지). harness 문서가 그 브리지다.

## 4. 루프 라우팅 (OODA vs PDCA)
- 봇/배포 **런타임 이상수복** = OODA(시간민감 빠른회전). → [[ooda-runtime]] [[self-healing]]
- **빌드/기능 개선** = PDCA(계획 품질루프). → [[pdca]]
- prod-write / 비가역 / confidence < 80~90% = **어느 루프든 HITL**(AskUserQuestion) 게이트.

## 5. git · 자원 (요약 — 상세 [[git-conventions]] [[model-tiering]])
- 단일 git DB · **경로한정 add**(`git add <경로>`) · 핫스팟은 `CODEOWNERS` single-writer · 나머지 additive-only.
- 병렬 = worktree-per-agent + 에이전트스코프 브랜치. git작업 직렬화(`kill -15` + `git worktree remove`, `kill -9`/`rm -rf` 금지). rebase-before-merge 순차머지.
- 모델 티어링: Opus=orchestrator, Haiku=worker/1차스크리닝, 다른패밀리=최종 judge. 동시성측 + 비용 원장 + $ 킬스위치.

## 6. 어디부터 (진입)
- 사람: [[README]] → 6폴더 멘탈모델.
- 에이전트: 루트 `llms.txt`(기계지도) → 필요 폴더 `INDEX.md` → ripgrep frontmatter.
- 새로 시작: [[bootstrap]](Day-1 최소 플로어) → `scripts/new-project.sh`.
- 변경 후: **반드시 `scripts/check-all.sh`** (lint + link + gen-index --verify). 통과해야 커밋·`PROVEN`.
