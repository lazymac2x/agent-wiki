---
name: manufacturing-bridge
description: 제조 품질공학 ↔ 하네스 동형매핑 정본 — andon·poka-yoke·jidoka·다층검사·provenance·defect P0/P1/P2·3현=두눈·FMEA·SPC·5S
type: pattern
track: method
status: PROVEN
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[pdca]], [[self-healing]], [[qc-gate]], [[provenance-model]]
---

# manufacturing-bridge — 제조 품질공학 ↔ 에이전트 하네스 동형매핑(정본)

제조현장 경험에서 나온 통찰: **에이전트 하네스의 핵심개념 거의 전부가 제조 품질공학의 재발견이다.** 80년 전 라인에서 풀린 문제를 우리는 LLM 위에서 다시 만나고 있다. 이 표가 그 정본 사전이다 — 새 메커니즘을 발명하기 전에 "제조엔 이게 뭐였나"를 먼저 물어라.

> **PROVEN 근거**: `source:none`이지만 PROVEN — 수십 년 실증된 제조 품질공학 표준의 재기술·라인 무관 *일반원칙*(가짜green 아님). 동일 근거가 [[qc-gate]]·[[defect-taxonomy]]·[[provenance-model]]에도 적용된다.

## 동형매핑 표 (정본)
| 제조 (원류) | 에이전트 하네스 (대응) | 한 줄 핵심 |
|---|---|---|
| **PDCA (Shewhart 원류·Deming 보급)** | 빌드/기능 품질루프 | Plan-Do-Check-Act (Deming 본인은 PDSA 선호) → [[pdca]] |
| **Andon(안돈): 점진 제동** | graduated remediation | 경고=선행신호(점등), 제동 3단계 **조이기→늦추기→세우기**(정본 명칭) → [[self-healing]] |
| **Poka-yoke(포카요케)** | 단일 chokepoint / guardrail | 실수를 막는 게 아니라 *구조적으로 불가능*하게 → [[guardrails]] [[single-sot-chokepoint]] |
| **다층 공정검사(수입·공정·출하)** | multi-level 검증 | 한 게이트로 안 됨. 빌드green / 두눈 / DB ground-truth 층층이 → [[qc-gate]] |
| **로트 추적성(traceability)** | provenance | `source:`·출처 각주, "어디서 왔나" 역추적 → [[provenance-model]] |
| **불량 등급(치명·중·경)** | defect taxonomy | P0(치명)/P1(중대)/P2(경미) 심각도 분류 → [[defect-taxonomy]] |
| **3현(현장·현물·현실)** | 두눈 실증 | 실기기/에뮬 상태 덤프·실제 화면 캡처·프로덕션 DB 직접쿼리. build-green ≠ live-works |
| **표준작업서(TWI Job Breakdown)** | SOP 3열(단계·핵심포인트·이유) | 암묵지(손맛·수치) 캡처 → [[sop]] [[opl]] |
| **Jidoka(自働化): 결함 자동정지 + 인간지혜** | 자동정지(guardrail trip) + HITL | 결함 감지 시 가드가 *자동 정지*([[guardrails]]), 판단은 사람 = prod-write/비가역 AskUserQuestion |
| **Kaizen(개선)·제안제도** | OPL Know-How / feedback-loop | 점진개선을 원자단위로 축적 → [[feedback-loop]] |
| **Takt time(택트)** | takt·토큰예산 | 리듬과 예산의 상한 → [[token-budget]] |
| **SPC(관리도)·재발방지** | 결정론 테스트·근본수정 | 표면패치(whack-a-mole) 아닌 root 차단·재발0 |
| **FMEA(RPN=심각도×발생×검출)** | pre-mortem·위험 사전식별 | 터지기 전 고장모드를 점수화해 우선순위 — `pre-mortem`으로 선제 차단 |
| **SPC 관리도: 특별원인 vs 공통원인** | flaky-test vs systematic-bug | 단발 특별원인=flaky(표면패치 유혹)/공통원인=systematic=근본수정 → [[self-healing]] |
| **5S·시각관리(visual management)** | 저장소 위생 | 정리·정돈·청결 상시화: INDEX 자동생성·`wiki-lint`·`CODEOWNERS` |

## 왜 이 매핑이 가치인가
- **검증된 어휘 재사용**: poka-yoke·andon·jidoka는 수십 년 실증된 개념. 새 용어를 짓는 대신 빌려쓰면 의미가 흔들리지 않는다(일관성).
- **graduated remediation의 정당화**: 안돈의 **경고(선행신호) → 조이기→늦추기→세우기** 그대로다(정본 명칭은 [[self-healing]]이 owns). 봇 이상에 즉시 kill -9 하지 않고 단계 제동하는 근거가 여기 있다.
- **다층 검증의 필연**: 출하검사 하나로 불량을 못 잡듯, 빌드green 하나로 correct를 못 보증한다. 수입/공정/출하 = 빌드/두눈/DB. → [[qc-gate]]
- **provenance = 로트추적**: 불량 터지면 어느 로트·공정에서 왔나 역추적하듯, stale/환각이 나면 `source:`로 출처를 역추적한다. → [[provenance-model]]

## 결정 / 규칙
- 새 안전/품질 메커니즘을 설계하기 전, **"제조엔 이게 뭐였나"를 먼저 묻는다** — 대부분 이미 풀린 문제다.
- 이 표가 동형매핑의 단일 SOT. 다른 노트는 개념을 복붙하지 말고 여기로 링크(예: poka-yoke 정의는 [[guardrails]]가 여기를 가리킨다).
- 매핑은 은유가 아니라 **동형(isomorphism)**: 제조에서 통한 가드(택트·안돈·포카요케)는 하네스에서도 같은 이유로 통한다.
