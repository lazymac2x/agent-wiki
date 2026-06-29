---
name: self-healing
description: 이상탐지→분류→graduated(조이기·늦추기·세우기)→검증(결정론·가짜0)→런타임 자율수복 · prod-write=HITL · 자가수복 루틴 브리지(Phase0~4)
type: howto
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[ooda-runtime]], [[guardrails]], [[notify]]
---

# Self-Healing — 자율 진단·수복 (자가수복 루틴 Phase 0~4)

당신의 런타임 자가수복 루틴(자신의 환경에 있는 것을 연결)의 사용설명서. 시스템 이상을 **자율 탐지→분류→점진 수복→검증→보고**한다. 시간민감 빠른회전이라 OODA로 돈다 → 런타임 루프는 [[ooda-runtime]]. **graduated remediation = 가장 약한 개입부터**(롤백은 최후). confidence < 80~90% 또는 prod-write/비가역이면 **HITL** → [[guardrails]].

## Phase 0 — 이상탐지 (Observe)
- 신호 수집: 빌드 green 여부 · 두눈(에뮬 캡처·dumpsys) · 프로덕션 DB ground-truth · 봇 heartbeat · 에러율/PnL.
- **build-green ≠ healthy**: CI 통과해도 의미버그(TZ/DST·계약·stale 데이터)는 산다. 라이브 신호를 본다.
- **가짜 신호 배제**: 무음스킵·vacuous green·`ai_calls=0`(정상 idle)을 "멈춤"으로 오인하지 말 것 → [[automation-bots]] 사례.

## Phase 1 — 분류 (Orient)
- 심각도·우선순위 매김: P0(prod 다운/자금손실) > P1(기능불가) > P2(degradation).
- **근본 vs 증상 구분**: 자해 재시작 루프처럼 가드가 매번 소멸하는 구조적 결함인가, 일시 glitch인가.
- confidence 추정. < 80~90% → 자율수복 보류, HITL 에스컬레이션.

## Phase 2 — Graduated Remediation (Decide→Act, 약→강)

**정본 3단계 명칭(이 노트가 owns — 다른 노트는 복붙 말고 여기로 링크):** andon(안돈)의 점진 제동 그대로, 가장 약한 개입부터 승급한다 — **조이기(tighten) → 늦추기(slow) → 세우기(stop)**.
- **조이기(tighten)**: 공차·파라미터를 조여 감시 강화 + 재시작/재시도 — 가동 유지.
- **늦추기(slow)**: takt·토큰·동시성 캡을 낮춰 부하/불량률을 떨어뜨림 — 부분 가동.
- **세우기(stop)**: 그래도 이탈하면 격리·차단·롤백으로 정지 — 손실 최소화. prod 정지/롤백 = HITL 필수.
- ⚠️ 안돈 **경고(warn)는 제동단계가 아니라 선행 신호**(이상 점등일 뿐 아직 개입 아님) — 제동 3단계로 세지 말 것.

아래 자가수복 운영표가 이 3단계의 실제 개입 매핑이다.

| 단계(정본) | 개입 | 조건 |
|---|---|---|
| 1 · 조이기 | **재시작/재시도** | 일시 glitch. 단 재시작은 서킷브레이커에 **편입**(`_record_restart` 우회 금지 — 우회하면 가드 소멸·재진입). → [[ooda-runtime]] |
| 2 · 늦추기 | **자원 재할당** | 부하/메모리/레이트리밋. 토큰·동시성 캡 조정. |
| 3 · 세우기 | **격리/차단** | 부패 레코드 sanitize([0,1] 이탈 phantom)·오염 소스 격리·킬스위치. |
| 3 · 세우기 | **롤백 (최후)** | 위 무효 시 직전 known-good 버전으로. prod = **HITL 필수**. → [[deploy]] |

- 한 단계 적용 후 Phase 3 검증 → 미해소면 다음 단계로 승급(곧장 세우기(롤백) 점프 금지).

## Phase 3 — 검증 (가짜0 금지)
- **결정론 검증**: 수복이 실제로 신호를 정상화했는가를 결정론 테스트/replay로 확인. TZ-불변·무음스킵 금지.
- **LIVE 실증**: 유닛 green ≠ 라이브 정상. guard가 영속·실발화하는지 라이브에서 확인(예: startup save로 materialize되는지).
- 미해소 → Phase 1로 재분류(상한 도달 시 중단+HITL, 무한루프 금지 → [[evaluator-optimizer]]).

## Phase 4 — 보고 (알림 채널)
- 이상·수복단계·검증결과를 1줄 알림 보고(예: 메신저/푸시) → [[notify]].
- 회수 불가/HITL 필요 항목은 명시(정직: "안 되는 건 안 된다", dust=가치0=패배).
- 새 교훈·재발방지 수단은 [[_log]] 누적, 영향 노트 `updated:` 갱신.

## HITL 게이트 (반드시 멈추는 곳)
- prod-write · 비가역 · 자금 이동 · confidence < 80~90% = AskUserQuestion 먼저 → [[guardrails]].
- "검증만, 배포는 사람이 결정" 모드 = 자율 수복 보류 권고만.

## 안티패턴
- 곧장 롤백(graduated 무시) → 과잉개입·정보손실.
- 서킷브레이커 우회 재시작 → 가드 소멸·무한 재진입으로 대규모 손실(실증) → [[anti-patterns]].
- 유닛 green만 보고 "수복됨" 선언 → 라이브 inert guard 잔존.
