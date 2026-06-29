---
name: adr
description: ADR 템플릿 — 맥락·결정·대안·결과 4블록. PDCA Act 산출물을 불변 결정으로 영속. status Accepted=PROVEN 매핑. 복사용 코드펜스
type: reference
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[pdca]], [[ADR-0001-single-source-provider]]
---

# ADR 템플릿 — Architecture Decision Record

> ADR = **왜 이렇게 결정했나**를 코드가 못 담는 곳에 영속. [[pdca]] 라운드의 **Act**(개선을 표준화) 산출물이 ADR로 굳는다.
> 1 ADR = 1 결정. **불변(immutable)** — 결정이 바뀌면 새 ADR을 쓰고 옛것은 `DEPRECATED`로 supersede(덮어쓰기 금지).
> 실제 채워진 예시는 [[ADR-0001-single-source-provider]](단일 정본 레코드 provider chokepoint 채택) 참조.

```markdown
---
name: ADR-NNNN-<짧은-결정-슬러그>      # 순번 4자리. 파일 = decisions/ADR-NNNN-….md
description: <≤150자 — 무엇을 왜 결정했나>
type: adr
track: project                          # 또는 dev|method
status: DRAFT                           # 아래 ADR status ↔ frontmatter status 매핑 참조
owner: you
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>
source: <결정이 사는 코드/설정 경로 | none>
links: [[관련 노트]], [[supersede 대상 ADR | 없으면 생략]]
---

# ADR-NNNN: <결정 제목>

- **상태**: Proposed | Accepted | Superseded-by ADR-MMMM | Deprecated
- **결정일**: <YYYY-MM-DD>  ·  **PDCA 라운드**: <Rxx / 링크>

## 맥락 (Context)
<무엇이 문제였나 — 증상·제약·당시 ground truth. 결정을 강제한 힘. 사실+근거(실증/source)로.>

## 결정 (Decision)
<우리는 ___ 한다. 능동·단정 1~3문장. 불변식/단일 chokepoint가 있으면 명시.>

## 대안 (Alternatives — 왜 안 골랐나)
| 안 | 장점 | 버린 이유 |
|---|---|---|
| A. <대안> | | 🔴 <탈락 사유> |
| B. <표면패치> | 빠름 | whack-a-mole — 근본 아님 |

## 결과 (Consequences)
- ✅ 좋아지는 것: <…>
- ⚠️ 비용/트레이드오프: <…>
- 🔁 후속·검증: <두눈/결정론 테스트/게이트 결과 — 가짜0 금지>
```

## status 매핑 (ADR 어휘 → frontmatter)
| ADR 상태 | frontmatter `status` |
|---|---|
| Proposed | `DRAFT` |
| Accepted (실증·90점 통과) | `PROVEN` |
| Superseded / Deprecated | `DEPRECATED` (+ [[pruning]] tombstone) |

## 규율
- **Act에서 ADR로**: PDCA가 개선을 검증하면 그 결정을 ADR로 표준화 → 다음 라운드의 Plan 입력.
- supersede는 **새 파일 + 옛 ADR을 DEPRECATED** (decision 이력 보존, 덮어쓰기 금지).
- 대안 표의 '버린 이유'가 가장 값지다 — 미래의 재논쟁을 차단한다.
