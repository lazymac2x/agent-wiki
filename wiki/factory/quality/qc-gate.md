---
name: qc-gate
description: QC 게이트 정의 — 합격기준+실행증거 둘 다 요구. 현장검증=두눈 실증 동형(문서화됨≠수행됨=build-green≠live-works)
type: reference
track: factory
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[defect-taxonomy]], [[manufacturing-bridge]]
---

# QC 게이트 — 합격기준 + 실행증거

> 게이트 = **통과 못 하면 다음 공정 진입 금지**인 이진 PASS/FAIL 체크포인트. AGENTS.md L5(검증-선-영속)·L6(90점 적대 게이트)의 제조판이다.

> **PROVEN 근거**: `source:none`이지만 PROVEN — 확립된 제조 QC 표준의 재기술·라인 무관 일반원칙이라 실증 없이도 성립한다.

## 게이트는 두 요소를 모두 요구한다
1. **합격기준** — 측정가능·이진. 도면공차/사이클타임/토크처럼 숫자로.
2. **실행증거** — 사진·계측로그·프로덕션 DB ground-truth. 기준만 있고 증거 없으면 **vacuous green**(무측정 PASS).
- 둘 중 하나라도 없으면 게이트 아니다. **문서화됨 ≠ 수행됨**(= build-green ≠ live-works). → 핵심 교훈 [[_log]] L-001.

## 제조 ↔ 개발 동형
현장 두눈검사·계측치·초도품 승인이 에뮬 두눈 실증·결정론 테스트·`verify` 실행증거에 1:1 대응한다 — 동형 매핑표의 정본은 [[manufacturing-bridge]](여기 복붙 금지). 같은 함정: "작업표준에 적혀있음"(build-green)도 "양품 나옴"(live-works)도 **실증**으로만 증명된다.

## 게이트 위치 (공정 단계 ↔ 파이프라인)
| 제조 | 개발 |
|---|---|
| 수입검사 IQC | pre-commit / 입력검증 |
| 공정검사 IPQC | 라운드 게이트(라운드 종료조건) |
| 출하검사 OQC | deploy(HITL 명시인증) |

## 규율
- **가짜0 금지**: 무측정 PASS·무음스킵 금지. 검증 불가 시 **loud skip-with-warning**(소리내어 스킵).
- **audit ≠ constitution**: 게이트 강화로 실기능을 죽이지 않는다. 죽은 항목만 제거, 필요기준은 근거+절차로 정면돌파.
- 불량 발견 시 → [[defect-taxonomy]] 통제 어휘로 코드 부여(자유서술 금지), 심각도는 P0/P1/P2로.
- 제조↔개발 매핑의 정본은 [[manufacturing-bridge]]. 이 노트는 그 게이트 측면만 owns(복붙 금지).

## 종료조건 (예)
- 합격기준 항목 전부 ✔ ∧ 실행증거 첨부 ∧ CRITICAL/MAJOR(=P0/P1) 0건 → PASS·다음 공정 허가.
