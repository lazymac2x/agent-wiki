---
name: mobile-app
description: 모바일 공통 함정 — 라우터 redirect ancestor 발화·off-screen 캡처 precache·단일 provider chokepoint(watch)·이미지 캐시 비율왜곡
type: reference
track: dev
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[example-app]], [[single-sot-chokepoint]], [[verify]], [[anti-patterns]]
---

# 모바일 앱 — 크로스프로젝트 공통 함정

> 도메인 단일홈. 모바일 앱(예: Flutter · React Native)에서 실증된 재발성 버그 패턴만. 프로젝트별 화면/구현은 [[example-app]], 일반 안티패턴은 [[anti-patterns]].

## 🔑 선언적 라우터: route-level redirect = ancestor 발화
- 모바일 선언적 라우터(예: Flutter go_router)에서 route에 단 `redirect`는 **자식 경로 매칭 때도 ancestor로 발화**한다. 예: `/feed`에 redirect → 자식 `/feed/graph` 진입 시 `matchedLocation`이 부모 `/feed`로 잡혀 **자식이 엉뚱하게 오리다이렉트**(그래프 탭이 `/home`으로 튐).
- **수정 = top-level `redirect`에서 전체경로(`matchedLocation` 전체) 비교**. route-level이 아니라 전역 라우터 콜백에서 분기.
- 대형 IA 변경(탭 병합/제거)은 서브라우트까지 에뮬 육안 검증.

## 🔑 off-screen 캡처: captureFromWidget → precache 필수
- off-screen 위젯 캡처(예: `captureFromWidget`)는 네트워크 이미지를 **비신뢰**(아직 로드 안 됨)로 캡처 → 배경 누락.
- **캡처 직전 동일 URL로 `precacheImage` 필수**. 미리보기 화면은 정상 로드라 캡처 경로만 위험(함정).
- 정합(예: 정적지도 타일 + 오버레이 폴리라인): 타일과 **동일 center/zoom/투영 파라미터**, 프록시의 `zoom.toFixed(1)` 반올림까지 일치시켜야 안 어긋남.

## 🔑 단일 provider chokepoint (stale/husk 근본해결)
- 같은 데이터를 로컬 union vs 서버 DB 등 **다중소스**가 각자 읽으면 stale/husk가 whack-a-mole. → **단일 chokepoint provider 하나로 봉합**(여러 통계 화면이 전부 한 소스 경유). 상세 패턴 [[single-sot-chokepoint]].
- provider는 `read` 1회가 아니라 **`watch`**(미동기 시 stale "며칠 전" 근본). 같은 화면군은 같은 소스를 watch해 즉시 정합.
- 리스트 표시 vs 통계 책임은 분리하되 **카운트 정합 의무**(husk를 통계서 숨겨도 카운트는 맞춰야).

## 🔑 이미지 비율: cacheWidth + cacheHeight 동시지정 = 왜곡
- 이미지 디코드 캐시 폭(`cacheWidth`)과 높이(`cacheHeight`)를 **둘 다** 주면 종횡비 무시 → 찌그러짐. **하나만** 지정(나머지는 비율 유지).

## 검증 · 빌드 손맛
- 검증 = 에뮬 **두눈**(dumpsys 포그라운드 / 1080×1920 캡처 pull / uiautomator 네비) + **결정론 위젯·유닛 테스트**. 깊게결합 콜백은 **순수함수로 추출**해 통째 mock 회피(경계값까지 테스트). 무음스킵=vacuous green=금지. 절차 [[verify]].
- 정적 분석(예: `dart analyze`) clean 의무. 빌드 워처가 manifest 단계에서 stall = 데몬 타임아웃 → 백그라운드 디태치(`nohup … &`)로 완주.
- 에뮬 한계: 연속 센서 스트림(예: GPS) 재생 불가(fix 1샷·OS throttle) → 매끄러운 연속 출력(예: 거리 마일스톤 음성)은 **결정론 replay(순수함수)**로 충족, 실연속은 실기기.
- i18n: 번역 키(`'키'.t`류)에 아이콘 인라인 금지(아이콘은 파라미터로). const 위젯은 const 생성자/const 리스트.

## 안티패턴(하지 말 것)
- route-level redirect로 탭 분기. · 캡처 전 precache 누락. · 화면마다 데이터 소스 제각각(read-once). · cacheW+cacheH 동시. · CI-green을 라이브로 단정.
