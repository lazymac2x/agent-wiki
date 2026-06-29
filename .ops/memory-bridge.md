---
name: memory-bridge
description: 라이브 메모리 3중 화해 — auto-memory(에이전트학습) · 외부 자격/수익SOT · agent-wiki(방법론+지식). 로드순서·쓰기권한·drift 방지
type: reference
track: ops
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[sot-registry]], [[token-budget]]
---

# memory-bridge — 세 메모리 store를 충돌 없이 화해

에이전트는 **세 곳**에 기억을 둔다. 어느 사실이 어디 사는지 명확하지 않으면 같은 값이 셋 다에 복제돼 **drift**(서로 어긋남)가 난다. 이 노트가 그 경계를 못박는다. 사실↔정본 1:1 매핑은 [[sot-registry]].

## 세 store와 소유권 (한 사실 = 한 owner)
| store | owns(무엇) | 휘발성 | 로드 시점 | 쓰기 주체 |
|---|---|---|---|---|
| `<에이전트 auto-memory>` | **에이전트 학습** — 휘발성 노하우, 라운드별 헤드라인+토픽파일 포인터 | 높음 | 매 세션 자동 | 하네스 자동 append |
| `<외부 자격/수익 SOT>` (자격·응답룰·결제채널·파이프라인 인벤토리) | **자격증명·계정·페이아웃·수익·응답룰** | 낮음(민감) | 세션 시작 SOT 로드 | 사람 / main-session |
| `agent-wiki/` | **방법론(harness) + 프로젝트/도메인 지식 + 운영 SOT** | 낮음(검증됨) | JIT(frontmatter→Read) | main-session / worktree PR |

## 로드 순서 (세션 시작)
1. **SOT 먼저** — `<외부 자격/수익 SOT>`(자격·경계). 이게 없으면 prod 작업 권한/계정을 모른다.
2. **auto-memory** — 최근 학습/라운드 컨텍스트(자동 로드).
3. **agent-wiki** — 루트 `llms.txt`(기계지도) → 필요 폴더 INDEX → frontmatter JIT. 통째로 읽지 않는다([[token-budget]]).

## 쓰기 라우팅 결정표 (새 노하우가 생기면 — 한 곳만)
- **재사용·범용 방법론/지식** → agent-wiki (check-all.sh + 90점 게이트 거쳐 PROVEN).
- **휘발성·이번 라운드 학습 헤드라인** → auto-memory(≤150자 + 토픽파일 포인터).
- **자격증명·수익·계정·결제** → `<외부 자격/수익 SOT>` (민감 — wiki에 절대 값 복제 금지).
- **★ 세 곳 동시기록 금지.** 그게 3중 SOT drift의 근본이다. 헷갈리면: "이게 6개월 뒤에도 유효한 *규칙*인가(→wiki) 아니면 이번 라운드 *기록*인가(→auto-memory) 아니면 *비밀*인가(→외부 SOT)?"

## drift 방지 (셋이 겹칠 때)
- 같은 사실이 두 store에 = dup-SOT. **agent-wiki는 auto-memory/외부 SOT의 사실을 복제하지 않고 point만** 한다([[sot-registry]] B).
- auto-memory 엔트리는 **헤드라인 + 파일포인터**가 정상형태(본문은 토픽파일). 그 토픽이 담은 *재사용 방법론*은 agent-wiki가 owns — auto-memory엔 "토픽 파일 참조" 포인터만 남긴다.
- 예: 라운드별 학습 원문(`feedback_*.md` 류)은 auto-memory 쪽에 그대로 두고, 거기서 추출한 **범용 패턴**(단일 chokepoint·husk 판별 등)만 wiki 노트로([[single-sot-chokepoint]] 등). 원문 복붙 금지.

## 압력 흡수 — auto-memory를 슬림하게
auto-memory 파일은 디테일을 쌓다 보면 **임계(200줄/25KB)를 넘겨 절단된다**([[token-budget]] 실패 사례). agent-wiki의 존재 이유 하나가 이 압력 흡수다: **영속 방법론을 wiki로 이관**하면 auto-memory는 휘발성+포인터만 남아 슬림해진다. 방법론을 auto-memory에 쌓을수록 절단으로 더 빨리 소실된다.

## 쓰기 권한
- agent-wiki 노트 쓰기 = **main-session** 또는 worktree 에이전트의 PR만. 반드시 `scripts/check-all.sh` 게이트 통과([[sot-registry]] 무결성).
- auto-memory = 하네스가 자동 관리(직접 손대지 않음).
- `<외부 자격/수익 SOT>` = 사람 소유, 에이전트는 읽기 + 명시인증 후에만 갱신.

## 규칙
- 한 사실 = 한 owner = 한 store. 동시기록은 버그.
- 민감정보는 wiki 본문에 값으로 박지 않는다(경로 point만).
- "어디에 적지?" → 재사용규칙=wiki · 휘발학습=auto-memory · 비밀=외부 SOT.
