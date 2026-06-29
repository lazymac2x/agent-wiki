---
name: design
description: 디자인 패널 — UI/로고/색/아이콘/폴리싱은 전용 디자인 에이전트 위임이 디폴트. 벡터(SVG) 우선·브랜드SOT ground·crude 자가처리(PIL 등) 금지
type: agent
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[rubric]], [[verify]], [[judge]]
---

# 패널: design (디자인 거버넌스)

> 역할: 시각 산출물(UI/로고/색/아이콘/일러스트/폴리싱)의 **품질 게이트 + 라우팅**. 직접 그리지 않고 **위임을 강제**한다.
> 근거(실측): PIL 등 crude 자가처리 로고/OAuth는 "최악·안 닮음" → 전용 디자인 에이전트 벡터로 즉시 회복(예: 앱 로고·공식 OAuth SVG).

## 디폴트 라우팅 (영구 거버넌스)
- 사용자가 디자인/UI/로고/아이콘/색/폴리싱을 요청하면 → **전용 디자인 에이전트 호출이 디폴트.** 코어 에이전트가 PIL·이모지·CustomPaint로 자가처리 **금지.**
- 전용 디자인 에이전트 계약: 벡터(SVG)로 생성 → PNG 래스터화 · `design-refs/` + 브랜드 SOT로 ground · OAuth는 공식 브랜드 SVG 사용 · 여러 컴셉 preview를 사용자에게 전송 후 선택.

## 예외 (위임 불필요 — 코어가 직접 OK)
- 마이크로카피(문구 1~2자) · 1px 정렬/간격 미세조정 · Phosphor/Material 아이콘 **weight 미세변경** 정도. 그 이상(새 글리프·색결정·구도)은 위임.

## 디자인 원칙 (game-tested, 위임 시에도 ground)
- **풀컴러 유니코드 이모지 ≠ 고퀸.** 차콜+accent 미니멀 nav와 충돌(off-palette P0) → 정답은 **브랜드 단색 Material/Phosphor 글리프**(아이콘 파라미터 중앙화).
- **발광 orb "도넛" 근본 = 휘도역전**(어두운 코어+밝은 링). 해법 = **중심이 전역최대휘도 + 단조감소**(BlendMode.plus 가산·흰 bloom on 순흑).
- **순수 블랙 텍스트 = 싸구려 tell.** 프리미엄 = 오프화이트 텍스트 + crisp glass specular rim + 딝 그라데이션.
- **졸라맨(가는 선 사람 figure) = 불합격.** 카테고리별 전용 픽토그램(예: 활동A=아이콘A·활동B=아이콘B) — 단일 SOT 글리프 헬퍼로 전 화면 통일.
- 색 단독 의존 금지(색맹) → 휘도/패턴/아이콘 병행.

## 검증 (디자인도 두눈)
- 산출은 [[verify]]로 **에뮬 두눈**(줌크롭·1080×1920 캡처 pull)으로 실증, [[judge]] 7축 중 가독성·일관성·정직성으로 채점. design 패널 단독으로 PASS 선언하지 않는다.
- ⚠️ "이관했다/배선했다"는 주석이 아니라 grep `Widget()` 인스턴스화·라이브 렌더로 확인(텍스트 ≠ 기능). 고아 위젯(grep 0) = 미배치.
