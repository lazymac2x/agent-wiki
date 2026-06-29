---
name: runbook
description: 배포·인시던트 runbook 템플릿 — SOP 3열(단계|핵심포인트|이유) 동형 + 롤백 한줄 + HITL 게이트 + 실행증거 슬롯. 복사용 코드펜스
type: reference
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[sop]], [[deploy]]
---

# runbook 템플릿 — 배포·인시던트 (SOP 3열 동형)

> runbook = 실행되는 SOP. 제조 [[sop]]와 **같은 3열**(중요단계 | 핵심포인트 | 이유)을 쓴다 — 단계만 적으면 손맛·게이트가 소실된다.
> 차이: runbook은 ① **롤백 한 줄**(MTTR), ② **HITL 게이트**(prod 쓰기 = AskUserQuestion), ③ **실행증거 슬롯**(last verified live)이 의무다.
> 구체 인스턴스 예시는 [[deploy]] 참조. 이 파일은 빈 골격만 — 복사해서 채운다.

```markdown
---
name: <slug>
description: <≤150자>
type: howto          # 배포/운영 runbook
track: dev           # 또는 project|ops
status: DRAFT
owner: you
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
source: <배포 스크립트/워커/CI 경로 | none>
links: [[sop]], [[관련 ADR]]
---

# <시스템> 배포·인시던트 Runbook

| 항목 | 내용 |
|---|---|
| 대상 시스템 | <워커 / 앱 / 봇> |
| 트리거 | <정기배포 / 알람 / 회귀 핫픽스> |
| HITL 게이트 | ⚠️ prod 쓰기·비가역 = AskUserQuestion 명시인증 먼저 |
| 선행조건 | <build green · lint pass · 백업 · 자격증명 위치> |
| 롤백 한 줄 | <즉시 되돌리는 명령/버전 — 예: 직전 버전으로 rollback / 직전 배포로 revert> |

## 절차 (TWI 3열 — SOP 동형)
| # | 중요단계 (What) | 핵심포인트 (How — 명령·수치·게이트) | 이유 (Why) |
|---|---|---|---|
| 1 | 사전점검 | 🔑 build green ∧ lint pass ∧ diff 육안 | green≠works·미검증 영속 금지 |
| 2 | HITL 승인 | ⚠️ prod 쓰기 전 AskUserQuestion(무엇을·어디에) | 비가역·신원위조 차단 |
| 3 | 배포 | 🔑 <배포 명령 (예: 엣지 워커 deploy / 컨테이너 push)> · 라벨/전파 수초 지연 감안 | |
| 4 | 스모크 검증 | 🔑 두눈 / 스모크 / D1 ground-truth 1쿼리 | build-green ≠ live-works |
| 5 | 실패 시 롤백 | ⚠️ 위 '롤백 한 줄' 즉시 실행 → 원인분석 | MTTR 단축·blast radius 차단 |

## 인시던트 분기 (런타임 이상 = OODA)
- **Observe** <지표/로그/알람> → **Orient** <서킷브레이커·killswitch 상태>
- **Decide** 자율수복 vs HITL(confidence < 80~90% = HITL) → **Act** <수복 명령>
- 자율수복 루프 상세는 self-heal 런타임 노트로 위임(여기 복붙 금지).

## 실행증거 (last verified live — 가짜0 금지)
- 검증일: <YYYY-MM-DD> · 방법: <두눈/스모크/D1> · 배포ID/버전: <…> · 결과: <PASS/FAIL>
- 첨부: <캡처·로그·쿼리결과 경로>
```

## 채우는 법
1. 표 상단 5칸(대상·트리거·게이트·선행·롤백)을 먼저 확정 — **롤백 한 줄이 비면 배포 금지**.
2. 3열은 [[sop]]과 동일 규율: 핵심포인트에 손맛·명령·임계, 이유에 '왜'를 반드시.
3. 배포 후 **실행증거 슬롯을 채워야** `status: PROVEN` 승격(증거 없는 PASS = vacuous green).
