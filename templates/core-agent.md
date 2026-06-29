---
name: core-agent
description: 코어 에이전트 카드 본문 템플릿 — new-project.sh --agent-only 가 그대로 복사·stamp(type:agent·DRAFT로 착지)
type: agent
track: project
status: DRAFT
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[_AGENT_SPEC]]
---

# <프로젝트> 코어 에이전트

> 비즈니스 로직을 보유한 코어 에이전트 카드. 계약 전문은 [[_AGENT_SPEC]]. 이 파일 자체가 복사 대상이라 **복사 즉시 type:agent · status:DRAFT** 로 착지한다(가짜 PROVEN husk 금지 — 실증 후에만 PROVEN 승격).

## 카드메타 (런타임 계약 — 채워서 사용)
```yaml
preload: [self_card]            # 사전적재는 이 카드만. 나머지 지식은 JIT(ripgrep-over-frontmatter)
wiki_access:                    # 이 에이전트가 JIT로 끌어올 wiki 경로 allowlist
  - wiki/domain/<name>-notes    # TODO(you): 실제 도메인 노트 slug로 교체
loop: pdca                      # 기능/빌드 개선 루프(런타임 이상은 ooda-runtime)
gate: rubric                    # 90점 적대 게이트(avg≥90 ∧ P0/P1=0)
self_heal: self-healing         # 이상 시 graduated remediation(조이기→늦추기→세우기)
hitl: [prod-write, irreversible, "confidence<0.85"]   # 사람 확인 필수 경계
skills: [deep-feedback, self-heal]   # 재구현 금지 — 호출만(당신 환경의 스킬/루틴으로 매핑)
```

## §1 역할 / 소유 비즈로직
TODO(you): 이 프로젝트가 무엇을 책임지는가(한 문단). 범용 방법론은 적지 말고 [[_AGENT_SPEC]]·harness로 링크.

## §2 불변식 (이 에이전트만 아는 도메인 진실)
- TODO(you): 깨지면 안 되는 규칙·단일 chokepoint·함정(예: 단일 소스 provider, 검증 경로, 금칙 동작).

## §3 wiki 접근 (JIT)
- `rg -l "^name:|^description:" wiki/domain wiki/<track>` 로 검색 → 후보만 Read. 복붙 금지·위키링크 참조.

## §4 self-heal / HITL
- 이상 탐지 → [[_AGENT_SPEC]] §self-heal 훅. prod-write·비가역·confidence<0.85 = HITL(AskUserQuestion) 먼저.

## §5 stamp 후 할 일
1. `wiki_access` allowlist를 프로젝트에 맞게 최소화(죽은 글롭 제거).
2. §1/§2 에 **이 에이전트만 아는 비즈로직**을 채운다.
3. 실증·90점 게이트 통과 후 `status: PROVEN` 승격.
