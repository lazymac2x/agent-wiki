---
name: backlog
description: 의식적으로 이연한 항목 — audit≠constitution(감사가 권한 건 다 구현하지 않는다, 근거 갖춰 이연). 죽은 잔재 아님·추적됨
type: reference
track: ops
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[pruning]], [[bootstrap]]
---

# backlog — 의식적 이연 (audit ≠ constitution)

적대 감사가 제안한 것 전부를 구현하면 scaffold가 살줬다(scaffold-rot). 아래는 **근거를 갖춰 미뢬** 항목 — 빈 husk나 망각이 아니라 *추적되는 결정*이다. 트리거가 오면 승격한다.

## 런타임 강제 primitive (정책은 있음, 집행 스크립트는 이연)
- **비용 원장·$ 킬스위치·동시성 캡** — [[model-tiering]]·[[guardrails]]가 정책으로 규정. 실제 런타임 집행은 *소비 측 코드*(예: 자동매매 봇·워크플로 러너 — [[automation-bots]])에 사는 게 맞다(이 템플릿은 지식 OS지 런타임이 아님). repo-레벨 카운터 스크립트는 **이연**. 트리거: 이 폴더에서 빌드한 프로젝트가 자체 러너를 가질 때.
- **worktree 생성/회수 헬퍼 스크립트** — [[git-conventions]]가 절차(kill -15 + git worktree remove) 규정. 안전 래퍼 스크립트는 **이연**(현재는 규율 + pre-commit staged-scope 경고로 충분).

## self-test / CI 심화 (이연)
- **gen-index/wiki-lint 의 BATS 단위테스트** — 현재는 `check-all`이 58노트 실데이터로 dogfood(회귀 시 게이트 자신이 trip). 합성 픽스처 BATS는 **이연**. 트리거: 스크립트가 3+ 회귀하면 self-test 신설.
- **install-hooks 완전 자동화** — SessionStart hook이 미설치 시 *경고*까지 한다(`.claude/settings.json`). 무조건 자동설치는 사용자 동의 없는 .git 변경이라 보수적으로 **경고에서 멈춤**.

## 콘텐츠 충전 대기 (seed → real, husk 아님)
- **factory 실 라인데이터** — 제조 트랙은 *armed scaffold*(스키마 실증·DRAFT 시드). 첫 현장 OPL 캡처([[capture-floor-knowledge]])가 트리거. → [[_log]]
- **standard-work 예시 노트** — `type: standard-work` enum은 미래 유효값. 실 작업표준 들어올 때 첫 노트 생성(지금 빈 예시 = husk라 보류).
- **다관점 토론·멀티에이전트 빌드 스킬 전용 howto** — 호출 조건은 [[pattern-select]] 오케스트레이션 선택표 + [[feedback-loop]] 호출계약으로 커버. 전용 노트는 실제 반복 사용 패턴이 쌓이면 승격.

## 외부 소유(직접 수정 금지 — 통보만)
- **외부 store(auto-memory·외부 SOT)의 stale 경로** — 외부 메모리/SOT가 가리키는 워커·코드 경로가 옛 위치로 굳어 있을 수 있다. 이 저장소는 정본([[api-endpoints]])으로 정정하지만, 원천(auto-memory/외부 SOT)은 agent-wiki 소유가 아니다([[memory-bridge]] 경계) → **사람 승인 후 원천 정정**. wiki-lint의 dead-path blocklist가 이 저장소 내 회귀는 차단.

## 운영
- 항목이 트리거되면 여기서 제거하고 해당 노트/스크립트로 승격(단일 SOT). 무재현·무용이면 [[pruning]] 대상.
