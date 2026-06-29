---
name: pdca-round
description: PDCA 한 라운드 프롬프트 — Plan(전수조사)→Do(단일소스)→Check(90점 적대게이트 루프)→Act+배포+notify. 심층-피드백 스킬 구동·harness 경로 동봉
type: howto
track: method
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: harness/workflows/pdca.md
links: [[pdca]], [[rubric]]
---

# PDCA 한 라운드 — 복붙 가능한 예시 프롬프트

빌드/기능 개선 한 라운드를 끝까지(배포·보고) 돌다. 단계의 *정본*은 [[pdca]], 채점 루브릭은 [[rubric]]. 이 프롬프트는 당신의 심층-피드백/적대비평 스킬(프로덕트 모드 포함)을 구동한다 — 재구현 말고 호출(자신의 환경에 있는 스킬을 연결). 예시 프롬프트(DRAFT).

## 언제 / 입력
- 신규 기능 / 리팩터 / 노트 저작 / 데이터정합 수정 = PDCA. 런타임 이상수복은 [[ooda-runtime]] 먼저.
- 입력: 개선 대상(파일/기능/노트) 1개, 종료조건은 고정(아래).

## 프롬프트 (그대로 붙여넣어 실행)

```text
너는 agent-wiki PDCA 라운드 에이전트다. 대상="<feature/file>". 당신의 심층-피드백/적대비평 스킬을 호출해 한 라운드를 돌다.

P — Plan: 증상이 아니라 전체 데이터흐름 전수조사(grep -a 바이너리 오탐 주의, 프로덕션 DB 직접쿼리로 ground truth).
   단일 chokepoint 식별(같은 사실이 여러 소스? 표면패치=whack-a-mole). 수정지점·영향범위·재발방지·검증 시나리오를 미리 적는다.
D — Do: 식별한 chokepoint 한 곳만 고친다(두 곳에 같은 값 생기면 새 버그). 결정론 로직은 순수함수로 추출.
   이중트리는 경로한정 git add 로 각각. 빌드 green 확보(단, build-green ≠ live-works).
C — Check (3겹): ①감사(계약/비용/회귀 — build-green 이 통과시키는 결함) ② 90점 적대채점(7축 JSON 루브릭,
   생성과 다른 모델패밀리 judge) ③다양 시나리오 실증(두눈 에뮬 1080×1920·dumpsys + 결정론 테스트 TZ-불변·
   무음스킵 금지 + 프로덕션 DB ground-truth + 가짜0 금지). 조건부 발화 버그는 그 조건을 실제 재현해야 두눈 성립.
A — Act: Check 가 연 결함 수정 → C 로 되돌아가 재채점(loop). 종료=평균≥90 ∧ P0/P1=0 ∧ 반복상한 6.
   재발방지(결정론 테스트/가드/단일 SOT 헬퍼 영속화) → 문서 updated: 갱신 + _log 1줄 → 배포(prod-write 는
   AskUserQuestion 명시인증 후) → 텔레그램 notify.

마감: `bash scripts/check-all.sh` PASS 시에만 커밋·PROVEN 승격.
```

## 90점 게이트 루프 (Check↔Act 엔진)

```
        ┌────────────────────────────────────────────┐
        │  Optimizer(생성, 작업모델)  ──산출물──▶        │
        │                                     │         │
        │           ┌─────────────────────────▼──────┐  │
        │           │ Evaluator(judge, 다른 모델패밀리)│  │
        │           │  7축 점수 + P0/P1/P2 결함 JSON   │  │
        │           └─────────────┬───────────────┘  │
        │   결함 되먹임 ◀──아니오── 평균≥90 ∧ P0/P1=0 ?   │
        └───────────────────────│───────────────┘
                          예 │ (또는 반복상한 6 → HITL)
                             ▼
                       PROVEN 승격 검토
```
종료조건 셋 다 AND. 메커닉 상세 = [[rubric]] · 루프 엔진 = [[pdca]].

## harness 경로 (이 프롬프트가 끌어쓰는 SOT)

```
agent-wiki/
├── harness/
│   └── workflows/
│       ├── pdca.md               # ← 단계 정본(P/D/C/A) = source
│       └── evaluator-optimizer.md# ← 90점 루프 엔진(종료조건)
├── agents/
│   └── _panel/
│       ├── verify.md             # 실행증거(두눈/결정론/DB)
│       └── judge.md              # 7축 JSON 채점(다른 모델패밀리)
└── scripts/
    └── check-all.sh              # lint + link + gen-index --verify(커밋 게이트)
```

## 종료 체크리스트
- [ ] 단일 chokepoint에서 수정(dup-SOT 0)
- [ ] 적대채점 평균 ≥90 ∧ P0/P1 = 0(반복상한 6 내 수렴) → [[rubric]]
- [ ] 두눈 + 결정론(무음스킵 0) + 프로덕션 DB ground-truth 실증(가짜0 0)
- [ ] 재발방지 수단 1개 이상 영속화
- [ ] 노트 `updated:` 갱신 + `_log` 1줄 + `check-all.sh` PASS

## 주의 / 안티패턴
- **"build green이니 끝"** → Check 누락. 라이브/계약 결함은 적대리뷰로만 잡힌다.
- **증상만 패치**(재발방지 생략) → 다음 라운드 동일버그.
- **self-judge**(생성=평가 같은 모델) → self-preference 점수 인플레. judge는 다른 패밀리.
- **노이즈 패널 무한추격**: 적대 패널이 비결정·자기모순이면 스펙/루브릭=LAW, 상한에서 컷+HITL. audit ≠ constitution. → [[pdca]]
