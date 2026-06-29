---
name: model-tiering
description: 자원효율 모델 티어링 — Opus orchestrator/Haiku worker+1차스크리닝/다른패밀리 최종judge(self-pref 회피)·동시성캡·토큰/비용 원장·$ 킬스위치 임계
type: reference
track: ops
status: PROVEN
owner: you
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[pattern-select]], [[guardrails]]
---

# model-tiering — 단계마다 적정 티어 (전부 최상위 = 낭비 + self-pref)

모든 단계에 최상위 모델을 쓰면 **비용폭주 + self-preference**(자기생성 편애)가 동시에 터진다. 단계별로 적정 티어를 배분하면 **비용을 크게 줄이면서**(추정 40~60%) 품질은 유지된다. 어느 패턴/티어를 언제 = [[pattern-select]]. 비용 가드 본체 = [[guardrails]].

## 티어 배분 (역할별)
| 역할 | 티어 | 왜 |
|---|---|---|
| orchestrator · 플래닝 · 근본설계 | **Opus**(고추론) | depth 깊은 라우팅·전수조사·단일 chokepoint 판단 |
| worker · 검색 · 1차 스크리닝 · 대량 fan-out | **Haiku**(저비용·고병렬) | 디테일은 sub-agent에 격리, 1~2k 요약만 회수([[_AGENT_SPEC]]) |
| 최종 judge · 적대채점 | **생성과 다른 모델패밀리** | self-preference 회피(아래) |

## ★ self-preference 회피 = 티어링의 숨은 핵심
judge가 generation과 **같은 모델**이면 자기 출력을 편애해 점수가 인플레된다([[pdca]] 안티 · [[evaluator-optimizer]]). 그래서 90점 적대 게이트의 judge는 **다른 패밀리**로 돌린다 — 독립 평가만이 신뢰 oracle이다([[rubric]] 7축 · [[judge]]). 단순 비용절감이 아니라 **평가 무결성**이 걸린 결정.

## 동시성 캡
- 병렬 worker N 상한. worktree-per-agent와 정합([[git-conventions]] D) — 무제한 fan-out = `.git` 락 경합 + 비용폭주.
- 가벼운 1차 스크리닝(Haiku)으로 후보를 좁힌 뒤에만 비싼 티어(Opus)를 호출 → 깔때기.

## 비용 원장 + $ 킬스위치
- per-task / 일일 **토큰·$ 누적 원장**을 유지(블라인드 자율실행 금지).
- 임계 초과 = **강제정지**([[guardrails]] cost-cap). 자동매매 봇의 $ 킬스위치가 실사례 — 라이브 손실/비용을 회로차단으로 막는다([[automation-bots]]). 임계는 태스크별 사전설정.
- prod-write · 비가역 · confidence < 80~90% = 티어 무관 **HITL 먼저**([[guardrails]] B).

## 안티패턴
- 전부 Opus(비용 폭주) · judge = generation(self-pref 점수 인플레) · 무캡 fan-out(락 경합+폭주) · 원장 없이 자율실행(블라인드 비용) · 1차 스크리닝 생략하고 비싼 티어로 전수.

## 규칙
- 단계 = 적정 티어. 깔때기(저티어 스크리닝 → 고티어 결정).
- judge는 **항상** 생성과 다른 패밀리.
- 원장 + $ 킬스위치 없는 장기 자율실행 금지.
