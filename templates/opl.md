---
name: opl
description: One-Point-Lesson 템플릿 — 원자적 1주제 5~10분 단위, 위키링크로 SOP 조립(fractal)
type: reference
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[sop]], [[manufacturing-bridge]]
---

# OPL 템플릿 — 핵심포인트 1개를 원자단위로

> OPL = 한 주제 · 5~10분 · 비주얼. 여러 OPL을 `[[link]]`로 엮어 SOP를 조립한다(노트가 곧 레고블록).
> 4종 태깅: **Basic**(기본지식) · **Know-Why**(원리) · **Know-How**(개선/노하우) · **Trouble**(불량/사고 사례).

```markdown
---
name: <slug>
description: <≤150자 — 이 한 포인트가 무엇인가>
type: opl
track: factory       # 개발 팁이면 dev
status: DRAFT
owner: you
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
source: <설비/문서/코드 | none>
links: [[조립되는 SOP]], [[관련 OPL]]
---

# OPL: <제목>   `[Basic|Know-Why|Know-How|Trouble]`

**WHY** (왜 이게 중요한가 — 한 줄)
> 

**STEPS / 그림** (비주얼 우선 — 사진/도식 경로 또는 ASCII)
1. 
2. 

**KEY POINTS** (파라미터·임계·안전 — 수치로)
- 🔑 <핵심 수치/손맛>
- ⚠️ <안전·금지사항>
- 임계: <정상범위 vs 이탈>

작성: <이름> · 승인: <이름> · 현장검증: <YYYY-MM-DD>
```
