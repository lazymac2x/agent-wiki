@AGENTS.md

# CLAUDE.md — Claude Code 전용 오버레이

> 규칙의 본체는 위 `@AGENTS.md`에 있다(런치 시 전량 펼쳐짐). 여기는 **Claude Code에서만 의미 있는 것**만. ≤200줄 유지.

## 세션 시작 시
1. 루트 `llms.txt`(기계지도)를 먼저 본다 — INDEX는 거기서 링크 따라간다. 전체 트리를 통厰로 읽지 말 것(토큰낭비).
2. 작업 대상 프로젝트가 정해지면 그 코어 에이전트 카드(`agents/<name>.agent.md`) + `projects/<name>/llms.txt`만 적재.
3. 나머지 지식은 **JIT**: `rg -l "^name:|^description:|^type:" wiki/ projects/`로 frontmatter 검색 → 후보만 Read.

## 이 저장소와 라이브 메모리의 경계 (중요 — [[memory-bridge]])
- **에이전트 auto-memory 파일**(세션마다 자동 로드되는 메모리) = **에이전트 학습**. agent-wiki가 여기 사실을 복제하지 않는다.
- **외부 자격/수익 SOT 파일**(`<your-secrets-sot>`) = **민감정보**. agent-wiki는 **point만**(복붙·재기재 금지).
- `agent-wiki/wiki/` = **방법론 + 프로젝트/도메인 지식** owns. 셋이 겹치면 [[sot-registry]] 1:1 등록 규칙으로 해소.
- 새 노하우가 생기면: 재사용·범용 → agent-wiki, 휘발성 학습 → auto-memory, 민감정보 → 외부 SOT. **세 곳에 동시 기록 금지.**

## SKILL 브리지 (재구현 금지, 호출만 — *당신 환경의 스킬/루틴을 연결*)
| 작업 | 연결할 것(예) |
|---|---|
| 전수조사→실증→무한 90점 | 심층-피드백/적대비평 스킬 — harness 문서가 그 사용설명서 역할 |
| 런타임 이상 자율수복 | 자가수복 루틴 ≈ [[self-healing]] |
| 멀티에이전트 풀스택 빌드 | 멀티에이전트 빌드 스킬/스쿼드 |
| 교차검증 다관점 | 다관점 토론 스킬 |
| 디바이스 제어·배포 | 디바이스 제어 스킬 |
| UI/로고/색/디자인 | 전용 디자인 에이전트 위임 (crude 자가처리 금지 — [[design]]) |

## 강제(enforcement)
- 규칙은 **컨텍스트일 뿐 강제가 아니다.** 실제 강제는 `.claude/settings.json` + `.claude/hooks/pre-commit.sh`가 한다.
- 커밋 전 `scripts/check-all.sh`가 fail이면 **라운드/배포 미종료**. 이걸 우회하면 doc-rot가 그대로 재현된다(build-green≠live-works의 문서판).

## Telegram 보고
- 마일스톤(PDCA Act 완료 · 배포 · 머지)마다 `mcp telegram notify_user`로 1줄 보고. → [[notify]]
- 캐시 TTL 5분: 백그라운드 폴링으로 캐시를 태우지 말 것(작업 완료 시 자동 재호출됨).

## 작업 규율 (권장 — 자신의 규율로 교체·확장)
- 정직: 안 되는 건 "안 된다". `build-green ≠ live-works`. 가짜0 금지.
- 두눈 실증 + 결정론 테스트(무음스킵 = vacuous green = 금지).
- prod 쓰기·비가역 작업 = **AskUserQuestion 명시인증 먼저**.
- 문서 커지면 쪼개고 `[[link]]`. 절단(200줄/25KB) 전에 compaction-on-write.
