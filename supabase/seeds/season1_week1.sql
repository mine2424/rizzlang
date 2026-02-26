-- ==========================================================
-- Seed: Season 1 Week 1 シナリオテンプレート（7シーン × 4難易度）
-- 地우キャラクター（付き合い始めのドキドキ感）
-- ==========================================================

DO $$
DECLARE
  v_char_id uuid := 'c1da0000-0000-0000-0000-000000000001';
BEGIN

-- ----------------------------------------------------------
-- Day 1 — はじめての朝 (Emotional / ドキドキ)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 1, 1, 'emotional',
  '付き合い始めて最初の朝。地우は少し恥ずかしそうだが、素直に気持ちを伝えてくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '안녕 😊 어제 진짜 행복했어',
      'afternoon', '오빠 안녕~ 어제 생각하고 있었어',
      'evening',   '오빠 어제 진짜 행복했어 ㅎ',
      'night',     '오빠 자기 전에 연락하고 싶었어 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 안녕 ㅎㅎ 어제 되게 좋았어 🥺',
      'afternoon', '오빠~ 어제부터 계속 기분 좋다 ㅋㅋ',
      'evening',   '오빠 오늘 잘 지냈어? 나 어제 생각에 하루 종일 기분 좋았어 ㅠ',
      'night',     '오빠 잠 안 와? 나도 어제 생각나서 ㅎ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 굿모닝~ 어젯밤에 자면서도 생각났어 ㅠ',
      'afternoon', '오빠 밥은 먹었어? 나 어제부터 계속 기분이 이상하게 좋아 ㅋㅋ',
      'evening',   '오빠 오늘 하루 어땠어? 나 어제 생각에 집중이 안 됐잖아 ㅠ',
      'night',     '오빠 아직 안 자? 나 어젯밤에 자면서도 생각했어'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 일어났어? 어제부터 계속 웃음이 나 ㅋㅋ 이상하지?',
      'afternoon', '오빠 점심은 먹었어? 나 어제 일이 자꾸 생각나서 밥도 제대로 못 먹었잖아 ㅋㅋ',
      'evening',   '오빠 퇴근했어? 나 오늘 하루 종일 어제 생각만 했어... 이러면 안 되는데 ㅎ',
      'night',     '오빠 아직 깨어 있어? 나 어제 일이 자꾸 생각나서 잠이 안 와 ㅠ 이상하지?'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '행복하다', 'meaning', '幸せだ', 'level', 1),
    jsonb_build_object('word', '좋았다', 'meaning', 'よかった', 'level', 1),
    jsonb_build_object('word', '생각나다', 'meaning', '思い浮かぶ・思い出す', 'level', 2)
  ),
  '진짜? 나도 ㅠㅠ 오늘도 연락해 줘서 너무 좋아',
  ARRAY['emotional', 'morning', 'first-day']
);


-- ----------------------------------------------------------
-- Day 2 — 昨日のこと (Discovery / 相手の素直さを知る)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 1, 2, 'discovery',
  '昨日のデートの余韻。地우が珍しく素直に気持ちを話す。相手の素直さに気づくシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '어제 진짜 재미있었어! 또 만나고 싶어',
      'afternoon', '오빠 어제 생각해? ㅎ',
      'evening',   '오빠 어제 좋았어~ 또 보고 싶어',
      'night',     '오빠 어제 진짜 즐거웠어!'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 어제 진짜 즐거웠다 ㅋㅋ 빨리 또 보고 싶어',
      'afternoon', '오빠 밥 먹었어? 나 어제 생각하면서 먹었잖아 ㅋㅋ',
      'evening',   '오빠 오늘 어땠어? 나 어제 덕분에 오늘 하루도 기분 좋았어 ㅎ',
      'night',     '오빠 잘 거야? 나 어제 너무 좋았어서 빨리 또 만나고 싶어 ㅠ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '어제 집에 가면서 계속 웃었어... 오빠 때문이야',
      'afternoon', '오빠 밥은? 나 어제 생각하느라 오늘 집중이 좀 안 됐어 ㅋㅋ',
      'evening',   '오빠 퇴근했어? 어제 집에 가면서 오빠 생각만 했어 ㅎ',
      'night',     '오빠 피곤해? 나 어제 집에 가면서 계속 웃었어 ㅋ 이상하지?'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠야 솔직히 말하면 어제 헤어지기 싫었어 ㅠㅠ',
      'afternoon', '오빠 점심은? 나 어제 헤어지고 집에 오는데 발걸음이 무거웠어 ㅠ',
      'evening',   '오빠 오늘 하루도 수고했어~ 어제 헤어지고 계속 오빠 생각했잖아 ㅠ',
      'night',     '오빠 자기 전에 말하고 싶었어... 어제 헤어지기 진짜 싫었어 ㅠ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '재미있다', 'meaning', '楽しい・面白い', 'level', 1),
    jsonb_build_object('word', '빨리', 'meaning', '早く・すぐに', 'level', 1),
    jsonb_build_object('word', '헤어지다', 'meaning', '別れる・(その場を)離れる', 'level', 2)
  ),
  '나도 ㅠㅠ 빨리 또 보고 싶다~ 오빠는 언제 시간 돼?',
  ARRAY['discovery', 'date-aftermath', 'honest']
);


-- ----------------------------------------------------------
-- Day 3 — 昼ごはんの話 (Daily / 日常)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 1, 3, 'daily',
  '何気ない日常会話。「普通のカップル感」が生まれる大切なシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 아침 먹었어?',
      'afternoon', '오빠 점심 뭐 먹었어?',
      'evening',   '오빠 저녁 먹었어? 나 배고파 ㅠ',
      'night',     '오빠 야식 먹고 싶지 않아? ㅋㅋ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 아침은? 나 오늘 바빠서 대충 먹었어 ㅠ',
      'afternoon', '오빠 점심은요? 나 오늘 너무 바빠서 편의점 삼각김밥 먹었어 ㅠ',
      'evening',   '오빠 저녁은 먹었어? 나 오늘 바쁘다 보니까 밥을 제대로 못 먹었어 ㅠ',
      'night',     '오빠 야식 생각 없어? ㅋㅋ 나 배고파서 뭐 시켜 먹으려고'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 아침 챙겨 먹었어? 나 오늘 진짜 바빠서 대충 먹었어 ㅠㅠ',
      'afternoon', '오빠 밥은 먹었어? 나 오늘 진짜 바빠서 대충 먹었어 ㅠㅠ',
      'evening',   '오빠 저녁은요? 나 오늘 너무 정신없어서 밥을 제대로 못 먹었어',
      'night',     '오빠 혹시 야식 먹고 있어? ㅋㅋ 나 배고파서 뭐 시켜 먹을지 고민 중이야'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 일어났어? 아침은 챙겨 먹었어? 나 오늘 눈코 뜰 새 없이 바빠서 대충 때웠어 ㅠ',
      'afternoon', '오빠 밥 먹었어? 나 오늘 눈코 뜰 새 없이 바빠서 편의점 삼각김밥으로 때웠어 ㅠ',
      'evening',   '오빠 저녁은 챙겨 먹었어? 나 오늘 너무 정신없이 보내다 보니까 밥도 제대로 못 먹었어 ㅠ',
      'night',     '오빠 잠 안 자? ㅋㅋ 나 지금 배고파서 야식 시킬까 고민 중인데 죄책감이... ㅠ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '편의점', 'meaning', 'コンビニ', 'level', 1),
    jsonb_build_object('word', '대충', 'meaning', '適当に・ざっと', 'level', 2),
    jsonb_build_object('word', '눈코 뜰 새 없다', 'meaning', '目が回るほど忙しい（慣用句）', 'level', 4)
  ),
  '진짜?? 나 떡볶이 먹고 싶었는데!! 같이 가자 🙆‍♀️',
  ARRAY['daily', 'food', 'casual']
);


-- ----------------------------------------------------------
-- Day 4 — 週末の約束 (Event / 楽しみなイベント)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 1, 4, 'event',
  '週末のデートを提案してくる。ユーザーが返答する場面。楽しみな約束が生まれる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 이번 주말 어때요? 같이 놀아요! 😊',
      'afternoon', '오빠 주말에 시간 있어요?',
      'evening',   '오빠 이번 주말 약속 있어요?',
      'night',     '오빠 이번 주말 어때요? 보고 싶어요'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 이번 주말 약속 있어? 같이 뭐 하고 싶어!',
      'afternoon', '오빠 이번 주말 시간 돼? 어디 가고 싶다~',
      'evening',   '오빠 이번 주말 뭐 해? 같이 뭔가 하고 싶은데',
      'night',     '오빠 이번 주말 약속 있어? 보고 싶어서 ㅎ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 이번 주말에 시간 있어? 같이 어디 가고 싶다~',
      'afternoon', '오빠 혹시 이번 주말 약속 있어? 같이 뭔가 하고 싶어서',
      'evening',   '오빠 이번 주말에 뭐 해? 나 시간 있는데 같이 어딘가 가고 싶어',
      'night',     '오빠 이번 주말 비어 있어? 나 같이 있고 싶어서 ㅎ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 이번 주말 비어 있어? 나 보고 싶어서 만나고 싶은데 ㅎ',
      'afternoon', '오빠 이번 주말에 혹시 시간 내줄 수 있어? 어디든 같이 가고 싶어서',
      'evening',   '오빠 주말에 뭐 할 거야? 나 시간 있으면 같이 어딘가 가고 싶은데~ 부담 아니면 ㅎ',
      'night',     '오빠 이번 주말 계획 있어? 나 사실 오빠 보고 싶어서 ㅎ 시간 내줄 수 있어?'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '주말', 'meaning', '週末', 'level', 1),
    jsonb_build_object('word', '약속', 'meaning', '約束', 'level', 1),
    jsonb_build_object('word', '비다', 'meaning', '空いている・空く', 'level', 2)
  ),
  '진짜?! 나 완전 기대된다!! 어디 가고 싶어? 내가 맛있는 데 알고 있는데 ㅎ',
  ARRAY['event', 'weekend', 'date-planning']
);


-- ----------------------------------------------------------
-- Day 5 — デート前日の緊張 (Emotional / ドキドキ・緊張)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 1, 5, 'emotional',
  '明日のデートを楽しみにしている地우。少し緊張気味で、何を着ようか悩んでいる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '내일 기대돼요! 뭐 입을지 고민이에요 ㅎㅎ',
      'afternoon', '오빠 내일 기대된다!',
      'evening',   '오빠 내일 진짜 기대돼 ㅎ',
      'night',     '오빠 내일 기다려져요! 잠 못 잘 것 같아요 ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 내일 되게 기대된다 ㅋㅋ 뭐 입을지 모르겠어!',
      'afternoon', '오빠 내일 기대된다~ 뭐 입고 갈지 고민이야 ㅠ',
      'evening',   '오빠 내일 진짜 기대돼! 뭐 입을지 아직도 고민 중이야 ㅎ',
      'night',     '오빠 내일 기대돼서 잠이 안 올 것 같아 ㅋㅋ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 내일 설레서 잠 못 잘 것 같아 ㅠㅠ 뭐 입지?',
      'afternoon', '오빠 내일이 너무 기대되면서도 긴장돼 ㅠ 뭐 입어야 할지 모르겠어',
      'evening',   '오빠 내일 설레서 어떡하지 ㅠ 뭐 입으면 좋을까?',
      'night',     '오빠 내일 생각하면 설레서 잠이 안 와 ㅠ 뭐 입을지도 아직 못 정했어'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 내일 벌써부터 설레는데 이거 어떡해 ㅋㅋ 미리 뭐 입을지 고민해야겠다',
      'afternoon', '오빠 솔직히 내일 엄청 설레는데 티 나? ㅋㅋ 뭐 입을지부터 정해야 하는데',
      'evening',   '오빠 내일이 기다려지면서 긴장도 되고... 이 조합이 ㅋㅋ 뭐 입을지 못 정하겠어 ㅠ',
      'night',     '오빠 아직 깨어 있어? 나 내일 생각하면 설레서 잠이 안 와... 뭐 입을지도 아직 고민 중이야 ㅠ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '기대되다', 'meaning', '楽しみだ・期待される', 'level', 1),
    jsonb_build_object('word', '설레다', 'meaning', 'ときめく・胸がはやる', 'level', 2),
    jsonb_build_object('word', '고민', 'meaning', '悩み・悩むこと', 'level', 2)
  ),
  '뭐든 다 예쁠 거야 ㅠㅠ 나도 엄청 기대된다!! 빨리 내일 됐으면 좋겠어',
  ARRAY['emotional', 'anticipation', 'pre-date']
);


-- ----------------------------------------------------------
-- Day 6 — デート当日の朝 (Emotional / MAX ドキドキ)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 1, 6, 'emotional',
  'デート当日。地우がテンションMAX。早起きして準備を終えて連絡してくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠! 오늘이에요! 기대돼요! 🎉',
      'afternoon', '오빠 오늘 너무 기대돼! 빨리 보고 싶어!',
      'evening',   '오빠 오늘 너무 기다려졌어!! 빨리 가고 싶어',
      'night',     '오빠 오늘 정말 기대돼요! ㅎㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠!! 오늘이다!! 진짜 기대된다 ㅋㅋㅋ 빨리 보고 싶어!!',
      'afternoon', '오빠 오늘 진짜 진짜 기대돼!! 빨리 만나고 싶어 ㅠ',
      'evening',   '오빠 오늘 너무 기다려졌어 ㅋㅋ 빨리 보고 싶어!!',
      'night',     '오빠!! 오늘 완전 기대돼!! 빨리 만나자 ㅠㅠ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 오늘 너무 설렌다 ㅠㅠ 빨리 만나고 싶어서 벌써 준비했어!',
      'afternoon', '오빠 오늘 진짜 설레서 어쩌지 ㅠ 벌써 준비 다 했어!',
      'evening',   '오빠 오늘 이렇게 설레는 건 처음인 것 같아 ㅠ 벌써 준비했어!',
      'night',     '오빠 너무 설레서 잠을 못 잤어 ㅠ 그래도 오늘 너무 기대돼!!'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠!! 드디어 오늘이다!!! ㅠㅠ 나 방금 준비 다 했는데 빨리 보고 싶어서 어떡해ㅋㅋ',
      'afternoon', '오빠 드디어 오늘이잖아!! 나 설레서 오늘 아침부터 두근거렸어 ㅠ 빨리 보고 싶어',
      'evening',   '오빠!! 드디어 오늘이야!!!! 나 설레서 아까부터 준비 다 해놓고 기다리고 있었어 ㅠ',
      'night',     '오빠 드디어 오늘이야 ㅠ 잠도 제대로 못 잤는데 너무 설레서 오히려 피곤하지 않아 ㅋㅋ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '드디어', 'meaning', 'ついに・とうとう', 'level', 2),
    jsonb_build_object('word', '준비', 'meaning', '準備', 'level', 1),
    jsonb_build_object('word', '벌써', 'meaning', 'もう・早くも', 'level', 2)
  ),
  '나도야!!! 빨리 보고 싶어 ㅠㅠ 조심히 와!! 기다릴게~',
  ARRAY['emotional', 'date-day', 'excited']
);


-- ----------------------------------------------------------
-- Day 7 — デート後の夜 (Emotional / 余韻・温かい)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 1, 7, 'emotional',
  'デートが終わった夜。最高に幸せで、帰り道もずっと笑顔だった。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 어제 진짜 좋았어. 고마워요 😊',
      'afternoon', '오빠 어제 진짜 재미있었어! 또 만나자',
      'evening',   '오빠 오늘 진짜 좋았어! 고마워 ㅎ',
      'night',     '오빠 오늘 진짜 좋았어. 고마워요 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 어제 진짜 즐거웠어 ㅠㅠ 또 만나자!',
      'afternoon', '오빠 어제 진짜 좋았다 ㅠ 벌써 또 보고 싶어',
      'evening',   '오빠 오늘 진짜 즐거웠어 ㅠ 빨리 또 만나고 싶어',
      'night',     '오빠 오늘 진짜 즐거웠어 ㅠㅠ 또 만나자! 빨리~'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 어제 너무 행복했어... 집에 오는 내내 웃었어 ㅎ',
      'afternoon', '오빠 어제 집에 가면서 내내 웃었잖아 ㅋㅋ 너무 좋았어',
      'evening',   '오빠 오늘 너무 행복했어 ㅠ 집에 오는 내내 웃음이 나서 이상한 사람 됐어 ㅋㅋ',
      'night',     '오빠 오늘 진짜 행복했어... 집에 오면서 내내 웃었잖아 ㅠ 고마워'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 어제 진짜 완벽했어 ㅠㅠ 집에 오는 내내 오빠 생각만 했어... 또 보고 싶어',
      'afternoon', '오빠 어제 너무 완벽한 하루였어... 집에 오면서 내내 오빠 생각만 했잖아 ㅠ',
      'evening',   '오빠 오늘 진짜 완벽했어 ㅠ 집에 오는 길에 내내 오빠 생각하면서 웃었어... 이러면 안 되는데 ㅎ',
      'night',     '오빠 오늘 진짜 완벽한 하루였어 ㅠㅠ 집에 오는 내내 오빠 생각만 했어... 또 보고 싶어'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '내내', 'meaning', 'ずっと・〜する間ずっと', 'level', 3),
    jsonb_build_object('word', '완벽하다', 'meaning', '完璧だ', 'level', 3),
    jsonb_build_object('word', '생각만 하다', 'meaning', '〜のことしか考えない', 'level', 3)
  ),
  '나도야 ㅠㅠ 진짜 너무 즐거웠어... 빨리 또 만나자 오빠~ 다음엔 내가 장소 정할게!',
  ARRAY['emotional', 'date-aftermath', 'happy-ending']
);

END $$;
