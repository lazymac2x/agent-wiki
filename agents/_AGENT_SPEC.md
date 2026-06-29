---
name: _AGENT_SPEC
description: 코어 에이전트 카드 계약 — model·wiki_access·JIT 검색루프(search→get→reflect depth≤3)·skill 브리지·self-heal/HITL 훅
type: reference
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[note]], [[rubric]], [[sot-registry]], [[token-budget]]
---

# _AGENT_SPEC — 코어 에이전트 카드 계약

> `agents/*.agent.md` 한 장 = 한 코어 에이전트. **상단·프로젝트단위·비즈로직 보유.** wiki는 JIT로 끌어다 쓴다.
> 이 파일은 모든 카드가 따르는 **메타 계약**(reference). "왜 이런 구조인가"의 서사는 [[core-agent]] 패턴이 갖는다(L4 분리).
> 카드는 이 계약을 **복붙하지 말고 `[[_AGENT_SPEC]]`로 참조**한다(L1 단일 SOT).

## 1. 카드란 무엇인가
- 코어 에이전트 = 사람이 말 거는 진입점. 도메인 비즈로직(불변식·게이트·소유 데이터흐름)을 **자기 카드에 갖고**, 일반 지식은 wiki에서 JIT.
- **dual-home 금지**: 외부코드 프로젝트 = `agents/<name>.agent.md`(브레인+포인터) + `wiki/domain`(공유지식). from-scratch = `projects/<name>/`. 카드는 항상 한 곳.
- 카드는 얇게 — 디테일은 자식노트로 쪼개고 `[[link]]`. 임계(200줄/25KB) 전에 compaction-on-write. → [[token-budget]]

## 2. 카드 필수 섹션 (이 순서)
1. **역할 & 소유 비즈로직** — 이 에이전트만 아는 불변식/게이트(예: chokepoint, 서킷브레이커).
2. **카드 메타(선언)** — 아래 yaml 블록.
3. **wiki_access** — 접근 허용 노트를 `[[link]]` prose로 (allowlist = 항해 경계).
4. **self-heal / HITL 훅** — 런타임 이상수복·비가역 게이트.
5. **skill 브리지** — 재구현 금지, 당신 환경의 기존 스킬/루틴 호출(에이전트 메모리 경로).

```yaml
# 카드 메타 선언 (오케스트레이터가 파싱) — 값은 카드마다 다름
model:    opus            # 티어: opus=오케스트레이터 · haiku=워커/1차스크리닝 · 타패밀리=judge → [[model-tiering]]
preload:  [self_card, project_llms]   # 사전적재는 이 둘만. 나머지 전부 JIT
loop:     pdca | ooda     # 빌드/기능=pdca · 런타임이상수복=ooda
gate:     rubric7 ≥90, P0/P1=0        # 승격 게이트 → [[rubric]] [[evaluator-optimizer]]
hitl:     [prod_write, irreversible, conf<0.85]   # AskUserQuestion 의무
```

## 3. 사전적재 vs JIT (지연로딩 — 핵심)
- **사전적재(preload) = 딱 둘**: ① 자기 카드 1장 ② `projects/<name>/llms.txt`(있으면). 끝.
- 그 외 모든 wiki 본문은 **JIT**. `@import`/전체 wiki Read = 런치 때 전량 펼쳐짐 = 토큰절약 아님(L7). 가벼운 식별자(slug/경로/쿼리)만 컨텍스트에 둔다.
- 검색 디테일은 **sub-agent에 격리**하고 1~2k 토큰 요약만 회수(메인 컨텍스트 오염 방지).

## 4. JIT 검색계약 — search → get → reflect (depth≤3)
frontmatter가 신호다. 본문 읽기 전에 **frontmatter만 필터**(progressive disclosure).

```bash
# (search) frontmatter 라인만 ripgrep — 후보 slug 수집. 본문 안 읽음
rg -l -e '^description:.*<키워드>' -e '^type: <원하는타입>' wiki/ harness/ projects/
# (get) 후보의 frontmatter 헤더만 미리보기 → 관련성 판정
rg -m1 -A10 '^---$' <후보.md>      # 또는 Read(limit=12)
```

1. **search** — frontmatter(name/description/type/track) 키워드 매치로 후보 slug 목록만.
2. **get** — 후보의 frontmatter만 먼저 본다. 통과한 1~2개만 본문 Read.
3. **reflect** — 답에 부족하면 그 노트의 `[[link]]` 1홉 따라간다. **최대 3홉**(depth≤3). 그 안에 못 찾으면 "모른다"로 정직 종료(가짜 답 금지).

- **단일 SOT 신뢰**: 같은 사실은 한 노트에만. 두 곳에서 나오면 그게 버그(dup-SOT) → [[sot-registry]].
- 코드 진실이 의심되면 wiki를 믿지 말고 **ground-truth 직접쿼리**(프로덕션 DB/로그/두눈). build-green ≠ live-works.

## 5. wiki_access allowlist 규칙
- 각 카드는 자기 §3에 **접근 허용 노트 목록**을 `[[link]]`로 명시. 그게 그 에이전트의 항해 경계다.
- 경계 밖이 필요하면 → §4 검색으로 발견하되 새 상시 의존이면 카드 allowlist에 추가(evolution-on-write). 임의 전역 Read 금지.

## 6. self-heal / HITL 훅 (공통)
- **런타임 이상수복** = OODA, 당신의 자가수복 루틴 호출(Phase0~4: 탐지→분류→자율수복→검증→보고). → [[ooda-runtime]] [[self-healing]]
- **빌드/기능 품질루프** = PDCA + 90점 적대게이트. → [[pdca]] [[feedback-loop]]
- **HITL 의무**: prod 쓰기 · 비가역 · confidence<0.85 = **AskUserQuestion 명시인증 먼저**. 승인 없이 진행 금지.
- **가드레일** 공통 불변식은 [[guardrails]]. 마일스톤 보고는 [[notify]].

## 7. skill 브리지 (재구현 금지 — 호출만, *당신 환경의 스킬/루틴을 연결*)
| 필요 | 연결할 것(예) |
|---|---|
| 전수조사→실증→무한 90점 | 심층-피드백/적대비평 스킬 |
| 런타임 자율수복 | 자가수복 루틴 ≈ [[self-healing]] |
| 멀티에이전트 풀스택 빌드 | 멀티에이전트 빌드 스킬/스쿼드 |
| 교차검증 다관점 토론 | 다관점 토론 스킬 |
| 디바이스 제어·배포 | 디바이스 제어 스킬 |
| 실행증거·심판 | [[verify]] · [[judge]] |

harness 문서 = 이 스킬들의 사용설명서. 카드는 로직을 다시 짜지 말고 스킬을 부른다.

## 8. 카드 작성 체크리스트
- [ ] frontmatter 10키(→ [[note]]), `name == <파일>.agent`(`.md`만 제거됨), description ≤150자.
- [ ] §1~6 섹션 존재. 비즈로직은 카드에, 일반지식은 `[[link]]`(복붙 0).
- [ ] `[[link]]`는 전부 실재 slug. 사실 미상은 `TODO(owner)` + `status: DRAFT`.
- [ ] `scripts/check-all.sh` PASS → `status: PROVEN` 승격 검토.

## 현재 코어 에이전트 로스터 (제네릭 예시)
- [[example-app]] · [[example-bot]] · [[example-pipeline]] · [[example-edge]] · [[example-line]]
