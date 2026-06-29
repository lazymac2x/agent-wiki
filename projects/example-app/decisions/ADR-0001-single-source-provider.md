---
name: ADR-0001-single-source-provider
description: ADR-0001 — 모든 레코드 통계를 단일 정본 provider(single-source chokepoint)로 강제(다중소스 정합 불일치 봉합)
type: adr
track: project
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[single-sot-chokepoint]]
---

# ADR-0001 — 단일 정본 레코드 chokepoint (single-source provider)

- **상태(Status):** Accepted · 제네릭 worked example · 적대 게이트 93 PASS(예시)
- **일자:** 2026-06-29 캡처
- **맥락 서사(왜):** [[single-sot-chokepoint]]

## 맥락 (Context)
같은 레코드 데이터를 8개 이상 화면이 제각각 다른 소스(로컬 union vs 서버 DB)로 읽어, 헤더/요약/PB/주간/어시스턴트 통계가 서로 어긋났다. 복구 파편(husk = garbage duration/메트릭)이 통계에 섞이고, 진짜 레코드 판별 가드가 화면마다 분산돼 한 곳을 고쳐도 다른 곳이 옛 규칙을 따랐다. 표면패치는 매번 다른 화면에서 같은 불일치를 재생산 = whack-a-mole.

## 결정 (Decision)
1. 모든 레코드 통계 소비자(헤더·요약·PB·주간·성장·어시스턴트)는 **단일 정본 provider(single-source)를 경유**한다. 화면이 자기 소스를 고르는 것을 금지한다.
2. 진짜 레코드의 정의는 **단일 함수(메트릭 모듈의 `isValidRecord`)**에 못박는다: 핵심 메트릭이 현실 범위(최소값 이상 ∧ 현실적 비율, `isValidRecord`).
3. **husk 판별 = garbage duration/메트릭**(핵심 값 아님) — legit 소형 레코드는 보존.
4. 리스트(최근 항목)와 통계는 책임을 분리하되 **카운트 정합은 의무**.

## 대안 (Considered & rejected)
- **화면별 가드 추가(표면패치):** 반려 — 소스가 여러 개인 한 구조적으로 정합 불가(whack-a-mole 지속).
- **서버 DB만 단일 진실:** 반려 — 오프라인/미싱크 시 로컬 레코드가 사라짐(union 필요). 대신 union을 **클라이언트 chokepoint 한 곳**에서 합성.
- **핵심 값(거리/규모) 기준 husk 필터:** 반려 — legit 소형 레코드를 오살(false positive). garbage duration/메트릭이 정확한 시그널.

## 결과 (Consequences)
- (+) 1건·5.0·합계가 전 화면 정합. husk는 리스트·통계 양쪽에서 일관 숨김. 적대 게이트 81.5→89→93 PASS(P0/P1/P2=0)(예시).
- (+) 신규 통계 화면은 provider만 구독하면 자동 정합 — 재발 방지가 구조에 박힘.
- (−) 모든 소비자가 한 문을 지나므로 provider가 핫스팟 — 변경은 single-writer 규율(CODEOWNERS)로 직렬화.
- (−) husk 정의(garbage duration)는 복구 파이프라인과 결합 — 복구 로직 변경 시 `isValidRecord` 동반 검토 의무.

## 재발방지 (Prevention)
같은 류 불일치가 보이면 패치 전에 "이 사실의 소스가 몇 개인가"부터 센다. 값이 두 곳에 살면 그게 버그(dup-SOT). 판별 기준도 단일 SOT로 유지.
