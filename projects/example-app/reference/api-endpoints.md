---
name: api-endpoints
description: 엣지 워커(단일 대형 파일)의 `/v1/*` 엔드포인트 인벤토리 — pathname 스위치 라우팅 미러 예시
type: reference
track: project
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: <프로젝트 코드 경로>/workers/api.ts
links: [[data-schema]], [[deploy]]
---

# 엣지 워커 엔드포인트 인벤토리 (제네릭 예시)

단일 워커(단일 대형 워커 파일). 프레임워크 라우터가 아니라 `const p = url.pathname` **switch 라우팅**. `requireUser`는 외부 인증 제공자(OIDC/JWKS) 검증을 **시도**하되 미설정/미배포 시 `anon_`/`usub_` 신원으로 자동 폴백한다 — 즉 **현재 서버측 소셜 인증은 미동작(알려진 론칭 보안갑, ⚠️ Auth 섹션 참조)**. `/v1/me/*`는 폴백 신원이라도 owner mesh로 resolve. 권위본은 `source:` 코드 — 이 표는 그 미러(드리프트 시 freshness-lint fail). 스키마는 [[data-schema]], 배포는 [[deploy]].

> ⚠️ 미러 규율: 새 라우트 추가/변경 시 코드가 SOT다. 재추출:
> `grep -aoE "['\"\`]/v[0-9][a-zA-Z0-9_/:-]*" <프로젝트 코드 경로>/workers/api.ts | tr -d "'\"\`" | sort -u`

## Auth · 신원
> ⚠️ **실 상태**: 아래 소셜/이메일/refresh 라우트는 코드엔 실재하나 **기능은 503 stub**(OAuth secret 미설정 · auth-broker 미배포) — 호출 시 `anon_`/`usub_` 자동 폴백. 라우트 인벤토리는 코드 실재이되 인증 동작은 미동작(알려진 론칭 보안갑).
- `POST /v1/auth/{provider...}` ⚠️503 stub · `POST /v1/auth/email/start|verify` ⚠️503 stub · `POST /v1/auth/refresh` ⚠️503 stub · `POST /v1/auth/logout` ✅200(stateless 실동작)
- `GET /v1/me` · `GET|PUT /v1/me/profile` · `POST /v1/me/avatar` · `POST /v1/me/migrate`(anon→canonical 통합)
- `POST /v1/me/phone` · `POST /v1/me/contacts/match` · `GET /v1/me/consents` · `POST /v1/me/pause|resume|delete|delete/cancel`
- `GET /v1/me/data-snapshot` · `GET /v1/me/export` · `GET /v1/me/export/anon` (개인정보 export/삭제)

## 레코드 · 외부연동
- `GET|POST /v1/me/records` · `GET /v1/me/records/:id` · `GET /v1/me/records/anon`
- `POST /v1/me/records/title` · `POST /v1/me/records/type`(사후 종류편집)
- `GET|POST /v1/me/external/imports`(외부 임포트 — union 한 축, [[single-sot-chokepoint]])
- 외부 OAuth 연동: `/v1/me/integrations/connections` · `/v1/me/integrations/{provider}/oauth/start` · `/v1/integrations/{provider}/oauth/callback` · `POST /v1/integrations/{provider}/push`

## 어시스턴트 · 통계 · 회복
- `POST /v1/me/assistant`(툴콜링 RAG·SSE 진행칩·depth≤3) · `GET /v1/me/stats`
- `GET /v1/me/recovery` · `GET /v1/me/readiness` · `GET /v1/me/kg`(knowledge graph)
- 버디: `POST /v1/me/buddy/ask` · `GET /v1/me/buddy/context|providers|threads`
- `POST /v1/me/ai-decisions/opt-out`

## 소셜 · 그룹 · DM
- `GET|POST /v1/posts` · `GET /v1/me/posts` · `POST /v1/social/friends` · `GET /v1/social/contacts/match`
- 그룹: `GET /v1/groups` · `POST /v1/groups/create` · `/v1/groups/nearby|recommend` · `/v1/groups/:id/leave|transfer-owner`
- DM: `GET /v1/me/dm/threads` · `/v1/me/dm/threads/:id/messages|read`
- `GET|POST /v1/me/follow` · `/v1/users/:id/follow|stats` · `/v1/users/batch-recent|recommend|rising|search`
- `GET /v1/me/notifications` · `POST /v1/me/push-token`

## 장소 · 콘텐츠 · 편의시설
- `GET /v1/spots` · `/v1/spots/browse|nearby` · `/v1/spots/:id/comments|vote` · `POST /v1/comments/:id/vote`
- `GET /v1/collections` · `/v1/collections/feed|list|mine|recommend|weekly-rank`
- `GET /v1/amenities` · `/v1/amenities/nearby` · `GET /v1/events` · `/v1/me/events`
- `POST /v1/uploads/photo` · `GET /v1/photos/...`

## 결제 · 빌링
- `GET /v1/billing/catalog|entitled` · `POST /v1/billing/subscribe|restore` · `/v1/billing/lifetime|lifetimeStatus`
- `GET /v1/me/credits` · `POST /v1/me/credits/purchase`

## 자산 · 챌린지 · 관리/인프라
- `GET /v1/assets/static`(정적 자산 프록시 예시; 토큰 미설정 시 502) · `GET /v1/challenges` · `/v1/challenges/active`
- `GET /v1/health`
- 관리(토큰 게이트): `/v1/admin/observability|promote-verified|object-put` · 멀티파트 `/v1/admin/object-multipart/create|part|complete`

## 비고
- 통계 정합의 단일근본은 **클라이언트** chokepoint(단일 정본 레코드 provider)다 — 서버는 union 소스를 제공할 뿐. → [[single-sot-chokepoint]]
- AI 게이트웨이 호출(`/v1/messages`, `/v1/chat/completions` 등)은 외부 LLM 프록시 경로이며 공개 API 아님.
