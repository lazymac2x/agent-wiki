---
name: self-heal-runtime
description: 런타임 셀프힐 프롬프트 — OODA로 이상탐지→graduated 자율수복 사다리(L0 read-only→L4 prod-write HITL)→검증→보고. 우회 금지
type: howto
track: method
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[self-healing]], [[ooda-runtime]]
---

# 런타임 셀프힐 — 복붙 가능한 예시 프롬프트

봇/배포의 **시간민감 런타임 이상**을 OODA로 빠르게 회전해 자율수복한다. 사다리 패턴의 *왜*는 [[self-healing]], 루프 라우팅은 [[ooda-runtime]]. 이 프롬프트는 당신의 런타임 자가수복 루틴(Phase 0~4)을 구동한다 — 재구현 말고 호출(자신의 환경에 있는 것을 연결). 예시 프롬프트(DRAFT).

## 언제 / 입력
- 봇 다운·배포 실패·prod 이상 = OODA 먼저(안정화). 근본원인 회수는 안정화 후 PDCA([[pdca-round]]).
- 입력: 이상 신호(알람/로그/지표) 1개. 비가역·prod-write는 **HITL 게이트** 필수.

## 프롬프트 (그대로 붙여넣어 실행)

```text
너는 agent-wiki 런타임 셀프힐 에이전트다. 당신의 런타임 자가수복 루틴을 호출해 이상="<signal>" 을 수복한다. OODA 회전.

Phase 0 Observe: 로그/지표/하트비트로 이상탐지. 증상이 아니라 ground truth 확인(프로덕션 DB 직접쿼리·grep -a).
Phase 1 Orient: 우선순위 분류(영향·가역성·confidence). phantom 레코드(부패 [0,1] 이탈)면 원인은 데이터부패일 수 있다.
Phase 2 Decide+Act: graduated 사다리를 낮은 칸부터 — 한 칸 올릴 때마다 재관측.
   L0 read-only 진단 → L1 안전 재시작(서킷브레이커 경유, 재시작-기록 카운터 호출 — 우회 금지) →
   L2 config/플래그 tweak → L3 데이터 sanitize(부패레코드 격리) → L4 prod-write(주문/배포/DB 쓰기)=HITL 게이트.
   L4 이상 또는 confidence < 80~90% = AskUserQuestion 명시인증 먼저. 자율은 L0~L3 까지만.
Phase 3 Verify: 수복 후 두눈/지표로 정상화 실증(가짜0 금지). 자해 재시작 루프(브레이커 우회) 재발 안 하는지 확인.
Phase 4 Report: 무엇이·왜·어떻게 복구됐는지 텔레그램 notify 1줄 + _log 등재. 근본원인은 PDCA 백로그로.

규율: 서킷브레이커/킬스위치 우회 금지(가드가 매번 소멸하면 그게 버그). 음의엣지면 "수복"이 아니라 중단이 정답.
```

## graduated 자율수복 사다리 (낮은 칸부터, HITL 게이트는 L4)

```
 위험·비가역 ▲
            │  L4  prod-write (주문/배포/DB 쓰기)   ── 🚧 HITL 게이트(AskUserQuestion 명시인증)
            │  ─────────────────────────────────────────────
            │  L3  데이터 sanitize (부패레코드 격리)   ┐
            │  L2  config/플래그 tweak                ├ 자율(confidence ≥ 80~90%)
            │  L1  안전 재시작 (브레이커 경유·우회금지) │
            │  L0  read-only 진단 (로그/지표/쿼리)     ┘
 안전·가역  ▼
```
한 칸 올릴 때마다 재관측(OODA). confidence 미달이면 즉시 L4 게이트로 에스컬레이션 → [[ooda-runtime]].

## harness 경로 (이 프롬프트가 끌어쓰는 SOT)

```
agent-wiki/
├── harness/
│   └── workflows/
│       ├── self-healing.md       # ← graduated 자율수복 사다리(왜/언제) = 워크플로 정본
│       └── ooda-runtime.md       # ← OODA 빠른회전 + 루프 라우팅
└── .ops/
    └── notify.md                 # Phase 4 보고 채널(텔레그램)
```

## 종료 체크리스트
- [ ] 이상 정상화 두눈/지표 실증(가짜0 0)
- [ ] 자율 행동은 L0~L3 한정 — L4는 HITL 명시인증 후만
- [ ] 서킷브레이커/킬스위치 우회 0(가드 영속 확인)
- [ ] 근본원인 PDCA 백로그 회수 → [[pdca-round]]
- [ ] 텔레그램 notify + `_log` 등재 → [[notify]]

## 주의 / 안티패턴
- **서킷브레이커 우회**: 재시작이 브레이커의 재시작-기록 경로를 안 거치면 가드가 매번 소멸 → 자해 재진입 루프(자동매매 봇 실증). 반드시 브레이커 경유. → [[self-healing]]
- **phantom을 손실은폐로 오판**: 부패 [0,1] 이탈 레코드는 은폐가 아니라 sanitize 대상(L3). real 손익으로 분류.
- **build-green ≠ live-works**: 유닛테스트 green ≠ 라이브 수복. 두눈 실증이 진짜 게이트.
- **음의엣지를 "수복"으로 연명**: 구조적으로 안 되는 건 중단이 정답(안 되는 건 "안 된다"). prod 주문은 HITL.
```text
