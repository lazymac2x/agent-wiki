---
name: git-conventions
description: git 충돌방지 — 단일 git DB·경로한정 add·핫스팟 single-writer·additive-only·worktree-per-agent 스코프브랜치·git 직렬화(kill-15+worktree remove)·rebase-before-merge
type: reference
track: ops
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[model-tiering]], [[bootstrap]]
---

# git-conventions — 병렬 에이전트 충돌을 *해결*이 아니라 *회피*

전제: 여러 에이전트와 이중트리(예: 앱 SOT 경로 + 워커 SOT [[api-endpoints]] 정본 경로)가 **단일 git DB**를 공유한다. 병렬 쓰기 = 충돌·로스트 업데이트 위험. 규칙은 충돌을 사후에 푸는 게 아니라 **구조적으로 안 나게** 한다.

## A. 경로한정 add (`git add -A` 절대 금지)
- 항상 `git add <경로>`로 **자기 경로만** 스테이징. 이중트리에서 앱/워커가 같은 DB를 공유해도 각자 자기 디렉터리만 커밋.
- `git add -A` / `git add .` = 남(다른 에이전트·다른 트리)의 변경을 삼켜 로스트 업데이트. 이중트리 단일 git DB 운영의 핵심 안전장치.

## B. 핫스팟 single-writer (CODEOWNERS)
- 동시 편집이 잔은 파일(생성된 INDEX·`AGENTS.md`·단일 대형 워커 파일)은 **한 번에 한 에이전트만** 쓴다. `CODEOWNERS`로 owner를 못박아 직렬화.
- 핫스팟에 둘이 동시에 손대면 거의 항상 충돌 → 라우팅으로 회피.

## C. additive-only 기본
- 노트 시스템은 **한 파일=한 노트**라 병렬 신규추가가 안전(서로 다른 파일이a충돌 없음).
- 기존 파일 수정은 single-writer 경로(B)로만. 대부분 작업을 additive로 설계하면 병렬 안전이 공짜로 따라온다.

## D. worktree-per-agent + 에이전트스코프 브랜치
- 병렬 에이전트는 각자 `git worktree` + `agent/<name>` 브랜치 → 작업공간 물리 격리.
- 동시성 N 상한은 [[model-tiering]] 동시성 캡과 정합(무제한 worktree = 락 경합·비용폭주).

## E. git 작업 직렬화 (락 = 단일)
- `.git/index` 락은 하나뿐 → **동시 git 명령 금지**. git 작업은 직렬로.
- 정리(worktree 회수)는 **`kill -15`(graceful) + `git worktree remove`** 순서. **`kill -9` / `rm -rf` 금지** — 인덱스/락 부패로 DB가 깨진다.

## F. rebase-before-merge 순차머지
- 머지 전 최신 base로 `rebase` → fast-forward로 **순차** 머지. 동시 머지 금지(충돌·레이스).
- 한 브랜치 머지 완료 → 다음 브랜치 rebase → 머지. 한 줄로.

## 자동강제
- `.gitkeep` 금지(빈 폴더는 `INDEX.stub`로 → [[bootstrap]] husk 방지).
- pre-commit hook = `scripts/check-all.sh`(lint FAIL이면 커밋 차단 — doc-rot의 build-green 우회 방지).
- 커밋 메시지는 라운드/근거 1줄 + 공동저작 트레일러(저장소 컨벤션).

## 안티패턴
- `git add -A`/`git add .`(남의 변경 삼킴) · `kill -9` git(DB 부패) · 동시 머지(레이스) · 핫스팟 동시편집(충돌) · 락 무시한 병렬 git.
