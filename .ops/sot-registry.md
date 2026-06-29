---
name: sot-registry
description: 단일 SOT 레지스트리 — 한 사실=한 정본노트 1:1 등록표 + 외부 소유경계(자격/페이아웃=외부 SOT owns·wiki는 point만). dup-SOT 방지의 마스터 인덱스
type: reference
track: ops
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[memory-bridge]], [[provenance-model]]
---

# sot-registry — 어느 사실이 어느 노트에 사는가 (1:1)

L1(단일 SOT): **한 사실 = 한 노트.** 같은 값이 두 곳에 있으면 그게 버그(`wiki-lint`의 dup-description WARN이 잡는다). 이 레지스트리는 그 매핑의 마스터 인덱스 — 새 사실을 적기 전에 **여기서 정본이 있는지 먼저 본다.** 있으면 `[[link]]`, 없으면 정본 1곳을 정해 여기 등록한다.

## A. 내부 정본 등록표 (agent-wiki owns)
| 사실 영역 | 정본 노트 | 비고 |
|---|---|---|
| frontmatter 계약 | [[note]] | 전 노트 부모 템플릿 |
| 토큰/절단 한도·JIT | [[token-budget]] | 200줄/25KB·바이트 기준 |
| 라이브메모리 3중 경계 | [[memory-bridge]] | 어느 store가 무엇을 owns |
| 90점 루브릭(7축·종료조건) | [[rubric]] | 평균≥90 ∧ P0/P1=0 ∧ cap6 |
| 평가-최적화 루프 메커닉 | [[evaluator-optimizer]] | judge≠generation |
| 무한피드백 loop-until-dry | [[feedback-loop]] | 문제 사라질 때까지 반복 |
| PDCA 실행 단계 | [[pdca]] | 빌드/기능 개선 루프 |
| 제조↔에이전트 동형매핑 | [[manufacturing-bridge]] | QC/공정 ↔ 하네스 정본 |
| OODA 런타임 수복 | [[ooda-runtime]] · [[self-healing]] | 시간민감 이상수복 |
| 가드레일 수치 | [[guardrails]] | max-step·cost-cap·time-bound |
| git 충돌방지 | [[git-conventions]] | 경로한정 add·worktree |
| 모델 티어/비용 | [[model-tiering]] | Opus/Haiku/judge·$ 킬스위치 |
| 단일 chokepoint 패턴 | [[single-sot-chokepoint]] | poka-yoke 근본 |
| 패턴 선택 라우팅 | [[pattern-select]] | 어느 패턴/티어를 언제 |
| 안티패턴·judge 편향 | [[anti-patterns]] | 알려진 실패모드·self-preference |
| 결함 분류 | [[defect-taxonomy]] | P0/P1/P2 |
| 출처·증거 모델 | [[provenance-model]] | source·실증·freshness |
| 모바일 함정 | [[mobile-app]] | 라우터 redirect·precache·단일 provider |
| 제조 QC 게이트 | [[qc-gate]] | 합격기준+실증 둘 다(현장검증) |
| 부트스트랩/마이그레이션 | [[bootstrap]] · [[new-project-bootstrap]] | Day-1 플로어·stamp |
| pruning 수명주기 | [[pruning]] | tombstone·archive |
| 마일스톤 알림 | [[notify]] | telegram 트리거점 |
| 예시앱 프로젝트 사실 | [[example-app]] | projects 서브트리(자기완결) |
| 예시앱 DB 스키마 | [[data-schema]] | 테이블·컴럼 |
| 예시앱 워커 엔드포인트 | [[api-endpoints]] | 단일 대형 워커 파일 계약 |
| 자동매매/봇 도메인 | [[example-bot]] · [[automation-bots]] | 음의엣지·서킷브레이커 |
| 엣지/서버리스 도메인 | [[example-edge]] · [[edge-workers]] | 배포게이트·DB·오브젝트스토리지 |
| 데이터 파이프라인 방법론 | [[example-pipeline]] | 인벤토리 본체는 외부(B) |
| 제조 라인 코어 | [[example-line]] | 라인/공정 비즈로직·OPL 발행·QC 에스컬레이션 |

> 표가 곳 dedup 도구다: 새 노트의 description이 기존 행과 겹치면 dup-SOT — 둘 중 하나는 `[[link]]`로 접어야 한다.

## B. 외부 소유경계 (wiki는 point만 — 복붙·재기재 금지)
민감정보/휘발성 사실은 agent-wiki가 **소유하지 않는다.** 경로만 가리키고, 값은 절대 복제하지 않는다(복제하는 순간 두 곳이 drift). 상세 화해 = [[memory-bridge]].

| 사실 영역 | 진짜 owner(외부) | wiki의 역할 |
|---|---|---|
| 자격증명·계정ID·페이아웃·현재수익·자율결정 경계 | `<외부 자격/수익 SOT>` | 경로 point만 |
| 통합 응답룰 | `<외부 응답룰 SOT>` | point만 |
| 결제 채널 매트릭스 | `<외부 결제채널 SOT>` | point만 |
| 데이터 파이프라인 인벤토리·SLA·incident | `<외부 파이프라인 인벤토리 SOT>` | [[example-pipeline]]는 방법론 포인터만 |
| 에이전트 학습(휘발성·라운드 헤드라인) | `<에이전트 auto-memory>` | 복제 안 함 |

## 규칙
- 새 사실 → **A에 정본 있나 확인** → 있으면 `[[link]]`, 없으면 정본 1개 정해 등록.
- 민감/휘발 사실은 절대 wiki 본문에 값으로 박지 말 것 — B의 경로만 가리킨다.
- dup-description WARN = "레지스트리 등록 누락" 신호. 무시하지 말고 정본 1곳으로 병합.
- 증거/출처 메타(이 사실이 진짜인지)는 [[provenance-model]]이 정의한다.
