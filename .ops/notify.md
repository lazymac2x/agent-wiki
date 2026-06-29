---
name: notify
description: 텔레그램 마일스톤 notify(mcp telegram notify_user) — 트리거점(PDCA Act·배포·머지 완료)·1줄 보고·notify_user vs ask_user·캐시 TTL 5분 운영노트
type: reference
track: ops
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[self-healing]], [[pdca]]
---

# notify — 마일스톤마다 1줄, 텔레그램으로

장시간 자율작업의 가시성은 **마일스톤 알림**으로 확보한다. 매 스템이 아니라 **의미 있는 완료점**마다 알림 채널(예: 텔레그램 `notify_user`)로 사람에게 1줄 보고. 비동기 휴먼-in-the-loop.

## 트리거점 (언제 쓰나)
- **PDCA Act 완료** — 라운드 종료(평균 ≥90 PASS) → [[pdca]].
- **prod 배포 완료** — wrangler / AAB 등 → [[deploy]]. (배포 *실행* 자체는 HITL 명시인증 먼저 — 아래.)
- **머지 완료** — 브랜치 → main 순차머지 후 → [[git-conventions]].
- **셀프힐 수복 완료 / 에스컬레이션** — OODA 루프가 닫혔거나 사람 개입이 필요할 때 → [[self-healing]].
- **블로커 / 비동기 HITL** — AskUserQuestion을 띄울 수 없는 백그라운드 상황에서 결정이 필요하면 알림.

## 형식
- **1줄, 알짜배기.** 무엇이 · 어디서 · 결과(PASS / 배포ID / 버전 / 커밋). 장문 금지 — 텔레그램은 **신호**, 디테일은 wiki/로그에 있다([[token-budget]] 정신).
- 노이즈 금지: 모든 스템마다 쓰지 않는다. 마일스톤만.

## notify_user vs ask_user
| 상황 | 도구 |
|---|---|
| 단순 완료 보고(응답 불필요) | `notify_user`(단방향 통보) |
| 비가역 · prod-write · confidence<80~90% | `ask_user`(응답대기 = HITL 게이트) → [[guardrails]] |
> prod 작업을 `notify_user`로 알리기만 하고 그냥 진행하면 HITL 누락(P0). 비가역이면 반드시 `ask_user`로 멈춰 승인받는다.

## 캐시 TTL 5분 (운영노트)
- 백그라운드 폴링으로 캐시를 태우지 말 것 — 작업 완료 시 하네스가 **자동 재호출**한다.
- TTL 안에서 반복 폴링 = 불필요 호출 = 토큰/캐시 낭비([[guardrails]] 폴링 백오프와 동일 정신). 완료 이벤트에만 보고.

## 안티패턴
- 매 스템 notify(노이즈) · 장문 보고(텔레그램 부적합) · 비가역작업을 notify만 하고 진행(ask_user 써야) · TTL 내 폴링으로 캐시 소모.
