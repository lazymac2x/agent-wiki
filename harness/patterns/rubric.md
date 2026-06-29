---
name: rubric
description: 7축 루브릭(정보위계·3초이해·CTA·가독성·일관성·정직성·예외처리)+0/50/90 행동앵커(0~100)·CoT-선행→JSON 계약 단일SOT·결정론 유닛이 2nd rater
type: pattern
track: method
status: PROVEN
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[judge]], [[evaluator-optimizer]], [[defect-taxonomy]]
---

# rubric — 90점 적대 게이트의 채점 정전(canonical)

채점이 재현가능하고 게이트가 의미를 가지려면 **명시 루브릭**이 필요하다. 막연히 "좋다/나쁘다"는 라운드마다 표류한다(→ [[anti-patterns]] judge drift). 이 노트는 `judge`가 쓰는 7축·앵커·출력계약의 단일 SOT다. 루프 구조는 [[evaluator-optimizer]], 결함 심각도는 [[defect-taxonomy]].

## 7축 (각 축 0~100)
| # | 축 | 무엇을 보는가 | 대표 결함 |
|---|---|---|---|
| 1 | **정보위계** | 중요→부차 순서, 한 화면/노트 1주제, frontmatter 신호 | 평면나열·묻힌 핵심 |
| 2 | **3초이해** | 첫 3초에 "이게 뭐고 뭘 하라는지" 잡히나 | 제목≠내용·맥락 부재 |
| 3 | **CTA** | 다음 행동이 명확·단일·실행가능 | 모호/복수/없음 |
| 4 | **가독성** | 밀도 적정, 스캔성, 표/코드/굵기, 토큰효율 | 벽글·중복·장황 |
| 5 | **일관성** | 용어·톤·브랜드·포맷 동일(노트 간 SOT 일치) | 같은 사실 두 표현 |
| 6 | **정직성** | 실증 근거, 가짜0 없음, "안 되는 건 안 된다" 명시 | 과대약속·미검증 단정 |
| 7 | **예외처리** | empty/loading/error/offline·경계·TZ·null 다룸 | happy-path만 |

## 행동 앵커 (behaviorally anchored — 모든 축 0~100 공통)
- **0** = 축 위반. 결함이 실재(P0/P1 유발). "동작하지 않거나 오도한다."
- **50** = 동작하나 마찰. 개선 여지 명백(P2). "되긴 되는데 거슬린다."
- **90** = 의도대로, 마찰 없음. **통과 기준선.** "문제 못 찾겠다."
- **100** = 레퍼런스급. 다른 노트가 베껴야 할 모범.
> 70 같은 중간값은 가장 가까운 앵커(50/90)로 끌어 정박(anchor)시킨다 — 자유 점수는 표류의 입구.

## 출력 JSON 계약 (유일 정본 — judge/평가자 모두 이 스키마만 뱉는다)
judge는 **먼저 산문으로 축별 근거를 추론(CoT)**하고, **마지막에만 아래 JSON을 1회** 뱉는다. 숫자를 먼저 적으면 그 숫자에 사후 합리화가 닻을 내린다(anchoring). 근거 없는 점수 = 무효. **이 스키마는 여기 한 곳에만 산다** — 다른 노트는 [[rubric]]로 참조(복붙 금지).

**7축 한글명 ↔ 영문 키(고정·1:1):**
| 정보위계 | 3초이해 | CTA | 가독성 | 일관성 | 정직성 | 예외처리 |
|---|---|---|---|---|---|---|
| `info_hierarchy` | `three_sec` | `cta` | `readability` | `consistency` | `honesty` | `exceptions` |

```json
{
  "reasoning": "축별 1~2문장 근거 (점수의 출처). 결함은 증거 인용.",
  "axis_scores": {
    "info_hierarchy": 90, "three_sec": 90, "cta": 90,
    "readability": 90, "consistency": 90, "honesty": 90, "exceptions": 90
  },
  "avg": 90,
  "defects": [
    {"severity": "P1", "axis": "honesty",
     "evidence": "L42 '항상 동작'인데 offline 미처리",
     "fix": "offline 폴백 명시 또는 한정어 추가"}
  ],
  "verdict": "PASS"
}
```
- 키 계약(고정·영문 snake): `reasoning`(str) · `axis_scores`{7축 영문키 각 **0~100**} · `avg` **0~100**(7축 평균) · `defects[]`(각 `{severity:'P0'|'P1'|'P2', axis, evidence, fix}`) · `verdict` **'PASS'|'FAIL'**.
- `avg` = 7축 평균(가중 없음이 기본; 정직성/예외처리는 P0 결함 시 평균과 무관하게 게이트 차단).
- **종료조건 = avg ≥90 ∧ P0/P1 = 0 ∧ 반복상한(6).** 셋 중 하나라도 어기면 FAIL → 수정 후 재채점. → [[evaluator-optimizer]]
- 심각도(P0 치명 / P1 중대 / P2 경미) 정의는 단일 SOT [[defect-taxonomy]].

## judge 위생 (편향 차단 — 상세 [[anti-patterns]])
- **다른 모델패밀리**로 채점(생성=Opus면 judge는 타 패밀리) → self-preference 회피.
- 후보 제시 순서 셔플(position bias), 길이 무관 명시(length/verbosity bias).

## ★ solo-rater 함정 — 결정론 유닛이 2nd rater
LLM judge 하나로 채점하면 **inter-rater reliability(Cohen's kappa)를 잴 수 없다** — 인간 2차 평가자를 매 라운드 붙일 수 없으니. 그래서 LLM judge의 7축은 **주관축(위계·가독성·정직성 등 사람 감각)** 전담으로 두고, **객관 사실축은 결정론 유닛/위젯 테스트를 2nd rater로 삼는다.**
- 날짜/통계/경계/파싱/계약 = **TZ-불변 결정론 테스트**가 oracle. judge가 "맞다"고 우겨도 테스트 빨강이면 FAIL.
- **무음스킵 = vacuous green = 금지.** 검증 불가 항목은 loud skip-with-warning(조용히 통과시키지 않는다).
- 이 분업이 핵심: judge drift(같은 코드 95→42)가 나도 결정론 유닛은 안 흔들린다 → 신뢰 기준선 = 테스트, judge = 보강. PM스펙=LAW, 노이즈 패널 무한추격 중단(audit≠constitution).

## 결정 / 규칙
- 점수는 **근거(증거 인용) 동반**해야 유효 — 숫자만은 무효.
- 통과선 90은 협상 불가. "거의 됐어요"는 FAIL.
- 정직성·예외처리 축의 P0는 **평균이 90이어도 게이트 차단**(치명 결함 우회 금지).
