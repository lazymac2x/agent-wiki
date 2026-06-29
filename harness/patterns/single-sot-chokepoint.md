---
name: single-sot-chokepoint
description: 단일 정본 provider(single-source chokepoint)가 '왜' 근본인가 — 표면패치=whack-a-mole 차단의 1급 패턴(스파인)
type: explanation
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[sot-registry]], [[guardrails]], [[manufacturing-bridge]], [[ADR-0001-single-source-provider]]
---

# 왜 단일 chokepoint 인가 — 정본 레코드 이야기 (제네릭 예시)

## 증상: 같은 레코드가 화면마다 다르게 보였다
헤더는 1건·5.0(주요 메트릭), 요약 카드는 다른 카운트, 주간 통계엔 합계가 안 맞고, '최근 항목' 리스트엔 유령(husk)이 끼었다. 운영자는 매번 "또 이 이슈 싫다, 재발 없게". 패치할 때마다 다른 화면에서 같은 류의 불일치가 튀어나왔다 — 전형적인 **whack-a-mole**.

## 근본: 한 사실에 소스가 여러 개였다
같은 레코드 데이터를 8개 이상 화면이 **제각각 다른 소스**로 읽고 있었다.
- 로컬 union(기기+서버 합집합) vs 서버 DB 직접 — 두 진실이 갈렸다.
- **husk** 오염: 복구 파편(garbage duration/메트릭을 가진 레코드)이 핵심 값은 멀쩡해 보여 통계에 섞였다.
- 가드 로직이 화면마다 흩어져(분산), 한 곳을 고치면 다른 곳은 옛 규칙을 따랐다.

표면을 아무리 패치해도 **소스가 여러 개인 한** 정합은 구조적으로 불가능했다. 값이 두 곳에 살면 그게 버그다 — 이것이 [[sot-registry]]가 강제하는 단일 SOT 원칙의 런타임 판본이다.

## 봉합: 단일 chokepoint + 단일 판별 SOT
1. **단일 소스 chokepoint** = 단일 정본 레코드 provider(single-source) — 헤더·요약·PB·주간·성장·어시스턴트, 모든 통계가 **이 한 provider를 경유**한다. 통계 화면은 더 이상 자기 소스를 고르지 않는다.
2. **단일 판별 SOT** = 메트릭 모듈의 `isValidRecord` 한 함수 — 진짜 레코드의 정의를 한 곳에 못박는다: 핵심 메트릭이 현실 범위(예: 최소값 이상 ∧ 현실적 비율, `isValidRecord`).
3. **husk 판별 = garbage duration/메트릭**(핵심 값이 아니라). legit 소형 레코드는 보존하고, 복구 파편만 숨긴다.
4. **리스트 vs 통계 책임분리하되 카운트 정합 의무** — '최근 항목' 리스트는 husk를 숨기되, 그 숨김이 통계 카운트와 어긋나면 안 된다.

결과: 1건·5.0·합계가 전 화면에서 정합, husk는 리스트에서도 통계에서도 일관되게 빠졌다. 적대 게이트 81.5 → 89 → 93 PASS(P0/P1/P2=0)(예시 진척).

## 일반화한 교훈 (다른 프로젝트에도)
- **표면패치는 whack-a-mole, 단일소스가 근본.** 불일치가 반복되면 패치를 멈추고 "이 사실의 소스가 몇 개인가"를 먼저 센다.
- **chokepoint는 강제장치**다 — 모든 소비자가 한 문을 지나게 만들면, 한 곳만 고쳐도 전부 고쳐진다(provider/상태합성 패턴은 [[mobile-app]]).
- **판별 기준도 단일 SOT**여야 한다(`isValidRecord`). 가드가 분산되면 chokepoint가 무력화된다.
- 이 노트는 **코드 교훈의 문서계층 쌍둥이**다. agent-wiki 자체가 같은 패턴을 dogfood한다 — 한 사실=한 노트, 나머지는 `[[link]]`.

이 결정의 캡처본은 [[ADR-0001-single-source-provider]].
