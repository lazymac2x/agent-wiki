---
name: feedback-loop
description: 무한피드백 loop-until-dry — 전수조사→문제→수정→실증(두눈/결정론/가짜0)→재발방지. 일반원칙 vs 과적합 교훈 분리
type: howto
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[pdca]], [[_log]], [[anti-patterns]]
---

# Feedback Loop — 무한피드백 (loop-until-dry)

당신의 심층-피드백/적대비평 스킬의 핵심 엔진. 문제가 **마를 때까지(dry)** 전수조사→수정→실증→재발방지를 반복한다. PDCA의 Check↔Act를 채우는 내부 루프([[pdca]]). 적대채점 메커닉(90점·역할분리·상한)은 [[evaluator-optimizer]].

## 심층-피드백 스킬 호출계약
이 노트는 당신의 심층-피드백/적대비평 스킬의 사용설명서다(재구현 금지·호출만·자신의 환경에 있는 스킬을 연결). 호출 모드 3가지(트리거 플래그는 예시 — 자신의 스킬 인터페이스에 맞춘다):

| 모드 | 트리거(예시) | 무엇을 하나 |
|---|---|---|
| 기본 | 스킬 기본 호출 | loop-until-dry — 전수조사→수정→실증→재발방지를 새 결함 0(dry)까지 |
| 무한 PM | `--infinite` / `무한` | 깐깐한 천재 PM 적대심사를 모든 지적 PASS까지 반복 → [[evaluator-optimizer]] |
| 프로덕트 | `--product` (프로덕트 모드 플래그) | 프로덕트 모드(문서분석→플랜→안정성·DB·메쉬·UI 구현→90점 게이트→배포) → [[example-app]] |

> 스킬 설명의 "무제한 반복"은 **무한이 아니다**: harness에서 **반복상한 6 ∧ P0/P1=0 ∧ HITL**로 bounded된다(Uncontrolled Recursion 방지) — 종료조건 정본은 [[evaluator-optimizer]] [[rubric]].

## 한 사이클 (loop-until-dry)
1. **전수조사**: 증상이 아니라 전체 체인을 추적. `grep -a`(바이너리 오탐 회피)·프로덕션 DB 직접쿼리로 ground truth 확정([[data-schema]]). "X가 틀림"의 진짜원인이 데이터/UX갭일 수 있다 — 전 체인을 봐야 진실.
2. **문제 enumerate**: 발견 결함을 P0/P1/P2로 나열. "코드레벨 OK(등록·배선됨) ≠ e2e 동작"을 구분(서버인증·툴루프 전 체인 추적).
3. **수정**: 단일 chokepoint에서([[single-sot-chokepoint]]). 표면패치 금지 — 같은 root가 여러 표면으로 나오면 소스를 고친다.
4. **실증 (3겹, 가짜0 금지)**:
   - **두눈**: 에뮬 1080×1920 캡처·dumpsys 포그라운드·실제 조건 재현(조건부 버그는 그 조건을 재현해야 성립).
   - **결정론**: 순수함수 유닛/위젯 테스트. TZ-불변·무음스킵=vacuous green 금지 → [[verify]].
   - **프로덕션 DB ground-truth**: 앱 통계 의심 시 프로덕션 DB 직접쿼리로 진실 대조([[example-edge]]).
5. **재발방지**: 같은 root가 재발 못 하게 결정론 테스트/가드/단일 SOT 헬퍼를 영속화. 이게 없으면 다음 라운드 동일버그.
6. **종료판정**: 새 결함 0(dry) ∧ 적대채점 평균 ≥90 ∧ P0/P1=0 ∧ 반복상한 도달 안 함 → 종료. 아니면 1로.

## 일반원칙 vs 과적합 교훈 (반드시 분리)
재발방지를 기록할 때 **재사용 가능한 원칙**과 **그 사건에만 맞는 핀포인트**를 갈라 적는다(섞으면 노트가 오도).

| 일반원칙 (재사용·범용) | 과적합 교훈 (특정사건 핀포인트) |
|---|---|
| 단일소스가 근본·표면패치=whack-a-mole | go_router route-level redirect = ancestor 발화(top-level 비교) |
| build-green ≠ live-works | off-screen captureFromWidget → precache 필수 |
| 무음스킵 = vacuous green = 금지 | 부패 레코드 판별 = garbage duration 신호(다른 지표 아님) |
| 조건부 버그는 조건을 재현해야 두눈 성립 | 발광 위젯 = 중심 최대휘도 단조감소(도넛 아티팩트 박멸) |

- 좌측 = harness 노트([[anti-patterns]] 등)에 승격. 우측 = 프로젝트 노트([[example-app]])나 [[_log]]에 사건맥락과 함께. 과적합 교훈을 일반원칙처럼 올리면 다른 맥락에서 오작동.

## 어디로 기록하나 (단일 SOT)
- 재사용·범용 노하우 → agent-wiki 노트([[anti-patterns]]·도메인노트). 휘발성 학습 → auto-memory. 민감정보 → 외부 SOT(`<your-secrets-sot>`). **세 곳 동시기록 금지** → [[memory-bridge]] [[sot-registry]].
- 라운드 요약 1줄은 [[_log]]에 누적(추세·재발 패턴 가시화).

## 안티패턴
- 증상만 고치고 재발방지(5단계) 생략 → 무한반복의 가짜 버전(매라운드 같은 버그).
- 유닛 green만 보고 "고침" 선언 → 라이브 실증 누락.
- 과적합 교훈을 일반원칙으로 승격 → 다른 맥락 오도. → [[anti-patterns]]
