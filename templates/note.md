---
name: note
description: 정본 frontmatter 계약 + 위키링크 + evolution-on-write — 모든 .md 노트의 부모 템플릿
type: reference
track: method
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[sot-registry]], [[token-budget]]
---

# note 템플릿 — 모든 노트의 frontmatter 계약

새 노트를 만들 때 아래 코드블록을 복사해 맨 위에 붙인다. `scripts/wiki-lint.sh`가 이 필드들을 강제한다.

```markdown
---
name: <파일명과 동일한 kebab-slug>        # [[link]] 대상이 된다. 파일명 == name 의무.
description: <≤150자 한 줄 요약>           # 그대로 INDEX.md 헤드라인이 된다. 한글 3B/자 주의.
type: <tutorial|howto|reference|explanation | sop|opl|lesson|standard-work | agent|pattern|adr | index>
track: <dev|factory|personal|method|ops|project>
status: <PROVEN|DRAFT|DEPRECATED>          # 실증·90점 통과 전엔 DRAFT.
owner: <you|agent>                         # 누가 진실의 주인인가(사람 vs 에이전트).
created: <YYYY-MM-DD>
updated: <YYYY-MM-DD>                       # 내용 바뀌면 갱신. source 보다 오래되면 freshness-lint fail.
source: <미러하는 코드/문서 경로 | none>   # 코드에 진실이 있으면 그 경로. 그 코드 변경 > updated 면 stale.
links: [[관련노트a]], [[관련노트b]]         # 최소 1개(고아 금지). 양방향이 이상적.
---
```

## 본문 규칙
- **한 파일 = 한 모드 = 한 일**(Diátaxis). reference/howto는 간결·독립소비(에이전트 검색면), explanation/tutorial은 서사(사람용).
- 사실은 단정 + 근거(실증/`source:`)와 함께. 미검증 추정은 `status: DRAFT` + "⚠️ 미검증" 표기.
- 다른 노트의 사실을 **복붙하지 말고 `[[link]]`**. 같은 사실이 두 곳 = dup-SOT = 버그.
- **`description` = 선두에 가장 변별력 큰 페이로드.** `name`/`type` 재진술 금지(메타로 이미 신호), 하위개념·예시는 본문으로 이관 — 헤드라인은 에이전트의 검색 필터다.

## evolution-on-write (A-MEM 방식 — 노트 추가 시 한 트랜잭션으로)
1. 노트를 쓴다(frontmatter + 본문).
2. **관련 기존 노트를 찾아** 양방향 `[[link]]`를 건다(ripgrep으로 후보 검색).
3. 부모/이웃 노트의 요약이 낡았으면 갱신한다.
4. 해당 폴더 `INDEX.md`는 손대지 않는다 — `scripts/gen-index.sh`가 frontmatter에서 자동 등재.
5. `scripts/check-all.sh` 통과 확인 → 통과하면 `status: PROVEN` 승격 검토.

## compaction-on-write (임계 초과 시)
노트가 200줄 또는 25KB(바이트)에 근접하면 디테일을 자식노트로 쪼개고 `[[link]]`. 부모엔 **결정·버그·규칙**만 남기고 원문은 폐기. → [[token-budget]]
