---
name: 02-work-factory
description: 제조 현장 운영 노하우(교대·QC 루틴·설비 제약·안전) — 소프트웨어 은유(PDCA·graduated remediation·3층 모니터링)의 현장 ground
type: explanation
track: personal
status: DRAFT
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[manufacturing-bridge]], [[example-line]]
---

# 02 · 제조 현장 운영 노하우 (은유의 ground truth)

agent-wiki의 핵심 은유들 — PDCA·graduated remediation·3층 모니터링·QC 게이트·OPL/SOP·andon — 은 **비유가 아니라 실제 제조 현장 운영에서 온 것**이다(당신의 현장 경험을 ground 로 채워 넣으라). 이 노트는 그 현장 ground를 적어, 소프트웨어 쪽이 은유를 헐겁게 쓰지 않도록 닻을 내린다. 매핑(현장↔코드)은 [[manufacturing-bridge]]가, 도메인 인덱스는 [[example-line]]가 owns.

## 교대 인수인계 (shift handover)
현장은 24시간이 끊기지 않는다. 교대 때 **암묵지가 새는 게 #1 손실**이다.
- **인수인계 노트**: 진행 중 작업·이상징후·임시 workaround·"건드리지 마" 항목을 다음 조에게 넘긴다. → 소프트웨어판은 라운드 종료 `RESUME` 노트(NEXT_STEPS류).
- 🔑 "정상"만 적지 말고 **이상·미문서 workaround**를 적어야 살아 있는 인계가 된다(SOP 3계층의 ②작업자 실순서·③workaround).
- 인계 누락 = 다음 조가 같은 불량을 재발시킴 = whack-a-mole. 근본은 **단일 인계 채널**(여러 메모지가 아니라 한 보드).

## QC 루틴 (검사 게이트)
- **공정 내 검사(in-process)**: 라인 중간 게이트에서 막아야 불량이 다음 공정으로 안 흐른다. → 소프트웨어 [[qc-gate]] / 90점 적대 게이트.
- **합격기준은 측정가능**해야 한다("깨끗하게" X → "수치 + 실행증거"). → 검증-선-영속(L5), 가짜0 금지.
- **CI-green ≠ 양품**: 치수는 맞는데 기능 불량(조립 후 안 맞음)이 있다. 현장의 "측정은 통과인데 실물 불량"이 코드의 "build-green ≠ live-works".
- 불량은 유형화해 재발방지로 닫는다 → [[defect-taxonomy]].

## 설비 제약 (equipment constraints)
- **takt time**: 라인 속도는 가장 느린 설비가 정한다(bottleneck). 빠른 설비를 더 빨리 돌려도 전체 산출은 안 는다 → 단일 chokepoint 사고의 원형.
- **워밍업/콜드스타트**: 설비는 정온 도달 전 품질이 흔들린다 → 콜드스타트 집계중·캐시 워밍업 은유.
- **예방보전(PM) vs 사후보전**: 멈추기 전에 점검 → self-heal 사전탐지. 멈춘 뒤 고치면 라인 전체가 선다.
- 🔑 제약은 **없애는 게 아니라 근거+절차로 안고 간다** — audit ≠ constitution(L6). 안전·법규로 진짜 필요한 제약은 우회가 아니라 정면대응.

## 안전 (safety — 타협 불가)
- ⚠️ 안전은 **속도/산출보다 우선**. LOTO(잠금·표찰)·보호구·2인조는 생략 금지.
- **andon(안돈줄)**: 누구나 라인을 세울 권한. 이상 보이면 즉시 stop → 비가역/위험 작업의 HITL 게이트(AskUserQuestion)와 같은 정신.
- 안전사고는 **사후 보고가 아니라 사전 차단**. → prod-write·비가역 = HITL 먼저(L4 라우팅).

## graduated remediation (3단계 — 현장 원형)
설비가 이상하면 한 번에 끄지 않는다. 정본 명칭(소프트웨어판은 [[self-healing]]이 owns) **조이기(tighten) → 늦추기(slow) → 세우기(stop)** 순서:
1. **조이기(tighten)**: 파라미터/공차를 조여 감시 강화 — 생산은 유지.
2. **늦추기(slow)**: takt를 늦춰 불량률을 떨어뜨림 — 부분 가동.
3. **세우기(stop)**: 그래도 이탈하면 라인 정지(andon) — 손실 최소화.
이게 소프트웨어 자율수복의 **graduated remediation**이다(즉시 kill 아님 · 안돈 경고는 제동 아닌 선행신호) → [[self-healing]].

## 3층 모니터링 (현장 위계)
이상은 한 사람이 다 못 본다. **3층**으로 본다:
1. **작업자(operator)**: 실시간 손맛·계기 — 1차 신호.
2. **반장/감독(supervisor)**: 라인 단위 추세·교대 집계 — 2차.
3. **공장 관제(plant/SCADA)**: 전 라인 종합·KPI — 3차.
하층이 1차 차단, 상층이 패턴·근본을 본다 → 봇 런타임 모니터링 3층(런타임 가드 → 집계 → 관제 대시보드)의 ground. 루프는 시간민감 OODA로 회전.

## 표준작업·OPL (암묵지 자산화)
- **SOP**(TWI 3열: 중요단계·핵심포인트·이유) — "왜"가 빠지면 손맛이 소실 → [[sop]].
- **OPL**(One-Point-Lesson, 5~10분 1주제 비주얼) — 레고블록처럼 엮어 SOP 조립 → [[opl]].
- 🔑 현장 지식은 **사람이 떠나면 사라진다**. 적어서 링크해 굳히는 게 곳 이 wiki의 존재이유.

## TODO(you) — 미검증·채워넣기
- TODO(you): 당신이 담당한 **라인/설비명·공정 순서·대표 불량모드**를 1개 OPL로 캡처(`wiki/factory/`에 `[Trouble]` 태깅).
- TODO(you): 교대 인수인계 실제 양식(있던 항목)을 [[sop]] 1건으로 박제 → 소프트웨어 RESUME 노트와 양방향 링크.
- 위 본문은 일반 제조 실무 + 은유 매핑까지만 **검증됨**, 구체 라인 사실은 채워지기 전까지 DRAFT 유지.
