---
name: data-schema
description: 프로덕션 DB 테이블 인벤토리 + drift-proof 재생성법 — DDL 복붙 금지, 라이브 DB가 SOT
type: reference
track: project
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: <프로젝트 코드 경로>/db-snapshots/example-prod-YYYY-MM-DD.sql
links: [[api-endpoints]], [[single-sot-chokepoint]]
---

# 프로덕션 DB 스키마 인벤토리 (제네릭 예시)

> ⚠️ **이 노트는 스키마가 아니다.** DDL을 wiki에 hand-copy하면 즉시 stale = dup-SOT 버그.
> 권위본 = **라이브 DB**. 아래 인벤토리는 항해용 힌트(스냅샷 시점)일 뿐, 이후 드리프트됨 → DRAFT.

DB=ground truth: 앱 통계가 의심스러우면 DB를 직접 쿼리해 진실을 확인한다(추정 금지). 엔드포인트는 [[api-endpoints]], 통계 정합의 단일근본은 [[single-sot-chokepoint]].

## 권위본 재생성 (hand-copy 대신 항상 이것)
```bash
# 라이브 DDL 전체 덤프 (SOT) — 예: edge DB CLI / psql / sqlite
<db-cli> execute example-prod --remote \
  --command "SELECT sql FROM sqlite_master WHERE type='table' ORDER BY name"
# 또는 새 스냅샷
<db-cli> export example-prod --remote --output \
  <프로젝트 코드 경로>/db-snapshots/example-prod-$(date +%Y-%m-%d).sql
```
prod 쓰기/마이그레이션은 비가역 → 명시인증(HITL) 후 실행([[deploy]]와 동일 게이트).

## 도메인 prefix 인벤토리 (스냅샷 시점 — 권위본 아님)
테이블은 `domain_*` prefix로 묶인다. 한 도메인 = 한 관심사.

| prefix | 테이블 | 역할 |
|---|---|---|
| `identity_` | users · auth_identities · refresh_tokens · email_otp | 신원·인증·토큰 |
| `profile_` | profiles · preferences | 유저 프로필·설정 |
| `record_` | **items** | 핵심 정본 레코드(주요 메트릭·created_at) |
| (외부소스) | **external_imports** | 외부 연동 임포트(스냅샷엔 미포함=드리프트 증거) |
| `content_` | collections · entries | 콘텐츠·항목 |
| `place_` | spots · comments · reviews · votes | 장소·리뀐·투표 |
| `social_` | groups · group_members · posts · comments | 그룹·피드·댓글 |
| `followers` `semantic_edges` | | 팔로우·소셜 그래프 |
| `moderation_flags` | | UGC 신고(컴플라이언스) |
| `ai_` | memory_semantic · prompt_runs · eval_results · sessions | 어시스턴트 RAG·평가·세션 |
| `knowledge_graph_` | nodes · edges | KG |
| `billing_` | subscriptions · iap_receipts · webhook_log · lifetime_quota · promo_offers · pricing_catalog | 구독·IAP·평생권·프로모 |
| `privacy_` | consents · audit_logs · deletion_jobs | 동의·감사·삭제잡 |
| `integrations` `external_data` | | 외부 서비스 연동 |
| `analytics_product_events` `audit_security_events` `outbox_events` | | 제품 분석·보안·아웃박스 |
| `user_lifecycle` `activity_log` `export_jobs` | | 라이프사이클·활동로그·export |
| `meta_schema_version` | | 마이그레이션 버전 핀 |

## 신원·소유 메쉬 규칙 (코드에 사는 진실)
- 레코드 소유는 **정본 user id**(canonical) 우선 — 토큰만료 anon 추락 시 고아화를 막는다.
- 서버 읽기(records/recovery/readiness)는 owner resolver로 `user_id IN (union)` 조회, 쓰기는 단일 owner(anon 격리).
- 타임스탬프(`created_at`)는 **UTC 절대순간으로 저장**(정당) — civil date는 edge에서 `.toLocal()`. 날짜 off-by-one 근본.

TODO: 신규 테이블(moderation_flags 등)은 라이브 덤프로 갱신 후 PROVEN 승격.
