---
name: deploy
description: Example App 배포 runbook — 빌드큐 워처(앱) + 엣지 워커 prod 배포, 명시인증(HITL) 게이트
type: howto
track: project
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[edge-workers]], [[api-endpoints]]
---

# Example App 배포 runbook (TWI 3열)

> 이중트리: 앱 SOT=`<앱 코드 경로>`, 워커 SOT=`<프로젝트 코드 경로>/workers/api.ts`. **단일 git DB 공유** → 경로한정 `git add <경로>`로 각 트리 커밋.
> 핵심 손맛: 빌드는 데몬이 짧은 타임아웃에 끊기므로 **빌드큐 워처 또는 `nohup &` 디태치**. prod 쓰기는 **비가역 → 명시인증(HITL) 먼저**. 런타임 인프라 일반은 [[edge-workers]], 라우트 인벤토리는 [[api-endpoints]].

| 항목 | 내용 |
|---|---|
| 대상 시스템 | 모바일 앱(빌드 산출물) · 엣지 워커(api.ts) · 프로덕션 DB · 오브젝트 스토리지 |
| 소요시간 | 워커 배포 수초(라벨 propagation 수초 지연) · 앱 빌드 ~수분(빌드큐 워처) |
| 안전 주의 | ⚠️ prod DB/Worker 쓰기 = 비가역. 명시인증(HITL) 없이는 금지 |
| 필요 권한 | 엣지 플랫폼 로그인 · prod 쓰기 분류기 통과(운영자 위임 시 Bash 직접) |
| 선행조건 | 정적분석 clean · 변경파일 결정론 테스트 PASS · 에뮬 두눈(해당 시) |

## 절차 (TWI Job Breakdown)
| # | 중요단계 (What) | 핵심포인트 (How — 손맛·수치·안전) | 이유 (Why) |
|---|---|---|---|
| 1 | 변경 검증 | 🔑 정적분석 clean + 변경 파일만 테스트(단위 위젯 4/4류) | build-green ≠ live-works. 가짜0·무음스킵 금지 |
| 2 | 워커 배포 | 🔑 `<워커 경로>`에서 `<edge-cli> deploy` · 배포 후 `/v1/health` 200 확인 | api.ts는 SOT. 라벨 propagation 수초 지연은 정상 |
| 3 | prod DB 마이그레이션 | ⚠️ 명시인증(HITL) → `<db-cli> execute example-prod --remote` · 순서=이동→삭제→rekey(UNIQUE 롤백 주의) | 비가역 prod 쓰기. HITL 게이트 우회 금지 |
| 4 | 앱 빌드 | 🔑 빌드큐 워처에 큐잉(즉시발화 트리거) 또는 `nohup <build> &` | 데몬 타임아웃 → manifest stall. 디태치로 완주 |
| 5 | 대용량 산출물(스토리지) | 🔑 단일 PUT 한계 초과 산출물 = multipart-via-Worker(`/v1/admin/object-multipart/*`) · `User-Agent` 헤더 필수(403 회피) | 단일 PUT은 크기 한계가 있다 |
| 6 | 커밋 + 보고 | 🔑 트리별 경로한정 `git add` 각 커밋 · 마일스톤 1줄 보고 | 단일 git DB 충돌 방지 · PDCA Act 가시화 |

## 합격기준 (QC 게이트 — [[qc-gate]])
- [ ] `/v1/health` 200 · 변경 엔드포인트 라이브 스모크 PASS
- [ ] 앱: 에뮬 두눈(포그라운드 dumpsys / 스크린샷 pull) 또는 결정론 위젯테스트 PASS
- [ ] prod 쓰기는 명시인증(HITL) 로그 존재

## 실행증거 (예시 — 실 검증 시 채움)
- 검증일: (예시) · 방법: 워커 deploy + `/v1/health` 200 + 에뮬 두눈 · 결과: PASS
