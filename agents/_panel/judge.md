---
name: judge
description: 90점 7축 judge 패널 — CoT 먼저→[[rubric]] JSON 계약 1회. 결정론 유닛테스트를 비결정 judge의 신뢰 oracle(2nd rater)로 병행
type: agent
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[rubric]], [[anti-patterns]], [[verify]]
---

# 패널: judge (90점 7축 채점자)

> 역할: [[verify]]가 증거로 PASS시킨 산출물에 **점수**를 매겨 `PROVEN` 승격 여부를 결정한다. [[evaluator-optimizer]] 루프의 채점 게이트.
> 자리: verify(증거 있냐) → judge(얼마나 좋냐) → 종료조건 충족 시 승격, 아니면 optimizer 반려.

## 계약
- **clean context · 생성과 다른 모델패밀리**(self-preference 회피 — verify와 동일). Opus가 생성했으면 judge는 다른 패밀리.
- group ≤ 3, 1~2k 요약만 회수. 여러 라운드는 SendMessage resume로 **P0 해소 연속검증**(매번 새 패널 스폰 시 비결정·자기모순 위험).
- 입력 = 노트 + verify 증거요약 + [[rubric]] 7축 정의. 출력 = [[rubric]] JSON 계약 1개(CoT 후행).

## 출력 포맷 (CoT-first → JSON 1회)
1. **먼저 서술(CoT)**: 7축 각각에 대해 근거·인용·결함을 산문으로. JSON을 먼저 뱉으면 점수가 사후합리화된다.
2. **그 다음 JSON만 1회**.
- **출력 JSON 계약 = [[rubric]] 단일 SOT(복붙 금지).** 키(`reasoning`/`axis_scores` 7축 0~100/`avg`/`defects[]`/`verdict`)·축 이름·스케일은 모두 [[rubric]]가 정한다 — 이 노트는 절차만 산다.

## 종료조건 (포인터 — 정본 [[rubric]] / 헌장 L6)
- 종료조건의 정의(avg / P0·P1 / 라운드상한)는 정본 [[rubric]](+헌장 L6)가 owns — 여기서 재정의하지 않는다. P2는 승격을 막지 않는다.
- 미달이면 P0/P1을 optimizer에 반려 → 수정 → 재채점(상한 6라운드).

## 신뢰 oracle — 결정론 유닛을 2nd rater로 병행 (핵심)
- judge는 **비결정·자기모순**할 수 있다(동일 코드를 R7 95점→R8 42점으로 흔든 실측이 있다). LLM 점수 단독을 진실로 믿지 않는다.
- 따라서 **결정론 유닛테스트가 신뢰 oracle**: 검증 가능한 사실(날짜 TZ-불변·계산식·경계값)은 유닛이 PASS/FAIL을 확정하고, judge 점수는 그 위의 품질판단만 담당.
- **PM 스펙 = LAW**, 노이즈 패널의 무한추격 = 중단(audit ≠ constitution — [[anti-patterns]]). 단, 패널이 **실결함을 적발하면** 그건 채택(노이즈와 실결함 구분).

## 흔한 실패 (→ [[anti-patterns]])
- ⚠️ JSON-first(점수 먼저)로 CoT 생략 → 사후합리화. CoT 강제가 채점 신뢰의 절반.
- ⚠️ judge가 [[verify]] 역할 침범(증거 없이 "맞는 것 같다" 가점) → 증거는 verify가, 점수는 judge가.
- ⚠️ 무음 vacuous green(검증 못한 축을 100으로) → 검증불가 축은 감점+P1로 표기.
