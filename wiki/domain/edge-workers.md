---
name: edge-workers
description: 엣지/서버리스 재사용 패턴 — 배포 게이트·DB ground-truth 직접쿼리·대용량 멀티파트 업로드·prod 쓰기 HITL·단일 대형 파일 grep -a 함정
type: reference
track: dev
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[example-edge]], [[deploy]], [[data-schema]], [[api-endpoints]], [[example-app]], [[single-sot-chokepoint]]
---

# 엣지 / 서버리스 워커 — 크로스프로젝트 재사용 패턴

> 도메인 단일홈. 스택: **엣지/서버리스 런타임(예: Cloudflare Workers · Vercel Edge · Deno Deploy) + 서버리스 SQL DB + 오브젝트 스토리지**. 배포·진실확인·대용량업로드의 검증된 손맛만. 프로젝트별 엔드포인트/스키마는 [[api-endpoints]] [[data-schema]], 배포 절차는 [[deploy]].

## 이중트리 · git
- 워커 SOT = [[api-endpoints]] 정본 경로(단일 파일). 앱과 **단일 git DB 공유 → 경로한정 `git add`**(이중트리 충돌 회피).
- 라운드마다 워커 git 커밋 의무. 플랫폼 관리 API(DB 쿼리 / 오브젝트 스토리지 / 배포)와 배포 CLI를 병행.

## 🔑 DB = ground truth (앱 통계 의심의 최종심)
- 앱/캐시/프로바이더가 다투면 **프로덕션 DB를 직접 쿼리**해 진실을 본다. 표면 추측 금지 — 단일소스가 근본([[single-sot-chokepoint]]).
- 검증된 적발 예: `started_at`이 UTC 절대순간으로 저장됨 → civil date 비교를 `.toUtc()`로 하면 **off-by-one**(자정 직전 레코드가 전날로). 저장은 UTC가 정당, civil date는 edge에서 `.toLocal()`.
- husk/부패행: `duration`이 garbage(거리 아님)인 복구파편 → 통계에서 제외하되 카운트 정합 유지.
- 물리병합 가능: provider-split 파편(`user_X` / `user_email_X`)을 정본 user id로 migrate. 머지는 **이동→삭제→rekey 순서**(UNIQUE 롤백 회피).

## 🔑 prod 쓰기 = HITL 게이트
- 분류기가 prod DB/스토리지/배포 쓰기를 **차단**한다(설계대로). → **AskUserQuestion 명시인증 먼저**, 인증 후 Bash CLI 직접 실행 또는 관리 API.
- 비가역·prod = 어느 루프든 HITL. confidence<80~90%도 동일.
- 캡처용 임시행을 prod에 넣었으면 **정확히 롤백**(삽입 PK 기억 → 캡처 → 삭제).

## 🔑 대용량 업로드 = multipart-via-Worker
- CLI 단발 업로드(예: `wrangler put`류)는 흔히 **크기 한계**(예: 100MB). 그 이상(예: 100MB+ 앱 번들/산출물)은 **워커 경유 멀티파트 업로드**.
- 업로드 토큰 secret + **custom domain**. per-part **재시도** 필수.
- 함정: `urllib` 기본 요청은 **403** → `User-Agent` 헤더 필수.

## 🔑 단일 대형 워커 파일 검사 = grep -a
- 핸들러를 모은 **단일 대형 워커 파일**이 길면 도구가 **바이너리로 오인** → 일반 grep이 "엔드포인트 미구현" **거짓 P0**(반복된 함정). 반드시 `grep -a`(텍스트강제) + 라이브 호출로 실존 확인.
- 라이브 엔드포인트는 사전베이크 요약이 아니라 **실제 호출**로 검증(build-green ≠ live-works).

## 메쉬 소유권(다중기기/익명)
- 쓰기는 **단일 owner**, 읽기는 소유자 해석 함수로 **user_id IN union**(정본 user id + 파편 + anon 격리). 토큰만료 anon 추락 시 정본 user id 폴백.
- union 테이블 분리(두 소스 테이블)는 **union + 키 dedup**으로 봉합.

## 배포 후 관측
- 엣지 라벨/버전 **propagation 수초 지연** → 즉시 grep 0건이 곧 미배포 아님. 라이브0 = 시드 전 **edge 캐시**일 수 있음 → TTL 경과 후 재확인.
- 배포 검증은 [[verify]] 두눈(라이브 응답) + 결정론. 절차 상세 [[deploy]].

## 안티패턴(하지 말 것)
- 앱 캐시값을 진실로 단정(→ DB 미확인). · prod 쓰기 무인증. · 단발 업로드로 100MB+ 강행. · 일반 grep 결과만으로 워커 결함 단정.
