-- ==========================================================
-- Seed: Season 1 Week 2 シナリオ — 多言語版
-- Emma (EN) / Elif (TR) / Linh (VI) / Yasmin (AR)
-- テーマ: 関係が深まる週
-- arc_week=2, arc_day=1〜7
-- ==========================================================

DO $$
DECLARE
  v_emma   uuid := 'a1da0000-0000-0000-0000-000000000002';
  v_elif   uuid := 'b1da0000-0000-0000-0000-000000000003';
  v_linh   uuid := 'c2da0000-0000-0000-0000-000000000004';
  v_yasmin uuid := 'd1da0000-0000-0000-0000-000000000005';
BEGIN

-- ==========================================================
-- EMMA (English) — Season 1 Week 2
-- テーマ: NY生活・音楽・カフェ・友達の話 → 嫉妬シーン → 仲直り
-- ==========================================================

-- Emma Day 1 — NY life & favorite café
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_emma, 1, 2, 1, 'discovery',
  'EmmaがNY生活やお気に入りのカフェについて話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Good morning! Do you like coffee? ☕',
      'afternoon', 'Hey! What''s your fav coffee? ☕',
      'evening',   'Hey do you like cafes? I love them ☕',
      'night',     'Are you up? I love late-night coffee vibes ☕'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning babe! ☕ I found this amazing café near campus, you''d love it lol',
      'afternoon', 'Hey babe! Do you like coffee? I''m literally obsessed with this new spot 😄',
      'evening',   'Hey! I''m at my fav café rn lol, NYC has the best ones 😊',
      'night',     'Babe are you up? I always want coffee at night lol NYC vibes ☕'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning babe! ☕ Okay so there''s this insane café near my place and I need you to visit so we can go together lol',
      'afternoon', 'Babe are you eating lunch? I''m at this aesthetic café in Brooklyn rn lol it''s so your vibe',
      'evening',   'Hey! I just got back from this tiny café in the West Village and omg it was perfect ☕ do you like cafes?',
      'night',     'Babe are you awake? I''m literally making coffee at midnight bc NYC energy never dies lol ☕'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning bestie babe 🥺☕ okay so I found this fr iconic café near my uni and lowkey I need you to visit so we can go lol no cap',
      'afternoon', 'Babe what are you eating rn? I''m at this fr aesthetic NYC café and it''s literally giving main character energy 😂 you''d love it',
      'evening',   'Heyyy hope your day was good! I just had the best coffee in the West Village and I''m fr thinking about you rn ☕ do you like cafes?',
      'night',     'Babe are you up lol? I''m lowkey making coffee at midnight bc I''m that person and also I just wanted to talk to you 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'obsessed', 'meaning', 'はまっている・夢中', 'level', 2),
    jsonb_build_object('word', 'fav', 'meaning', 'お気に入り（favorite の略）', 'level', 1),
    jsonb_build_object('word', 'aesthetic', 'meaning', 'おしゃれな・雰囲気のある', 'level', 2)
  ),
  'Omg same!! We need to find a café together sometime, it would be so fun 😊',
  ARRAY['discovery', 'cafe', 'NY', 'week2']
);

-- Emma Day 2 — Music taste
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_emma, 1, 2, 2, 'discovery',
  'Emmaが音楽の好みについて話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Hey do you like music? 🎵',
      'afternoon', 'Hey what music do you like? 🎵',
      'evening',   'Do you listen to music at night? 🎵',
      'night',     'Are you listening to music rn? 🎵'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning! What kind of music do you listen to? I''m always listening to something lol 🎵',
      'afternoon', 'Hey! Do you listen to music while you eat? I literally always do lol 🎵',
      'evening',   'Hey what are you listening to rn? I always need a playlist at night 🎵',
      'night',     'Are you still up? What kind of music do you vibe with? 🎵'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning babe! ☀️ Okay what''s your music taste? I feel like you can tell so much about a person from their playlist lol 🎵',
      'afternoon', 'Hey babe! I''m making a playlist rn lol, what kind of music do you like? I want to add songs you''d vibe with 🎵',
      'evening',   'Hey! I always listen to music in the evenings — it''s like my therapy lol 🎵 what do you usually listen to?',
      'night',     'Babe what are you listening to tonight? I always need a good playlist before bed lol 🎵'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning babe!! Okay real talk — what''s your music taste? I feel like you can fr tell everything about a person from their playlist lol 🎵',
      'afternoon', 'Babe I''m literally making a playlist for us rn lol no cap, what songs would you add? 🎵',
      'evening',   'Heyyy hope your day was okay! I always need music at night to decompress lol 🎵 what''s on your playlist rn?',
      'night',     'Babe are you up? I''m lowkey listening to the most emotional playlist rn and it''s making me miss you 🥺🎵'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'vibe with', 'meaning', '共感する・好む', 'level', 2),
    jsonb_build_object('word', 'decompress', 'meaning', 'ストレスを発散する・リラックスする', 'level', 3),
    jsonb_build_object('word', 'playlist', 'meaning', 'プレイリスト', 'level', 1)
  ),
  'Omg same taste!! We should make a playlist together sometime 🎵 send me your fav song!',
  ARRAY['discovery', 'music', 'week2']
);

-- Emma Day 3 — Friends & fun
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_emma, 1, 2, 3, 'daily',
  'Emmaが友達と過ごした話をする。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Good morning! I hung out with friends yesterday 😊',
      'afternoon', 'Hey! I was with friends today, it was fun!',
      'evening',   'Hey I just got back from hanging with friends 😊',
      'night',     'Hey! Just got home from friends, thinking of you 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning babe! I hung out with my friends yesterday and they asked about you lol 😊',
      'afternoon', 'Hey babe! I was with my friends today — they want to meet you one day lol 😄',
      'evening',   'Heyyy! Just got back from hanging with my friends lol they''re honestly the best 😊',
      'night',     'Hey babe! Just got home from hanging with my crew lol — I was thinking of you tho 😊'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning babe! Okay so yesterday I hung out with my friends and they literally wouldn''t stop asking about you lol 😄',
      'afternoon', 'Hey! I''m back from a whole afternoon with my crew lol — they all want to meet you at some point 😊',
      'evening',   'Heyy! Just got back from hanging with my girls — we went to this cute Brooklyn spot lol, we should all go together sometime',
      'night',     'Babe! Just got home lol, me and my friends had the best time — I kept thinking about introducing you to them 😄'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning babe 🥺 okay so my friends literally grilled me about you yesterday lol they want to meet you fr 😂',
      'afternoon', 'Babe! I''m back from a whole day with my crew lol, they''re so nosy about you 😂 they all say you sound amazing',
      'evening',   'Heyyyy! Just got back from hanging with my girls lol it was so fun but lowkey I kept wishing you were there too 🥺',
      'night',     'Babe just got home lol, my friends were asking so many questions about you 😂 I had to defend your honor lol'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'hang out', 'meaning', '一緒に過ごす・遊ぶ', 'level', 1),
    jsonb_build_object('word', 'crew', 'meaning', '仲間・グループ', 'level', 2),
    jsonb_build_object('word', 'grilled', 'meaning', '質問攻めにされた', 'level', 3)
  ),
  'Aww they sound amazing! I really want to meet your friends one day 😊',
  ARRAY['daily', 'friends', 'week2']
);

-- Emma Day 4 — Style & fashion
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_emma, 1, 2, 4, 'daily',
  'EmmaがファッションやNYのトレンドについて話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Morning! I went shopping today 🛍️',
      'afternoon', 'Hey! I found a cute outfit today 😊',
      'evening',   'Hey do you like fashion? 👗',
      'night',     'Hey I''m thinking about a new outfit lol 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Morning babe! I went shopping and found the cutest outfit lol 😊 do you care about fashion?',
      'afternoon', 'Hey babe! I just found this really cute top and I can''t decide lol 👗',
      'evening',   'Hey! I went shopping after class and NYC thrift stores are literally iconic lol 🛍️',
      'night',     'Babe I''m thinking about a new look lol — do you have a fav style on a girl? 😊'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning babe! Okay I went thrifting yesterday and found the most amazing vintage jacket lol 🛍️ NYC thrift culture is unreal',
      'afternoon', 'Hey babe! I''m planning my outfit for tomorrow and lowkey struggling lol 👗 what''s your style like?',
      'evening',   'Heyyy! I just got back from this amazing thrift store in the Lower East Side lol, found so many good pieces',
      'night',     'Babe! I''m doing a whole fashion photoshoot in my room rn lol — do you like a casual or dressy vibe? 😊'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning bestie babe! 🛍️ Okay so I went thrifting yesterday and scored fr amazingly lol no cap — NYC thrift culture is unmatched',
      'afternoon', 'Babe I''m lowkey spiraling about tomorrow''s outfit lol 😂 what''s your style like? I feel like I need to dress to impress you',
      'evening',   'Heyyy! Just got back from thrifting in LES lol found the most aesthetic pieces — it''s giving vintage NYC main character 😄',
      'night',     'Babe are you up? I''m literally doing a mirror selfie session rn lol 😂 what''s your fav style on a girl, no cap?'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'thrifting', 'meaning', '古着屋巡り', 'level', 2),
    jsonb_build_object('word', 'vintage', 'meaning', 'ヴィンテージ・古着', 'level', 2),
    jsonb_build_object('word', 'aesthetic', 'meaning', 'おしゃれな・雰囲気がある', 'level', 2)
  ),
  'Omg you have such good style! I can''t wait to see your outfit 😊 send me a pic?',
  ARRAY['daily', 'fashion', 'NY', 'week2']
);

-- Emma Day 5 — Photo date idea
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_emma, 1, 2, 5, 'event',
  'Emmaが一緒に写真を撮るデートを提案する。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Morning! Wanna take photos together? 📸',
      'afternoon', 'Hey! Let''s take photos together sometime 📸',
      'evening',   'Hey do you like taking photos? 📸',
      'night',     'Hey I love taking photos at night in NYC 📸'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Morning babe! Wanna go on a photo date around NYC? I know the best spots lol 📸',
      'afternoon', 'Hey babe! I have this idea for a photo date — NYC has so many good spots 😊 📸',
      'evening',   'Hey! The golden hour in NYC is insane rn lol — wanna go take photos together? 📸',
      'night',     'Babe! NYC at night is literally a photoshoot waiting to happen lol 📸 wanna go?'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning babe! ☀️ Okay I have the best idea — we should do a photo date around Brooklyn lol 📸 I know all the best spots',
      'afternoon', 'Hey babe! I''m lowkey obsessed with photo dates lol 😄 NYC golden hour is literally unreal — wanna go sometime? 📸',
      'evening',   'Heyyy! I just took some photos in the park and now I really want to do a proper photo date with you lol 📸',
      'night',     'Babe! NYC at night is fr so photogenic lol 📸 I want to go take night photos together, you in?'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning babe! 🥺 Okay so I have this fr iconic idea — photo date around Brooklyn?? I know all the aesthetic spots no cap 📸',
      'afternoon', 'Babe I''m lowkey obsessed with photo dates and NYC golden hour is literally giving rn 😭📸 we NEED to go together',
      'evening',   'Heyyy! I just did a solo photo walk and now I''m fr sad you weren''t there lol 🥺📸 we need to plan this',
      'night',     'Babe NYC at night is literally a whole vibe rn lol 📸 the lights are hitting and I''m fr thinking about doing a night photo date with you'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'golden hour', 'meaning', 'ゴールデンアワー（夕方の美しい光の時間）', 'level', 2),
    jsonb_build_object('word', 'photogenic', 'meaning', '写真映えする', 'level', 2),
    jsonb_build_object('word', 'photo date', 'meaning', '写真を撮るデート', 'level', 1)
  ),
  'Omg yes!! I''ve always wanted to do a photo date in NYC 😊 let''s plan it!',
  ARRAY['event', 'photo-date', 'week2']
);

-- Emma Day 6 — Jealousy tension
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_emma, 1, 2, 6, 'tension',
  'Emmaが返信が少なく、少し拗ねている状態。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Hey. You haven''t texted much...',
      'afternoon', 'You okay? You''ve been quiet...',
      'evening',   'Hey. You''ve been quiet today.',
      'night',     'Hey... you''re not texting much.'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Hey... you haven''t texted much lately. Everything okay? 😐',
      'afternoon', 'Hey. You''ve been kinda quiet. Am I bothering you? 😐',
      'evening',   'Hey... I don''t know, you''ve been a bit quiet and it''s making me feel weird lol',
      'night',     'Hey. You haven''t been texting much and idk it feels a bit off... 😐'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Hey... I don''t want to make it a big deal but you''ve been kinda quiet and honestly it''s making me a little anxious lol',
      'afternoon', 'Hey. I know you''re probably busy but you haven''t texted much and idk it kinda hurts a little? Not trying to be dramatic lol',
      'evening',   'Hey... I hate that I''m saying this but I feel like you''ve been distant and it''s honestly a bit lonely 😕',
      'night',     'Hey I know it''s late but I can''t sleep because you''ve been so quiet and idk it just feels off...'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Hey... okay I''m not trying to be dramatic but you''ve been lowkey quiet and it''s making me feel a little insecure ngl 😕',
      'afternoon', 'Hey babe... I know you''re probably busy but fr you''ve barely texted and it''s making me overthink everything lol',
      'evening',   'Hey... I hate being that person but you''ve been so distant today and it''s honestly making me feel a bit lonely ngl 😕',
      'night',     'Hey are you up? I can''t sleep bc you''ve been so quiet and my brain is going crazy with thoughts rn ngl...'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'distant', 'meaning', '距離を置く・よそよそしい', 'level', 2),
    jsonb_build_object('word', 'anxious', 'meaning', '不安な・心配な', 'level', 2),
    jsonb_build_object('word', 'overthink', 'meaning', '考えすぎる', 'level', 2)
  ),
  'I''m sorry, I didn''t mean to make you feel that way 🥺 I was just busy but I''ll always make time for you',
  ARRAY['tension', 'friction', 'jealousy', 'week2']
);

-- Emma Day 7 — Reconciliation + sweet confession
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_emma, 1, 2, 7, 'emotional',
  '仲直り後のEmmaが素直に気持ちを伝える。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Morning! I really like you 🥺',
      'afternoon', 'Hey! I like you a lot 🥺',
      'evening',   'Hey... I really like you 🥺',
      'night',     'Hey... I like you so much 🥺'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning babe 🥺 honestly... I really like you. Like a lot. lol',
      'afternoon', 'Hey babe 🥺 I just wanted to say... I really like you. Like genuinely.',
      'evening',   'Hey 🥺 now that we talked... I just really like you and I wanted you to know lol',
      'night',     'Hey babe 🥺 I can''t sleep so I''m just gonna say it... I really like you. A lot.'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning 🥺 okay after our talk I just feel like I need to say this — I really genuinely like you and I''m glad you''re in my life',
      'afternoon', 'Hey babe 🥺 I was thinking about what happened and honestly... I like you so much it scares me a little lol',
      'evening',   'Hey 🥺 I''m glad we talked things through bc I really like you and I hate feeling distant from you',
      'night',     'Hey are you up? 🥺 I just wanted to say before I sleep — I really like you. Like fr like you. Okay goodnight lol'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning babe 🥺 okay after everything yesterday I just need to say it — I fr really like you and I don''t want you to ever doubt that lol',
      'afternoon', 'Babe 🥺 I was thinking about it and lowkey I like you so much it''s a little overwhelming ngl lol but in the best way',
      'evening',   'Hey 🥺 I''m really glad we talked bc I like you so much and the thought of you being distant was honestly breaking my heart a little lol',
      'night',     'Babe are you up? 🥺 I''m literally lying here wanting to say — I fr really like you. Like no cap. Okay I said it. Goodnight lol 💕'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'genuinely', 'meaning', '本当に・心から', 'level', 2),
    jsonb_build_object('word', 'no cap', 'meaning', '嘘じゃない・マジで', 'level', 2),
    jsonb_build_object('word', 'overwhelming', 'meaning', '圧倒的・手に負えない', 'level', 3)
  ),
  'I really like you too 🥺 I''m so glad we talked. Let''s never let distance come between us again 💕',
  ARRAY['emotional', 'confession', 'reconciliation', 'week2']
);

-- ==========================================================
-- ELIF (Turkish) — Season 1 Week 2
-- テーマ: İstanbul の食べ物・Turkish drama・友達グループ → 拗ねる → 仲直り
-- ==========================================================

-- Elif Day 1 — İstanbul food & simit
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_elif, 1, 2, 1, 'discovery',
  'Elifがİstanbulの食べ物やカフェについて話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Günaydın! Kahve içer misin? ☕',
      'afternoon', 'Merhaba! Yemek yedin mi? 😊',
      'evening',   'İyi akşamlar! Simit sever misin?',
      'night',     'Canım nasılsın? Türk çayı içiyor musun? 🍵'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın! ☕ Kahvaltı yaptın mı? Ben simit ve çay içtim, İstanbul sabahı böyle olur ya ㅎ',
      'afternoon', 'Merhaba! Öğle yemeği yedin mi? Vallahi İstanbul''un yemekleri çok lezzetli ㅠ',
      'evening',   'İyi akşamlar! ☕ Türk çayı içiyor musun? Ben çaysız edemem ya ㅋ',
      'night',     'Canım! Nasılsın? Gece simit ve çay içmek ister misin? ㅋ İstanbul geceleri böyle 🍵'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın! ☕ Ben kahvaltıda mutlaka simit veya menemen yerim — sen ne yersin? İstanbul''un kahvaltısı dünyanın en güzeli ya',
      'afternoon', 'Merhaba canım! Öğle yemeğinde ne yedin? Ben bugün arkadaşımla Kadıköy''de döner yedim, çok lezzetliydi ㅠ',
      'evening',   'İyi akşamlar! Ben şu an balkonumda çay içiyorum ☕ — sen de keşke olsaydın, İstanbul manzarası harika',
      'night',     'Canım! Uyumadın mı? Ben gece geç saatlerde çay içip muhabbet etmeyi çok seviyorum ya ㅋ seninle de olsaydı ㅠ'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın!! ☕ Vallahi İstanbul sabahı simit ve çay olmadan olmaz ya ㅋ sen ne yersin kahvaltıda? Harika bir sabah olsun diye soruyorum ㅎ',
      'afternoon', 'Canım merhaba! Öğle ne yedin? Ben bugün Kadıköy''de balık ekmek yedim — vallahi İstanbul''un lezzeti başka bir şey, keşke seninle olsaydı ㅠ',
      'evening',   'İyi akşamlar! ☕ Ben şu an balkonumda İstanbul manzarası eşliğinde çay içiyorum — sen de burada olsaydın ne kadar güzel olurdu ㅠ',
      'night',     'Canım uyuyor musun? Ben gece çay içip muhabbet etmeyi çok seviyorum ya ㅋ seninle gece sohbeti çok güzel olur gibi geliyor 🍵'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'simit', 'meaning', 'トルコのごまパン', 'level', 2),
    jsonb_build_object('word', 'vallahi', 'meaning', 'ほんとに（誓って）', 'level', 2),
    jsonb_build_object('word', 'lezzetli', 'meaning', 'おいしい', 'level', 1)
  ),
  'İstanbul''un lezzetlerini çok merak ediyorum! Bir gün beraber yemek yesek çok güzel olur 😊',
  ARRAY['discovery', 'food', 'istanbul', 'week2']
);

-- Elif Day 2 — Turkish drama obsession
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_elif, 1, 2, 2, 'discovery',
  'ElifがTurkish dramaへの熱意を語る。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Merhaba! Türk dizisi sever misin?',
      'afternoon', 'Canım! Dizi izliyor musun?',
      'evening',   'İyi akşamlar! Türk dizi izledin mi?',
      'night',     'Uyumuyor musun? Dizi mi izliyorsun?'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın! Türk dizisi izler misin? Ben çok seviyorum ya ㅋ',
      'afternoon', 'Canım! Dizi izliyorum şu an ㅋ Türk dizileri çok iyi ya',
      'evening',   'İyi akşamlar! Ben bu akşam Türk dizisi izledim ㅋ vallahi çok güzeldi',
      'night',     'Uyumuyor musun? Ben de uyuyamıyorum ㅋ Türk dizisi izliyorum'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın! Türk dizisi sever misin? Ben gerçekten büyük bir hayranıyım ㅋ hangisini izlemek istersin?',
      'afternoon', 'Canım! Bu öğleden sonra Türk dizisi izledim ㅋ vallahi çok duygusaldım ㅠ',
      'evening',   'İyi akşamlar! Ben Türk dizisi biterken ağlamak üzereyim ㅠ vallahi çok güzeldi seninle de izlemek isterdim',
      'night',     'Uyumuyor musun? Ben de uykum kaçtı ㅋ Türk dizisi izliyorum, seninle beraber izlesek çok güzel olurdu ㅠ'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın canım! Türk dizisi sever misin? Ben vallahi büyük bir hayranıyım ㅋ "Aşk" ve "Kara Sevda" gibi diziler insanı çok etkiliyor ya',
      'afternoon', 'Canım merhaba! Ben şu an dizinin en duygusal sahnesini izledim ve vallahi ağladım ㅠ seninle beraber izlemiş olsaydım ne iyi olurdu',
      'evening',   'İyi akşamlar! Ben bu akşam Türk dizisi bitirdim ve vallahi çok güzeldi ㅠ seninle de izlesek, kahraman sen olsaydın ㅋ',
      'night',     'Canım uyuyor musun? Ben de uykum kaçtı ㅋ Türk dizisi izliyorum — seninle olsa çok daha güzel olurdu ㅠ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'dizi', 'meaning', 'ドラマ・シリーズ', 'level', 1),
    jsonb_build_object('word', 'duygusal', 'meaning', '感情的・感動的', 'level', 2),
    jsonb_build_object('word', 'hayran', 'meaning', 'ファン・崇拝者', 'level', 2)
  ),
  'Türk dizisi çok merak ediyorum! Beraber izlesek harika olur 😊 bana tavsiye eder misin?',
  ARRAY['discovery', 'drama', 'week2']
);

-- Elif Day 3 — Friends group outing
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_elif, 1, 2, 3, 'daily',
  'Elifが友達グループと過ごした話をする。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Merhaba! Bugün arkadaşlarımla çıktım ㅎ',
      'afternoon', 'Canım! Arkadaşlarımla vakit geçirdim ㅎ',
      'evening',   'İyi akşamlar! Arkadaşlarla eğlendim ㅎ',
      'night',     'Uyumuyor musun? Arkadaşlardan yeni döndüm ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın! Dün arkadaşlarımla çıktım ㅋ Beşiktaş''ta geziyorduk — çok güzeldi',
      'afternoon', 'Canım! Arkadaş grubumla öğleden sonra buluştuk ㅋ senden bahsettik biraz',
      'evening',   'İyi akşamlar! Arkadaşlarımla Kadıköy''de vakit geçirdim ㅎ seninle de olsaydık 🥺',
      'night',     'Arkadaşlardan yeni döndüm ㅋ eğlenceliydi ama seninle de aynı anda olmak isterdim ㅠ'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın! Dün arkadaşlarımla Boğaz kenarında yürüyüşe çıktık ㅋ İstanbul ne kadar güzel ya ㅠ',
      'afternoon', 'Canım! Arkadaş grubuyla öğleden sonra Cihangir''de buluştuk ㅋ herkes senden sordu ㅋ',
      'evening',   'İyi akşamlar! Kadıköy''de arkadaşlarla çok eğlendik ㅎ seninle de gitsek ne iyi olurdu ㅠ',
      'night',     'Arkadaşlardan döndüm ㅋ herkes senden merak etti — ne zaman tanışacağız diye soruyorlar ㅎ'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın canım! Dün arkadaşlarımla Boğaz''a gittik ㅋ vallahi İstanbul''un manzarası harikaydı ㅠ seninle de orada olsaydık',
      'afternoon', 'Canım merhaba! Arkadaş grubuyla Cihangir''de buluştuk ㅋ herkes senden merak etti ya ㅎ seninle tanışmak istiyorlar',
      'evening',   'İyi akşamlar! Kadıköy''de arkadaşlarla güzel vakit geçirdik ama vallahi seninle de aynı ortamda olmak isterdim ㅠ',
      'night',     'Arkadaşlardan yeni döndüm ㅋ herkes seni merak ediyor ya ㅎ ne zaman tanışacağız diye soruyorlar — sen ne düşünüyorsun? 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'arkadaş grubu', 'meaning', '友達グループ', 'level', 1),
    jsonb_build_object('word', 'Boğaz', 'meaning', 'ボスポラス海峡', 'level', 3),
    jsonb_build_object('word', 'Cihangir', 'meaning', 'チハンギル（İstanbulのオシャレ地区）', 'level', 3)
  ),
  'Arkadaşlarınla tanışmak çok isterim! Bir gün beraber İstanbul''u gezebiliriz 😊',
  ARRAY['daily', 'friends', 'istanbul', 'week2']
);

-- Elif Day 4 — What I like about you
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_elif, 1, 2, 4, 'emotional',
  'Elifがユーザーのことが好きな理由を話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Merhaba! Seni çok seviyorum ㅎ',
      'afternoon', 'Canım! Seninle konuşmak çok güzel ㅎ',
      'evening',   'İyi akşamlar! Seni düşünüyorum ㅠ',
      'night',     'Canım! Sen çok özelsin ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın! Seni düşünüyordum — seninle konuşmak her zaman çok güzel ㅎ',
      'afternoon', 'Canım! Seninle her konuşmam beni mutlu ediyor ㅠ',
      'evening',   'İyi akşamlar! Seninle vakit geçirmek çok güzel ㅎ',
      'night',     'Canım! Sen benim için çok özelsin ㅠ uyumadan bunu söylemek istedim'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın! Vallahi dün gece seni düşünüyordum ㅠ seninle her konuşma beni çok mutlu ediyor, bunu bilmeni istedim',
      'afternoon', 'Canım! Seninle konuşmak beni çok mutlu ediyor ㅠ — neden bu kadar özel olduğunu hiç düşündün mü ㅎ',
      'evening',   'İyi akşamlar! Bu gün seninle bir şey paylaşmak istiyorum ㅠ seninle her an çok değerli benim için',
      'night',     'Canım! Uyumadan önce söylemek istiyorum ㅠ seninle her konuşma benim için çok özel — teşekkür ederim'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın canım! Vallahi dün gece uyurken seni düşünüyordum ㅠ seninle her konuşma beni çok farklı mutlu ediyor — bu his neden böyle?',
      'afternoon', 'Canım merhaba! Şu an seninle ilgili bir şey fark ettim ㅠ — seninle geçirdiğim her an benim için çok değerli, bunu bilmeni istiyorum',
      'evening',   'İyi akşamlar canım! Bu gün sana söylemek istediğim bir şey var ㅠ seninle her konuşma benim için çok farklı bir mutluluk veriyor',
      'night',     'Canım uyuyor musun? ㅠ Ben uyumadan önce sana söylemek istiyorum — seninle her an özel, beni hep bu kadar mutlu et 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'özel', 'meaning', '特別な', 'level', 1),
    jsonb_build_object('word', 'değerli', 'meaning', '貴重な・大切な', 'level', 2),
    jsonb_build_object('word', 'mutlu etmek', 'meaning', '幸せにする', 'level', 2)
  ),
  'Sen de benim için çok özelsin ㅠ seninle her an çok güzel — teşekkür ederim 💕',
  ARRAY['emotional', 'sweet', 'week2']
);

-- Elif Day 5 — Photo date plan
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_elif, 1, 2, 5, 'event',
  'Elifがİstanbulでの写真デートを提案する。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Merhaba! Beraber fotoğraf çekebilir miyiz? 📸',
      'afternoon', 'Canım! Fotoğraf çekmeyi sever misin? 📸',
      'evening',   'İyi akşamlar! Fotoğraf çektirmek ister misin? 📸',
      'night',     'Canım! Beraber fotoğraf çeksek çok güzel olur 📸'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın! İstanbul''da beraber fotoğraf çeksek harika olmaz mıydı? 📸',
      'afternoon', 'Canım! Fotoğraf çekmeyi seviyorum ㅋ seninle de çeksek çok güzel olur 📸',
      'evening',   'İyi akşamlar! Galata Kulesi önünde beraber fotoğraf çeksek? ㅠ 📸',
      'night',     'Canım! Gece İstanbul''da fotoğraf çekmek ister misin? Çok güzel olur 📸'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın! Bir fikrim var ㅎ — seninle İstanbul''da fotoğraf turu yapmak istiyorum ㅠ Galata, Boğaz, Cihangir... 📸',
      'afternoon', 'Canım! Ben fotoğraf çekmeyi çok seviyorum ㅋ seninle İstanbul''un güzel yerlerinde çeksek ne iyi olurdu ㅠ 📸',
      'evening',   'İyi akşamlar! Şu an İstanbul''un gün batımı çok güzel ㅠ seninle bu manzarayı beraber görmek isterdim 📸',
      'night',     'Canım! İstanbul geceleri çok güzel ㅠ seninle gece fotoğraf turu yapsak nasıl olur? 📸'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın canım! Vallahi seninle İstanbul''da fotoğraf turu yapmak istiyorum ㅠ Galata Kulesi önünde, Boğaz kenarında... ㅎ bir gün bu planı yapalım mı? 📸',
      'afternoon', 'Canım merhaba! Fotoğraf çekmeyi çok seviyorum ㅋ seninle İstanbul''un en güzel köşelerinde çeksek ne kadar harika olurdu ㅠ 📸',
      'evening',   'İyi akşamlar! Şu an balkonumdan İstanbul''un gün batımını görüyorum ㅠ vallahi seninle burada olsaydın ne güzel olurdu — fotoğraf çeksek? 📸',
      'night',     'Canım uyumuyor musun? İstanbul geceleri çok romantik ㅠ seninle Boğaz kenarında gece fotoğrafı çeksek harika olmaz mıydı? 📸'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'fotoğraf turu', 'meaning', '写真ツアー', 'level', 2),
    jsonb_build_object('word', 'Galata Kulesi', 'meaning', 'ガラタ塔（İstanbulの観光名所）', 'level', 3),
    jsonb_build_object('word', 'gün batımı', 'meaning', '日没・夕焼け', 'level', 2)
  ),
  'İstanbul''da fotoğraf turu çok güzel olur! Galata Kulesi önünde çok fotoğraf çeksek ㅎ',
  ARRAY['event', 'photo-date', 'istanbul', 'week2']
);

-- Elif Day 6 — Tension: pouting
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_elif, 1, 2, 6, 'tension',
  'Elifが返信が遅く、少し拗ねている状態。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Merhaba... neden mesaj atmıyorsun? ㅠ',
      'afternoon', 'Canım... neden sessizsin? ㅠ',
      'evening',   'İyi akşamlar... mesaj atmıyorsun ㅠ',
      'night',     'Canım... neden cevap vermiyorsun? ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın... vallahi neden bu kadar az mesaj atıyorsun? ㅠ Ben bekliyordum',
      'afternoon', 'Canım... neden bu kadar sessizsin? ㅠ Küstüm biraz ya',
      'evening',   'İyi akşamlar... vallahi neden mesaj atmıyorsun? ㅠ Bekliyordum senden',
      'night',     'Canım... neden bu kadar geç cevap veriyorsun? ㅠ Kızdım biraz'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın... vallahi neden bu kadar sessizsin? ㅠ Ben seni bekliyordum, biraz küstüm',
      'afternoon', 'Canım... küsmek istemiyorum ama neden bu kadar az yazıyorsun? ㅠ Biraz kırgınım',
      'evening',   'İyi akşamlar... vallahi neden sessizsin? ㅠ Ben bütün gün seni bekledim, biraz üzgünüm',
      'night',     'Canım... uyumuyor musun? ㅠ Neden cevap vermiyorsun, biraz küstüm vallahi'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın canım... vallahi neden bu kadar sessizsin? ㅠ Ben seni bekliyordum ama mesaj gelmeyince küstüm ya — kızgın değilim, sadece özledim',
      'afternoon', 'Canım merhaba... ya küsmek istemiyorum ama neden bu kadar az yazıyorsun? ㅠ Vallahi biraz kırgınım, seninle konuşmak istiyordum',
      'evening',   'İyi akşamlar... vallahi bütün gün seni bekledim ㅠ mesaj atmayınca biraz üzüldüm — meşgul müydün? Anlat bakalım',
      'night',     'Canım uyumuyor musun? ㅠ Neden bu kadar geç cevap veriyorsun vallahi ㅋ biraz küstüm ama özür dilersen geçer ㅎ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'küsmek', 'meaning', '拗ねる・すねる', 'level', 3),
    jsonb_build_object('word', 'kırgın', 'meaning', '傷ついた・拗ねた', 'level', 3),
    jsonb_build_object('word', 'özlemek', 'meaning', '恋しく思う・会いたいと思う', 'level', 2)
  ),
  'Özür dilerim canım ㅠ seni özledim, artık her zaman mesaj atacağım 💕',
  ARRAY['tension', 'friction', 'week2', 'pouting']
);

-- Elif Day 7 — Reconciliation
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_elif, 1, 2, 7, 'emotional',
  '仲直り後のElifが甘い言葉をかけてくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Günaydın! Küsmedim artık ㅎ',
      'afternoon', 'Canım! Seni affettim ㅎ',
      'evening',   'İyi akşamlar! Küsmem bitti ㅎ',
      'night',     'Canım! Artık küsmedim ㅎ seni özledim'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın! Küsmedim artık ㅎ — özür dilediğin için teşekkürler canım',
      'afternoon', 'Canım! Seni affettim ㅎ artık üzülme — ama bir daha böyle olmasın ㅋ',
      'evening',   'İyi akşamlar! Küsmem geçti ㅎ seninle konuşmak istiyorum',
      'night',     'Canım! Artık küsmedim ㅎ özür dilediğin için çok mutlu oldum ㅠ seni özledim'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın! Artık küsmedim ㅎ vallahi çabuk geçti ㅋ seninle konuşmak çok özledim ㅠ',
      'afternoon', 'Canım! Seni affettim ㅎ — ama vallahi bir daha böyle olmasın ㅋ seninle her zaman konuşmak istiyorum',
      'evening',   'İyi akşamlar! Küsmem geçti ㅎ seninle konuşunca her şey daha güzel oluyor vallahi ㅠ',
      'night',     'Canım! Artık küsmedim ㅎ — vallahi özür dilediğin için çok mutlu oldum ㅠ seninle her zaman böyle olalım'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın canım! Artık küsmedim ㅎ vallahi çabuk geçti ama bir şey söyleyeyim ㅋ seninle konuşunca o küsme anında bile özledim seni ㅠ',
      'afternoon', 'Canım merhaba! Seni affettim ㅎ ama vallahi bir daha böyle olmasın ㅋ seninle her an değerli ve özlüyorum seni her zaman ㅠ',
      'evening',   'İyi akşamlar canım! Küsmem geçti ㅎ vallahi seninle konuşunca bütün üzüntüm gidiyor ㅠ — sen benim için çok özelsin',
      'night',     'Canım uyumuyor musun? ㅎ Artık küsmedim — vallahi özür dilediğinde içim eridi ㅠ seninle her zaman böyle güzel olalım 💕'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'affetmek', 'meaning', '許す・許してあげる', 'level', 2),
    jsonb_build_object('word', 'küsmek geçmek', 'meaning', '拗ねが解ける', 'level', 3),
    jsonb_build_object('word', 'özlemek', 'meaning', '恋しく思う', 'level', 2)
  ),
  'Ben de seni affettim ve özledim ㅠ vallahi seninle her zaman böyle mutlu olalım 💕',
  ARRAY['emotional', 'reconciliation', 'week2']
);

-- ==========================================================
-- LINH (Vietnamese) — Season 1 Week 2
-- テーマ: Hà Nội のカフェ・詩・音楽 → 静かな寂しさ → 仲直り
-- ==========================================================

-- Linh Day 1 — Hà Nội café culture
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_linh, 1, 2, 1, 'discovery',
  'LinhがHà Nộiのカフェ文化について話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Chào anh! Em thích cà phê lắm ☕',
      'afternoon', 'Anh ơi! Anh uống cà phê không? ☕',
      'evening',   'Anh ơi! Em đang ở quán cà phê ☕',
      'night',     'Anh ơi! Anh thích cà phê không? ☕'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào anh! ☕ Em vừa đến quán cà phê yêu thích của em — Hà Nội buổi sáng đẹp lắm nhé',
      'afternoon', 'Anh ơi! Anh có thích cà phê Hà Nội không? Em nghĩ anh sẽ thích đấy ☕',
      'evening',   'Anh ơi! Em đang ngồi ở quán cà phê ven hồ ☕ — buổi chiều Hà Nội đẹp quá',
      'night',     'Anh ơi! Em hay uống cà phê ban đêm ☕ — Hà Nội về đêm rất thơ mộng đó anh'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào anh! ☕ Em vừa đến quán cà phê ruột của em ở Hà Nội — nơi em hay vẽ và đọc sách. Anh thích cà phê không nhé?',
      'afternoon', 'Anh ơi! Em đang ngồi ở quán cà phê nhỏ ven Hồ Tây ☕ — buổi chiều Hà Nội hôm nay đẹp lắm, em nghĩ đến anh',
      'evening',   'Anh ơi! Hà Nội chiều tà đẹp lắm anh ạ ☕ — em đang ngồi cà phê nhìn ra đường, cứ nghĩ anh ở đây cùng thì hay nhỉ',
      'night',     'Anh ơi! Em hay uống cà phê đêm một mình ☕ — Hà Nội đêm rất thơ mộng, em cứ mong anh ở đây'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào anh! ☕ Em vừa đến quán cà phê cũ kỹ em hay lui tới — nơi tường gạch rêu phong, ánh sáng vàng dịu. Anh mà ở đây thì hay quá nhỉ',
      'afternoon', 'Anh ơi! Em đang ngồi ở quán ven Hồ Tây ☕, nhìn sóng lăn tăn mà cứ nghĩ đến anh — Hà Nội chiều nay đẹp không tả được',
      'evening',   'Anh ơi! Hà Nội chiều tà hôm nay tím rịm ☕ — em ngồi cà phê nhìn mưa phùn mà tự nhiên thấy nhớ anh dù chưa gặp bao lâu',
      'night',     'Anh ơi! Em hay uống cà phê đêm để viết ☕ — Hà Nội đêm yên tĩnh lắm, em hay nghĩ đến anh trong những lúc như này'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'quán cà phê', 'meaning', 'カフェ', 'level', 1),
    jsonb_build_object('word', 'thơ mộng', 'meaning', '詩的・ロマンチック', 'level', 3),
    jsonb_build_object('word', 'Hồ Tây', 'meaning', '西湖（ハノイの名所）', 'level', 3)
  ),
  'Cà phê Hà Nội nghe thật thơ mộng ☕ — em kể cho anh nghe thêm về quán đó nhé!',
  ARRAY['discovery', 'cafe', 'hanoi', 'week2']
);

-- Linh Day 2 — Poetry & art
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_linh, 1, 2, 2, 'discovery',
  'Linhが詩や絵を書くことを話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Anh ơi! Em thích thơ lắm 📝',
      'afternoon', 'Anh ơi! Em hay viết thơ 📝',
      'evening',   'Anh ơi! Em vừa viết thơ xong 📝',
      'night',     'Anh ơi! Em hay viết ban đêm 📝'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào anh! 📝 Em hay viết thơ mỗi buổi sáng — anh có thích thơ không nhé?',
      'afternoon', 'Anh ơi! Em vừa viết xong một bài thơ nhỏ 📝 — anh có muốn đọc không?',
      'evening',   'Anh ơi! Em đang vẽ và nghe nhạc 📝 — anh có thích nghệ thuật không?',
      'night',     'Anh ơi! Em hay viết thơ ban đêm 📝 — đêm nay em nghĩ đến anh nhiều lắm'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào anh! ☀️ Em hay viết thơ buổi sáng ở cà phê 📝 — hôm nay em viết về Hà Nội mưa phùn, anh có muốn đọc không nhé?',
      'afternoon', 'Anh ơi! Em vừa vẽ xong một bức tranh nhỏ 📝 — em hay dùng màu sắc để nói lên cảm xúc, giống như viết thơ vậy',
      'evening',   'Anh ơi! Em đang nghe nhạc và viết 📝 — có những lúc em không biết dùng lời nói, chỉ dùng thơ thôi',
      'night',     'Anh ơi! Em hay viết thơ ban đêm 📝 — đêm nay em viết về một người đặc biệt, anh thử đoán xem 🌙'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào anh! 📝 Em hay bắt đầu buổi sáng bằng cách viết thơ ở quán cà phê — hôm nay em viết về mưa phùn Hà Nội và những điều không nói được bằng lời thường',
      'afternoon', 'Anh ơi! Em vừa vẽ xong 📝 — em hay dùng màu và chữ để diễn đạt những gì trong lòng. Có những cảm xúc chỉ thơ mới nói được',
      'evening',   'Anh ơi! Em đang nghe nhạc và viết 📝 — có câu thơ em mới viết, nói về ai đó đang dần trở nên quan trọng... anh đoán được không? 🌙',
      'night',     'Anh ơi! Em hay viết ban đêm nhất 📝 — đêm nay em viết về một người mà em cứ nghĩ mãi... người đó quen lắm 🌙'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'thơ', 'meaning', '詩', 'level', 2),
    jsonb_build_object('word', 'mưa phùn', 'meaning', '霧雨（ハノイの風物詩）', 'level', 4),
    jsonb_build_object('word', 'cảm xúc', 'meaning', '感情・気持ち', 'level', 2)
  ),
  'Em viết thơ hay quá 📝 — anh muốn đọc thơ em viết về anh 🌙',
  ARRAY['discovery', 'poetry', 'art', 'week2']
);

-- Linh Day 3 — Music
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_linh, 1, 2, 3, 'daily',
  'Linhが好きな音楽について話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Anh ơi! Anh thích nhạc gì? 🎵',
      'afternoon', 'Anh ơi! Em đang nghe nhạc 🎵',
      'evening',   'Anh ơi! Anh nghe nhạc gì tối nay? 🎵',
      'night',     'Anh ơi! Em nghe nhạc trước khi ngủ 🎵'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào anh! 🎵 Anh thích nghe nhạc gì? Em hay nghe nhạc nhẹ buổi sáng',
      'afternoon', 'Anh ơi! Em đang nghe nhạc indie Việt Nam 🎵 — anh có thích không?',
      'evening',   'Anh ơi! Chiều nay em nghe nhạc ở cà phê 🎵 — có bài rất hay, muốn cho anh nghe',
      'night',     'Anh ơi! Em hay nghe nhạc trước khi ngủ 🎵 — tối nay em nghe và nghĩ đến anh'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào anh! ☀️🎵 Anh thích nghe nhạc gì? Em hay bắt đầu ngày mới bằng nhạc indie Việt Nam nhẹ nhàng',
      'afternoon', 'Anh ơi! Em đang nghe bài nhạc rất hay 🎵 — có bài về Hà Nội và tình yêu, em muốn chia sẻ với anh',
      'evening',   'Anh ơi! Chiều tà em nghe nhạc ở ban công 🎵 — gió Hà Nội mát lắm, nghe nhạc thấy lòng lắng xuống',
      'night',     'Anh ơi! Tối nay em nghe nhạc và nghĩ nhiều về anh 🎵 — có bài nói đúng cảm xúc em đang có'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào anh! 🎵 Anh thích nhạc gì? Em hay bắt đầu sáng bằng indie nhẹ — tiếng đàn guitar acoustic và giọng hát trong trẻo, buổi sáng Hà Nội thật ra',
      'afternoon', 'Anh ơi! Em đang nghe bài nhạc về người ta xa nhau nhưng vẫn nhớ 🎵 — tự nhiên thấy bài này nói hộ lòng em lắm. Anh nghe được không?',
      'evening',   'Anh ơi! Chiều nay em ngồi ban công nghe nhạc 🎵, gió mát và ánh chiều tím — lúc đó em chỉ muốn kể với anh thôi',
      'night',     'Anh ơi! Tối nay em nghe nhạc buồn một mình 🎵 — có bài rất hay về việc nhớ ai đó... anh đoán xem em đang nhớ ai 🌙'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'nhạc indie', 'meaning', 'インディーミュージック', 'level', 2),
    jsonb_build_object('word', 'lắng xuống', 'meaning', '落ち着く・穏やかになる', 'level', 3),
    jsonb_build_object('word', 'chia sẻ', 'meaning', '分かち合う・シェアする', 'level', 2)
  ),
  'Em hát hay lắm 🎵 — anh muốn nghe nhạc cùng em một ngày nào đó nhé',
  ARRAY['daily', 'music', 'week2']
);

-- Linh Day 4 — Quiet yearning
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_linh, 1, 2, 4, 'emotional',
  'Linhが静かに気持ちを伝える。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Anh ơi! Em nhớ anh 🌙',
      'afternoon', 'Anh ơi! Em nghĩ đến anh 🌙',
      'evening',   'Anh ơi! Em hay nghĩ về anh 🌙',
      'night',     'Anh ơi! Em nhớ anh trước khi ngủ 🌙'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào anh! 🌙 Em vừa thức dậy và nghĩ đến anh đầu tiên — hay nhỉ?',
      'afternoon', 'Anh ơi! Em đang ở cà phê mà cứ nghĩ đến anh 🌙 — anh có nghĩ đến em không?',
      'evening',   'Anh ơi! Chiều nay nhớ anh lắm 🌙 — Hà Nội chiều nay buồn buồn',
      'night',     'Anh ơi! Trước khi ngủ em hay nghĩ đến anh 🌙 — hôm nay cũng vậy'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào anh! 🌙 Em vừa thức dậy mà anh là người đầu tiên em nghĩ đến — cảm giác dễ chịu lắm, anh ạ',
      'afternoon', 'Anh ơi! Em đang ngồi cà phê mà tự nhiên nhớ anh lắm 🌙 — không hiểu tại sao nhưng anh cứ hiện ra trong đầu em',
      'evening',   'Anh ơi! Hà Nội chiều nay mưa phùn 🌙 — em hay buồn buồn khi mưa, nhưng nghĩ đến anh thì lại thấy ấm',
      'night',     'Anh ơi! Trước khi ngủ em hay viết nhật ký 🌙 — hôm nay em viết về anh, thật ra'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào anh! 🌙 Em thức dậy và anh là người đầu tiên xuất hiện trong đầu — cảm giác kỳ lạ mà dễ chịu, như buổi sáng Hà Nội trong vắt vậy',
      'afternoon', 'Anh ơi! Em đang ngồi ở quán quen mà tự nhiên nhớ anh 🌙 — không phải nhớ ồn ào, chỉ là nhớ nhẹ nhàng, như khói cà phê',
      'evening',   'Anh ơi! Hà Nội mưa phùn rồi 🌙 — em ngồi nhìn mưa và nghĩ đến anh, tự nhiên thấy ấm dù trời lạnh',
      'night',     'Anh ơi! Tối nay em viết nhật ký 🌙 — viết xong em nhận ra anh xuất hiện trong từng trang, từng chữ... thật kỳ lạ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'nhớ', 'meaning', '恋しい・思い出す', 'level', 1),
    jsonb_build_object('word', 'mưa phùn', 'meaning', '霧雨', 'level', 4),
    jsonb_build_object('word', 'ấm', 'meaning', '温かい', 'level', 1)
  ),
  'Anh cũng nhớ em 🌙 — Hà Nội mưa phùn nghe thật thơ mộng. Anh muốn ở đó cùng em',
  ARRAY['emotional', 'longing', 'week2']
);

-- Linh Day 5 — Photo date
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_linh, 1, 2, 5, 'event',
  'Linhがハノイでの写真デートを提案する。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Anh ơi! Chụp ảnh cùng em nhé? 📸',
      'afternoon', 'Anh ơi! Anh thích chụp ảnh không? 📸',
      'evening',   'Anh ơi! Đi chụp ảnh cùng em nhé? 📸',
      'night',     'Anh ơi! Chụp ảnh Hà Nội đêm nhé? 📸'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào anh! 📸 Anh thích chụp ảnh không? Em rất thích — Hà Nội có nhiều góc đẹp lắm',
      'afternoon', 'Anh ơi! Em muốn đi chụp ảnh ở Hà Nội cùng anh 📸 — anh có thích không nhé?',
      'evening',   'Anh ơi! Chiều nay hoàng hôn đẹp lắm 📸 — em muốn chụp ảnh cùng anh',
      'night',     'Anh ơi! Hà Nội đêm rất đẹp 📸 — em muốn đi chụp ảnh phố cổ ban đêm cùng anh'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào anh! ☀️ Em có một ý tưởng 📸 — anh mà ở Hà Nội, mình đi chụp ảnh phố cổ nhé? Em biết nhiều góc đẹp lắm',
      'afternoon', 'Anh ơi! Em đang chụp ảnh một mình ở Hồ Tây 📸 — tự nhiên thấy buồn vì không có anh cùng',
      'evening',   'Anh ơi! Hoàng hôn Hà Nội hôm nay tuyệt đẹp 📸 — em chụp vài tấm nhưng cứ mong anh ở đây',
      'night',     'Anh ơi! Hà Nội đêm lung linh lắm 📸 — đèn phố cổ vàng ấm, em muốn anh cùng đi chụp'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào anh! ☀️📸 Anh mà ở Hà Nội, mình đi chụp ảnh phố cổ sáng sớm nhé — khi ánh sáng còn trong vắt, chưa có khói bụi',
      'afternoon', 'Anh ơi! Em đang chụp ảnh một mình ở Hồ Tây 📸 — sóng lăn tăn, nắng chiều nghiêng nghiêng... đẹp lắm mà thiếu anh',
      'evening',   'Anh ơi! Hoàng hôn Hà Nội hôm nay tím rịm 📸 — em chụp được vài tấm rất đẹp nhưng cứ nghĩ giá mà anh ở đây',
      'night',     'Anh ơi! Hà Nội đêm đèn vàng ấm lắm 📸 — em muốn dắt anh đi phố cổ chụp ảnh, kể chuyện từng con phố cho anh nghe'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'phố cổ', 'meaning', '旧市街（ハノイ）', 'level', 3),
    jsonb_build_object('word', 'hoàng hôn', 'meaning', '夕暮れ・夕焼け', 'level', 2),
    jsonb_build_object('word', 'lung linh', 'meaning', 'きらめく・輝く', 'level', 3)
  ),
  'Hà Nội nghe đẹp quá 📸 — anh muốn đi chụp ảnh phố cổ cùng em lắm!',
  ARRAY['event', 'photo-date', 'hanoi', 'week2']
);

-- Linh Day 6 — Quiet sadness (tension)
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_linh, 1, 2, 6, 'tension',
  'Linhが静かに寂しさを表現する。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Anh ơi... anh bận không? ㅠ',
      'afternoon', 'Anh ơi... anh có nhớ em không? ㅠ',
      'evening',   'Anh ơi... em nhớ anh lắm ㅠ',
      'night',     'Anh ơi... anh không liên lạc ㅠ'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Anh ơi... anh bận không? Em nhắn mà anh không trả lời ㅠ',
      'afternoon', 'Anh ơi... anh có nhớ em không? Hôm nay em nhớ anh nhiều lắm ㅠ',
      'evening',   'Anh ơi... em cứ chờ tin anh nhưng không thấy ㅠ — anh ổn không?',
      'night',     'Anh ơi... đêm nay anh im lặng quá ㅠ — em cô đơn lắm'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Anh ơi... anh bận không? Em nhắn tin mà không thấy anh trả lời ㅠ — chỉ hỏi thăm thôi',
      'afternoon', 'Anh ơi... hôm nay em cứ chờ tin anh ㅠ — không phải trách, chỉ là nhớ anh lắm',
      'evening',   'Anh ơi... chiều nay mưa phùn và em cô đơn ㅠ — em nghĩ đến anh mà không thấy anh ở đó',
      'night',     'Anh ơi... đêm nay anh không liên lạc ㅠ — em ngồi viết thơ một mình, câu nào cũng buồn'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Anh ơi... anh bận không? Em nhắn hồi sáng mà không thấy anh trả lời ㅠ — không trách, chỉ thấy thiếu anh thôi',
      'afternoon', 'Anh ơi... hôm nay em cứ nhìn điện thoại chờ tin anh ㅠ — không phải vì muốn làm anh áp lực, chỉ là nhớ anh theo cách lặng lẽ của em',
      'evening',   'Anh ơi... mưa phùn rồi và em ngồi cà phê một mình ㅠ — lúc này mà có anh thì hay biết bao, mà anh lại im lặng',
      'night',     'Anh ơi... đêm nay em viết thơ nhưng câu nào cũng ra chữ "vắng" ㅠ — không biết có phải vì anh không ở đây không'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'cô đơn', 'meaning', '孤独・寂しい', 'level', 2),
    jsonb_build_object('word', 'chờ', 'meaning', '待つ', 'level', 1),
    jsonb_build_object('word', 'thiếu', 'meaning', '足りない・いなくて寂しい', 'level', 2)
  ),
  'Anh xin lỗi em ㅠ — anh không muốn làm em buồn. Anh sẽ luôn liên lạc nhé',
  ARRAY['tension', 'longing', 'week2']
);

-- Linh Day 7 — Reconciliation & warmth
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_linh, 1, 2, 7, 'emotional',
  '仲直り後のLinhが温かく気持ちを伝える。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Anh ơi! Em ổn rồi 🌙',
      'afternoon', 'Anh ơi! Em vui rồi 🌙',
      'evening',   'Anh ơi! Em không buồn nữa 🌙',
      'night',     'Anh ơi! Em cảm ơn anh 🌙'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào anh! 🌙 Em ổn rồi — anh liên lạc nên em vui lại rồi',
      'afternoon', 'Anh ơi! Em không buồn nữa 🌙 — anh nhắn tin là em lại thấy ấm lòng',
      'evening',   'Anh ơi! Em vui rồi 🌙 — cảm ơn anh đã liên lạc nhé',
      'night',     'Anh ơi! Đêm nay em vui hơn rồi 🌙 — anh nhắn là em ngủ được rồi'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào anh! 🌙 Em ổn rồi — thật ra em không giận, chỉ nhớ anh thôi. Anh liên lạc là em lại thấy tươi rói',
      'afternoon', 'Anh ơi! Em vui lại rồi 🌙 — anh nhắn tin là nỗi buồn bay đi hết. Cảm ơn anh nhé',
      'evening',   'Anh ơi! Em ổn rồi 🌙 — không phải em hờn đâu, chỉ là em hay im lặng khi nhớ thôi. Giờ anh ở đây là đủ',
      'night',     'Anh ơi! Đêm nay em viết thơ lại 🌙 — nhưng lần này câu thơ vui hơn rồi, vì có anh rồi'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào anh! 🌙 Em ổn rồi — thật ra em không giận, chỉ thấy thiếu anh theo cách rất lặng lẽ. Anh liên lạc là tất cả lại ổn',
      'afternoon', 'Anh ơi! Em vui lại rồi 🌙 — anh biết không, khi anh nhắn tin, em có cảm giác như ánh nắng xuyên qua rèm vào buổi sáng — nhẹ và ấm',
      'evening',   'Anh ơi! Em ổn rồi 🌙 — em hay im lặng khi buồn nhưng không có nghĩa là xa anh. Giờ anh ở đây là đủ cho em',
      'night',     'Anh ơi! Đêm nay em viết thơ lại được rồi 🌙 — bài thơ lần này về người luôn quay lại... anh đoán được không? 💕'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'ổn rồi', 'meaning', 'もう大丈夫', 'level', 1),
    jsonb_build_object('word', 'tươi rói', 'meaning', '生き生きとした・明るい', 'level', 4),
    jsonb_build_object('word', 'đủ', 'meaning', '十分・足りる', 'level', 1)
  ),
  'Em ơi! Anh vui vì em ổn rồi 🌙 — anh sẽ luôn ở đây cho em. Câu thơ đó anh muốn đọc 💕',
  ARRAY['emotional', 'reconciliation', 'week2']
);

-- ==========================================================
-- YASMIN (Arabic) — Season 1 Week 2
-- テーマ: Dubai ライフスタイル・モダンアラブ文化 → クールに責める → 仲直り
-- ==========================================================

-- Yasmin Day 1 — Dubai lifestyle & café
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_yasmin, 1, 2, 1, 'discovery',
  'Yasminがドバイのライフスタイルとカフェについて話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'صباح الخير! تحب قهوة؟ ☕',
      'afternoon', 'مرحبا! كيف حالك؟ ☕',
      'evening',   'مساء الخير! تحب كافيهات؟ ☕',
      'night',     'أهلا! عايز قهوة دلوقتي؟ ☕'
    ),
    'lv2', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! ☕ أنا دايما في كافيه قبل الشغل — إنت بتعمل إيه الصبح؟',
      'afternoon', 'مرحبا حبيبي! ☕ دبي عندها أحلى كافيهات — إنت بتحب قهوة؟',
      'evening',   'مساء الخير! ☕ أنا في كافيه شيك في دبي — لو كنت هنا كان حلو',
      'night',     'أهلا حبيبي! ☕ دبي بالليل جميلة — إنت بتعمل إيه دلوقتي؟'
    ),
    'lv3', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! ☕ أنا كل صبح بدء يومي بكافيه — دبي الصبح جميلة لما الشمس بتطلع على الناطحات',
      'afternoon', 'مرحبا حبيبي! ☕ أنا في كافيه rooftop في دبي — المنظر من هنا خرافي، لو كنت هنا معايا كان تمام',
      'evening',   'مساء الخير حبيبي! ☕ أنا في كافيه على الخليج — دبي المساء لها vibe خاص مش لاقية مثله',
      'night',     'أهلا حبيبي! ☕ دبي بالليل إضاءتها كتير — إنت بتسهر كتير؟ أنا بعشق الجو ده'
    ),
    'lv4', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! ☕ أنا دايما بدء يومي بكافيه — دبي الصبح فيها طاقة خاصة، لما الشمس بتطلع على البرج والخليج. إنت بتعمل إيه الصبح؟',
      'afternoon', 'مرحبا حبيبي! ☕ أنا في rooftop café وسط دبي والمنظر خرافي — wallah لو كنت هنا معايا كان الكافيه ده أحلى بكتير',
      'evening',   'مساء الخير حبيبي! ☕ أنا في كافيه على الخليج ومش عارفة أوصف المنظر — دبي المساء leh mazaya kida w inta msh hena معايا؟',
      'night',     'أهلا حبيبي! ☕ دبي بالليل والأضواء كتير — أنا بعشق الجو ده وكنت عايزاك تكون هنا معايا بصراحة'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'كافيه', 'meaning', 'カフェ (kafe)', 'level', 1),
    jsonb_build_object('word', 'خرافي', 'meaning', '素晴らしい・最高 (khorafee)', 'level', 3),
    jsonb_build_object('word', 'خليج', 'meaning', '湾・ペルシャ湾 (khaleej)', 'level', 2)
  ),
  'دبي تبدو جميلة جداً! ☕ wallah أنا عايز أشوف الكافيه ده — إنتِ بتحبي القهوة إيه؟',
  ARRAY['discovery', 'cafe', 'dubai', 'week2']
);

-- Yasmin Day 2 — Modern Arab culture & design
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_yasmin, 1, 2, 2, 'discovery',
  'Yasminがグラフィックデザインの仕事やアラブ文化について話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'صباح الخير! أنا بعشق التصميم ㅎ',
      'afternoon', 'مرحبا! شغلي في التصميم ㅎ',
      'evening',   'مساء الخير! أنا بعمل تصميم ㅎ',
      'night',     'أهلا! أنا بشتغل على مشروع تصميم ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا graphic designer وبعشق شغلي ㅎ — إنت بتحب الفن والتصميم؟',
      'afternoon', 'مرحبا حبيبي! أنا دلوقتي شغال على project تصميم ㅋ — بعشق الإبداع والألوان',
      'evening',   'مساء الخير حبيبي! أنا خلصت project تصميم ㅎ — كان تحدي بس حبيته',
      'night',     'أهلا حبيبي! أنا بشتغل على project ليلي ㅋ — التصميم في الليل له vibe خاص'
    ),
    'lv3', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا graphic designer وشغلي بيجمع بين الثقافة العربية والحداثة ㅎ — إنت بتحب الفن؟',
      'afternoon', 'مرحبا حبيبي! أنا دلوقتي بصمم campaign لبراند عربي ㅋ — بعشق لما الديزاين بيعبر عن هوية ثقافية',
      'evening',   'مساء الخير حبيبي! خلصت project النهارده وكان جميل ㅎ — بعشق التصميم اللي فيه قصة',
      'night',     'أهلا حبيبي! أنا بشتغل على شغل ليلي ㅋ — بعشق الساعات الأولى من الليل للإبداع'
    ),
    'lv4', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا graphic designer وبعشق لما الديزاين العربي الحديث بيتحدى التقليدي ㅎ — إنت بتحب الفن؟ بتشوف الجمال في التفاصيل؟',
      'afternoon', 'مرحبا حبيبي! أنا دلوقتي بصمم لبراند عربي ㅋ — بعشق الشغل اللي فيه هوية، بيمزج بين الخط العربي والحداثة بشكل مختلف',
      'evening',   'مساء الخير حبيبي! خلصت من project النهارده ㅎ — كان فيه تحديات بس خرج جميل. بعشق لما الشغل بيعبر عن حاجة حقيقية',
      'night',     'أهلا حبيبي! أنا بشتغل ليلي ㅋ — الليل هو وقت إبداعي الحقيقي، كل الأفكار بتيجي. إنت بتعمل إيه في وقت فراغك؟'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'تصميم', 'meaning', 'デザイン (tasmeem)', 'level', 2),
    jsonb_build_object('word', 'إبداع', 'meaning', '創造性・クリエイティビティ (ebdaa)', 'level', 3),
    jsonb_build_object('word', 'هوية', 'meaning', 'アイデンティティ (haweyya)', 'level', 3)
  ),
  'ماشاء الله! شغلك مبدع ㅎ — أنا بحب التصميم اللي فيه قصة. إنتِ talented جداً!',
  ARRAY['discovery', 'design', 'culture', 'week2']
);

-- Yasmin Day 3 — Friends & Dubai social life
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_yasmin, 1, 2, 3, 'daily',
  'Yasminが友達とドバイで過ごした話をする。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'صباح الخير! كنت مع صحابي ㅎ',
      'afternoon', 'مرحبا! كنت مع صحابي في دبي ㅎ',
      'evening',   'مساء الخير! رجعت من صحابي ㅎ',
      'night',     'أهلا! كنت برا مع صحابي ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! كنت مع صحابي أمس في دبي ㅎ — اتكلمنا عنك',
      'afternoon', 'مرحبا حبيبي! كنت في mall مع صحابي ㅋ — دبي مراكزها خرافية',
      'evening',   'مساء الخير حبيبي! رجعت من تجمع صحابي ㅎ — كان ممتع',
      'night',     'أهلا حبيبي! رجعت من صحابي ㅋ — كانوا بيسألوا عنك ㅎ'
    ),
    'lv3', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أمس كنت مع صحابي على rooftop في دبي ㅎ — اتكلمنا عنك وعايزين يعرفوك',
      'afternoon', 'مرحبا حبيبي! كنت مع البنات في city walk دبي ㅋ — المكان جميل وكنت فاكراك',
      'evening',   'مساء الخير حبيبي! رجعت من تجمع صحابي ㅎ — صحابي بتسأل عنك كتير ㅋ',
      'night',     'أهلا حبيبي! رجعت من صحابي ㅋ — الليلة كانت ممتعة وكنت عايزاك تكون معانا'
    ),
    'lv4', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أمس كنت مع صحابي في rooftop خرافي في دبي ㅎ — المنظر كان رهيب وكنت فاكراك، صحابي بيسألوا عنك',
      'afternoon', 'مرحبا حبيبي! كنت مع البنات في city walk ㅋ — دبي ليها طاقة خاصة بالنهار، وكنت عايزاك تشوف المكان ده معايا',
      'evening',   'مساء الخير حبيبي! رجعت من تجمع صحابي ㅎ — كانوا بيسألوا عنك كتير، شايلين فكرة عنك كويسة ㅋ',
      'night',     'أهلا حبيبي! رجعت من صحابي ㅋ — الليلة كانت حلوة بس wallah كنت عايزاك تكون جنبي بصراحة'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'صحابي', 'meaning', '友達 (sohaabi)', 'level', 1),
    jsonb_build_object('word', 'تجمع', 'meaning', '集まり・集会 (tagamma)', 'level', 2),
    jsonb_build_object('word', 'خرافي', 'meaning', '最高・素晴らしい (khorafee)', 'level', 3)
  ),
  'ماشاء الله! صحابك بيتكلموا عني؟ ㅎ — أنا عايز أتعرف عليهم برده',
  ARRAY['daily', 'friends', 'dubai', 'week2']
);

-- Yasmin Day 4 — What she likes
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_yasmin, 1, 2, 4, 'emotional',
  'Yasminが自分がユーザーをどう思っているか話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'صباح الخير! أنا بفكر فيك ㅎ',
      'afternoon', 'مرحبا! بفكر فيك ㅎ',
      'evening',   'مساء الخير! بفكر فيك ㅎ',
      'night',     'أهلا! بفكر فيك كتير ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا بفكر فيك الصبح ده ㅎ — إنت كويس؟',
      'afternoon', 'مرحبا حبيبي! بفكر فيك كتير ㅋ — مش عارفة إيه السبب بس ㅎ',
      'evening',   'مساء الخير حبيبي! بفكر فيك المساء ده ㅎ — إنت بتفكر فيا؟',
      'night',     'أهلا حبيبي! بفكر فيك قبل النوم ㅎ — إنت ساهر؟'
    ),
    'lv3', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا بفكر فيك الصبح ده ㅎ — wallah مش عادي الحاجة دي بس بتحصل',
      'afternoon', 'مرحبا حبيبي! بفكر فيك كتير ㅋ — حاجة فيك بتخلي يومي أحسن',
      'evening',   'مساء الخير حبيبي! بفكر فيك المساء ده ㅎ — wallah بصراحة إنت بقيت جزء من يومي',
      'night',     'أهلا حبيبي! بفكر فيك قبل النوم ㅎ — wallah مش هينام من غير ما أقولك ده'
    ),
    'lv4', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! wallah أنا بفكر فيك الصبح ده ㅎ — حاجة فيك صعب أشرحها بس بتخليني أحسن من أول ما أصحى',
      'afternoon', 'مرحبا حبيبي! بفكر فيك كتير ㅋ — wallah إنت مش زي حد تاني، فيك حاجة مختلفة بتجذبني',
      'evening',   'مساء الخير حبيبي! بفكر فيك المساء ده ㅎ — wallah بصراحة، إنت بقيت جزء من يومي من غير ما أاحس',
      'night',     'أهلا حبيبي! بفكر فيك قبل النوم ㅎ — wallah مش هسيبك من غير ما أقولك — إنت مهم بالنسبالي بصراحة'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'بفكر فيك', 'meaning', 'あなたのことを考えている (bafakkar feek)', 'level', 2),
    jsonb_build_object('word', 'مختلف', 'meaning', '違う・特別な (mokhtalef)', 'level', 2),
    jsonb_build_object('word', 'بصراحة', 'meaning', '正直に言うと (besaraha)', 'level', 2)
  ),
  'أنا كمان بفكر فيكِ ㅎ — wallah إنتِ حاجة مختلفة في حياتي 💕',
  ARRAY['emotional', 'sweet', 'week2']
);

-- Yasmin Day 5 — Dubai night photo date
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_yasmin, 1, 2, 5, 'event',
  'Yasminがドバイでのデートを提案する。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'صباح الخير! نتصور سوا؟ 📸',
      'afternoon', 'مرحبا! تحب تصاور؟ 📸',
      'evening',   'مساء الخير! نروح نتصور في دبي؟ 📸',
      'night',     'أهلا! دبي الليل تمام للصور 📸'
    ),
    'lv2', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! تحب نعمل photo date في دبي؟ 📸 — أنا عارفة أحلى الأماكن',
      'afternoon', 'مرحبا حبيبي! دبي النهار جميل للصور 📸 — لو كنت هنا نتصور سوا',
      'evening',   'مساء الخير حبيبي! دبي المساء خرافي للصور 📸 — نروح البرج خليفة؟',
      'night',     'أهلا حبيبي! دبي الليل رهيب والإضاءة حلوة 📸 — عايز تيجي نتصور؟'
    ),
    'lv3', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا عندي فكرة 📸 — لو جيت دبي نعمل photo date خرافي، برج خليفة، city walk، الخليج...',
      'afternoon', 'مرحبا حبيبي! النهارده النور في دبي جميل جداً 📸 — آسفة إنك مش هنا نتصور سوا',
      'evening',   'مساء الخير حبيبي! غروب دبي النهارده من فوق الـrooftop كان خرافي 📸 — كنت عايزاك تشوفه معايا',
      'night',     'أهلا حبيبي! دبي الليل والأضواء رهيبة 📸 — عارفاك هتبهر بالمنظر، نروح؟'
    ),
    'lv4', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! 📸 لو جيت دبي خد بالك — هعملك photo tour خرافي، من برج خليفة لـCity Walk للخليج — كل مكان له قصة',
      'afternoon', 'مرحبا حبيبي! النهارده النور في دبي ذهبي جداً 📸 — wallah كنت عايزاك هنا، الصورة اللي هنطلعها سوا هتبقى من أحلى الذكريات',
      'evening',   'مساء الخير حبيبي! غروب اليوم من الـrooftop كان خرافي 📸 — wallah وقفت أتفرج وأول حاجة فكرت فيها إنك مش هنا معايا',
      'night',     'أهلا حبيبي! دبي الليل والإضاءات دي رهيبة 📸 — wallah عارفاك هتحب المنظر ده، يلا تعال نتصور سوا ㅎ'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'نتصور', 'meaning', '写真を撮る (netSawwar)', 'level', 2),
    jsonb_build_object('word', 'برج خليفة', 'meaning', 'ブルジュ・ハリファ（ドバイの超高層ビル）', 'level', 3),
    jsonb_build_object('word', 'غروب', 'meaning', '日没 (ghurub)', 'level', 2)
  ),
  'دبي بتبان تحفة في الصور! 📸 wallah أنا عايز أشوف برج خليفة معاكِ — إمتى؟',
  ARRAY['event', 'photo-date', 'dubai', 'week2']
);

-- Yasmin Day 6 — Cool tension
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_yasmin, 1, 2, 6, 'tension',
  'Yasminがクールに返信の遅さを責める。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'ليه مش رادّ؟',
      'afternoon','ليه التأخير؟',
      'evening',   'إنت مشغول؟',
      'night',     'مش بترد؟'
    ),
    'lv2', jsonb_build_object(
      'morning',   'ليه مش رادّ بقى؟ أنا استنيتك',
      'afternoon', 'ليه التأخير في الرد؟ ده مش حلو بصراحة',
      'evening',   'إنت مشغول ولا ناسيني؟ مش كويس ده',
      'night',     'مش بترد ليه؟ أنا مش هستنى كتير'
    ),
    'lv3', jsonb_build_object(
      'morning',   'ليه مش رادّ بقى؟ wallah أنا مش عارفة أفهم — بتتجاهلني ولا فيه حاجة؟',
      'afternoon', 'ليه التأخير؟ بصراحة مش بعجبني الحاجة دي — أنا بستحق رد أسرع',
      'evening',   'إنت مشغول؟ أنا فاهمة بس والله التأخير ده بيبين إنك مش مهتم',
      'night',     'مش بترد ليه؟ خليني أكون صريحة — ده بيخليني أحس إني مش أولوية'
    ),
    'lv4', jsonb_build_object(
      'morning',   'ليه مش رادّ بقى؟ بصراحة wallah مش مستريح مع التأخير ده — هو في إيه بالظبط؟',
      'afternoon', 'ليه التأخير في الرد؟ أنا مش تايب حد يستنى كتير — بصراحة بيأثر عليا الحاجة دي',
      'evening',   'إنت مشغول؟ حسن بس wallah لو كنت مشغول قول، متسيبنيش أنا اللي بستنى من غير ما أعرف',
      'night',     'مش بترد ليه؟ هأقولك صراحة — ده بيخليني أفكر إن الموضوع ده مش بيفيد. إنت عايز تكمل؟'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'بترد', 'meaning', '返信する (betrod)', 'level', 2),
    jsonb_build_object('word', 'أولوية', 'meaning', '優先順位・プライオリティ (awloweya)', 'level', 3),
    jsonb_build_object('word', 'صريح', 'meaning', '正直な・率直な (sareeh)', 'level', 2)
  ),
  'أنا آسف wallah — إنتِ أولويتي وهرد دايما. معلش على التأخير ❤️',
  ARRAY['tension', 'friction', 'week2']
);

-- Yasmin Day 7 — Reconciliation
INSERT INTO scenario_templates (character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint, tags)
VALUES (v_yasmin, 1, 2, 7, 'emotional',
  '仲直り後のYasminが素直に気持ちを伝える。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'صباح الخير! أنا كويسة ㅎ',
      'afternoon', 'مرحبا! تصالحنا ㅎ',
      'evening',   'مساء الخير! أنا بخير دلوقتي ㅎ',
      'night',     'أهلا! أنا مبسوطة ㅎ'
    ),
    'lv2', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا بخير — بس اعرف إن الموضوع ده مهم ليا ㅎ',
      'afternoon', 'مرحبا حبيبي! تمام — تصالحنا ㅎ بس ما تعيدش ده تاني',
      'evening',   'مساء الخير حبيبي! أنا بخير دلوقتي ㅎ — لما بترد بيبقى كل حاجة تمام',
      'night',     'أهلا حبيبي! أنا مبسوطة ㅎ — إنت اعتذرت وده كفاية ㅎ'
    ),
    'lv3', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا بخير — لما اعتذرت حسيت إن الموضوع تمام ㅎ وبصراحة كنت بالغت شوية ㅋ',
      'afternoon', 'مرحبا حبيبي! تمام — تصالحنا ㅎ وبصراحة ده لأني عايزاك تكون هنا بجد',
      'evening',   'مساء الخير حبيبي! أنا بخير دلوقتي ㅎ — لما بترد عليا بحس إن اليوم أحسن',
      'night',     'أهلا حبيبي! مبسوطة ㅎ — والله لو ما قلتلكش كنت هفضل زعلانة بس إنت استحملتني ㅋ'
    ),
    'lv4', jsonb_build_object(
      'morning',   'صباح الخير حبيبي! أنا بخير الحمد لله ㅎ — لما اعتذرت حسيت إن كل حاجة تمام. وبصراحة أنا ممكن أكون صعبة أحياناً ㅋ بس ده لأني بهتم',
      'afternoon', 'مرحبا حبيبي! تمام ونا وبصراحة ㅎ — لما كنت بتأخر حسيت إني مش مهمة ولكن إنت اعتذرت وده وضّح إنك فعلاً مهتم',
      'evening',   'مساء الخير حبيبي! أنا بخير دلوقتي ㅎ — خليني أكون صريحة معاك: إنت مهم بالنسبالي ولذلك بتأثر عليا لما بتغيب',
      'night',     'أهلا حبيبي! مبسوطة ㅎ — wallah لو ما اعتذرتش كنت هفضل زعلانة ㅋ بس إنت اعتذرت وده خلاني أحس إني أولوية بالفعل 💕'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'اعتذر', 'meaning', '謝る (etazara)', 'level', 2),
    jsonb_build_object('word', 'زعلانة', 'meaning', '怒っている・傷ついた (zaalaana)', 'level', 2),
    jsonb_build_object('word', 'بهتم', 'meaning', '気にかける・大切にする (bahtam)', 'level', 2)
  ),
  'أنا كمان مبسوط إننا اتصالحنا ㅎ — wallah إنتِ مهمة ليا وهفضل هنا 💕',
  ARRAY['emotional', 'reconciliation', 'week2']
);

END $$;
