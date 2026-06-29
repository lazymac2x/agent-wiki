---
name: bootstrap
description: Day-1 시딩/마이그레이션 — 최소가용 플로어(AGENTS+INDEX+예시앱 worked+pdca)→기존 학습 엔트리 import 순서→점진확장. 빈 husk 방지
type: reference
track: ops
status: DRAFT
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[memory-bridge]], [[new-project-bootstrap]]
---

# bootstrap — from-zero에서 최소가용 wiki 세우기

원칙: **빈 폴더 husk부터 만들지 않는다.** 스캐폴드만 있고 내용 0인 wiki는 stale로 능동오도한다. 먼저 **최소가용 플로어(min viable floor)**를 세워 첫 커밋부터 실사용 가능하게 하고, 그 위에 기존 지식을 우선순위대로 import 한다. 신규 프로젝트 stamp는 [[new-project-bootstrap]].

## Phase 0 — 최소가용 플로어 (이게 규칙의 70~80%)
이 4개 + 재료가 있으면 wiki는 "동작한다":
1. **`AGENTS.md`** — 헌장·7대 법칙. 단일 정본. 다른 진입점은 이걸 import.
2. **프랙탈 INDEX + 루트 `llms.txt`** — INDEX는 `gen-index.sh` 자동생성(수기금지), llms.txt는 기계지도.
3. **예시앱 1개 worked example** — `projects/example-app/`( [[data-schema]] · [[api-endpoints]] + [[ADR-0001-single-source-provider]] ). 자기유사 stamp의 원본이자 "노트가 이렇게 생겨다"의 산 증거.
4. **[[pdca]] 1개 실행 루프** — 나머지 import를 *어떻게* 할지의 작업방식.
   재료: `templates/`( [[note]]·[[sop]]·[[opl]] ) + `scripts/`(check-all·gen-index·wiki-lint).

> 검증: 이 시점에 `scripts/check-all.sh` PASS + 고아 0 이어야 "플로어 섬다". 이 저장소가 지금 바로 그 상태다.

## Phase 1 — 기존 지식 import (우선순위 = 가치/빈도순)
복붙이 아니라 **추출**이다 — 사실은 정본 1곳, 나머지 `[[link]]`([[sot-registry]] 등록). 원문 소유경계는 [[memory-bridge]].

1. **가장 자주 인용되는 실증 패턴부터**: [[single-sot-chokepoint]] · [[guardrails]] · [[rubric]]. 라이브에서 이미 반복 참조되는 것 = 최고 ROI.
2. **auto-memory 최신 엔트리 → 방법론 추출**: 휘발성 학습 헤드라인은 auto-memory에 두고, 거기서 **재사용 규칙만** wiki로. 라운드 학습 원문(`feedback_*.md` 류) → 프로젝트지식([[example-app]]) + 교훈 1줄([[_log]]).
3. **도메인 합본**: 여러 라운드에 반복된 공통지식을 [[mobile-app]] · [[automation-bots]] · [[edge-workers]]로 합친다(흩어진 N곳 → 정본 1곳).
4. **개인 운영지식**: `personal/`( [[03-dev-operating]] 등 ). LLM 개인 wiki.

## import 규칙
- **복붙 금지**: 같은 사실이 원문+wiki 두 곳이면 dup-SOT. wiki는 방법론판만 owns, 원문은 auto-memory에 그대로([[memory-bridge]]).
- **실증된 것만 PROVEN**, 미검증/현장미확인은 `DRAFT` + "⚠️ 미검증"(가짜 PROVEN 금지 — L5).
- 각 import 후 **`check-all.sh` PASS**(깨진링크 0·고아 0·dup 점검).

## 빈 husk 방지 (안티패턴)
- **폴더 생성 ≠ 시딩.** 내용 없는 노트를 미리 만들지 말 것 — DRAFT husk가 stale로 능동오도한다.
- 빈 폴더가 필요하면 `.gitkeep` 금지 → `INDEX.stub` 1개로 표현([[git-conventions]]).
- "나중에 채울" 스텁 양산 금지. 채울 사실이 생겼을 때 그 노트를 만든다.

## 점진확장
- 새 프로젝트 = `scripts/new-project.sh`로 stamp → 같은 플로어 모양 자기유사 복제([[new-project-bootstrap]]).
- 분기 청소로 죽은 잔재 제거 + supersession 관리 → [[pruning]].

## TODO
- auto-memory 전체 import 1패스는 아직 미실행 → 본 절차는 이 저장소 플로어(Phase 0)로 부분 실증, Phase 1 full sweep 후 PROVEN 승격.
