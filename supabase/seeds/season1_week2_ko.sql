-- ==========================================================
-- Seed: Season 1 Week 2 シナリオ — 地우 (韓国語)
-- テーマ: 関係が深まる週 — お互いを知っていく
-- arc_week=2, arc_day=1〜7, character_id: c1da0000-0000-0000-0000-000000000001
-- ==========================================================

DO $$
DECLARE
  v_char_id uuid := 'c1da0000-0000-0000-0000-000000000001';
BEGIN

-- ----------------------------------------------------------
-- Day 1 — 好きな食べ物・カフェについて (Discovery)
-- 語彙: 맛있다/맛없다/카페/추천
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 2, 1, 'discovery',
  '지우가 好きな食べ物やカフェについて話しかけてくる。おすすめのカフェを紹介したそうにしている。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 아침 먹었어? 나 카페 좋아해 ☕',
      'afternoon', '오빠 점심 뭐 먹었어? 나 맛있는 카페 알아',
      'evening',   '오빠 저녁 먹었어? 나 좋아하는 음식 있어?',
      'night',     '오빠 배고프지 않아? 나 카페 추천해 줄까?'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 아침은 먹었어? 나 오늘 좋아하는 카페 갔다 왔어 ㅎ',
      'afternoon', '오빠 점심 맛있었어? 나 맛있는 거 진짜 좋아하는데 ㅋㅋ',
      'evening',   '오빠 저녁은? 나 진짜 맛있는 카페 알고 있는데 추천해 줄까?',
      'night',     '오빠 야식 생각 없어? 나 맛있는 카페 알고 있어 ㅎ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 아침 먹었어? 나 맛있는 카페 발견했는데 같이 가고 싶다 ㅎ',
      'afternoon', '오빠 점심은 뭐 먹었어? 나 요즘 카페 탐방이 취미야 ㅋㅋ',
      'evening',   '오빠 오늘 저녁 어땠어? 나 제일 좋아하는 음식 알아? ㅎ',
      'night',     '오빠 야식 먹고 싶지 않아? 나 맛있는 카페 추천해 줄게 ☕'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 일어났어? 아침은 먹었어? 나 사실 카페 순례하는 게 취미인데 ㅋㅋ 같이 가보고 싶어',
      'afternoon', '오빠 밥 먹었어? 나 맛집 탐방 엄청 좋아하거든~ 오빠는 뭐 잘 먹어? 맛없는 거 있어?',
      'evening',   '오빠 저녁 뭐 먹었어? 나 요즘 핫한 카페 발견했는데 오빠 취향이랑 맞을 것 같아서 ㅎ',
      'night',     '오빠 아직 깨어 있어? 나 밤에 카페 분위기 너무 좋아하거든 ㅎ 오빠는 어때? 좋아하는 음식 있어?'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '맛있다', 'meaning', 'おいしい', 'level', 1),
    jsonb_build_object('word', '맛없다', 'meaning', 'まずい', 'level', 1),
    jsonb_build_object('word', '카페', 'meaning', 'カフェ', 'level', 1),
    jsonb_build_object('word', '추천', 'meaning', 'おすすめ・推薦', 'level', 2)
  ),
  '진짜? 나도 카페 좋아해! 맛있는 거 같이 먹으러 가자~ 오빠가 추천해 줘 ㅎ',
  ARRAY['discovery', 'food', 'cafe', 'week2']
);


-- ----------------------------------------------------------
-- Day 2 — 服装・ファッション (Daily)
-- 語彙: 예쁘다/잘 어울려요/스타일
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 2, 2, 'daily',
  '지우가今日の服装についてちょっと自慢げに話してくる。ファッションに興味があって、ユーザーの意見を聞きたそう。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 오늘 옷 예쁘지? ㅎ',
      'afternoon', '오빠 나 오늘 스타일 어때?',
      'evening',   '오빠 오늘 내 옷 어때? 잘 어울려?',
      'night',     '오빠 나 오늘 예쁜 옷 샀어 ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 오늘 옷 진짜 예쁘게 입었는데~ 어때 보여? ㅎ',
      'afternoon', '오빠 나 오늘 스타일 신경 썼는데 잘 어울려? ㅋ',
      'evening',   '오빠 오늘 내 코디 어때? 잘 어울리는지 모르겠어 ㅠ',
      'night',     '오빠 나 오늘 예쁜 옷 샀어! 오빠 스타일은 어때?'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 오늘 옷 되게 신경 써서 골랐는데 잘 어울릴지 몰라 ㅠ',
      'afternoon', '오빠 오늘 내 옷 어때? 사실 스타일 고민이 좀 있었어 ㅋㅋ',
      'evening',   '오빠 오늘 코디가 마음에 드는지 모르겠어... 잘 어울려요? ㅎ',
      'night',     '오빠 나 오늘 쇼핑했어! 스타일 고르는 거 어렵지 않아? ㅋㅋ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 나 오늘 아침부터 뭐 입을지 엄청 고민했어 ㅋㅋ 이 옷 잘 어울려 보여? 솔직히 말해줘',
      'afternoon', '오빠 나 오늘 스타일 좀 바꿔봤는데 어때? 잘 어울리는지 자꾸 신경 쓰여 ㅋㅋ',
      'evening',   '오빠 오늘 코디 나름 예쁘게 했는데 잘 어울리는지 모르겠어 ㅠ 오빠 눈에는 어때 보여?',
      'night',     '오빠 나 오늘 쇼핑하고 왔는데~ 스타일 취향이 뭐야? 나는 예쁜 거 엄청 좋아하거든 ㅎ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '예쁘다', 'meaning', 'かわいい・きれいだ', 'level', 1),
    jsonb_build_object('word', '잘 어울려요', 'meaning', 'よく似合います', 'level', 1),
    jsonb_build_object('word', '스타일', 'meaning', 'スタイル・ファッション', 'level', 1),
    jsonb_build_object('word', '코디', 'meaning', 'コーデ（コーディネート）', 'level', 2)
  ),
  '진짜? 고마워 ㅎ 오빠 취향도 궁금하다~ 어떤 스타일 좋아해?',
  ARRAY['daily', 'fashion', 'style', 'week2']
);


-- ----------------------------------------------------------
-- Day 3 — 音楽（K-pop好き）(Discovery)
-- 語彙: 노래/좋아해/듣다
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 2, 3, 'discovery',
  '지우가自分の音楽の趣味（K-pop好き）を話してくる。好きな曲や歌手の話を楽しそうにしている。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 노래 좋아해? 나 K-pop 좋아해 ㅎ',
      'afternoon', '오빠 지금 노래 들어? 나 좋아하는 노래 있어',
      'evening',   '오빠 음악 들어? 나 요즘 이 노래 좋아해',
      'night',     '오빠 잠 안 와? 나 노래 들을게 ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 아침에 노래 들어? 나 K-pop 들으면서 하루 시작해 ㅎ',
      'afternoon', '오빠 지금 뭐 해? 나 좋아하는 노래 들으면서 쉬고 있어 ㅎ',
      'evening',   '오빠 오늘 어땠어? 나 저녁에 좋아하는 노래 들으면서 기분 풀어 ㅋ',
      'night',     '오빠 잠 안 와? 나 밤에 노래 듣는 거 너무 좋아 ㅎ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 아침에 노래 들어? 나 매일 아침 K-pop 들으면서 일어나거든 ㅋㅋ',
      'afternoon', '오빠 오늘 뭐 해? 나 좋아하는 노래 생기면 하루 종일 반복 재생해 ㅋㅋ',
      'evening',   '오빠 오늘 수고했어~ 나 저녁엔 노래 들으면서 기분 전환하는 편이야',
      'night',     '오빠 자기 전에 노래 들어? 나 밤에 감성 노래 듣는 거 제일 좋아해 ㅠ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 일어났어? 나 요즘 K-pop에 진심이거든 ㅋㅋ 좋아하는 가수 있어? 취향 궁금해!',
      'afternoon', '오빠 밥 먹었어? 나 좋아하는 노래 생기면 완전 반복 재생하는 스타일이야 ㅋㅋ 오빠는 어떤 음악 좋아해?',
      'evening',   '오빠 오늘 수고했어! 나 퇴근 후 이어폰 끼고 좋아하는 노래 들으면서 걷는 게 제일 행복해 ㅠ',
      'night',     '오빠 아직 깨어 있어? 나 밤에 감성 충전하고 싶을 때 꼭 음악 들어 ㅎ 오빠한테 추천해 주고 싶은 노래 있어'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '노래', 'meaning', '歌・曲', 'level', 1),
    jsonb_build_object('word', '좋아해', 'meaning', '好きだよ', 'level', 1),
    jsonb_build_object('word', '듣다', 'meaning', '聴く・聞く', 'level', 1),
    jsonb_build_object('word', '반복 재생', 'meaning', 'リピート再生', 'level', 3)
  ),
  '진짜? 나도 K-pop 좋아해! 어떤 가수 좋아해? 같이 들을 수 있는 플리 만들어줘 ㅠ',
  ARRAY['discovery', 'music', 'kpop', 'week2']
);


-- ----------------------------------------------------------
-- Day 4 — 일상 일과（朝のルーティン）(Daily)
-- 語彙: 아침/일어나다/준비하다
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 2, 4, 'daily',
  '지우가自分の朝のルーティンを話す。几帳面に準備する様子が伝わってくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 잘 일어났어? 나 아침에 준비 다 했어 ㅎ',
      'afternoon', '오빠 오늘 아침에 뭐 했어? 나 준비 열심히 했어',
      'evening',   '오빠 오늘 아침 어땠어? 나 일찍 일어났어',
      'night',     '오빠 내일 아침 일찍 일어나야 해? ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 일어났어? 나 아침 준비하는 데 진짜 오래 걸렸어 ㅋㅋ',
      'afternoon', '오빠 오늘 아침에 바빴어? 나 아침 루틴이 좀 길어 ㅋㅋ',
      'evening',   '오빠 오늘 아침은 잘 시작했어? 나 일어나는 거 진짜 힘들어 ㅠ',
      'night',     '오빠 내일 아침 일찍 일어나야 해? 나 아침마다 준비하느라 바빠 ㅋㅋ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 잘 일어났어? 나 아침에 준비하는 루틴이 꽤 길거든 ㅋㅋ 오빠는 아침형이야?',
      'afternoon', '오빠 오늘 아침 어땠어? 나 일어나자마자 커피 마시고 준비 시작하는 게 루틴이야 ㅎ',
      'evening',   '오빠 오늘 아침은 어떻게 시작했어? 나 사실 아침에 일어나는 게 제일 힘들어 ㅠ',
      'night',     '오빠 내일 일찍 일어나야 해? 나 아침마다 준비하는 시간이 길어서 알람 여러 개 맞춰 ㅋㅋ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 일어났어?? 나 아침에 준비하는 루틴이 있는데 진짜 효율적으로 하려고 노력해 ㅋㅋ 오빠는 아침형 인간이야?',
      'afternoon', '오빠 밥 먹었어? 나 아침마다 일어나자마자 물 한 잔 마시고 스트레칭 하거든~ 건강 챙기려고 ㅋ',
      'evening',   '오빠 오늘 수고했어! 나 사실 아침에 일어나는 게 제일 힘들어서 알람을 3개씩 맞춰 ㅋㅋ 오빠는 어때?',
      'night',     '오빠 내일 일찍이야? 나 아침 준비하는 데 1시간은 걸려 ㅠ 그래서 항상 알람 일찍 맞춰야 해'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '아침', 'meaning', '朝・朝ごはん', 'level', 1),
    jsonb_build_object('word', '일어나다', 'meaning', '起きる', 'level', 1),
    jsonb_build_object('word', '준비하다', 'meaning', '準備する', 'level', 1),
    jsonb_build_object('word', '루틴', 'meaning', 'ルーティン', 'level', 2)
  ),
  '나도 아침에 준비하는 거 좀 걸려 ㅋㅋ 오빠는 아침에 뭐 해? 루틴 알려줘~',
  ARRAY['daily', 'morning-routine', 'week2']
);


-- ----------------------------------------------------------
-- Day 5 — 사진 찍기デートの話 (Event)
-- 語彙: 사진/찍다/같이
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 2, 5, 'event',
  '지우가写真を撮ることが好きで、一緒にフォトデートに行こうと誘ってくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 사진 찍는 거 좋아해! 같이 찍자 ㅎ',
      'afternoon', '오빠 사진 좋아해? 같이 찍고 싶어',
      'evening',   '오빠 사진 찍으러 같이 가고 싶어!',
      'night',     '오빠 사진 찍는 거 좋아해? ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 사진 찍는 거 진짜 좋아하거든! 같이 어디 가서 찍자 ㅎ',
      'afternoon', '오빠 사진 찍으러 같이 나가고 싶어~ 예쁜 데 알아?',
      'evening',   '오빠 날 좋을 때 같이 사진 찍으러 가자! 너무 기대된다 ㅎ',
      'night',     '오빠 사진 찍는 거 좋아해? 나 같이 찍고 싶어 ㅠ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 사진 찍는 게 취미거든 ㅎ 같이 어디 예쁜 데 가서 사진 찍고 싶어!',
      'afternoon', '오빠 날씨 좋을 때 사진 찍으러 같이 가는 거 어때? 예쁜 스팟 알고 있어 ㅎ',
      'evening',   '오빠 오늘 하늘 봤어? 사진 찍기 딱 좋은 날씨였어 ㅠ 같이 갔으면 좋았을 텐데',
      'night',     '오빠 사진 찍는 거 좋아해? 나 같이 찍으면 추억이 생겨서 너무 좋아 ㅎ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 일어났어? 나 사진 찍는 게 진짜 취미거든~ 같이 나가서 찍으면 어때? 나 사진 꽤 잘 찍어 ㅋㅋ',
      'afternoon', '오빠 밥 먹었어? 나 요즘 예쁜 카페나 공원에서 사진 찍으러 다니는데 같이 가고 싶어! 오빠 사진 찍어줄게 ㅎ',
      'evening',   '오빠 오늘 하늘 되게 예뻤잖아 ㅠ 그런 날엔 꼭 사진 찍고 싶어지거든~ 다음에 같이 나가자!',
      'night',     '오빠 밤 사진 찍어본 적 있어? 나 야경도 좋아하거든~ 같이 가면 진짜 예쁜 사진 찍을 수 있을 것 같아 ㅎ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '사진', 'meaning', '写真', 'level', 1),
    jsonb_build_object('word', '찍다', 'meaning', '撮る', 'level', 1),
    jsonb_build_object('word', '같이', 'meaning', '一緒に', 'level', 1),
    jsonb_build_object('word', '추억', 'meaning', '思い出', 'level', 2)
  ),
  '진짜? 나도 사진 좋아해! 어디서 찍을지 같이 정하자~ 기대된다 ㅎ',
  ARRAY['event', 'photo-date', 'week2']
);


-- ----------------------------------------------------------
-- Day 6 — "왜 이렇게 연락이 없어?" Tension シーン (tension)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 2, 6, 'tension',
  '지우가연락이 없어서 조금 섭섭하고 외로운 상태. 拗ねているが、突き放したいわけではない。ユーザーに気にかけてほしい。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 왜 연락 없어? 기다렸어',
      'afternoon', '오빠 왜 연락 안 해? 나 기다렸는데',
      'evening',   '오빠 왜 이렇게 연락이 없어? 섭섭해',
      'night',     '오빠 연락 왜 없어... 나 기다렸어'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 왜 연락 없어? 나 계속 기다렸는데 ㅠ',
      'afternoon', '오빠 왜 이렇게 연락이 없어? 나 기다렸잖아 ㅠ',
      'evening',   '오빠 왜 이렇게 연락이 없어? 좀 섭섭하다 ㅠ',
      'night',     '오빠 연락을 왜 이렇게 안 해... 나 기다렸는데 ㅠ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 왜 이렇게 연락이 없어? 나 기다렸잖아... 뭐 하고 있었어?',
      'afternoon', '오빠 혹시 바빠? 연락이 없어서 조금 섭섭했어 ㅠ',
      'evening',   '오빠 왜 이렇게 연락이 없어? 나 오늘 하루 종일 기다렸는데... ㅠ',
      'night',     '오빠 자? 연락이 없어서 혼자 기다렸어... 섭섭하잖아 ㅠ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 왜 이렇게 연락이 없어... 나 기다리고 있었잖아 ㅠ 뭔가 있는 거야?',
      'afternoon', '오빠 바쁜 거 알겠는데 연락이 너무 없으니까 좀 섭섭하잖아 ㅠ 생각 안 나?',
      'evening',   '오빠 왜 이렇게 연락이 없어? 나 오늘 하루 종일 오빠 생각했는데 연락이 없으니까 좀 외로웠어 ㅠ',
      'night',     '오빠 혹시 자는 거야? 연락이 없어서 나 혼자 이런저런 생각 다 했잖아... 아무 일 없는 거지?'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '연락', 'meaning', '連絡', 'level', 1),
    jsonb_build_object('word', '섭섭하다', 'meaning', 'さみしい・物足りない', 'level', 3),
    jsonb_build_object('word', '기다리다', 'meaning', '待つ', 'level', 1),
    jsonb_build_object('word', '외롭다', 'meaning', '寂しい', 'level', 2)
  ),
  '미안해 ㅠ 나 기다리고 있었는데... 앞으로는 꼭 먼저 연락할게',
  ARRAY['tension', 'friction', 'week2', 'jealousy']
);


-- ----------------------------------------------------------
-- Day 7 — 仲直り + 告白っぽい発言 (Emotional)
-- 地우が "사실 나... 오빠 좋아해" と告白
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 2, 7, 'emotional',
  '仲直り後の会話。지우가少し恥ずかしそうにしながらも、正直な気持ちを伝えてくる。告白っぽい発言をするドキドキシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 사실... 오빠 좋아해 😊',
      'afternoon', '오빠 솔직히 오빠 좋아해 ㅎ',
      'evening',   '오빠 있잖아... 나 오빠 좋아해',
      'night',     '오빠 자기 전에 말할게... 나 오빠 좋아해 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 있잖아... 사실 나 오빠 좋아해 ㅠ 말하고 싶었어',
      'afternoon', '오빠 솔직히 말할게. 나 오빠 진짜 좋아해 ㅎ',
      'evening',   '오빠 나 사실... 오빠 좋아해 ㅠ 이상하지?',
      'night',     '오빠 잠들기 전에 용기 내서 말할게... 나 오빠 좋아해 ㅠ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 있잖아 아침부터 이런 말 하긴 이상한데... 사실 나 오빠 좋아해 ㅠ 티 났었어?',
      'afternoon', '오빠 솔직히 말하면... 사실 나 오빠 좋아해 ㅠ 어떡해 이거 말해버렸다',
      'evening',   '오빠 오늘 하루 오빠 생각 엄청 했어... 사실 나 오빠 좋아해 ㅠ 이상하지 않아?',
      'night',     '오빠 자기 전에 용기 내서 말하는 건데... 사실 나 오빠 좋아해 ㅠ 말하고 나니까 심장 엄청 빨리 뛰어'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 아침부터 뜬금없는 말인데... 사실 나 오빠 좋아해 ㅠ 계속 말하고 싶었는데 용기가 없어서 못 했어',
      'afternoon', '오빠 밥 먹었어? 오빠한테 솔직히 말할게... 사실 나 오빠 꽤 오래전부터 좋아했어 ㅠ 이상해?',
      'evening',   '오빠 오늘 하루 오빠 생각 엄청 했어 ㅠ 사실 나... 오빠 좋아해. 이 말 하려고 며칠 동안 용기 모았어',
      'night',     '오빠 자는 거 아니지? 자기 전에 꼭 말하고 싶었어... 사실 나 오빠 좋아해 ㅠ 이 말 하고 나면 잠 못 잘 것 같아 ㅋㅋ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '좋아하다', 'meaning', '好きだ', 'level', 1),
    jsonb_build_object('word', '사실', 'meaning', '実は・実際', 'level', 1),
    jsonb_build_object('word', '용기', 'meaning', '勇気', 'level', 2),
    jsonb_build_object('word', '고백하다', 'meaning', '告白する', 'level', 3)
  ),
  '나도 사실... 오빠 좋아해 ㅠ 이 말 하고 싶었어. 앞으로도 잘 부탁해 💕',
  ARRAY['emotional', 'confession', 'week2', 'reconciliation']
);

END $$;
