---
name: provenance-model
description: 로트/설비/원자재 provenance = 문서 source: 메타(미러 코드경로·ground-truth)와 동형. 진실원 우선·끕긴 체인=stale
type: reference
track: factory
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[sot-registry]], [[manufacturing-bridge]]
---

# Provenance 모델 — 추적성 = `source:` 메타와 동형

> 정의: 모든 산출물(로트/제품)은 **출처 체인**을 갖는다 — 원자재 LOT → 설비/금형 ID → 작업자/조 → 공정조건 → 시각. 한 단계라도 끕기면 추적성 상실(리콜 범위 폭발).
> 동형: 문서 frontmatter `source:` = 그 노트가 미러하는 코드경로/ground-truth. 끕기면(none 남용·stale) 문서 추적성 상실 = **능동 오도**.
> **PROVEN 근거**: `source:none`이지만 PROVEN — 확립된 추적성 원리의 재기술·라인 무관 일반원칙. 동형 근거 → [[manufacturing-bridge]].

## 진실원 우선 (single source of truth)
- 의심 시 **파생물**(앱 통계·요약문서)가 아니라 **진실원**(프로덕션 DB ground-truth / 자재 LOT 라벨 / 계측 원본)으로 확인한다.
- 제조판 = "라인 양품률 의심 시 로트 추적해 원자재·설비조건으로 환원". 개발판 = "앱 통계 의심 시 프로덕션 DB 직접쿼리".
- 진실원의 1:1 등록은 [[sot-registry]]가 owns. 이 노트는 그 **물리적 추적 레이어**만 owns(복붙 금지).

## 매핑 (제조 provenance ↔ 문서/개발)
| 제조 provenance | 문서/개발 동형 |
|---|---|
| 원자재 LOT 번호 | `source:` 코드/문서 경로 |
| 설비·금형 ID · 교체로그 | git commit / 빌드 ID |
| 계측 원본 데이터 | 결정론 테스트 로그 / 프로덕션 DB row |
| COA(성적서) | 실행증거(`verify` 출력) |
| 정방향 추적(source→파생) | source가 가리키는 코드 → 노트 |
| 역방향 추적(파생→source) | 노트 → `source:` 경로 |

## 끕긴 체인 = stale (freshness)
- `source:`가 가리키는 코드의 변경시각 > 노트 `updated` → **freshness-lint FAIL**(stale). 제조판 = 로트 추적 단절 audit.
- 그래서 `source:`를 함부로 `none`으로 두지 않는다 — 진실원이 있으면 명시(추적 끕김 방지).
- 외부트리라 경로 미해소면 **loud skip-with-warning** + 수동 freshness 확인(무음 통과 금지).
- 제조↔개발 매핑의 정본은 [[manufacturing-bridge]]. 이 노트는 추적성 측면만 다룬다.
