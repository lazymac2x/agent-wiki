---
name: capture-floor-knowledge
description: 제조 현장 암묵지 캡처 프롬프트 — capture-while-fresh→3계층(공시SOP/실최적순서/workaround)→OPL+SOP 산출→위키링크 조립→lessons 등재
type: howto
track: method
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[opl]], [[sop]], [[example-line]]
---

# 제조 현장 암묵지 캡처 — 복붙 가능한 예시 프롬프트

작업자 머릿속의 **손맛·순서·workaround**(사라지면 복구불가)를 신선할 때 잡아 OPL/SOP 자산으로 굳힌다. OPL 템플릿 = [[opl]], SOP(TWI 3열) = [[sop]], 폴더지도 = [[example-line]]. 예시 프롬프트(DRAFT).

## 핵심 원칙 — capture-while-fresh
- 작업 **직후**(기억 신선) 캡처. 시간이 지나면 "왜 그렇게 했는지"(이유)가 먼저 증발한다.
- **단계만 적지 말 것**: 핵심포인트(손맛·수치·안전)와 *이유*가 빠지면 암묵지가 소실된다 → [[sop]].
- 한 주제 = 1 OPL(원자·레고블록). 여러 OPL을 위키링크로 엮어 SOP를 조립(fractal) → [[opl]].

## 3계층 — 반드시 셋 다 캡처

| 계층 | 무엇 | 왜 중요 |
|---|---|---|
| ① 공식 SOP | 문서에 적힌 절차 | 기준선(baseline) |
| ② 실최적순서 | 작업자가 *실제로* 하는 순서 | 공식과 다름 = 숨은 노하우(Know-How) |
| ③ workaround | 미문서 임시방편·예외대응 | 사라지면 사고 재발(Trouble) |

①만 적고 ②③을 빠뜨리는 게 #1 실패. ②③이 진짜 자산이다.

## 프롬프트 (그대로 붙여넣어 실행)

```text
너는 agent-wiki 현장 암묵지 캡처 에이전트다. 작업="<task>", 라인/설비="<line>". 작업 직후 캡처(capture-while-fresh).

1) 3계층 인터뷰: ①공식 SOP 절차 ②작업자 실최적순서(공식과 차이) ③미문서 workaround/예외대응.
   각 단계마다 [중요단계 What / 핵심포인트 How=손맛·수치·안전 / 이유 Why] 3열을 채운다. 이유가 비면 다시 묻는다.
2) OPL 산출: 원자적 1주제마다 wiki/factory/opl/<slug>.md 생성(opl 템플릿). 태깅 1택:
   Basic(기본) / Know-Why(원리) / Know-How(개선·②) / Trouble(불량·사고·③). KEY POINTS 는 수치로(임계: 정상 vs 이탈).
3) SOP 조립: wiki/factory/sop/<slug>.md 생성(TWI Job Breakdown 3열). 본문은 OPL 들을 위키링크로 엮어 조립(사실 복붙 금지).
   대상설비/takt/안전⚠️/공구·권한/선행조건 헤더 + 합격기준(qc-gate) + 실행증거(검증일·방법·PASS/FAIL).
4) lessons 등재: ③ workaround/Trouble 사례는 wiki/factory/lessons/ 에 사례노트로 등재(재발방지 1줄 교훈).
5) 링크: 생성 노트 간 양방향 위키링크(OPL↔SOP↔lesson, 고아 0). frontmatter: created=updated=오늘, source=라인/설비/문서.
6) `bash scripts/check-all.sh` PASS → 현장검증 전이면 DRAFT, 두눈/계측 실증 후 PROVEN.

규율: 모르는 손맛/수치는 지어내지 말고 TODO(owner)+DRAFT. 같은 description 두 곳 금지. 노트 ≤200줄/≤25KB.
```

## 산출 폴더트리 (wiki/factory)

```
agent-wiki/
└── wiki/
    └── factory/
        ├── INDEX.md            # [GENERATED] gen-index.sh
        ├── opl/                # ← 원자 1주제(레고블록) Basic/Know-Why/Know-How/Trouble
        │   └── <slug>.md
        ├── sop/                # ← TWI 3열(OPL 들을 위키링크로 조립)
        │   └── <slug>.md
        ├── lessons/            # ← ③workaround·Trouble 사례 + 재발방지 교훈
        │   └── <slug>.md
        ├── quality/            # qc-gate · defect-taxonomy(합격기준)
        └── traceability/       # provenance-model(추적성)
```

## 조립 하이라키 (노트 = 레고블록, 위키링크로 fractal 조립)

```
   [OPL]  [OPL]  [OPL]        ← 원자(한 주제·5~10분·핵심포인트 1개)
      \     |     /
       \    |    /  위키링크로 엮음(복붙 아님)
        ▼   ▼   ▼
        ┌─────────┐
        │   SOP   │           ← TWI 3열(중요단계|핵심포인트|이유) = OPL 조립체
        └────┬────┘
             │ ③workaround/Trouble 발생 시
             ▼
        ┌─────────┐
        │ lesson  │           ← 사례 + 재발방지 교훈 → 다음 OPL/SOP 개정으로 환류
        └─────────┘
```

## 종료 체크리스트
- [ ] 3계층(공식/실최적/workaround) 전부 캡처 — ②③ 누락 0
- [ ] 모든 단계에 핵심포인트(How=수치·손맛) + 이유(Why) 동반 → [[sop]]
- [ ] OPL 4종 태깅 + KEY POINTS 수치화(임계: 정상 vs 이탈) → [[opl]]
- [ ] OPL↔SOP↔lesson 양방향 위키링크(고아 0·사실 복붙 0)
- [ ] 현장검증(두눈/계측) 후에만 PROVEN, 미검증은 DRAFT + TODO(owner)
- [ ] `scripts/check-all.sh` PASS

## 주의 / 안티패턴
- **단계만 나열**(핵심포인트·이유 누락) → 암묵지 소실. 그건 SOP가 아니라 목차다. → [[sop]]
- **공식 SOP만 옮겨적기**: ②실최적순서·③workaround가 진짜 자산. 그게 빠지면 캡처 가치 0.
- **사실 복붙**: SOP가 OPL 내용을 복붙하면 dup-SOT. 위키링크로 조립.
- **손맛/수치 날조**: 모르면 TODO(owner)+DRAFT. 가짜 수치는 사고를 부른다. 폴더지도 = [[example-line]].
