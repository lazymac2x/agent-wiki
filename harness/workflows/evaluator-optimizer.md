---
name: evaluator-optimizer
description: 생성(optimizer)/평가(judge) 역할분리 루프 — 종료=평균≥90 ∧ P0/P1=0 ∧ hard 반복상한6. Uncontrolled Recursion·self-preference 방지
type: howto
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[rubric]], [[judge]], [[pdca]]
---

# Evaluator-Optimizer — 생성/평가 역할분리 루프

PDCA의 Check↔Act를 돌리는 엔진([[pdca]]). 한 모델이 "쓰고 스스로 합격" 주는 self-preference를 끊기 위해 **생성과 평가를 분리**하고, **하드 종료조건**으로 무한루프(Uncontrolled Recursion)를 막는다.

## 역할 분리 (왜 두 역할인가)
| 역할 | 누가 | 무엇 |
|---|---|---|
| **Optimizer(생성)** | 작업 모델 | 노트/코드/수정안을 만든다. 직전 judge 피드백을 입력으로 받아 개선. |
| **Evaluator(judge)** | **다른 모델패밀리** | 7축 루브릭으로 채점·결함 enumerate. 생성 못 봄(독립). → [[judge]] [[rubric]] |

- 같은 모델이 양쪽이면 점수 인플레(self-preference). judge는 반드시 다른 패밀리.
- 적대 패널(3인 등)은 **SendMessage resume로 P0 해소를 연속검증**할 수 있다(재채점 시 직전 지적 반영 여부 확인).

## 루프 (한 라운드)
1. **Optimizer**가 산출물 + 직전 결함 리스트를 받아 수정안 생성.
2. **Evaluator**가 7축 점수(0~100) + 결함을 **P0/P1/P2 심각도**로 JSON 반환 → [[rubric]].
3. **종료판정**: 아래 종료조건 충족? → 예: 종료(PROVEN 승격 검토) / 아니오: 결함을 Optimizer에 되먹임, 라운드++.
4. 라운드마다 적용 결함과 점수를 [[_log]]에 누적(추세 가시화).

## 종료조건 (셋 다 AND — 하나라도 빠지면 계속/중단 판단 보류)
- **평균 ≥ 90** (7축 가중평균)
- **P0 = 0 ∧ P1 = 0** (점수 높아도 P0 잔존이면 미종료 — 평균에 가려진 치명결함 방지)
- **반복상한 = 6** (하드 캡). 6회 내 미수렴이면 **중단 + HITL 에스컬레이션** → [[guardrails]]

## Uncontrolled Recursion 방지 (하드 캡이 핵심)
- 점수만으로 멈추면 끝나지 않을 수 있다. **반복상한이 안전판.**
- **audit ≠ constitution**: 적대 패널이 비결정·자기모순일 수 있다(동일 코드에 라운드마다 정반대 점수를 준 사례 = [[automation-bots]] 실증). 노이즈 패널을 무한추격하면 **노이즈 최적화**가 된다.
- 따라서 **스펙/루브릭 = LAW**, 결정론 유닛테스트가 신뢰 oracle. 패널이 실결함을 적발하면 수정하되, 비결정 노이즈는 상한에서 컷하고 HITL.
- 실증 추세 예: 적대 게이트 81.5 → 89 → 93 PASS(P0/P1/P2=0)로 수렴 = [[example-app]].

## 안티패턴
- 평균 92인데 P0 1개 잔존을 "통과" 처리 → 치명결함 출하. (P0=0 AND가 막는다)
- 상한 없이 "PASS까지 무한" → 노이즈 패널이면 영영 안 끝남. → [[anti-patterns]]
- 같은 모델 self-judge → 점수 신뢰 0.

## 종료 후
- 종료 시 산출물 `status: PROVEN` 승격 검토(실증증거 동봉). 미수렴 중단은 `DRAFT` 유지 + HITL 노트.
