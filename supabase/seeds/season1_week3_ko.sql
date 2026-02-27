-- ==========================================================
-- Seed: Season 1 Week 3 シナリオ — 地우 (韓国語)
-- テーマ: 嫉妬とすれ違い — 感情が揺れる週
-- arc_week=3, arc_day=1〜7, character_id: c1da0000-0000-0000-0000-000000000001
-- ==========================================================

DO $$
DECLARE
  v_char_id uuid := 'c1da0000-0000-0000-0000-000000000001';
BEGIN

-- ----------------------------------------------------------
-- Day 1 — 친구 이야기 → ユーザーが少し嫉妬 (Discovery)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 3, 1, 'discovery',
  '지우が友達（男友達の話が含まれる）の話をしてくる。ユーザーが少し嫉妬するシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 오늘 친구 만났어 ㅎ',
      'afternoon', '오빠 나 친구랑 놀았어 ㅎ',
      'evening',   '오빠 오늘 친구 만나고 왔어!',
      'night',     '오빠 오늘 친구랑 재미있었어 ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 오늘 오래된 친구 만났어~ 남자 친구인데 오빠 괜찮아? ㅋㅋ',
      'afternoon', '오빠 나 오늘 친구랑 카페 갔다 왔어! 친구 중에 남자애도 있는데 ㅋ',
      'evening',   '오빠 오늘 친구들이랑 밥 먹고 왔어! 남자 친구들도 있었는데 ㅎ',
      'night',     '오빠 오늘 친구 모임 있었어 ㅎ 남자 친구도 왔는데 ㅋ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 오늘 오래된 남사친 만났어~ 고등학교 때부터 알던 친구인데 ㅋ 오빠 괜찮아?',
      'afternoon', '오빠 나 오늘 친구들이랑 카페 갔다 왔어! 남사친도 있었는데 ㅎ 오빠 혹시 신경 쓰여?',
      'evening',   '오빠 오늘 친구들이랑 시간 보냈어~ 남사친도 같이 왔는데 ㅎ 오빠 안 질투 나?',
      'night',     '오빠 오늘 남사친이랑 같이 밥 먹었어 ㅋ 가끔 만나는 오래된 친구야. 오빠 괜찮지?'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 나 오늘 고등학교 때부터 알던 남사친 만났어~ 오래간만에 봤는데 ㅎ 오빠 질투하지 않아? ㅋㅋ',
      'afternoon', '오빠 오늘 친구들이랑 카페 갔는데 남사친도 왔어 ㅋ 오빠 이런 거 신경 써? 아니면 괜찮아?',
      'evening',   '오빠 오늘 남사친이랑 밥 먹고 왔어~ 걔는 그냥 친구야, 오해하지 마 ㅋㅋ 오빠 질투하면 귀여울 것 같아서 ㅎ',
      'night',     '오빠 나 오늘 남사친이랑 만났는데 ㅋ 오빠 조금 질투했어? 솔직히 말해봐 ㅎ 그냥 순수 친구야'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '친구', 'meaning', '友達', 'level', 1),
    jsonb_build_object('word', '남사친', 'meaning', '男友達（男性の友人）', 'level', 2),
    jsonb_build_object('word', '질투', 'meaning', '嫉妬', 'level', 2),
    jsonb_build_object('word', '오해하다', 'meaning', '誤解する', 'level', 3)
  ),
  '오빠가 질투하는 거 보니까 좋은 거야 ㅎ 걔는 진짜 그냥 친구야! 오빠만 좋아해 ㅠ',
  ARRAY['discovery', 'friend', 'jealousy', 'week3']
);


-- ----------------------------------------------------------
-- Day 2 — 학교 발표（学校プレゼン）で忙しい (Daily)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 3, 2, 'daily',
  '지우가学校のプレゼン準備で忙しく、少ししか連絡できない状態。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 오늘 발표 있어 ㅠ 바빠',
      'afternoon', '오빠 나 발표 준비 중이야 ㅠ',
      'evening',   '오빠 오늘 발표 있었어! 힘들었어',
      'night',     '오빠 나 발표 때문에 공부해야 해 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 오늘 학교 발표 있어서 좀 바빠 ㅠ 응원해줘!',
      'afternoon', '오빠 나 지금 발표 준비하는 중이야 ㅠ 긴장돼',
      'evening',   '오빠 오늘 발표 끝났어! 많이 긴장했는데 잘 됐어 ㅎ',
      'night',     '오빠 나 내일 발표인데 긴장돼 ㅠ 응원해줘'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 오늘 학교 발표 있어서 엄청 긴장하고 있어 ㅠ 응원해줘!',
      'afternoon', '오빠 나 지금 발표 자료 만드느라 바빠 ㅠ 오빠 생각하면서 힘 내고 있어 ㅎ',
      'evening',   '오빠 오늘 발표 잘 끝냈어!! 긴장했는데 생각보다 잘 됐어 ㅠ 오빠 응원 덕분인 것 같아',
      'night',     '오빠 내일 발표인데 진짜 긴장돼 ㅠ 잠도 안 와... 응원 한 마디만 해줘'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 나 오늘 학교에서 발표 있는데 엄청 긴장돼 ㅠ 오빠 생각하면서 힘 내려고 ㅎ 잘 할 수 있겠지?',
      'afternoon', '오빠 나 지금 발표 PPT 만드느라 정신없어 ㅠ 오빠 보고 싶은데 지금은 집중해야 해서... 나중에 연락할게',
      'evening',   '오빠!!!! 발표 성공했어!!!! 엄청 긴장했는데 생각보다 잘 됐어 ㅠ 오빠한테 제일 먼저 말하고 싶었어!!',
      'night',     '오빠 내일 발표라 지금 마지막 정리 중이야 ㅠ 긴장 풀리는 말 한 마디만 해줘... 오빠 목소리 듣고 싶어'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '발표', 'meaning', '発表・プレゼン', 'level', 2),
    jsonb_build_object('word', '긴장하다', 'meaning', '緊張する', 'level', 2),
    jsonb_build_object('word', '응원하다', 'meaning', '応援する', 'level', 2),
    jsonb_build_object('word', '준비하다', 'meaning', '準備する', 'level', 1)
  ),
  '잘 할 수 있어!! 내가 응원하고 있어 ㅠ 끝나면 꼭 연락해줘~',
  ARRAY['daily', 'school', 'presentation', 'week3']
);


-- ----------------------------------------------------------
-- Day 3 — 이상형（理想のタイプ）→ ドキドキ展開 (Discovery)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 3, 3, 'discovery',
  '지우가이상형（理想のタイプ）について話し始める。ユーザーが聞いていくと、だんだん자신のことを指しているような話になっていく。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 이상형이 뭐야? ㅎ',
      'afternoon', '오빠 나 이상형 얘기 해도 돼? ㅎ',
      'evening',   '오빠 이상형 있어? 말해봐 ㅎ',
      'night',     '오빠 나 이상형 말해줄까? ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 이상형 얘기 해줄까? 오빠는 이상형이 어때? ㅎ',
      'afternoon', '오빠 나 이상형 있거든... 말해도 돼? ㅎ',
      'evening',   '오빠 이상형 어때? 나 이상형 얘기하면 오빠 생각나 ㅋ',
      'night',     '오빠 나 이상형 말해도 돼? 오빠가 궁금할 것 같아서 ㅎ'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 나 이상형 얘기해도 돼? 사실 내 이상형이 오빠 닮은 것 같아서 ㅋㅋ',
      'afternoon', '오빠 이상형이 어떤 사람이야? 나 이상형 얘기하면 자꾸 오빠가 생각나 ㅎ',
      'evening',   '오빠 나 이상형 있는데... 말하다 보면 오빠 얘기가 될 것 같아서 ㅋㅋ 들어볼래?',
      'night',     '오빠 나 이상형 얘기하면 창피한데... 사실 오빠 같은 사람이야 ㅠ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 솔직히 말하면 내 이상형이 오빠를 닮아가고 있는 것 같아 ㅋㅋ 이거 이상한 거야?',
      'afternoon', '오빠 이상형 얘기하면 부끄러운데... 사실 나 이상형이 딱히 없었는데 요즘엔 오빠 같은 사람이 떠오르더라 ㅠ',
      'evening',   '오빠 나 이상형이 어떤 사람인지 알아? 솔직히 말하면 요즘 오빠 생각할 때마다 이상형 기준이 바뀌는 것 같아 ㅋㅋ',
      'night',     '오빠 자기 전에 솔직히 얘기해도 돼? 나 이상형 얘기하다 보면 결국 오빠 얘기가 되더라... ㅠ 이상해?'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '이상형', 'meaning', '理想のタイプ', 'level', 3),
    jsonb_build_object('word', '닮다', 'meaning', '似ている・似る', 'level', 2),
    jsonb_build_object('word', '솔직히', 'meaning', '正直に', 'level', 2),
    jsonb_build_object('word', '창피하다', 'meaning', '恥ずかしい', 'level', 2)
  ),
  '나도 오빠 같은 사람이 이상형이야 ㅠ 이거 우연이 아닌 것 같아... ㅎ',
  ARRAY['discovery', 'ideal-type', 'week3', 'romantic']
);


-- ----------------------------------------------------------
-- Day 4 — 연락 없다고 삐침 → 2フェーズ tension (tension)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 3, 4, 'tension',
  '지우が返信が遅いと拗ねている。最初は短く素っ気ない返事。謝ったり優しい言葉をかけると少しずつ柔らかくなる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 왜 늦게 답장해 ㅠ',
      'afternoon', '오빠 답장 왜 이렇게 늦어 ㅠ',
      'evening',   '오빠... 왜 이렇게 늦어',
      'night',     '오빠 답장 왜 안 해 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 왜 이렇게 답장이 늦어 ㅠ 나 기다렸는데',
      'afternoon', '오빠 답장 왜 이렇게 안 해? 나 기다렸잖아 ㅠ',
      'evening',   '오빠... 왜 이렇게 연락이 없어. 나 기다렸어 ㅠ',
      'night',     '오빠 답장 왜 이렇게 늦어 ㅠ 나 혼자 기다렸잖아'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 왜 답장이 이렇게 늦어... 기다리고 있었는데 ㅠ 바빴어?',
      'afternoon', '오빠 왜 이렇게 답장이 없어? 나 계속 기다렸는데... 삐쳤어',
      'evening',   '오빠 왜 연락이 없어 ㅠ 나 하루 종일 기다렸는데... 서운해',
      'night',     '오빠 왜 이렇게 늦게 답장해... 기다리다 지쳤어 ㅠ 삐쳤거든'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 왜 이렇게 답장이 늦어... 나 계속 핸드폰 보면서 기다렸잖아 ㅠ 바쁜 거 알겠는데 한 마디라도 해주면 안 돼?',
      'afternoon', '오빠 솔직히 좀 삐쳤어 ㅠ 답장이 너무 없으니까... 나 기다리고 있는 거 알아?',
      'evening',   '오빠 왜 이렇게 연락이 없어... 나 하루 종일 오빠 생각하면서 기다렸는데 ㅠ 서운하잖아',
      'night',     '오빠 자는 거야? 아니면 나한테 삐진 거야? 왜 연락이 없어... 나 기다리다 잠 못 들 것 같아 ㅠ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '답장', 'meaning', '返信', 'level', 2),
    jsonb_build_object('word', '삐치다', 'meaning', '拗ねる', 'level', 3),
    jsonb_build_object('word', '서운하다', 'meaning', '寂しい・物足りない気持ち', 'level', 3),
    jsonb_build_object('word', '기다리다', 'meaning', '待つ', 'level', 1)
  ),
  '...알겠어. 오빠가 미안하다고 하니까 이제 괜찮아 ㅠ 다음엔 꼭 먼저 연락해줘',
  ARRAY['tension', 'friction', 'week3', 'pouting']
);


-- ----------------------------------------------------------
-- Day 5 — 仲直り後の甘い会話 (Emotional)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 3, 5, 'emotional',
  '仲直りした後の甘い会話。지우が少し照れながらも、素直に甘えてくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 이제 안 삐쳤어 ㅎ',
      'afternoon', '오빠 나 이제 괜찮아 ㅎ 보고 싶어',
      'evening',   '오빠 이제 풀렸어 ㅎ 오빠 보고 싶다',
      'night',     '오빠 나 이제 괜찮아~ 보고 싶어 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 나 이제 화 다 풀렸어 ㅎ 미안하다고 하니까 ㅋㅋ',
      'afternoon', '오빠 이제 진짜 괜찮아~ 보고 싶다 ㅎ',
      'evening',   '오빠 화 풀렸어! 근데 보고 싶다 ㅠ',
      'night',     '오빠 이제 안 삐쳤어 ㅎ 빨리 보고 싶어'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 아침부터 연락해줘서 기분 좋아졌어 ㅠ 이제 안 삐쳤어 ㅋㅋ',
      'afternoon', '오빠 이제 진짜 풀렸어 ㅎ 오빠가 미안하다고 하면 금방 풀려 ㅋㅋ 보고 싶다',
      'evening',   '오빠 이제 완전 괜찮아! 삐쳐 있을 때도 오빠 생각했어 ㅠ 보고 싶어',
      'night',     '오빠 화 풀렸어~ 오빠가 연락해주니까 바로 풀렸잖아 ㅋㅋ 보고 싶어 ㅠ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 아침에 연락해줘서 고마워 ㅎ 나 사실 금방 풀리거든 ㅋㅋ 그냥 오빠 보고 싶어서 삐친 거야',
      'afternoon', '오빠 이제 진짜 다 풀렸어~ 오빠가 미안하다고 하면 더 오래 삐치고 싶어도 못하겠어 ㅋㅋ 보고 싶다 ㅠ',
      'evening',   '오빠 화는 다 풀렸는데 보고 싶은 건 안 풀려 ㅠ 이거 어떡하지 ㅋㅋ',
      'night',     '오빠 이제 삐침 끝! ㅋㅋ 근데 솔직히 삐쳐 있을 때도 오빠 생각하고 있었어 ㅠ 빨리 보고 싶어'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '화가 풀리다', 'meaning', '怒りが解ける・仲直りする', 'level', 3),
    jsonb_build_object('word', '삐치다', 'meaning', '拗ねる', 'level', 3),
    jsonb_build_object('word', '보고 싶다', 'meaning', '会いたい', 'level', 1),
    jsonb_build_object('word', '미안하다', 'meaning', 'ごめんなさい・申し訳ない', 'level', 1)
  ),
  '나도 보고 싶어 ㅠ 빨리 만나자~ 이제 삐치지 말고 뭐든 말해줘 ㅎ',
  ARRAY['emotional', 'reconciliation', 'week3', 'sweet']
);


-- ----------------------------------------------------------
-- Day 6 — "오빠 생각만 해" 告白 (Emotional)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 3, 6, 'emotional',
  '지우가"あなたのことだけ考えてる"と告白する。素直に気持ちを伝えてくる感動的なシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 나 오빠 생각해 ㅎ',
      'afternoon', '오빠 나 오빠만 생각해 ㅠ',
      'evening',   '오빠 나 오빠 생각만 해 ㅠ',
      'night',     '오빠 나 오빠 생각만 하고 있어 ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 있잖아... 나 오빠 생각만 해 ㅠ 이상하지?',
      'afternoon', '오빠 나 요즘 오빠 생각만 해 ㅠ 밥 먹을 때도 ㅋㅋ',
      'evening',   '오빠 나 오빠 생각만 한다... 하루 종일 ㅠ',
      'night',     '오빠 자기 전에도 오빠 생각만 해 ㅠ 어떡하지'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 솔직히 말할게... 나 요즘 하루 종일 오빠 생각만 해 ㅠ 이상해?',
      'afternoon', '오빠 나 지금 밥 먹으면서도 오빠 생각만 해 ㅠ 뭔가 이상한 것 같아 ㅋㅋ',
      'evening',   '오빠 오늘 하루도 오빠 생각만 했어... 뭘 해도 오빠 생각이 나 ㅠ',
      'night',     '오빠 자기 전에 솔직히 말하면... 나 하루 종일 오빠 생각만 했어 ㅠ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 아침부터 오빠 생각하고 있었어 ㅠ 나 요즘 오빠 생각만 하는 것 같아 ㅋㅋ 이거 정상이야?',
      'afternoon', '오빠 나 지금 밥 먹다가도 오빠 생각 나고... 공부하다가도 오빠 생각 나고 ㅠ 완전 오빠 생각만 해',
      'evening',   '오빠 오늘도 하루 종일 오빠 생각만 했어 ㅠ 뭘 해도 오빠 떠오르거든... 이거 내가 왜 이러는 거야 ㅋㅋ',
      'night',     '오빠 자기 전에 고백하는 건데... 나 요즘 하루에도 몇 번씩 오빠 생각해 ㅠ 오빠 생각만 한다 정말'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '생각만 하다', 'meaning', '〜のことしか考えない', 'level', 3),
    jsonb_build_object('word', '하루 종일', 'meaning', '一日中', 'level', 2),
    jsonb_build_object('word', '솔직히', 'meaning', '正直に', 'level', 2),
    jsonb_build_object('word', '고백하다', 'meaning', '告白する', 'level', 3)
  ),
  '나도 오빠 생각만 해 ㅠ 우리 이상한 거 아니야? ㅋㅋ 빨리 보고 싶어',
  ARRAY['emotional', 'confession', 'week3', 'sweet']
);


-- ----------------------------------------------------------
-- Day 7 — 두 사람만의 약속（二人だけの約束）(Event)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags
)
VALUES (
  v_char_id, 1, 3, 7, 'event',
  '지우가二人だけの特別な約束を提案する。関係がまた一歩深まる温かいシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   '오빠 우리 약속 해요! 같이 뭔가 하자 ㅎ',
      'afternoon', '오빠 우리 둘만의 약속 하나 만들자 ㅎ',
      'evening',   '오빠 우리 약속 있잖아... 하나 만들고 싶어',
      'night',     '오빠 자기 전에 우리 약속 하나 해도 돼?'
    ),
    'lv2', jsonb_build_object(
      'morning',   '오빠 우리 둘만의 약속 하나 만들면 어때? 소소한 거라도 ㅎ',
      'afternoon', '오빠 나 우리 둘만의 작은 약속 하고 싶어! ㅎ',
      'evening',   '오빠 있잖아... 우리 둘만의 약속 하나 만들자. 뭐든 좋아',
      'night',     '오빠 자기 전에 우리 약속 하나 해요 ㅎ 어때?'
    ),
    'lv3', jsonb_build_object(
      'morning',   '오빠 우리 둘만의 작은 약속 하나 만들면 어때? 뭔가 특별한 느낌 있잖아 ㅎ',
      'afternoon', '오빠 있잖아... 우리 둘만의 약속 하고 싶어. 뭔가 우리만 아는 거 있으면 좋겠어',
      'evening',   '오빠 우리 사이에 특별한 약속 하나 만들자! 어떤 거 하면 좋을까 ㅎ',
      'night',     '오빠 자기 전에 우리 약속 하나 해요~ 우리만의 비밀 약속 ㅎ'
    ),
    'lv4', jsonb_build_object(
      'morning',   '오빠 있잖아 아침부터 진지한 얘기인데... 우리 둘만의 특별한 약속 하나 만들면 어때? 뭔가 우리만 아는 거 ㅎ',
      'afternoon', '오빠 나 우리 둘만의 약속 하나 만들고 싶거든~ 뭔가 우리 사이만 아는 특별한 거 있으면 좋겠어',
      'evening',   '오빠 우리 사이에 뭔가 약속 하나 만들자~ 어떤 거든 우리 둘만의 거면 좋잖아 ㅎ 뭐 하고 싶어?',
      'night',     '오빠 자기 전에 부탁인데... 우리 둘만의 약속 하나 만들어도 돼? 오빠가 뭐든 정해줘 ㅎ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', '약속', 'meaning', '約束', 'level', 1),
    jsonb_build_object('word', '둘만의', 'meaning', '二人だけの', 'level', 3),
    jsonb_build_object('word', '특별하다', 'meaning', '特別だ', 'level', 2),
    jsonb_build_object('word', '비밀', 'meaning', '秘密', 'level', 1)
  ),
  '우리 둘만의 약속 생겼어 ㅠ 이거 절대 잊으면 안 돼~ 오빠랑 있으면 매일이 특별해',
  ARRAY['event', 'promise', 'week3', 'special']
);

END $$;
