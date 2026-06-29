---
name: guardrails
description: bounded exec(max-step·cost-cap·time-bound 구체수치)+input/tool-call/tool-response/output 4지점 가드·단일 chokepoint=poka-yoke
type: pattern
track: method
status: PROVEN
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[self-healing]], [[manufacturing-bridge]], [[model-tiering]]
---

# guardrails — 자율 실행을 bounded 하게

자율 에이전트의 3대 폭주 모드: **무한루프 · 비용폭주 · prod 파괴.** 가드레일은 실패를 *막는 게 아니라* **bounded(유계)** 하게 만든다 — 터져도 한 칸 안에서 터지게. 가드가 걸리면 [[self-healing]] OODA로 라우팅. 제조 대응(andon·poka-yoke·자동화)은 [[manufacturing-bridge]].

## A. Bounded execution (구체 수치 — 묶어두기)
| 차원 | 가드 | 구체값(검증된 기본) |
|---|---|---|
| **max-step** | 도구 루프 깊이 상한 | depth ≤ 3 (에이전틱 도구 루프 예시) |
| | 적대 게이트 반복 | iteration cap = 6 (→ [[rubric]] 종료조건) |
| **cost-cap** | $ 킬스위치 | 일일/태스크 한도 초과 시 강제정지(자동매매 봇 예시) |
| | 토큰/호출 캡 | per-run 토큰 상한 · BYOK=유저키·서버=가드통과 시만 |
| | 동시성 캡 | worktree-per-agent N 상한 + 비용 원장 |
| **time-bound** | wall-clock 타임아웃 | 빌드 워처 600초(데몬 120초 stall → nohup 디태치) |
| | 폴링 백오프 | 캐시 TTL 내 재폴링 금지(불필요 호출 차단) |
> 수치는 "있으면 좋은 것"이 아니라 **필수 회로차단기**. 없으면 한 번의 오작동이 무한히 증식한다(자동매매 봇이 브레이커를 우회해 손익분기 미만에서 무한 재진입한 사례 = 브레이커 우회의 근본).

## B. 4지점 가드 (데이터 흐름의 관문)
1. **input** — 들어오는 것 검증/sanitize. phantom 레코드([0,1] 이탈 부패값) 제거, 미래 타임스탬프·em대시·raw id sanitize, civil date는 edge에서 .toLocal().
2. **tool-call** — 나가기 전. allow-list(허용 도구만) · 인자 스키마 검증 · **prod-write/비가역/confidence<80~90% = HITL(AskUserQuestion) 게이트**.
3. **tool-response** — 받은 것 신뢰 금지. 스키마 체크 · husk/garbage(garbage duration) 필터 · plausibility 게이트(현실범위 밖 reject).
4. **output** — 최종 산출. JSON 계약 준수 · 환각 사실 차단(근거 없는 단정 금지) · 가짜0 금지.
> 4지점 중 하나라도 비면 그 틈으로 샌다(에이전트 환각 양방향: 있는데 "없다" + stale로 "과부하" — 두 틈 다 막아야 RELIABILITY 통과).

## C. ★ 단일 chokepoint = poka-yoke (실수를 불가능하게)
표면패치는 whack-a-mole — 같은 결함이 가드 분산된 N곳에서 반복 재발한다. 정답은 **모든 경로를 단일 관문으로 강제 통과**시키는 것. → [[single-sot-chokepoint]]
- 사례: 모든 통계 화면(헤더·요약·집계·주간·대시보드)이 **단일 정본 레코드 provider(single-source)** 하나를 경유. 검증은 단일 메트릭 모듈의 `isValidRecord`(예: 측정치 하한 + 현실범위 상·하한) 단일 SOT.
- 핵심 차이: 가드를 *추가*하는 게 아니라(잊으면 구멍), **틀린 경로 자체를 없애** 우회가 구조적으로 불가능하게(poka-yoke). 새 호출자도 자동으로 가드 안에 든다.
- 가드 우회는 그 자체가 P0: 서킷브레이커의 재시작 카운터를 갱신하지 않는 경로로 재시작하면(재시작 기록 누락) 브레이커가 매번 소멸 → 무의미.

## D. Graduated remediation (걸렸을 때 — andon)
가드 트립 시 즉시 kill -9 아님. **3단계 제동의 정의·명칭은 [[self-healing]] Phase 2가 owns**(여기서 재정의 금지 = dup-SOT 회피). 선행신호 **경고**(점등, 예: 25KB 근접 warn)는 제동단계가 아니다 → 그 뒤 **조이기**(재시작·재시도·가동 유지) → **늦추기**(백오프·동시성 캡·저비용 티어 [[model-tiering]]) → **세우기**(정지·롤백 + [[self-healing]] 원인 진단·수복·검증). 안돈 매핑은 [[manufacturing-bridge]].

## 결정 / 규칙
- 가드레일 없는 자율 실행 금지 — 최소 max-step·cost-cap·time-bound 셋은 의무.
- prod 쓰기는 **항상 HITL 먼저**. "build-green"은 가드 면제 사유가 아니다(라이브 결함은 적대리뷰로만 잡힌다).
- 가드를 분산 추가하기 전에 **단일 chokepoint로 합칠 수 있나** 먼저 물어라 — 그게 근본.
