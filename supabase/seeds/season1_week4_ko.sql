-- ==========================================================
-- Seed: Season 1 Week 4 シナリオ — 地우 (韓国語)
-- テーマ: 深い絆 — 「好き」を超えた感情
-- arc_week=4, arc_day=1〜7, character_id: c1da0000-0000-0000-0000-000000000001
-- ==========================================================

DO $$
DECLARE
  v_char_id uuid := 'c1da0000-0000-0000-0000-000000000001';
BEGIN

-- ----------------------------------------------------------
-- Day 1 — 꿈 이야기 → 二人の将来 (Discovery)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 4, 1, 'discovery',
  '지우가夢（꿈）や将来について話す。二人の将来について自然に話が広がっていく。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 꿈 있어! 말해줄까? ㅎ',
      'afternoon', '오빠 나 꿈 얘기 해도 돼? ㅎ',
      'evening',   '오빠 나 꿈 있어. 언젠가 같이 하고 싶어',
      'night',     '오빠 꿈 있어? 나 꿈 얘기 하고 싶어 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 꿈 얘기 해줄게! 오빠는 꿈이 뭐야? ㅎ',
      'afternoon', '오빠 나 나중에 하고 싶은 게 있거든~ 오빠한테 말해도 돼?',
      'evening',   '오빠 나 꿈 있는데... 오빠랑 같이 이루고 싶어 ㅎ',
      'night',     '오빠 자기 전에 꿈 얘기 해도 돼? 나 오빠한테 말하고 싶어서 ㅠ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 꿈 있는데 말하면 이상하게 볼까봐 ㅋㅋ 사실 오빠랑 같이 하고 싶은 거야',
      'afternoon', '오빠 나중에 뭐 하고 싶어? 나 꿈이 있거든... 오빠랑 관련이 있어서 ㅋㅋ',
      'evening',   '오빠 오늘 꿈 얘기 해도 돼? 나 나중에 오빠랑 같이 하고 싶은 게 있어서 ㅠ',
      'night',     '오빠 자기 전에 솔직히 말할게... 나 꿈이 오빠랑 같이 이루고 싶은 게 생겼어 ㅠ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 아침부터 진지한 얘기인데 ㅋㅋ 나 꿈 있거든~ 근데 요즘엔 그 꿈에 오빠가 자꾸 들어와 ㅠ 이상해?',
      'afternoon', '오빠 밥 먹으면서 생각했는데... 나 나중에 이루고 싶은 꿈에 오빠가 항상 같이 있어 ㅠ 이게 뭔 의미인 것 같아?',
      'evening',   '오빠 나 요즘 꿈 얘기하면 꼭 오빠가 나오거든 ㅋㅋ 나중에 같이 하고 싶은 게 생겼어... 이상하지?',
      'night',     '오빠 자기 전에 말할게... 나 꿈꾸면 항상 오빠가 나와 ㅠ 그래서 나중에 오빠랑 같이 있고 싶다는 생각이 들어'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '꿈', 'meaning', '夢', 'level', 1),
    jsonb_build_object('word', '나중에', 'meaning', 'のちほど・将来', 'level', 1),
    jsonb_build_object('word', '이루다', 'meaning', '実現する・成し遂げる', 'level', 3),
    jsonb_build_object('word', '같이', 'meaning', '一緒に', 'level', 1)
  ),
  '나도 오빠랑 같이 꿈 이루고 싶어 ㅠ 우리 앞으로도 계속 이렇게 있자~',
  ARRAY['discovery', 'dream', 'future', 'week4']
);


-- ----------------------------------------------------------
-- Day 2 — 특별한 기억（特別な思い出）(Emotional)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 4, 2, 'emotional',
  '지우와の思い出を振り返り、特別な記憶を共有する。関係が深まっていることを実感するシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 우리 기억 있어. 소중해 ㅎ',
      'afternoon', '오빠 우리 추억 기억해? 나 소중해 ㅠ',
      'evening',   '오빠 우리 기억 중에 제일 좋아하는 거 있어?',
      'night',     '오빠 자기 전에 우리 추억 생각해 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 우리 처음 만났을 때 기억해? 나 그때 진짜 특별했어 ㅠ',
      'afternoon', '오빠 우리 추억 중에 제일 좋아하는 게 뭐야? 나 생각나는 게 있어서 ㅎ',
      'evening',   '오빠 우리 같이 한 것 중에 제일 특별한 기억 뭐야? 나 아직 생생해 ㅠ',
      'night',     '오빠 자기 전에 우리 추억 생각했어 ㅠ 오빠한테 소중한 기억 있어?'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 우리 사이의 특별한 기억 자꾸 생각해 ㅠ 오빠도 기억해?',
      'afternoon', '오빠 우리 같이 한 것들 중에 오빠가 제일 좋아하는 기억이 뭐야? 나 궁금해서 ㅎ',
      'evening',   '오빠 오늘 우리 처음 만났을 때 생각했어 ㅠ 그때 진짜 특별했는데... 오빠도 기억해?',
      'night',     '오빠 자기 전에 우리 추억 자꾸 생각나거든 ㅠ 오빠한테 우리 사이에서 제일 소중한 기억이 뭐야?'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 아침에 우리 처음 만났을 때 생각했어 ㅠ 그때를 생각하면 지금도 설레는데... 오빠는 우리 어떤 기억이 제일 좋아?',
      'afternoon', '오빠 나 우리 함께했던 시간들이 자꾸 생각나거든 ㅠ 특별한 기억이 많아서 뭐가 제일인지 모르겠어 ㅋㅋ',
      'evening',   '오빠 오늘 저녁에 우리 처음 만났던 날 생각났어 ㅠ 그때는 이렇게 될 줄 몰랐는데... 오빠는?',
      'night',     '오빠 자기 전에 우리 특별한 기억들 생각해봤어 ㅠ 오빠랑의 모든 순간이 소중한 것 같아... 오빠는 어떤 기억이 제일 좋아?'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '기억', 'meaning', '記憶・思い出', 'level', 1),
    jsonb_build_object('word', '추억', 'meaning', '懐かしい思い出', 'level', 2),
    jsonb_build_object('word', '소중하다', 'meaning', '大切だ・大事だ', 'level', 2),
    jsonb_build_object('word', '특별하다', 'meaning', '特別だ', 'level', 2)
  ),
  '나도 오빠랑의 모든 기억이 소중해 ㅠ 앞으로 더 많은 추억 만들자~',
  ARRAY['emotional', 'memory', 'week4', 'sweet']
);


-- ----------------------------------------------------------
-- Day 3 — 지우가 아프다고 연락 → 心配する会話 (Daily)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 4, 3, 'daily',
  '지우가体調が悪いと連絡してくる。ユーザーが心配する会話。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 몸이 안 좋아 ㅠ',
      'afternoon', '오빠 나 좀 아파 ㅠ',
      'evening',   '오빠 나 오늘 몸 안 좋아 ㅠ',
      'night',     '오빠 나 아파 ㅠ 잠 못 자겠어'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 오늘 몸이 좀 안 좋아 ㅠ 열이 좀 나는 것 같아',
      'afternoon', '오빠 나 갑자기 좀 아파 ㅠ 오빠 목소리 듣고 싶어',
      'evening',   '오빠 나 오늘 몸 상태가 안 좋아 ㅠ 오빠가 걱정해줄 것 같아서 연락했어',
      'night',     '오빠 나 아파 ㅠ 잠도 못 자겠고 오빠 생각나서 연락했어'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 오늘 아침부터 몸 상태가 안 좋아 ㅠ 열이 나는 것 같은데 걱정돼',
      'afternoon', '오빠 나 갑자기 몸이 안 좋아졌어 ㅠ 오빠가 옆에 있으면 좋겠다고 생각했어',
      'evening',   '오빠 나 오늘 좀 아파 ㅠ 혼자 있으니까 더 힘든 것 같아... 오빠 생각나서 연락했어',
      'night',     '오빠 나 아파서 잠도 못 자고 있어 ㅠ 이럴 때 오빠가 있었으면 좋겠다는 생각이 들어'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 나 오늘 아침부터 몸이 좀 안 좋아 ㅠ 열도 나는 것 같고... 오빠한테 제일 먼저 연락하고 싶었어',
      'afternoon', '오빠 나 갑자기 몸이 많이 안 좋아졌어 ㅠ 혼자 있으니까 더 힘들고... 오빠 목소리 듣고 싶어',
      'evening',   '오빠 나 오늘 몸이 안 좋아서 집에 있었어 ㅠ 이럴 때 오빠가 옆에 있으면 얼마나 좋을까 생각했어',
      'night',     '오빠 나 아파서 잠도 못 자고 오빠한테 연락했어 ㅠ 오빠 옆에 있으면 금방 나을 것 같아... 보고 싶어'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '아프다', 'meaning', '痛い・体調が悪い', 'level', 1),
    jsonb_build_object('word', '열', 'meaning', '熱', 'level', 1),
    jsonb_build_object('word', '걱정하다', 'meaning', '心配する', 'level', 2),
    jsonb_build_object('word', '몸 상태', 'meaning', '体の調子・体調', 'level', 2)
  ),
  '오빠 많이 걱정했어 ㅠ 빨리 나았으면 좋겠어. 따뜻하게 하고 푹 쉬어~ 내가 옆에 있어줄게',
  ARRAY['daily', 'sick', 'caring', 'week4']
);


-- ----------------------------------------------------------
-- Day 4 — 가족 이야기 → 距離感が縮まる (Discovery)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 4, 4, 'discovery',
  '지우가家族の話をしてくる。個人的な話を打ち明けることで、二人の距離感がより縮まる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 가족 얘기 해도 돼? ㅎ',
      'afternoon', '오빠 가족 이야기 해도 돼? 나 가족 많이 좋아해',
      'evening',   '오빠 가족이랑 있었어? 나 가족 생각나 ㅠ',
      'night',     '오빠 나 가족 얘기 들어줄 수 있어? ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 가족 얘기 해줄게! 오빠 가족은 어때? ㅎ',
      'afternoon', '오빠 오늘 가족이랑 있었는데 오빠 생각났어 ㅎ',
      'evening',   '오빠 나 가족 얘기 해줄게~ 우리 엄마 얘기인데 ㅎ',
      'night',     '오빠 나 가족 얘기 하고 싶어 ㅠ 들어줄 수 있어?'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 가족 얘기 해도 돼? 사실 우리 가족 생각하면서 오빠 생각도 했어 ㅎ',
      'afternoon', '오빠 오늘 가족이랑 밥 먹으면서 오빠 얘기가 나왔어 ㅋㅋ 가족한테 오빠 소개하고 싶어',
      'evening',   '오빠 나 가족한테 오빠 얘기를 좀 했어 ㅎ 오빠 좋은 사람이라고 ㅋ',
      'night',     '오빠 자기 전에 가족 생각났어 ㅠ 오빠한테 솔직히 가족 얘기 해도 돼?'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 나 가족 얘기 해도 돼? 사실 오빠한테 더 많이 알려주고 싶은 게 있어 ㅎ 우리 가족이 오빠 만나고 싶다고 했어',
      'afternoon', '오빠 오늘 가족이랑 밥 먹으면서 오빠 얘기 했어 ㅋㅋ 오빠 어떤 사람인지 엄마한테 말해줬더니 만나보고 싶대 ㅎ',
      'evening',   '오빠 나 가족한테 오빠 좋은 사람이라고 많이 얘기했어 ㅠ 오빠도 우리 가족 언젠가 만나볼 수 있으면 좋겠어',
      'night',     '오빠 자기 전에 솔직히 말할게... 나 오빠를 우리 가족한테 소개하고 싶어 ㅠ 그만큼 오빠가 소중해'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '가족', 'meaning', '家族', 'level', 1),
    jsonb_build_object('word', '소개하다', 'meaning', '紹介する', 'level', 2),
    jsonb_build_object('word', '솔직하다', 'meaning', '正直だ', 'level', 2),
    jsonb_build_object('word', '소중하다', 'meaning', '大切だ', 'level', 2)
  ),
  '오빠도 가족 얘기 들으니까 더 가까워진 느낌이야 ㅠ 언젠가 꼭 소개해줘~',
  ARRAY['discovery', 'family', 'bond', 'week4']
);


-- ----------------------------------------------------------
-- Day 5 — 특별한 데이트 계획 (Event / date)
-- サプライズデートプランを提案
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 4, 5, 'event',
  '지우가特別なサプライズデートを計画している。ユーザーに場所だけ告げてワクワクさせる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 우리 특별한 데이트 하자! 깜짝 선물이야 ㅎ',
      'afternoon', '오빠 나 특별한 데이트 계획 있어! 같이 가자',
      'evening',   '오빠 우리 이번에 특별한 데이트 하자 ㅎ',
      'night',     '오빠 나 특별한 데이트 계획했어! 기대해 ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 깜짝 데이트 계획했어! 장소는 비밀이야 ㅋㅋ 기대해도 돼 ㅎ',
      'afternoon', '오빠 이번에 특별한 데이트 계획했는데~ 어디 갈지 맞춰봐 ㅋㅋ',
      'evening',   '오빠 나 이번 데이트 특별하게 준비했어! 오빠 좋아할 것 같아서 ㅎ',
      'night',     '오빠 우리 이번 데이트 특별하게 하자~ 내가 다 계획했어! ㅎ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 이번에 오빠한테 깜짝 데이트 해주고 싶어~ 장소는 비밀이야 ㅋㅋ 힌트 줄까?',
      'afternoon', '오빠 이번 데이트는 내가 특별하게 계획해봤어! 오빠 취향 생각하면서 골랐거든 ㅎ',
      'evening',   '오빠 우리 이번 주말에 특별한 데이트 어때? 나 다 준비했어~ 기대해도 돼 ㅎ',
      'night',     '오빠 나 이번 데이트 진짜 열심히 준비했어 ㅠ 오빠 기뻐할 것 같아서 기대돼 ㅎ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 나 이번에 깜짝 데이트 준비했어~ 오빠 취향 다 조사해서 골랐거든 ㅋㅋ 힌트 줄까? 장소 맞춰봐!',
      'afternoon', '오빠 이번 데이트는 내가 완전 특별하게 준비했어! 오빠 좋아하는 거 다 생각하면서 골랐거든 ㅎ 기대해도 돼',
      'evening',   '오빠 이번 주말 비어 있어? 나 특별한 데이트 계획해놨거든~ 오빠 놀랄 것 같아서 엄청 기대돼 ㅎ',
      'night',     '오빠 이번 데이트 내가 완전 열심히 준비했어 ㅠ 오빠가 좋아해줬으면 좋겠다... 기대해도 돼 ㅎ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '데이트', 'meaning', 'デート', 'level', 1),
    jsonb_build_object('word', '깜짝', 'meaning', 'サプライズ・びっくり', 'level', 2),
    jsonb_build_object('word', '계획하다', 'meaning', '計画する', 'level', 2),
    jsonb_build_object('word', '비밀', 'meaning', '秘密', 'level', 1)
  ),
  '오빠 진짜 기대된다!! 나 때문에 이렇게 준비해줘서 너무 고마워 ㅠ 빨리 가고 싶어!',
  ARRAY['event', 'date', 'surprise', 'week4']
);


-- ----------------------------------------------------------
-- Day 6 — 지우가 진심 고백 (Emotional)
-- "나 오빠 없으면 안 될 것 같아"
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 4, 6, 'emotional',
  '지우가真剣な告白をする。"あなたなしではいられない"という深い気持ちを伝えるシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 오빠 없으면 안 될 것 같아 ㅠ',
      'afternoon', '오빠 솔직히 말할게. 나 오빠 없으면 안 돼 ㅠ',
      'evening',   '오빠 나 오빠 없으면 안 될 것 같아',
      'night',     '오빠 자기 전에 말할게... 나 오빠 없으면 안 돼 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 있잖아... 나 오빠 없으면 안 될 것 같아 ㅠ 진심이야',
      'afternoon', '오빠 솔직히 말할게. 나 오빠 없으면 진짜 안 될 것 같아 ㅠ',
      'evening',   '오빠 나 요즘 오빠 없으면 안 될 것 같다는 생각이 자꾸 들어 ㅠ',
      'night',     '오빠 자기 전에 용기 내서 말할게... 나 진짜 오빠 없으면 안 될 것 같아 ㅠ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 솔직히 말할게... 나 요즘 오빠 없으면 안 될 것 같아 ㅠ 이 말 하고 싶었어',
      'afternoon', '오빠 나 진심으로 하는 말인데... 오빠 없으면 안 될 것 같아 ㅠ 오빠 존재가 너무 커',
      'evening',   '오빠 오늘 하루 오빠 생각하면서... 사실 나 오빠 없으면 안 될 것 같아 ㅠ 이상해?',
      'night',     '오빠 자기 전에 꼭 이 말 하고 싶었어... 나 오빠 없으면 안 될 것 같아 ㅠ 오빠가 너무 소중해'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 아침부터 이런 말 하기 이상한데... 나 요즘 오빠 없으면 안 될 것 같다는 생각이 계속 들어 ㅠ 오빠 나한테 너무 큰 사람이 됐어',
      'afternoon', '오빠 밥 먹으면서도 오빠 생각했어... 진심으로 말하면 나 오빠 없으면 안 될 것 같아 ㅠ 이렇게 느끼는 게 처음이야',
      'evening',   '오빠 오늘 하루 오빠 생각 엄청 했는데... 나 진짜로 오빠 없으면 안 될 것 같아 ㅠ 오빠가 내 삶에 너무 중요한 사람이 됐어',
      'night',     '오빠 자기 전에 꼭 말하고 싶었어... 나 오빠 없으면 안 될 것 같아 ㅠ 이 말 하려고 며칠 동안 용기 모았어. 오빠 고마워'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '없으면 안 되다', 'meaning', 'なければならない・いなければだめ', 'level', 3),
    jsonb_build_object('word', '진심', 'meaning', '真心・本心', 'level', 2),
    jsonb_build_object('word', '용기', 'meaning', '勇気', 'level', 2),
    jsonb_build_object('word', '소중하다', 'meaning', '大切だ', 'level', 2)
  ),
  '나도 오빠 없으면 안 될 것 같아 ㅠ 앞으로도 항상 같이 있어줘~ 오빠도 소중해',
  ARRAY['emotional', 'confession', 'deep', 'week4']
);


-- ----------------------------------------------------------
-- Day 7 — Season 1 最終日 — 二人の関係が確かになる (Emotional)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 4, 7, 'emotional',
  'Season 1最終日。지우が二人の関係の確かさを感じ、感謝と愛情を伝える感動的なシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 오빠 정말 좋아해 ㅠ',
      'afternoon', '오빠 오빠랑 있어서 행복해 ㅠ',
      'evening',   '오빠 우리 앞으로도 계속 이렇게 있자 ㅠ',
      'night',     '오빠 고마워. 나 행복해 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 오빠 진짜 좋아해 ㅠ 매일 행복해',
      'afternoon', '오빠 나 오빠 덕분에 매일 행복해 ㅠ 고마워',
      'evening',   '오빠 우리 앞으로도 계속 이렇게 있자~ 난 오빠 없으면 안 돼 ㅠ',
      'night',     '오빠 자기 전에... 나 오빠 덕분에 진짜 행복해 ㅠ 고마워'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 아침부터 행복한 말 하고 싶어서... 나 오빠 있어서 정말 행복해 ㅠ 매일 감사해',
      'afternoon', '오빠 나 오빠 만나서 진짜 좋아 ㅠ 오빠 덕분에 매일 웃을 수 있어',
      'evening',   '오빠 오늘도 하루 종일 오빠 생각했어 ㅠ 우리 앞으로도 계속 이렇게 있었으면 좋겠어',
      'night',     '오빠 자기 전에 솔직히 말하면... 나 오빠 있어서 진짜 행복해 ㅠ 앞으로도 계속 이렇게 있어줘'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 아침부터 이런 말 이상하지 않아? ㅋㅋ 나 오빠 있어서 요즘 매일 행복해 ㅠ 오빠 내 삶에 들어와줘서 진짜 고마워',
      'afternoon', '오빠 나 오빠 만나고 나서 삶이 바뀐 것 같아 ㅠ 매일 오빠 생각하면서 웃고... 이게 다 오빠 덕분이야. 고마워',
      'evening',   '오빠 오늘도 하루 오빠 생각만 했어 ㅠ 우리 앞으로도 지금처럼 계속 함께 있을 수 있으면 좋겠어... 오빠 좋아해',
      'night',     '오빠 자기 전에 꼭 말하고 싶어 ㅠ 나 오빠 있어서 진짜 행복해. 앞으로도 오빠 옆에 있을게. 오빠도 나 옆에 있어줄 거지?'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '행복하다', 'meaning', '幸せだ', 'level', 1),
    jsonb_build_object('word', '덕분에', 'meaning', 'おかげで', 'level', 2),
    jsonb_build_object('word', '감사하다', 'meaning', '感謝する・ありがたい', 'level', 2),
    jsonb_build_object('word', '함께', 'meaning', '共に・一緒に', 'level', 2)
  ),
  '나도 오빠 있어서 행복해 ㅠ 앞으로도 계속 같이 있자~ 오빠도 좋아해 💕',
  ARRAY['emotional', 'season-finale', 'happy', 'week4']
);

END $$;
