---
name: glossary
description: agent-wiki 고밀도 은어 사전 — husk·whack-a-mole·vacuous green·가짜0·두눈·chokepoint·∧/≠ 등 첫 독자 decode
type: reference
track: dev
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[note]], [[manufacturing-bridge]]
---

# glossary — agent-wiki 고밀도 은어 사전

이 저장소의 노트들은 압축된 은어를 쓴다. 처음 읽는 에이전트/사람이 1줄로 **decode**하라고 만든 사전. 각 용어는 정본(owns) 노트로 `[[link]]`만 걸고 정의는 짧게 — 상세는 그 노트 본문.

## 용어
- **husk** — 복구 과정의 garbage-duration 파편 레코드(판별자는 거리 아닌 **비현실 duration**). 통계 오염원이라 리스트엔 숨기되 카운트는 정합 유지. cf. [[single-sot-chokepoint]].
- **whack-a-mole(두더지잡기)** — 표면만 고쳐 같은 root가 다른 표면으로 재발하는 안티패턴. 해법은 단일 SOT chokepoint(소스를 고친다).
- **vacuous green / 가짜0** — 검증한 척하지만 실제로 아무것도 안 본 green: 무음스킵·0건 통과·`ai_calls=0`(정상 idle)을 "멈춤"으로 오인. 금지 → loud skip-with-warning.
- **두눈(실증)** — 사람이 직접 본 ground truth: 에뮬 1080×1920 캡처·dumpsys 포그라운드·D1 직접쿼리. 제조 3현(현장·현물·현실)에 대응 → [[manufacturing-bridge]].
- **single SOT chokepoint** — 한 사실/계산이 통과하는 단일 관문(poka-yoke). 분산 가드 대신 한 소스에서 봉합 → [[single-sot-chokepoint]].
- **build-green ≠ live-works** — CI/유닛 통과가 라이브 정상을 보증하지 못함(TZ/DST·계약·stale 데이터는 green을 통과). 라이브 신호를 따로 본다.
- **JIT(just-in-time 적재)** — 본문을 미리 안 읽고 frontmatter(경로/링크)만 들고 런타임에 끌어옴. `@import`(런치 때 전량 펼침)는 토큰절약이 아님.
- **fractal INDEX** — 모든 폴더가 같은 모양 `INDEX.md`(자기유사 항해). 항목은 1줄 헤드라인·자동생성·고아0.
- **P0/P1/P2** — 결함 심각도(치명/중대/경미). 제조 불량등급 대응. 종료=avg≥90 ∧ P0/P1=0 → [[rubric]].
- **audit ≠ constitution** — 감사/리뷰 보고서는 헌법이 아니다. 실기능에 필요한 권한은 축소가 아니라 근거+절차로 정면돌파. 죽은 잔재만 제거.
- **graduated remediation** — andon식 점진 제동, 정본 3단계 명칭 **조이기(tighten) → 늦추기(slow) → 세우기(stop)**. 즉시 kill 아님. '경고(warn)'는 제동단계 아닌 **신호**. 정본 owner → [[self-healing]].
- **loop-until-dry** — 새 결함이 마를(dry) 때까지 전수조사→수정→실증→재발방지를 반복 → [[feedback-loop]].
- **∧ / ≠** — `∧`=AND(둘 다 참), `≠`=같지 않음. 예: "avg≥90 ∧ P0/P1=0", "build-green ≠ live-works".
- **HITL(human-in-the-loop)** — prod-write·비가역·confidence<80~90%면 AskUserQuestion 명시인증 먼저. 자동화의 비상정지.
- **dogfood** — 이 저장소가 자기 규칙을 자기에게 적용. `scripts/check-all.sh`를 통과 못 하면 커밋 금지.
- **evolution-on-write** — 노트 추가를 한 트랜잭션으로: 쓰고 → 양방향 `[[link]]` 걸고 → 이웃 요약 갱신 → [[note]].
