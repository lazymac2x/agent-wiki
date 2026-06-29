---
name: ooda-runtime
description: 봇/배포 런타임 OODA(시간민감 빠른회전) + OODA↔PDCA 라우팅 트리거표(런타임이상=OODA/계획빌드=PDCA) + 서킷브레이커 우회금지
type: howto
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[pdca]], [[self-healing]], [[example-bot]]
---

# OODA Runtime — 시간민감 런타임 루프 (봇/배포)

런타임 이상은 **빠른 회전**이 생명이라 PDCA(계획품질·느린루프)가 아니라 OODA로 돈다. Observe→Orient→Decide→Act. 자율 수복 실행체는 [[self-healing]](자가수복 루틴), 자동매매 런타임은 [[example-bot]] [[automation-bots]].

## OODA 한 회전
1. **Observe**: heartbeat·에러율·PnL·프로덕션 DB ground-truth·포지션 상태 수집. 라이브 신호 우선(build-green ≠ live-works).
2. **Orient**: 정상 idle인가 진짜 이상인가 판별. `ai_calls=0`·entry-stall = 정상일 수 있다(멈춤으로 오인 금지). 부패 레코드([0,1] 이탈 phantom)는 손실은폐 아닌 데이터버그.
3. **Decide**: graduated 개입 선택(약→강) — 상세 [[self-healing]] Phase 2. prod-write/비가역 = HITL → [[guardrails]].
4. **Act**: 최소개입 실행 → 즉시 Observe로 회귀(닫힌 루프). 미해소면 개입 1단계 승급.

## ★ OODA ↔ PDCA 라우팅 트리거표
어느 루프로 갈지 **증상으로** 판단한다. 잘못 라우팅하면 느린 루프로 불나는 봇을 두거나, 빠른 루프로 설계결함을 땜질만 한다.

| 트리거(증상) | 루프 | 이유 |
|---|---|---|
| 봇 다운 · 배포 실패 · prod 에러 스파이크 | **OODA** | 시간민감 — 먼저 안정화 |
| 포지션/자금 이상 · 레이트리밋 · 자원고갈 | **OODA** | 즉시 격리/캡 |
| stale 데이터 · 자해 재시작 루프(일시) | **OODA**(안정화) → 근본은 **PDCA** | 멈추고 나서 근본수정 |
| 신규 기능 · 리팩터 · 데이터정합 설계결함 | **PDCA** | 전수조사+적대채점 필요 → [[pdca]] |
| 노트/문서 저작·갱신 | **PDCA** | 90점 게이트 |
| 반복 재발(같은 root 2회+) | **PDCA** | OODA는 증상억제뿐 — 재발방지는 PDCA Act |

**원칙**: OODA로 **출혈을 멈추고**, 회수한 근본원인은 **PDCA로 영구수정**(재발방지 영속화). 둘은 경쟁이 아니라 직렬 — OODA가 시간을 벌고 PDCA가 빚을 갚는다.

## 서킷브레이커 (런타임 안전판)
- 재시작/재진입은 **서킷브레이커에 편입**한다. `_record_restart`를 호출하지 않고 재시작 큐를 돌리면 브레이커를 **우회** → 가드가 매번 소멸 → 무한 재진입(실증: 가드 소멸로 대규모 손실) = [[automation-bots]].
- 브레이커 트립 시: 개입 중단 + HITL 알림 → [[notify]]. 자동 재무장 금지(사람의 명시 재개만).
- $ 킬스위치·동시성 캡·비용 원장은 항상 켜둔다 → [[guardrails]] [[model-tiering]].

## 안티패턴
- 런타임 이상에 PDCA 풀사이클(전수조사 30분) → 그 사이 봇 출혈. → [[anti-patterns]]
- OODA로 증상만 억제하고 PDCA 회수 생략 → 같은 사고 재발.
- 브레이커 우회 자동 재시작 → 가드 무력화.
