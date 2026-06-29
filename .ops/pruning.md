---
name: pruning
description: 분기 pruning — 죽은잔재만 제거(audit≠constitution: 실기능은 근거+절차로 보존)·supersession 수명주기(정본 이동시 archive tombstone+리다이렉트 스텁)로 깨진링크 방지
type: reference
track: ops
status: DRAFT
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[bootstrap]], [[_log]]
---

# pruning — 신호밀도 유지를 위한 분기 청소

stale 노트는 **없느니만 못하다**(능동 오도, L5). 분기마다 한 번 sweep 해서 죽은 가지를 친다. 단, 청소가 곧 삭제는 아니다 — 핵심은 **무엇을 베고 무엇을 근거+절차로 살리느냐**다. 부트스트랩(채우기)의 반대 작용([[bootstrap]]).

## ★ audit ≠ constitution (제1원칙)
pruning 보고서/감사는 **헌법이 아니다.** 실기능에 필요한 노트·권한·섹션은 *축소·삭제가 아니라* **근거+절차를 갖춰 보존**한다. 오직 **죽은 잔재**만 제거한다.
> 원칙: "정말 필요하면 거기에 맞는 근거와 절차를 두어서 진행." — 타이트하게 깎는 게 미덕이 아니다. 필요한 건 정당화해서 남긴다(정책상 막히는 극소수 기능만 컴플라이언트 대체수단으로 보존).

## prune 대상 판별 (죽은 잔재의 정의)
| 신호 | 판별 | 처리 |
|---|---|---|
| **DEPRECATED** | `source` 코드/사실이 사라짐 | tombstone(아래) |
| **고아** | 어떤 INDEX/링크에서도 참조 0(check-orphans) | 링크 걸거나 제거 |
| **dup-SOT** | 같은 사실 2곳(dup-description WARN) | 정본 1개로 병합·나머지 `[[link]]` |
| **DRAFT husk** | 장기 미검증·내용 빈약 | 채우거나 삭제([[bootstrap]] husk 방지) |
| **stale** | `source` > `updated`(freshness-lint fail) | 갱신 또는 DEPRECATE |

> "참조 0 + source 죽음 + 미검증" 셋 다면 죽은 잔재 — 베다. 하나라도 살아있으면(실기능 의존) 근거 달아 보존.

## supersession 수명주기 (정본이 옮겨갈 때 — 깨진 `[[link]]` 방지)
정본 노트를 새 위치/slug로 옮길 때 인바운드 `[[link]]`가 깨지면 lint FAIL. 그래서 **즉시 삭제 금지**, 항상 tombstone 경유:
1. **새 정본 작성**(새 slug/위치) + [[sot-registry]] 등록 갱신.
2. **구노트 → `archive/`로 이동** + `status: DEPRECATED`.
3. **구 slug 자리에 리다이렉트 tombstone 스텁**: frontmatter + "이 노트는 `[[새정본]]`으로 이전됨" 1줄. → 기존 `[[구slug]]` 링크가 안 깨진다(lint의 DEFFILE에 basename이 살아있어야 하므로 **tombstone 파일명=구 slug 유지**).
4. `archive/`는 `wiki-lint` **EXCLUDE**(스캔 제외) — 죽은 본문이 freshness/size 게이트를 어지럽히지 않는다.
5. 인바운드 링크를 새 정본으로 **점진 rewire** → 전부 옮겨진 다음 분기에 tombstone 자체를 prune.

## 절대 금지
- 인바운드 링크가 살아있는데 노트 **즉시 삭제**(깨진 `[[link]]` FAIL). 항상 tombstone 경유.
- 실기능 의존 노트를 "정리" 명목으로 삭제(audit≠constitution 위반).
- `archive/` 밖에 죽은 본문 방치(freshness-lint 노이즈).

## 기록·검증
- 각 prune 라운드의 결정(무엇을 왜 제거/보존)은 [[_log]]에 1줄.
- prune 후 **`scripts/check-all.sh` PASS**(깨진링크 0 · 고아 0 · dup 점검).

## TODO
- 분기 sweep은 아직 1회도 실행 전(저장소 신생) → 절차는 설계, 첫 라운드 실행 후 PROVEN 승격 + [[_log]] 기록.
