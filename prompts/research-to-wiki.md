---
name: research-to-wiki
description: 리서치→제텔 노트화 프롬프트 — web검색→frontmatter노트+위키링크→evolution-on-write(이웃 요약 갱신)→INDEX 자동등재. 검색 디테일은 sub-agent 격리
type: howto
track: method
status: DRAFT
owner: agent
created: 2026-06-29
updated: 2026-06-29
source: none
links: [[note]], [[token-budget]]
---

# 리서치 → 위키 노트화 — 복붙 가능한 예시 프롬프트

웹/소스 리서치를 **검색 가능·링크된·토큰효율적** 제텔카스텐 노트로 굳힌다. frontmatter 계약은 [[note]], 토큰예산/격리 규율은 [[token-budget]]. 예시 프롬프트(DRAFT).

## 언제 / 입력
- 새 도메인 지식/툴/패턴을 조사해 wiki에 자산화할 때.
- 입력: 리서치 주제 1개, 대상 폴더(보통 `wiki/domain/` 또는 `wiki/personal/`).
- **JIT 원칙**: 검색 raw(수십 페이지)는 컨텍스트에 쌓지 말고 sub-agent에 격리, 1~2k 토큰 요약만 회수 → [[token-budget]].

## 프롬프트 (그대로 붙여넣어 실행)

```text
너는 agent-wiki 리서치-노트화 에이전트다. 주제="<topic>", 대상폴더="wiki/<domain|personal>".

1) 검색(격리): web검색/소스조사를 sub-agent로 돌려 raw 를 거기 가두고 1~2k 요약 + 출처 URL 만 회수.
   사실은 단정+근거 동반. 미검증 추정은 'TODO(owner)'/'⚠️ 미검증' 표기.
2) 노트 작성: 대상폴더에 <slug>.md 생성. note 템플릿 frontmatter 정확히:
   name(==파일명) / description(≤150자=INDEX 헤드라인) / type / track / status / owner /
   created=updated=오늘 / source(출처 URL 또는 코드경로|none) / links.
   한 파일=한 모드(Diátaxis): reference/howto=간결·독립소비, explanation=서사.
3) 링크판단(evolution-on-write): `rg -l "^name:|^description:|^type:" wiki/ projects/` 로 관련 기존 노트를
   찾아 양방향 위키링크를 건다(최소 1개, 고아 금지). 사실 복붙 금지 — 참조만.
4) 요약갱신: 이웃/부모 노트의 요약이 새 노트로 인해 낡았으면 그 자리에서 갱신(updated: 갱신).
5) 등재: INDEX.md 는 손대지 않는다 — gen-index.sh 가 frontmatter 에서 자동 등재.
6) `bash scripts/check-all.sh` PASS → 통과 시에만 PROVEN 승격 검토(미검증이면 DRAFT 유지).

규율: status 는 실증 전 DRAFT. 같은 description 두 곳 금지(dup-SOT). 노트 ≤200줄/≤25KB.
```

## evolution-on-write — 한 트랜잭션(노트 추가 = 5스텝)

```
1. write       → 새 노트(frontmatter + 본문)
2. link        → 기존 노트 검색 → 양방향 위키링크(고아 0)
3. refresh     → 이웃/부모 요약 낡았으면 갱신
4. (INDEX 자동) → gen-index.sh 가 등재(수기 금지)
5. check-all   → PASS 시 PROVEN 승격 검토
```

## 결과 폴더트리

```
agent-wiki/
└── wiki/
    └── domain/                       # (또는 personal/)
        ├── INDEX.md                  # [GENERATED] ← gen-index.sh 가 새 노트 자동 등재
        ├── <new-note>.md             # ← 리서치 산출(frontmatter + 위키링크)
        ├── <neighbor-a>.md           #    요약 갱신됨(evolution-on-write step 3)
        └── <neighbor-b>.md           #    역방향 위키링크 추가됨
```

## 종료 체크리스트
- [ ] frontmatter 10필드 전부 + name==파일명 + description ≤150자 → 계약 [[note]]
- [ ] 출처 `source:` 기재(URL/코드경로), 미검증은 DRAFT + ⚠️ 표기
- [ ] 최소 1개 관련 노트와 양방향 위키링크(고아 0)
- [ ] 이웃 요약 갱신 + 사실 복붙 0(참조만)
- [ ] `scripts/check-all.sh` PASS(깨진 링크·dup-description 0)

## 주의 / 안티패턴
- **raw 검색 결과를 본문에 통째 붙이기** → 토큰낭비 + stale 위험. 알짜만 증류, 출처는 `source:`로. → [[token-budget]]
- **사실 복붙(dup-SOT)**: 다른 노트의 사실을 옮겨적지 말고 위키링크로 참조. 같은 description 두 곳 = 버그.
- **INDEX 수기등재**: gen-index.sh 자동 — 손대면 덮어쓰기.
- 모르는 구체수치를 그럴듯하게 채우는 것 = 능동 오도. 모르면 TODO(owner).
