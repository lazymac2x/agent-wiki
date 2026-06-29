# INDEX — agents/_panel

<!-- [GENERATED] scripts/gen-index.sh — 이 라인 아래 수기편집 금지. 사람용 글은 PROSE 블록에. -->
<!-- PROSE:START -->
_이 폴더의 지도. 항목은 frontmatter에서 자동 등재된다._
<!-- PROSE:END -->

## Notes
- [[design]] — 디자인 패널 — UI/로고/색/아이콘/폴리싱은 전용 디자인 에이전트 위임이 디폴트. 벡터(SVG) 우선·브랜드SOT ground·crude 자가처리(PIL 등) 금지
- [[judge]] — 90점 7축 judge 패널 — CoT 먼저→[[rubric]] JSON 계약 1회. 결정론 유닛테스트를 비결정 judge의 신뢰 oracle(2nd rater)로 병행
- [[verify]] — 적대 verify 패널 — 실행증거(테스트/로그/스크린샷/DB)를 요구하는 검증자. 정적분석만으론 PASS 불가, 생성과 다른 모델패밀리
