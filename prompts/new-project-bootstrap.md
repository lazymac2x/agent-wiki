---
name: new-project-bootstrap
description: 새 프로젝트 부트스트랩 프롬프트 — new-project.sh로 _template 복제→코어 배선→wiki 링크→PDCA 1라운드→self-heal 훅→텔레그램 notify. 결과 트리 동봉
type: howto
track: method
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: scripts/new-project.sh
links: [[bootstrap]], [[pdca-round]]
---

# 새 프로젝트 부트스트랩 — 복붙 가능한 예시 프롬프트

Day-1 최소 플로어를 깔고 첫 PDCA 라운드까지 돌다. 패턴의 *왜*는 [[bootstrap]], 첫 라운드 메커닉은 [[pdca-round]]. 이 노트는 **예시 프롬프트**(DRAFT) — 스캐폴딩 스크립트 `scripts/new-project.sh`는 실존·PROVEN.

## 언제 / 입력
- **외부코드** 프로젝트(이미 코드가 따로 있음) → `--agent-only`: `agents/<name>.agent.md`(brain) + `wiki/domain/<name>.md`(pointer). dual-home 금지 — 코어는 한 곳만.
- **from-scratch** 빌드(이 저장소 안에서 자기완결) → `--buildable`: `projects/<name>/` 서브트리.
- 입력: `<name>`(kebab-slug), 모드 1택.

## 프롬프트 (그대로 붙여넣어 실행)

```text
너는 agent-wiki 부트스트랩 에이전트다. 새 프로젝트 "<name>"(kebab-slug)을 䋀다. 모드=<buildable|agent-only>.

1) 스캐폴드: `bash scripts/new-project.sh --<mode> <name>` 실행.
   - buildable → projects/<name>/ 가 _template 에서 복제됨(reference/howto/explanation/decisions + llms.txt + INDEX).
   - agent-only → agents/<name>.agent.md + wiki/domain/<name>.md 생성.
2) 코어 배선: 생성된 코어 카드(agent.md 또는 llms.txt)의 비즈로직·SOT 경로·도구매핑을
   실제 사실로 채운다. 모르는 값은 지어내지 말고 TODO(owner) + status: DRAFT.
3) wiki 링크: 관련 기존 노트를 ripgrep frontmatter 로 찾아(`rg -l "^name:|^type:" wiki/ projects/`)
   양방향 위키링크를 건다(고아 0). 사실 복붙 금지 — 참조만(단일 SOT).
4) PDCA 1라운드: prompts/pdca-round.md 절차로 Plan→Do→Check(90점 게이트)→Act. 첫 산출물 1개를 PROVEN 후보까지.
5) self-heal 훅: 런타임 자산이면 이상탐지/수복 경로를 self-heal-runtime 프롬프트에 등록(graduated 사다리 + prod-write HITL).
6) 마감: `bash scripts/check-all.sh` PASS 확인 → 통과 시에만 커밋(경로한정 git add). 그 후 텔레그램 notify 1줄 보고.

규율: build-green ≠ live-works. 가짜0 금지. prod-write 는 AskUserQuestion 명시인증 먼저.
INDEX.md/llms.txt 는 수기편집 금지(gen-index.sh 자동생성).
```

## 결과 폴더트리 (buildable 모드)

```
agent-wiki/
├── projects/
│   └── <name>/                  # ← from-scratch 자기완결 서브트리(자기유사)
│       ├── llms.txt             #    기계지도(__PROJECT__→<name> 치환됨)
│       ├── INDEX.md             #    [GENERATED] gen-index.sh — 수기편집 금지
│       ├── reference/           #    에이전트 검색면(간결·독립소비)
│       ├── howto/               #    배포/운영 runbook
│       ├── explanation/         #    사람용 서사(왜)
│       └── decisions/           #    ADR(결정 기록)
└── (scripts/new-project.sh 가 INDEX/llms.txt 자동 재생성)
```

## 결과 폴더트리 (agent-only 모드 — 외부코드)

```
agent-wiki/
├── agents/
│   └── <name>.agent.md          # ← 코어 에이전트(비즈로직·JIT 검색) = brain, 한 곳만
└── wiki/
    └── domain/
        ├── INDEX.md             #    [GENERATED]
        └── <name>.md            # ← 공유 도메인 지식 = pointer(brain 아님, 중복홈 금지)
```

## 종료 체크리스트
- [ ] 코어 카드 비즈로직/SOT 경로 채움(미상은 TODO(owner)+DRAFT)
- [ ] 관련 기존 노트와 양방향 위키링크(고아 0)
- [ ] PDCA 1라운드 통과(평균 ≥90 ∧ P0/P1=0) — 상세 [[pdca-round]]
- [ ] `scripts/check-all.sh` PASS → 커밋
- [ ] 텔레그램 notify 보고 → [[notify]]

## 주의 / 안티패턴
- **INDEX.md·llms.txt 수기편집** → gen-index.sh가 덮어쓴다. frontmatter만 손대라.
- **dual-home**: 외부코드를 `agents/`와 `projects/` 둘 다에 두면 SOT 깨짐. agent-only면 코어는 `agents/` 하나.
- **사실 복붙**: 자격증명/수익 같은 민감정보는 외부 SOT 파일(`<your-secrets-sot>`)이 owns — 부트스트랩이 재기재하지 말 것(point만). 경계는 [[bootstrap]].
- 더 큰 빌드 오케스트레이션이 필요하면 당신의 멀티에이전트 빌드 스킬/스쿼드를 호출(재구현 금지·자신의 환경에 있는 것을 연결).
