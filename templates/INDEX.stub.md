---
name: INDEX.stub
description: 새 폴더용 프랙탈 INDEX 스텁 — 1줄 포인터(≤150자) 수기 폴백. gen-index.sh 없는 환경용(정상 환경은 자동생성이 정본)
type: reference
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: scripts/gen-index.sh
links: [[note]]
---

# INDEX.stub — 프랙탈 INDEX 폴백 스텁

> ⚠️ **정상 환경에서 `INDEX.md`는 수기편집 금지** — `scripts/gen-index.sh`가 자식 노트의 frontmatter에서 자동생성한다(상단 `[GENERATED]` 배너).
> 이 스텁은 **gen-index 없는 환경**(다른 하네스·CI 부재)에서만 새 폴더에 떨궈 수기 유지하는 폴백이다. 항목 1줄 = 자식 노트의 `description`을 그대로(≤150자).
> 모든 폴더가 **같은 모양** INDEX를 갖는 게 프랙탈 항해의 핵심. 항목 형식은 [[note]]의 description 계약을 따른다.

```markdown
[GENERATED-FALLBACK] gen-index.sh 가 있으면 이 파일을 지우고 자동생성에 맡길 것.
규칙: 항목 = `- [[자식-slug]] — <자식 description 그대로, ≤150자>` 1줄. 본문 prose 0(서문만 허용).

# <폴더명> INDEX

> <이 폴더가 무엇을 모으는가 — 사람용 1줄 서문. 롤업 표 위에만 수기 유지>

- [[child-a]] — <child-a 의 description ≤150자 그대로>
- [[child-b]] — <child-b 의 description ≤150자 그대로>
- [[child-c]] — <child-c 의 description ≤150자 그대로>
```

## 규율
- **≤150자**: 헤드라인이 길면 INDEX 절단(한글 UTF-8 = 3B/자)에서 잘린다. description을 다듬어 짧게.
- **고아 0**: 폴더의 모든 노트가 여기 1줄로 등재돼야 한다(어디서도 안 링크되면 금지).
- **단일 SOT**: 헤드라인은 자식 노트 `description`의 **거울**이지 새 사실이 아니다 — 본문을 복붙하지 말 것.
- 루트 `INDEX.md`는 '인덱스의 인덱스'(본문 0, 자식 INDEX만 링크).
