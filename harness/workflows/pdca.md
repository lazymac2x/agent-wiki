---
name: pdca
description: Plan(전수조사)→Do(단일소스 구현)→Check(감사·90점 적대채점·다양시나리오 실증)→Act(재발방지·문서갱신·배포) 계획-품질 루프 · 심층-피드백 스킬 브리지
type: howto
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[evaluator-optimizer]], [[rubric]], [[feedback-loop]]
---

# PDCA 실행 — 계획품질 루프 (빌드/기능 개선)

빌드·기능 개선의 기본 루프. 런타임 이상수복(시간민감)은 OODA로 — 라우팅은 [[ooda-runtime]]. 이 문서는 당신의 심층-피드백/적대비평 스킬(프로덕트 모드 포함)의 사용설명서다: 아래 단계를 그 스킬이 실행한다(자신의 환경에 있는 스킬을 연결). 종료조건은 [[evaluator-optimizer]]와 동일(평균 ≥90 ∧ P0/P1=0 ∧ 반복상한 6).

## 언제 PDCA인가
- 신규 기능 / 리팩터 / 노트 저작 / 데이터정합 수정 = PDCA.
- 봇 다운·배포 실패·prod 이상 = OODA([[ooda-runtime]]) 먼저, 안정화 후 근본원인은 PDCA로 회수.
- prod-write · 비가역 · confidence < 80~90% = 어느 단계든 HITL(AskUserQuestion) 게이트 → [[guardrails]].

## P — Plan (전수조사 먼저, 표면패치 금지)
1. **전수조사**: 증상이 아니라 전체 데이터흐름을 추적. 코드 grep(바이너리 오탐 주의 → `grep -a`), 프로덕션 DB 직접쿼리로 ground truth 확정([[data-schema]]). "기능이 틀림"의 진짜원인이 데이터/UX갭일 수 있다 — 전 체인 추적해야 진실.
2. **단일 chokepoint 식별**: 같은 사실이 여러 소스에 흩어졌나? 표면패치 = whack-a-mole. **단일소스가 근본** → [[single-sot-chokepoint]]. 단일 정본 레코드 provider(single-source) 사례 = [[example-app]].
3. **정밀 플랜**: 수정지점·영향범위·재발방지 수단·검증 시나리오를 미리 적는다. 대형 IA변경은 선매핑.
4. 산출: 무엇을·왜·어디를 한 소스에서 고치는지 1문단.

## D — Do (단일소스 구현)
1. 식별한 chokepoint **한 곳**만 고친다. 두 곳에 같은 값이 생기면 그게 새 버그.
2. 결정론 로직은 **순수함수로 추출**(깊게결합된 핸들러 통째 mock 회피 → 경계 테스트 가능).
3. 이중트리(앱/워커 등)는 경로한정 `git add`로 각각 커밋 → [[git-conventions]].
4. 빌드 green 확보. **단, build-green ≠ live-works**(다음 단계가 진짜 게이트).

## C — Check (감사 + 적대채점 + 실증, 3겹)
1. **감사**: 계약/비용/회귀 등 build-green·라이브정상이 통과시키는 결함을 코드리뷰로 적발. audit ≠ constitution — 실기능 필요권한은 근거+절차로 정면돌파, 죽은 잔재만 제거.
2. **90점 적대채점**: 7축 JSON 루브릭 → [[rubric]]. 생성과 다른 모델패밀리 judge([[judge]])로 self-preference 회피. 루프 메커닉 = [[evaluator-optimizer]].
3. **다양 시나리오 실증**: 두눈(에뮬 1080×1920 캡처·dumpsys 포그라운드) + 결정론 테스트(TZ-불변·무음스킵=vacuous green 금지) + 프로덕션 DB ground-truth + **가짜0 금지** → [[verify]] [[feedback-loop]].
4. 조건부 발화 버그는 **그 조건을 실제 재현**해야 두눈 성립(못 켜는 이유 자체가 2차 버그일 수 있다).

## A — Act (수정 + 재발방지 + 문서 + 배포)
1. Check가 연 결함을 수정 → C로 되돌아가 재채점(loop). 종료 = 평균 ≥90 ∧ P0/P1=0 ∧ 반복상한 6.
2. **재발방지**: 같은 root가 재발하지 못하게 결정론 테스트/가드/단일 SOT 헬퍼를 심는다(증상 패치만 하고 끝내지 않음).
3. **문서갱신**: 바뀐 사실의 노트 `updated:` 갱신, 새 교훈은 [[_log]]에 1줄. stale 노트 = 능동 오도.
4. **배포**: prod 쓰기는 HITL 명시인증 후 실행(예: 엣지 배포 CLI) → [[deploy]]. 마일스톤 보고 → [[notify]].

## 종료 체크리스트
- [ ] 단일 chokepoint에서 수정(dup-SOT 0)
- [ ] 적대채점 평균 ≥90 ∧ P0/P1 = 0
- [ ] 두눈 + 결정론 + 프로덕션 DB ground-truth 실증(가짜0 없음)
- [ ] 재발방지 수단 1개 이상 영속화
- [ ] 영향 노트 `updated:` 갱신 + [[_log]] 기록 + `scripts/check-all.sh` PASS

## 안티패턴
- "build green이니 끝" → C 누락(라이브/계약 결함 잔존). → [[anti-patterns]]
- 증상만 패치(A의 재발방지 생략) → 다음 라운드 동일버그.
- judge를 생성과 같은 모델로 → self-preference 점수 인플레.
