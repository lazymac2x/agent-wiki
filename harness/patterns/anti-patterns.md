---
name: anti-patterns
description: self-audit 체크리스트 — 7대 안티패턴 + Reflexion 3함정(퇴화·무한루프·틀린교훈 영구저장) + judge 편향 5종(위치·길이·자기편애·장황·표류)
type: pattern
track: method
status: PROVEN
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[rubric]], [[feedback-loop]]
---

# anti-patterns — 보내기 전 self-audit

산출을 내보내기 전에 스스로 돌리는 체크리스트. 채점축은 [[rubric]], 루프 구조는 [[feedback-loop]]. 여기 항목 하나라도 걸리면 PASS 아님 — 고치고 다시.

## A. 7대 안티패턴 (저작·구현 공통)
- [ ] **표면패치(whack-a-mole)** — 증상을 N곳에서 패치. 정답=단일소스가 근본([[rubric]] 일관성축). 같은 값 두 곳이면 그게 버그.
- [ ] **가짜0 / vacuous green** — 무음스킵 테스트, "build-green=correct" 착각. CI-green ≠ live-works(TZ/DST 의미버그는 통과한다). 검증불가 = loud skip-with-warning.
- [ ] **dup-SOT** — 같은 사실 복붙. 복붙 말고 위키링크로 참조(같은 description 두 곳 금지).
- [ ] **사전적재 폭주** — JIT 아닌 전량 펼침. 가벼운 식별자만 컨텍스트, 본문은 런타임에. `@import`는 토큰절약 아님.
- [ ] **stale 노트 방치** — `source:` 코드 변경 후 미갱신 = 능동 오도(없느니만 못함). freshness-lint이 잡기 전에.
- [ ] **4역할 1파일** — Diátaxis 혼합(reference+howto+explanation+tutorial 동시). 분리 + 상호링크가 가치.
- [ ] **audit=constitution** — 감사보고서를 헌법처럼 무지성 수용(권한·기능 일괄 축소). 죽은 잔재만 제거, 실기능은 근거+절차로 정면돌파. 노이즈 패널 무한추격 중단.

## B. Reflexion 3함정 (자기반성 루프의 실패모드)
자기 출력을 반성·재수정하는 루프는 강력하지만 셋으로 망가진다:
1. **퇴화(degeneration)** — 반복 수정이 오히려 품질 저하(N라운드째가 초안보다 나쁨). **가드: 점수 회귀 시 직전 버전으로 롤백**(매 라운드 점수 기록, 단조 비증가면 정지). 적대 게이트는 P0/P1=0 *연속* 검증.
2. **무한루프** — 같은 결함을 영원히 재시도. **가드: iteration cap(6) + "이번 결함이 직전과 다른가" 확인.** 같은 결함 2회 반복이면 접근 자체를 바꿔라(다른 root).
3. **틀린 교훈 영구저장** — 잘못된 self-lesson을 메모리에 영구 기록 → 영영 오도(가장 위험). **가드: lesson은 실증 후에만 영속(검증-선-영속), `source:`/증거 첨부.** 미검증 추정은 DRAFT + "⚠️ 미검증", 메모리/wiki에 단정으로 박지 마라.

## C. judge 편향 5종 (채점 신뢰성 위협 — [[rubric]] 위생과 짝)
LLM judge는 다음으로 흔들린다. 각각 가드 동반 없이는 judge 점수를 신뢰하지 마라:
1. **위치(position)** — 먼저/나중 제시 순서로 점수 치우침. 가드: 순서 셔플 / A-B 교차 평가.
2. **길이(length)** — 긴 답을 무조건 높게. 가드: 길이 정규화, "길이 무관" 명시.
3. **자기편애(self-preference)** — 자기(같은 모델패밀리) 생성물 편애. 가드: **다른 모델패밀리 judge**.
4. **장황(verbosity)** — 자신감·미사여구·전문어에 점수. 가드: CoT로 *근거* 요구, 근거 없는 점수 무효.
5. **표류(drift)** — 라운드 거듭하며 기준 이동(동일 코드 95→42처럼 자기모순·비결정). 가드: **결정론 유닛이 oracle**, PM스펙=LAW, judge는 보강. 노이즈 패널 무한추격 = 중단(audit≠constitution).

## 결정 / 규칙
- 이 체크리스트는 **내보내기 직전 1회 의무.** 통과 못 하면 [[feedback-loop]]로 되돌아간다.
- Reflexion 루프엔 항상 (롤백·cap·실증-후-영속) 3가드 동반.
- judge 점수는 5편향 가드가 갖춰진 경우에만 신뢰. 의심되면 결정론 테스트로 교차검증.
