---
name: sop
description: SOP/배포 runbook 본문 표준 — TWI Job Breakdown 3열(중요단계|핵심포인트|이유). 제조·개발 공통
type: reference
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[opl]], [[runbook]], [[manufacturing-bridge]]
---

# SOP 템플릿 — TWI 3열 (제조 SOP = 개발 runbook)

> 핵심: **"단계"만 적지 말 것.** 핵심포인트(손맛·수치·안전)와 이유(왜)가 빠지면 암묵지가 소실된다.
> 3계층 전부 캡처: ① 공식 절차 ② 작업자 실최적순서 ③ 미문서 workaround.

```markdown
---
name: <slug>
description: <≤150자>
type: sop            # 개발 배포면 howto/runbook
track: factory       # 개발이면 dev|project
status: DRAFT
owner: you
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
source: <라인/설비/코드경로 | none>
links: [[관련 OPL]], [[표준작업]]
---

# <작업명> SOP

| 항목 | 내용 |
|---|---|
| 대상 설비/라인/시스템 | |
| 소요시간(takt) | |
| 안전 주의 | ⚠️ |
| 필요 공구/부품/권한 | |
| 선행조건 | |

## 절차 (TWI Job Breakdown)
| # | 중요단계 (What) | 핵심포인트 (How — 손맛·수치·안전) | 이유 (Why) |
|---|---|---|---|
| 1 | | 🔑 | |
| 2 | | 🔑 | |
| 3 | | ⚠️ | |

## 합격기준 (QC 게이트 — [[qc-gate]])
- [ ] <측정가능 기준 + 실행증거(사진/로그/수치)>

## 실행증거 (last verified on floor / live)
- 검증일: <YYYY-MM-DD> · 검증방법: <두눈/계측/D1> · 결과: <PASS/FAIL>
```
