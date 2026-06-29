---
name: defect-taxonomy
description: 불량 taxonomy — 통제 어휘(증상코드)+근본원인 5M1E 코드. 심각도 CRITICAL/MAJOR/MINOR를 P0/P1/P2와 1:1 동형 매핑
type: reference
track: factory
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[qc-gate]], [[rubric]]
---

# 불량 Taxonomy — 통제 어휘 + 근본원인 코드

> 왜: 자유서술 불량설명은 집계·검색·재발방지가 안 된다. **통제 어휘(controlled vocabulary)**로 코드화해야 파레토·추적이 선다.
> 1 불량 = **1 심각도 코드 + ≥1 근본원인 코드**. 부여 시점은 [[qc-gate]]. 실 사용례 → [[_log]] I-001/I-002.
> **PROVEN 근거**: `source:none`이지만 PROVEN — 확립된 품질공학 통제어휘(5M1E·심각도 등급)의 재기술·라인 무관 일반원칙. 동형 근거 → [[manufacturing-bridge]].

## 축 1 — 심각도 (P0/P1/P2 동형)
| 제조 등급 | 정의 | 조치 | 개발 동형 |
|---|---|---|---|
| **CRITICAL** | 안전·법규·기능상실 | 출하정지·리콜 | **P0** (배포차단·데이터손실) |
| **MAJOR** | 기능저하·고객불만 | 라인정지·전수선별 | **P1** (핵심기능 회귀) |
| **MINOR** | 외관·경미 | 수리/특채 | **P2** (nit·외관) |
> 게이트 종료조건 = CRITICAL/MAJOR(P0/P1) **0건**. [[rubric]] 7축 채점의 P0/P1/P2와 1:1로 정렬된다.

## 축 2 — 근본원인 (5M1E)
| 코드 | 영역 | 예 |
|---|---|---|
| **MAN** | 작업자/숙련 | 순서·토크 미준수 |
| **MAC** | 설비/금형 | 로케이트링 마모·히터 불량 |
| **MAT** | 원자재 | 수지 수분·LOT 불량 |
| **MET** | 방법/공정조건 | 온도·압력·작업표준 결함 |
| **MEA** | 계측 | 게이지 교정만료·측정오류 |
| **ENV** | 환경 | 온습도·정전기 |

## 증상 코드 (controlled vocabulary)
| 코드 | 증상 |
|---|---|
| SHT | 쇼트샷(충전부족) |
| FLA | 플래시(버 오버플로) |
| BUR | 버(burr) |
| SCR | 스크래치 |
| DIM | 치수이탈 |
| CON | 오염/이물 |

## 운영
- 신규 증상/원인 코드는 **이 어휘에 등록 후** 사용(임의 신설 = 어휘오염 → 집계 깨짐).
- 폐기 코드는 삭제 말고 **DEPRECATED tombstone**(과거 데이터 호환).
- 코드 1개 = 사실 1개 = 한 곳에만 정의(단일 SOT). 매핑 정본은 [[qc-gate]]·[[rubric]]가 참조.
