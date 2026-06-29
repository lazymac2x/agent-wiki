---
name: 05-knowledge-library
description: 개인 레퍼런스 라이브러리(템플릿) — 자주 쓰는 명령·계정ID 포인터·외부 SOT 링크. 값은 외부가 owns, 여기엔 구문·포인터만
type: reference
track: personal
status: DRAFT
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[sot-registry]], [[00-home]]
---

# 05 · 개인 레퍼런스 라이브러리

> **템플릿**: 외부 SOT 경로·계정ID·DB명은 `<당신의 ...>` placeholder — 자신의 실제 값으로 채워라.

자주 다시 찾는 **명령 구문 · 외부 SOT 위치 · 계정ID 포인터**의 단일 색인. 값(키·잔액·ID)은 여기 살지 않는다 — 외부 SOT가 owns(어디에 무엇이 사는지는 [[sot-registry]]). 여기엔 **꿼내 쓰는 법(명령)과 포인터**만.

## 외부 SOT 위치 (값의 owner — 복붙 금지)
| SOT 파일 | 무엇을 owns |
|---|---|
| `<당신의 자격/수익 SOT 파일>` | 자격증명·계정ID·페이아웃·현재수익·자율결정 경계 |
| `<당신의 결제채널 매트릭스 파일>` | 결제 채널 매트릭스 |
| `<당신의 파이프라인 인벤토리 파일>` | 데이터 파이프라인 인벤토리·SLA·incident 백로그 |
| `<당신의 통합 응답룰 파일>` | 통합 응답룰(에이전트 영구룰) |
| `<에이전트 메모리 경로>` | auto-memory(에이전트 학습·휘발성) |
| `<당신의 프로젝트 RESUME 노트>` | 프로젝트 라운드 RESUME |

> 등록 규칙(어느 사실이 어느 SOT에 1:1로 사는가)은 [[sot-registry]]가 owns. 충돌·중복이면 거기서 해소.

## 계정ID 포인터 (값 X — 위치만)
- 콘솔/계정/플랫폼 ID = `<당신의 자격/수익 SOT 파일>`의 계정ID 섹션. **여기 숫자를 적지 않는다**(이중기록=stale).
- 예시 프로젝트: 엣지 DB=`<프로덕션-DB>`, 워커 라우트/앱 버전코드 등 운영ID는 `<당신의 프로젝트 RESUME 노트>` 헤더 + 자격 SOT.
- TODO(you): 자주 참조하는 ID는 **라벨만**(예: "개발자 콘솔 ID → 자격 SOT §계정") 한 줄 포인터로 둘지 결정.

## 자주 쓰는 명령 (구문 — 토큰 절약용 박제)
**엣지 / 서버리스 (예: Cloudflare Workers)**
```bash
# 배포(HITL 인증 후에만 — 03-dev-operating 게이트)
wrangler deploy
# DB ground-truth 직접 쿼리(앱 통계 의심 시 진실 확인)
wrangler d1 execute <프로덕션-DB> --remote --command "SELECT ..."
# 워커 소스 grep(바이너리 오인 방지 — -a 필수)
grep -a "endpoint" <단일 대형 워커 파일 경로>   # 정본 경로 = [[api-endpoints]]
```

**모바일 / 빌드 (예: Flutter)**
```bash
flutter analyze            # lib clean 확인(빌드 전 게이트)
# 빌드 = GUI 빌드큐 워처. 데몬 stall 회피:
nohup <build-cmd> &        # 데몬 타임아웃 디태치
```

**git (단일 DB · 경로한정 add)**
```bash
git add <경로>             # 핫스팟 single-writer, 나머지 additive-only
# 이중트리: 앱(<앱 소스 경로>) + 워커(<워커 소스 경로>) 각 커밋
```

**에뮬 두눈 검증**
```bash
adb shell dumpsys ... | grep -i foreground   # 포그라운드 서비스 실증
adb exec-out screencap -p > shot.png         # 1080×1920 캡처 pull
```

**zsh 함정**
- `!`(history expansion) → 큰/작은따옴표 모두 escape 필요. 회피책: 해당 라인은 `Write` 도구로 파일 생성.

## 검증/채점 정전 (canonical — 한 곳에만)
- 7축: 정보위계·3초이해·CTA·가독성·일관성·정직성·예외처리. **평균≥90 ∧ P0/P1=0**.
- 두눈 실증 / 결정론 테스트(TZ-불변·무음스킵=vacuous green 금지) / DB ground-truth / 가짜0 금지 / build-green≠live-works.
- 상세 루브릭은 method 트랙 노트가 owns(여기선 포인터로 충분).

## 항해
- 개인 홈/우선순위 → [[00-home]].
- 어느 사실이 어느 SOT에 사는지 → [[sot-registry]].
