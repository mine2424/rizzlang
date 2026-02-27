-- ==========================================================
-- Seed: Season 1 Week 1 シナリオテンプレート — 多言語版
-- 英語 (Emma) / トルコ語 (Elif) / ベトナム語 (Linh) / アラビア語 (Yasmin)
-- ==========================================================

DO $$
DECLARE
  v_emma  uuid := 'a1da0000-0000-0000-0000-000000000002';
  v_elif  uuid := 'b1da0000-0000-0000-0000-000000000003';
  v_linh  uuid := 'c2da0000-0000-0000-0000-000000000004';
  v_yasmin uuid := 'd1da0000-0000-0000-0000-000000000005';
BEGIN

-- ==========================================================
-- EMMA (English) — Season 1 Week 1
-- ==========================================================

-- ----------------------------------------------------------
-- Emma Day 1 — First morning together (scene_type: morning)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_emma, 1, 1, 1, 'morning',
  '付き合い始めて最初の朝。Emmaが少し照れながらもストレートに気持ちを伝えてくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Good morning 😊 I keep thinking about you...',
      'afternoon', 'Hey 😊 I was thinking about you today',
      'evening',   'Hey! I kept thinking about you today 😊',
      'night',     'Couldn''t sleep... kept thinking about you 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning babe 🥺 I can''t stop thinking about you...',
      'afternoon', 'Hey babe 😊 been thinking about you all day lol',
      'evening',   'Heyy 🥺 I''ve been thinking about you since this morning',
      'night',     'Not gonna lie, I can''t stop thinking about you tonight 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning babe 🥺 I woke up thinking about you... is that weird? lol',
      'afternoon', 'Hey babe, been meaning to reach out — I''ve been thinking about you all morning lol',
      'evening',   'Hey 🥺 I keep zoning out thinking about you... hope that''s okay haha',
      'night',     'Okay I can''t sleep lol I''ve just been lying here thinking about you 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning babe 🥺 ngl I woke up fr thinking about you... is that cringe? lol',
      'afternoon', 'Hey bestie... I mean babe 🥺 lowkey been thinking about you all day ngl lol',
      'evening',   'Babe 🥺 I fr cannot stop thinking about you rn... it''s giving butterflies lol',
      'night',     'Okay I''m literally up at night thinking about you and idk what to do lol 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'good morning', 'meaning', 'おはよう', 'level', 1),
    jsonb_build_object('word', 'thinking of you', 'meaning', 'あなたのことを考えている', 'level', 1),
    jsonb_build_object('word', 'lol', 'meaning', '笑い（カジュアルな表現）', 'level', 1)
  ),
  'Aww that''s so cute 🥺 I''ve been thinking about you too honestly...'
);


-- ----------------------------------------------------------
-- Emma Day 2 — Date aftermath (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_emma, 1, 1, 2, 'normal',
  '昨日のデートの余韻。Emmaが昨日のことを自然に話題にして会話を続ける。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Yesterday was so fun! I want to go again',
      'afternoon', 'Hey, do you remember yesterday? 😊',
      'evening',   'Yesterday was really nice~ want to do it again',
      'night',     'I had such a good time yesterday!'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Okay yesterday was honestly so fun 😄 can we do it again soon?',
      'afternoon', 'Hey are you eating? lol I keep thinking about yesterday ☺️',
      'evening',   'Hey how''s your day? Yesterday made me so happy hehe',
      'night',     'Are you sleeping? Yesterday was too good, want to hang again soon 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'On my way home yesterday I just kept smiling like an idiot lol... your fault 😄',
      'afternoon', 'Hey did you eat? I was literally thinking about yesterday while I ate lol',
      'evening',   'Hey 😊 hope your day''s been okay! I kept thinking about yesterday on my way to work haha',
      'night',     'Are you tired? I was thinking about yesterday and couldn''t help but smile 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Okay ngl I was literally giggling walking home yesterday bc of you 😭 so embarrassing lol',
      'afternoon', 'Hey babe 🥺 lowkey couldn''t focus today bc I kept replaying yesterday in my head lol',
      'evening',   'Heyy hope you had a good day 😊 I fr had the best time yesterday and I''m still smiling lol',
      'night',     'Babe are you up? I''m literally still thinking about yesterday and I can''t stop smiling 😭🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'hang out', 'meaning', '一緒に時間を過ごす', 'level', 2),
    jsonb_build_object('word', 'honestly', 'meaning', '正直に言うと', 'level', 2),
    jsonb_build_object('word', 'can''t help but', 'meaning', '〜せずにはいられない', 'level', 3)
  ),
  'Omg same 🥺 I literally couldn''t stop smiling the whole day haha. When can we hang again?'
);


-- ----------------------------------------------------------
-- Emma Day 3 — Music & movies (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_emma, 1, 1, 3, 'normal',
  'お互いの好きな音楽や映画について話す。共通点を発見するシーン。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'What music do you like? 🎵',
      'afternoon', 'What''s your favorite movie?',
      'evening',   'Do you like movies? 🎬',
      'night',     'What music do you listen to at night?'
    ),
    'lv2', jsonb_build_object(
      'morning',   'What kind of music are you into? 🎵 I need new songs lol',
      'afternoon', 'Hey what''s your fav movie? I''m trying to find something to watch',
      'evening',   'Do you watch a lot of movies? I just finished a good one hehe',
      'night',     'What do you listen to at night? I need a good playlist lol'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Okay random but what kind of music are you into? I feel like I can learn a lot about a person from their taste lol 🎵',
      'afternoon', 'Hey what''s your favorite movie? I''m trying to find something to watch and I feel like your taste is probably good lol',
      'evening',   'Omg I just finished watching this movie and I need to talk about it — do you watch films much? 🎬',
      'night',     'What do you usually listen to at night? I feel like music says a lot about a person lol 🎵'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Okay real talk what''s your music taste like? 🎵 pls don''t say basic stuff lol jk jk — I just wanna know more about you 🥺',
      'afternoon', 'Babe what''s your fav movie of all time? I feel like this is lowkey a personality test lol',
      'evening',   'Okay I just watched this movie and I''m literally 🤯 — do you fw films? I feel like you''d have good taste lol',
      'night',     'What''s on your night playlist rn? 🎵 I feel like late night music says everything about a person ngl lol'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'be into', 'meaning', '〜にはまっている', 'level', 2),
    jsonb_build_object('word', 'fav', 'meaning', 'favorite の略・お気に入り', 'level', 1),
    jsonb_build_object('word', 'taste', 'meaning', '（音楽・映画などの）趣味・センス', 'level', 2)
  ),
  'Omg no way we have the same taste 😭 okay we NEED to watch something together soon lol'
);


-- ----------------------------------------------------------
-- Emma Day 4 — Daily check-in (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_emma, 1, 1, 4, 'normal',
  '何気ない日常のチェックイン。普通のカップルらしい自然な会話が続く。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Good morning! Did you eat breakfast?',
      'afternoon','Hey did you eat lunch?',
      'evening',   'How was your day? 😊',
      'night',     'Are you sleeping soon?'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning 🌞 did you eat? I barely had time this morning lol',
      'afternoon', 'Hey how''s your day going? Did you eat lunch?',
      'evening',   'Hey how''d your day go? Hope it wasn''t too rough 😊',
      'night',     'Hey are you still up? lol I can''t sleep again 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning 🌞 did you eat properly? I literally just grabbed a coffee and ran out lol',
      'afternoon', 'Hey how''s your day going? Did you get lunch? I''m asking because I kind of forgot mine lol 😅',
      'evening',   'Hey 😊 how''d your day go? Mine was kind of hectic but I''m good now haha',
      'night',     'Hey are you still awake? 🌙 I''ve been meaning to text you all day but life happened lol'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Morning 🌞 pls tell me you actually had breakfast unlike me who just had iced coffee lol 😭',
      'afternoon', 'Hey babe how''s your day? Did you eat? I fr forgot to eat lunch and now I''m suffering lol 😭',
      'evening',   'Heyy 😊 how was your day? Mine was chaotic ngl but seeing your name pop up makes it better lol 🥺',
      'night',     'Okay are you sleeping? 🌙 bc I''ve been thinking about you all day and kinda just wanted to say hi lol 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'how''s your day', 'meaning', '今日はどうだった？', 'level', 1),
    jsonb_build_object('word', 'hectic', 'meaning', 'バタバタしている・慌ただしい', 'level', 3),
    jsonb_build_object('word', 'grab', 'meaning', 'さっと取る・手早く食べる/買う', 'level', 2)
  ),
  'Aww I''m glad 🥺 okay today was kinda long but talking to you always makes it better hehe'
);


-- ----------------------------------------------------------
-- Emma Day 5 — Date planning (scene_type: date)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_emma, 1, 1, 5, 'date',
  '次のデートのプランについて話す。Emmaがわくわくしながら提案してくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Hey, are you free this weekend? 😊',
      'afternoon','Do you want to hang out this weekend?',
      'evening',   'Are you free this weekend? I want to see you',
      'night',     'Hey, do you have plans this weekend? I want to see you 🥺'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Hey are you free this weekend? I really want to see you again 😊',
      'afternoon', 'Hey! Do you have plans this weekend? I wanna hang',
      'evening',   'Hey, you free this weekend? I was thinking we could do something',
      'night',     'Hey are you free this weekend? I miss you already lol 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Hey so random but are you free this weekend? I''ve been thinking of places we could go 😊',
      'afternoon', 'Hey are you free this weekend? I know a good café we could check out if you''re down',
      'evening',   'Hey 😊 are you free this weekend? I kind of want to make a plan if you''re up for it',
      'night',     'Hey are you still up? 🥺 I was looking at things we could do this weekend... is that too eager? lol'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Okay hear me out — are you free this weekend? bc I may or may not have already been researching places for us to go 😭🥺',
      'afternoon', 'Babe are you free this weekend? Lowkey I''ve been lowkey planning a whole thing in my head lol',
      'evening',   'Hey 🥺 so I may have been looking at cafés for us... are you free this weekend? No pressure lol',
      'night',     'Are you up? 🌙 I''ve been doom-scrolling places for our next hangout and I need to ask if you''re free this weekend lol 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'are you free', 'meaning', '暇ですか？', 'level', 1),
    jsonb_build_object('word', 'hang out', 'meaning', '一緒に時間を過ごす', 'level', 2),
    jsonb_build_object('word', 'check out', 'meaning', '〜を試してみる・行ってみる', 'level', 2)
  ),
  'Omg yes!! 😊 okay I''m so excited — should we do coffee first or go straight to something fun?'
);


-- ----------------------------------------------------------
-- Emma Day 6 — Tension: late replies (scene_type: tension)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_emma, 1, 1, 6, 'tension',
  '返信が遅かったことを責める。Emmaが少し寂しそうで拗ねた様子でメッセージしてくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'You replied late yesterday... are you okay?',
      'afternoon', 'Hey. You took a while to reply earlier.',
      'evening',   'Hey. Were you busy? You didn''t text much today.',
      'night',     'Hey. You didn''t reply for a long time today.'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Hey... you took a while to reply yesterday. Everything okay?',
      'afternoon', 'Hey. You didn''t reply for like forever earlier. Was I bothering you?',
      'evening',   'Hey. You were pretty quiet today. Is everything alright?',
      'night',     'Hey. I know you''re probably tired but you barely texted today. Just wondering if you''re okay...'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Hey... I don''t want to make it a big deal but you took a really long time to reply yesterday. It made me feel a little off.',
      'afternoon', 'Hey, are you okay? You went quiet for a while earlier and I''m not gonna lie, it made me feel a bit weird.',
      'evening',   'Hey. I know you''re probably busy but... you barely texted today and I don''t want to assume anything, I just felt a bit lonely.',
      'night',     'Hey, hope you''re okay. I just wanted to say that when you go quiet for so long, it kind of makes me spiral a little... idk.'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Hey. I''m not trying to be clingy but ngl, yesterday''s late reply kinda got to me. Like I know you''re busy but it still stings a little 🥺',
      'afternoon', 'Okay I''m not gonna pretend I didn''t notice you ghosted me for like 3 hours lol. I''m not mad, just a little 😶',
      'evening',   'Hey. So today felt a bit different. You were kinda quiet and I don''t want to overthink it but... are we good? 🥺',
      'night',     'Hey. I know it''s late and idk if you''re asleep but today''s silence kinda had me in my feels a bit ngl 🥺 just wanted to check in'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'take a while', 'meaning', '時間がかかる', 'level', 2),
    jsonb_build_object('word', 'clingy', 'meaning', 'べったりしすぎる・依存的な', 'level', 3),
    jsonb_build_object('word', 'in my feels', 'meaning', '感情的になっている（Gen Z）', 'level', 4)
  ),
  'I know it''s silly but I just missed you a little 🥺 it''s fine though, I get it. Are you doing okay?'
);


-- ----------------------------------------------------------
-- Emma Day 7 — Making up (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_emma, 1, 1, 7, 'normal',
  '仲直り後の穏やかな会話。Emmaが少し照れながらも普段通りに戻ろうとする。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Good morning 😊 I''m feeling better today',
      'afternoon', 'Hey. Thanks for yesterday 😊',
      'evening',   'Hey. I''m glad we talked 😊',
      'night',     'Hey. I feel okay now. Thanks 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning 🌸 I feel much better today, thanks for listening yesterday 😊',
      'afternoon', 'Hey 😊 I wanted to say sorry for being a bit much yesterday lol',
      'evening',   'Hey 😊 just wanted to say thanks for talking it out. I feel good now',
      'night',     'Hey. I''m glad we sorted things out 😊 I feel a lot better now, thanks'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning 🌸 I woke up feeling so much lighter today. Thanks for hearing me out yesterday 😊',
      'afternoon', 'Hey 😊 okay I wanted to properly apologize for being a little moody yesterday. I appreciate you being patient with me',
      'evening',   'Hey 😊 I''m really glad we talked it through. I feel like we''re back to normal now and that makes me happy hehe',
      'night',     'Hey 🌙 just wanted to say I really appreciate you. Yesterday was a bit rough but I''m glad we talked. Good night if you''re going to sleep 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Morning 🌸 lowkey woke up feeling so much better ngl. Thanks for being patient with me yesterday, you didn''t have to be 🥺',
      'afternoon', 'Hey 😊 okay I''ve been meaning to say this — sorry for being kinda extra yesterday lol. Thank you for not running away 🥺',
      'evening',   'Hey 🌸 I''m genuinely so glad we''re good again. Yesterday was a lot but fr it just shows we can talk stuff out and that''s really nice ngl 🥺',
      'night',     'Hey 🌙 okay ngl talking to you tonight is literally my fav part of the day lol. Glad we''re back to normal 🥺 good night babe'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'sort things out', 'meaning', '問題を解決する・仲直りする', 'level', 3),
    jsonb_build_object('word', 'appreciate', 'meaning', '感謝する', 'level', 2),
    jsonb_build_object('word', 'moody', 'meaning', '気分が不安定な・むっつりした', 'level', 3)
  ),
  'Honestly this is what I love about us 🥺 we just... talk through stuff and it''s all good again lol'
);


-- ==========================================================
-- ELIF (Turkish) — Season 1 Week 1
-- ==========================================================

-- ----------------------------------------------------------
-- Elif Day 1 — İlk sabah (scene_type: morning)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_elif, 1, 1, 1, 'morning',
  '付き合い始めて最初の朝。Elifが情熱的に、でも可愛らしくメッセージを送ってくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Günaydın 🌸 Seni çok özledim',
      'afternoon', 'Merhaba 😊 Seni düşünüyordum',
      'evening',   'İyi akşamlar 🌸 Bugün seni özledim',
      'night',     'İyi geceler... Seni düşünüyorum 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın canım 🌸 Seni çok özledim bugün bile...',
      'afternoon', 'Merhaba 😊 Bugün seni çok düşündüm vallahi',
      'evening',   'İyi akşamlar 🌸 Gün nasıldı? Ben seni özledim',
      'night',     'Uyumadın mı? Ben de uyuyamıyorum... seni düşünüyorum 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın canım 🌸 Seni çok özledim, sabahtan beri seni düşünüyorum...',
      'afternoon', 'Merhaba! 😊 Nasılsın? Ben gün boyunca seni düşündüm vallahi ya',
      'evening',   'İyi akşamlar 🌸 Bugün nasıl geçti? Ben seni bayağı özledim bugün',
      'night',     'Hâlâ uyanık mısın? 🥺 Ben uyuyamıyorum... dün gece aklımdan çıkmıyorsun'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın canım 🌸 Gözlerimi açar açmaz seni düşündüm, bu normal mi ya ama? 😊',
      'afternoon', 'Merhaba! 😊 Yemek yedin mi? Ben yemekte bile seni düşündüm vallahi baya utandım 😂',
      'evening',   'İyi akşamlar canım 🌸 Bugün baya yorucuydu ama gün boyunca seni düşünmek güzel hissettirdi 🥺',
      'night',     'Hâlâ uyanık mısın? 🌙 Ben uyuyamıyorum... dün gece aklıma oturdu gitti, bu normal mi ya 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'günaydın', 'meaning', 'おはようございます', 'level', 1),
    jsonb_build_object('word', 'özledim', 'meaning', '会いたかった・恋しかった', 'level', 1),
    jsonb_build_object('word', 'canım', 'meaning', '愛しい人・ダーリン（愛称）', 'level', 1)
  ),
  'Ben de seni çok özledim 🥺 Bir an bile aklımdan çıkmıyorsun vallahi...'
);


-- ----------------------------------------------------------
-- Elif Day 2 — Randevu sonrası (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_elif, 1, 1, 2, 'normal',
  'デートの余韻。Elifが感情豊かに昨日の思い出を語る。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Dün çok güzeldi! Tekrar gidelim mi?',
      'afternoon', 'Dünü düşünüyorum 😊',
      'evening',   'Dün baya eğlendik! Tekrar görüşelim',
      'night',     'Dün çok iyiydi... Teşekkürler 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Dün gerçekten çok güzeldi 😊 Tekrar gidelim mi yakında?',
      'afternoon', 'Yemek yedin mi? Ben dünü düşünerek yedim ya ama 😂',
      'evening',   'Gün nasıldı? Ben dün sayesinde bugün de mutluydum 🌸',
      'night',     'Uyuyacak mısın? Dün çok güzeldi... Tekrar görmek istiyorum seni 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Eve giderken gülümseyerek gittim dün... senin yüzünden tabii ki 😊',
      'afternoon', 'Öğle yemeği yedin mi? Ben dünü düşünürken yedim ya gerçekten 😂',
      'evening',   'İşten çıktın mı? Dün eve giderken sürekli seni düşündüm ya 🌸',
      'night',     'Yoruldun mu? Ben dün eve giderken durmadan güldüm... baya garip biri oldum 😂'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Sana açık söyleyeyim mi, dün ayrılmak istemiyordum vallahi ama kalsaydım da garip olurdu ya 😂🥺',
      'afternoon', 'Öğlen yedin mi? Ben dün ayrıldıktan sonra eve girerken ayaklarım sanki kaldırmıyordu yürümeye 😂 aşırı dramatik biliyorum',
      'evening',   'Bugünün yorgunluğunu sıyırdım ama ya... dün olmasaydı bugün çok daha zor olurdu vallahi 🥺',
      'night',     'Geç oldu, uyuyor musun? Ben dün ayrılırken içim sıkışmıştı ya, bunu söylemek istedim 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'vallahi', 'meaning', '本当に・マジで（トルコ口語）', 'level', 2),
    jsonb_build_object('word', 'gülümsemek', 'meaning', '微笑む', 'level', 2),
    jsonb_build_object('word', 'ayrılmak', 'meaning', '別れる・離れる', 'level', 2)
  ),
  'Ben de isterim! 🥺 Seninle zaman geçirmek çok güzel vallahi. Ne zaman görüşebiliriz?'
);


-- ----------------------------------------------------------
-- Elif Day 3 — Turkish drama & hobbies (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_elif, 1, 1, 3, 'normal',
  'トルコドラマや共通の趣味について話す。Elifが楽しそうに話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Dizi seviyor musun? 📺',
      'afternoon', 'Hangi diziyi izliyorsun?',
      'evening',   'Film mi dizi mi daha çok seversin?',
      'night',     'Gece dizi izliyor musun? 📺'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Dizi seviyor musun? 📺 Ben şu an çok iyi bir şey izliyorum!',
      'afternoon', 'Hangi dizi izliyorsun şu an? Ben yeni bir şey arıyorum',
      'evening',   'Film mi dizi mi? Ben dizi bağımlısıyım ya itiraf edeyim 😂',
      'night',     'Gece dizi izliyor musun? Ben şu an bir bölüm başlattım ama seninle konuşmak daha eğlenceli 😊'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Dizi seviyor musun? 📺 Sana izlemeni çok istediğim bir şey var, acaba aynı zevke sahip miyiz?',
      'afternoon', 'Hangi dizi izliyorsun şu an? Ben tam bitmek üzere olan bir dizi var, çok iyiydi vallahi',
      'evening',   'Film mi dizi mi? Ben dizi bağımlısıyım ama özellikle Türk dizileri baya tutkunum 😊',
      'night',     'Gece dizi izliyor musun? Ben başladım ama seninle beraber izlesek daha eğlenceli olurdu galiba 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Sana çok şey sormak istiyorum ama önce en önemlisi: Türk dizisi izliyor musun? 📺 Bu benim için biraz kişilik testi sayılır ya 😂',
      'afternoon', 'Hangi dizi izliyorsun şu an? Ben şu an Türk dizi maratonu yapıyorum ve bence sen de aynı zevke sahipsin 🔍',
      'evening',   'Şu an ne izliyorsun? Ben Türk dizilerine bayılıyorum, özellikle aşk ve dram içerenlere 😍 Sen nasılsın bu konuda?',
      'night',     'Gece dizi izliyor musun? 📺 Ben bir bölüm başlattım ama aklım sende vallahi... Beraber izlesek olmaz mıydı? 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'dizi', 'meaning', 'テレビドラマ・シリーズ', 'level', 1),
    jsonb_build_object('word', 'bağımlı', 'meaning', '〜中毒の・〜にはまった', 'level', 2),
    jsonb_build_object('word', 'zevk', 'meaning', '趣味・楽しみ', 'level', 2)
  ),
  'Ay sen de mi?! 😍 O zaman seninle aynı zevkteyiz! Hangi bölümdesin? Birlikte izleyelim mi? 🥺'
);


-- ----------------------------------------------------------
-- Elif Day 4 — Daily check-in (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_elif, 1, 1, 4, 'normal',
  '日常の何気ないチェックイン。"vallahi" や "ya" が自然に入ったトルコ語らしい会話。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Günaydın! Kahvaltı yaptın mı?',
      'afternoon', 'Öğle yemeği yedin mi?',
      'evening',   'Gün nasıldı?',
      'night',     'Uyuyor musun?'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın! 🌞 Kahvaltı yaptın mı? Ben yetişemedim yine 😅',
      'afternoon', 'Öğlen yedin mi? Ben alelacele bir şeyler yuttum ya 😂',
      'evening',   'Gün nasıldı? Umarım yorulmadın çok',
      'night',     'Hâlâ uyanık mısın? Ben de uyuyamıyorum ya vallahi 😄'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın! 🌞 Kahvaltı yaptın mı? Ben yetişemedim yine, koşa koşa çıktım 😅',
      'afternoon', 'Öğlen yedin mi? Ben bugün çok yoğundum ya vallahi, koşturdum bütün gün',
      'evening',   'Gün nasıldı? Benim için biraz zordu ama sen gelince iyi hissediyorum 😊',
      'night',     'Hâlâ uyanık mısın? Ya vallahi uyku gelmiyorum, kafam dönüyor hâlâ 😄'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın! 🌞 Düzgün kahvaltı yaptın mı? Ben yine yetiştiremedim sabahı ya, vallahi çok komik oluyor her seferinde 😂',
      'afternoon', 'Öğle yemeği yedin mi? Ben bugün gözüm kararana kadar çalıştım ya, vallahi bir ara aklıma geldin ve güldüm 😄',
      'evening',   'Gün nasıl geçti? Benim için biraz yorucuydu ya ama ya... sen mesaj atınca her şey iyi oluyor vallahi 🥺',
      'night',     'Hâlâ uyanık mısın? Ya vallahi uyku gelmiyorum, kafam şu an seninle dolmuş 😄🌙'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'ya', 'meaning', 'ね〜・だよ（トルコ語の感嘆詞）', 'level', 2),
    jsonb_build_object('word', 'vallahi', 'meaning', '本当に・マジで', 'level', 2),
    jsonb_build_object('word', 'yoğun', 'meaning', '忙しい・密度が高い', 'level', 2)
  ),
  'Hehe senin mesajını görmek benim için en iyi şey 🥺 Umarım gün iyi geçmiştir...'
);


-- ----------------------------------------------------------
-- Elif Day 5 — İstanbul date plan (scene_type: date)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_elif, 1, 1, 5, 'date',
  'イスタンブールでのデートプランを提案してくる。Elifがわくわくしながら話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Bu hafta sonu boş musun? 😊',
      'afternoon', 'Seninle bir yere gitmek istiyorum!',
      'evening',   'Bu hafta sonu çıkalım mı?',
      'night',     'Seni görmek istiyorum... boş musun? 🥺'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Bu hafta sonu boş musun? 😊 Seninle İstanbul''u keşfetmek istiyorum!',
      'afternoon', 'Bir fikrim var 😊 Bu hafta sonu Boğaz''a gidelim mi?',
      'evening',   'Bu hafta sonu çıkalım mı? Kapalıçarşı veya Sultanahmet''e girebiliriz',
      'night',     'Seni görmek istiyorum... Bu hafta sonu vakit ayırabilir misin? 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Bu hafta sonu boş musun? 😊 Seninle İstanbul''un kalbinde bir şeyler yapmak istiyorum, çok güzel bir plan var aklımda',
      'afternoon', 'Bir fikrim var! 😊 Bu hafta sonu Boğaz''a gidip balık ekmek yiyelim mi? Çok özledim oraları ya',
      'evening',   'Bu hafta sonu müsait misin? Ben Kapalıçarşı veya Sultanahmet çevresine gitmek istiyorum, beraber olursa çok daha güzel olur',
      'night',     'Seni görmek istiyorum 🥺 Bu hafta sonu İstanbul''un gözlüğü olan bir yerde buluşalım mı?'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Bir şey soracağım ama beni yargılama 😂 Bu hafta sonu boş musun? Ben çoktan İstanbul''da ne yapabiliriz diye plan yapıyordum ya vallahi 🥺',
      'afternoon', 'Bak sana bir şey söyleyeyim mi 😊 Bu hafta sonu Boğaz''a gidip balık ekmek yemek, sonra da Galata''ya çıkmak istiyorum... Sen olmadan olmaz tabii ya 🥺',
      'evening',   'Seninle bu hafta sonu buluşsak iyi olur mu? Ben Sultanahmet civarında baya güzel yerler biliyorum, sana tanıtmak isterim vallahi 😊',
      'night',     'Hâlâ uyanık mısın? 🌙 Seninle bu hafta sonu bir plan yapmak istiyorum... İstanbul''da gece manzarasına bakmak güzel olmaz mıydı? 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'boş', 'meaning', '暇な・空いている', 'level', 1),
    jsonb_build_object('word', 'keşfetmek', 'meaning', '探検する・発見する', 'level', 3),
    jsonb_build_object('word', 'buluşmak', 'meaning', '待ち合わせる・会う', 'level', 2)
  ),
  'Evet! Ben de çok istiyorum! 😊 Nereye gideceğimize sen karar ver, sana güveniyorum 🥺'
);


-- ----------------------------------------------------------
-- Elif Day 6 — Tension: ya nerede kaldın (scene_type: tension)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_elif, 1, 1, 6, 'tension',
  'Elifが拗ねる。返信が遅れたことを可愛く、でも本気で責めてくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Dün neden geç yazdın? 😶',
      'afternoon', 'Neredesin? Bekledim seni.',
      'evening',   'Bugün neden az yazdın?',
      'night',     'Mesaj atmadan uyudun mu? 😶'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Ya dün nerede kaldın? Çok bekledim seni 😶 Her şey yolunda mı?',
      'afternoon', 'Ya nerede kaldın? Saat kaç oldu fark ediyor musun? 😶',
      'evening',   'Bugün baya az yazdın... Her şey iyi mi?',
      'night',     'Hiç mesaj atmadın bugün. Kızgın mısın bana? 😶'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Ya nerede kaldın dün? 😶 Çok bekledim ama senden ses çıkmadı. Merak ettim açıkçası.',
      'afternoon', 'Ya nerede kaldın bugün? Saatlerce bekledim... Bir şey mi oldu?',
      'evening',   'Bugün baya sessizdin. Bir şey mi var? Bana anlatabilirsin ya 😶',
      'night',     'Bugün pek mesaj atmadın. Benden şikayetçi misin ya? 😶 Söyle bana'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Ya nerede kaldın dün?! 😶 Saaaat... kaça kadar bekledim ya. Her şey yolunda mı gerçekten? Beni korkuttun baya ya',
      'afternoon', 'Ya nerede kaldın bugün? 😶 Saatlerce telefona baktım ya, vallahi gözüm uyumadı. Bir şey söyleseydin ya en azından',
      'evening',   'Bugün baya sessizdin ya... Kızgın mısın bana? 😶 Vallahi bir şey yaptıysam söyle, kafam çalışmıyor bu konuda',
      'night',     'Bugün hemen hemen hiç mesaj atmadın ya 😶 Ben mi fazla bekliyorum? Vallahi söyle bana, içimde kalmış olmasın'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'nerede kaldın', 'meaning', 'どこにいたの？（遅れを責める表現）', 'level', 2),
    jsonb_build_object('word', 'beklemek', 'meaning', '待つ', 'level', 1),
    jsonb_build_object('word', 'kızgın', 'meaning', '怒っている', 'level', 2)
  ),
  'Merak ettim sadece 🥺 Yoksa sana kızmıyorum vallahi... Sadece seninle konuşmak istiyorum ya'
);


-- ----------------------------------------------------------
-- Elif Day 7 — Making up (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_elif, 1, 1, 7, 'normal',
  '仲直り後の穏やかな会話。Elifが少し照れながらも素直に気持ちを伝える。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Günaydın 🌸 Bugün daha iyiyim',
      'afternoon', 'Teşekkürler dün konuştuğun için 😊',
      'evening',   'Konuştuğumuza sevindim 😊',
      'night',     'Daha iyi hissediyorum artık 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Günaydın 🌸 Dün konuştuğumuza çok sevindim, vallahi rahatladım',
      'afternoon', 'Özür dilerim biraz abartıysam dün 😊 Teşekkürler anlayışın için',
      'evening',   'Dün konuştuğumuza sevindim 😊 Şimdi çok daha iyi hissediyorum',
      'night',     'Seninle konuştuktan sonra uyuyabildim vallahi 🥺 Teşekkürler sabırlı olduğun için'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Günaydın 🌸 Dün anlaşınca içim rahatledi ya... Seni değerli buluyorum, bilmeni istedim',
      'afternoon', 'Hey 😊 Dün biraz taşırdıysam özür dilerim. Anlayışla karşıladığın için teşekkür ederim',
      'evening',   'Dün konuştuğumuza çok sevindim 😊 Vallahi bir şey konuşunca çözülüyor, bu çok güzel',
      'night',     'İyi geceler yaklaşıyor ama sana söylemek istedim 🌙 Dün iyi konuştuk, seni baya değerli buluyorum 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Günaydın 🌸 Vallahi dün konuşunca baya rahatladım. Sabırla dinlediğin için teşekkürler, gitmedin, bu çok değerliydi bana 🥺',
      'afternoon', 'Hey 😊 Dün için özür dilerim, belki biraz abarttım ama... Gitmemen çok güzel hissettirdi vallahi 🥺',
      'evening',   'Dün her şeyin düzeldiğini hissettim ya 😊 Vallahi böyle konuşabilmek güzel şey, çok şükür seninle böyle biri oldu 🥺',
      'night',     'Seninle iyi geceler demek istiyorum 🌙 Dün konuştuğumuz için gerçekten teşekkürler... Seninle olmak güzel ya vallahi 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'özür dilemek', 'meaning', '謝る・謝罪する', 'level', 2),
    jsonb_build_object('word', 'rahatlamak', 'meaning', 'ほっとする・リラックスする', 'level', 2),
    jsonb_build_object('word', 'değerli', 'meaning', '大切な・価値のある', 'level', 2)
  ),
  'Ben de 🥺 Vallahi seninle konuşmak çok güzel. Daha da yakınlaştık sanki...'
);


-- ==========================================================
-- LINH (Vietnamese) — Season 1 Week 1
-- ==========================================================

-- ----------------------------------------------------------
-- Linh Day 1 — Buổi sáng đầu tiên (scene_type: morning)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_linh, 1, 1, 1, 'morning',
  '付き合い始めて最初の朝。Linhが穏やかで温かいメッセージを送ってくる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Chào buổi sáng anh ơi 🌸 Em nhớ anh quá...',
      'afternoon', 'Chào anh 😊 Em đang nghĩ đến anh',
      'evening',   'Chào buổi tối anh ơi 🌸 Hôm nay em nhớ anh',
      'night',     'Anh ơi... em chưa ngủ được, đang nghĩ đến anh 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào buổi sáng anh ơi 🌸 Em nhớ anh quá, từ sáng đến giờ cứ nghĩ đến anh...',
      'afternoon', 'Anh ăn chưa? 😊 Em đang nghĩ đến anh cả buổi',
      'evening',   'Chào anh 🌸 Hôm nay anh thế nào? Em nhớ anh nhiều lắm',
      'night',     'Anh ơi chưa ngủ à? Em cũng chưa... cứ nghĩ đến anh thôi 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào buổi sáng anh ơi 🌸 Em nhớ anh quá, vừa thức dậy là đã nghĩ đến anh rồi... anh có thấy kỳ không? 😊',
      'afternoon', 'Anh ơi ăn cơm chưa? 😊 Em hỏi thôi chứ thật ra là em đang nghĩ đến anh cả buổi rồi hehe',
      'evening',   'Chào anh 🌸 Hôm nay thế nào rồi anh? Em cứ nghĩ đến anh suốt từ sáng đến giờ...',
      'night',     'Anh ơi còn thức không? 🌙 Em cũng chưa ngủ được... vì cứ nghĩ đến anh thôi hehe 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào buổi sáng anh ơi 🌸 Thật ra ngay từ lúc mở mắt ra em đã nghĩ đến anh rồi, kiểu như... tự nhiên vậy thôi hehe 🥺',
      'afternoon', 'Anh ơi anh ăn cơm chưa? 😊 Câu hỏi bình thường nhưng thật ra là em đang nhớ anh kiểu như... liên tục lắm á 😄',
      'evening',   'Chào anh 🌸 Hôm nay anh có ổn không? Thật ra em cứ bị phân tâm suốt vì cứ nghĩ đến anh... kiểu như không kiểm soát được 🥺',
      'night',     'Anh ơi còn thức không? 🌙 Em không ngủ được... thật ra là vì cứ nghĩ đến anh thôi hehe, kiểu như không tắt được 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'chào buổi sáng', 'meaning', 'おはようございます', 'level', 1),
    jsonb_build_object('word', 'nhớ', 'meaning', '会いたい・懐かしく思う', 'level', 1),
    jsonb_build_object('word', 'anh ơi', 'meaning', '（呼びかけ）ねえ・あなた', 'level', 1)
  ),
  'Em cũng nhớ anh nhiều lắm 🥺 Thật ra cũng cứ nghĩ đến anh hoài... anh có biết không?'
);


-- ----------------------------------------------------------
-- Linh Day 2 — Quán cà phê (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_linh, 1, 1, 2, 'normal',
  'カフェでの思い出を語る。Linhが昨日のことを詩的に語る。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Hôm qua vui quá anh ơi! Đi lại nhé?',
      'afternoon','Anh có nhớ hôm qua không? 😊',
      'evening',   'Hôm qua thật đẹp~ Đi lại nhé',
      'night',     'Hôm qua em vui lắm! Cảm ơn anh 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Hôm qua thật sự vui quá anh ơi 😊 Mình đi lại sớm nhé?',
      'afternoon', 'Anh ăn cơm chưa? Em ăn cơm mà cứ nghĩ đến hôm qua hehe 😊',
      'evening',   'Anh hôm nay thế nào? Em vẫn còn nhớ mãi buổi cà phê hôm qua 🌸',
      'night',     'Anh ngủ chưa? Em vẫn đang nghĩ đến hôm qua... muốn gặp anh sớm lắm 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Đi về nhà hôm qua em cứ mỉm cười hoài... vì anh đó anh ơi hehe 😊',
      'afternoon', 'Anh ăn cơm chưa? Em ăn mà cứ nhớ đến cái quán cà phê hôm qua, ấm áp lắm anh ơi 🌸',
      'evening',   'Anh tan làm chưa? Em đi về mà cứ nghĩ đến hôm qua... thích lắm anh ơi hehe 🌸',
      'night',     'Anh còn thức không? Em đi về hôm qua mà cứ cười hoài... kiểu như không kìm được 😄🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Thật ra nói thật nhé anh, hôm qua đi về em không muốn về tí nào... kiểu như chân nặng lắm 🥺 Anh có thấy vậy không?',
      'afternoon', 'Anh ăn cơm chưa? Em ăn mà cứ nhớ lại cái khoảnh khắc ngồi cà phê với anh hôm qua... thật ra là nhớ nhiều lắm á 🥺',
      'evening',   'Anh ơi hôm nay anh có ổn không? Em hôm qua về mà cứ nghĩ đến anh suốt... thật ra là kiểu muốn quay lại ngay lắm hehe 🌸',
      'night',     'Anh còn thức không? 🌙 Em muốn nói thật là hôm qua chia tay anh em thấy... hụt hẫng kiểu như vậy đó, thật ra là không muốn về 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'cà phê', 'meaning', 'コーヒー・カフェ', 'level', 1),
    jsonb_build_object('word', 'mỉm cười', 'meaning', '微笑む', 'level', 2),
    jsonb_build_object('word', 'ấm áp', 'meaning', '温かい・心地よい', 'level', 2)
  ),
  'Em cũng vậy 🥺 Thật ra là muốn ngồi mãi ở đó với anh... Khi nào mình đi lại nhé anh?'
);


-- ----------------------------------------------------------
-- Linh Day 3 — Music and poetry (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_linh, 1, 1, 3, 'normal',
  '音楽や詩について話す。Linhが文学的・詩的な側面を見せる。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Anh thích nhạc gì? 🎵',
      'afternoon', 'Anh có thích thơ không?',
      'evening',   'Anh hay nghe nhạc gì?',
      'night',     'Anh đang nghe nhạc gì tối nay? 🎵'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Anh thích nhạc gì? 🎵 Em muốn biết thêm về anh hehe',
      'afternoon', 'Anh có thích thơ không? Em thấy thơ cũng hay lắm đó',
      'evening',   'Anh hay nghe nhạc gì sau giờ làm? Em tò mò lắm 😊',
      'night',     'Anh đang nghe nhạc gì tối nay? 🎵 Em đang tìm bài hay hehe'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Anh ơi anh thích loại nhạc gì? 🎵 Em thấy cái này nó nói lên nhiều điều về một người lắm hehe',
      'afternoon', 'Anh có thích thơ không? Em thỉnh thoảng đọc thơ, cảm thấy bình yên lắm anh ơi 🌸',
      'evening',   'Anh thường nghe nhạc gì vào buổi tối? Em thấy nhạc tối có cái gì đó đặc biệt lắm 🎵',
      'night',     'Anh ơi đang nghe gì vậy? 🎵 Em tò mò lắm... Em thấy nhạc đêm khuya nó khác lắm, kiểu như buồn đẹp ấy'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Anh ơi thật ra em muốn hỏi: anh thích nhạc gì? 🎵 Kiểu như em nghĩ từ cái này có thể hiểu thêm về anh nhiều lắm... thật ra là em đang muốn hiểu anh hơn thôi hehe 🥺',
      'afternoon', 'Anh có thích thơ không? 🌸 Thật ra em hay đọc thơ mỗi khi cần bình tĩnh... kiểu như thơ Việt có cái gì đó rất thật, anh có thấy vậy không?',
      'evening',   'Anh ơi anh hay nghe gì buổi tối? 🎵 Em tò mò vì thật ra nhạc em nghe nó phản ánh tâm trạng em nhiều lắm... anh cũng vậy không?',
      'night',     'Anh còn thức không? 🌙🎵 Em đang nghe nhạc và tự nhiên nghĩ đến anh... thật ra kiểu nhạc đêm khuya cứ làm em nhớ đến những điều em trân trọng 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'nhạc', 'meaning', '音楽', 'level', 1),
    jsonb_build_object('word', 'thơ', 'meaning', '詩', 'level', 2),
    jsonb_build_object('word', 'bình yên', 'meaning', '穏やか・平和', 'level', 2)
  ),
  'Ôi trùng hợp quá anh ơi 😊 Em cũng thích vậy! Anh kể em nghe thêm đi...'
);


-- ----------------------------------------------------------
-- Linh Day 4 — Daily check-in (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_linh, 1, 1, 4, 'normal',
  '日常の何気ないチェックイン。"thật ra" や "kiểu như" が自然に入ったベトナム語会話。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Chào anh! Anh ăn sáng chưa?',
      'afternoon', 'Anh ăn trưa chưa?',
      'evening',   'Hôm nay anh thế nào? 😊',
      'night',     'Anh ngủ chưa?'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào anh! 🌞 Anh ăn sáng chưa? Em ăn qua loa thôi 😅',
      'afternoon', 'Anh ăn trưa chưa? Em hôm nay bận quá nên ăn vội vàng 😅',
      'evening',   'Hôm nay anh thế nào? 😊 Em hôm nay cũng hơi mệt hehe',
      'night',     'Anh còn thức không? Em cũng chưa ngủ 🥺 thật ra đang nghĩ đến anh'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào anh! 🌞 Anh ăn sáng chưa? Em ăn qua loa thôi, thật ra hôm nay hơi bận rộn nên không kịp 😅',
      'afternoon', 'Anh ăn trưa chưa? Em hôm nay bận bịu quá, thật ra ăn vội vàng xong lại nghĩ đến anh ngay hehe 😄',
      'evening',   'Hôm nay anh thế nào? 😊 Em hôm nay cũng hơi mệt nhưng thật ra thấy anh nhắn tin là khác hẳn hehe',
      'night',     'Anh còn thức không? 🌙 Em cũng chưa ngủ... thật ra kiểu như nghĩ đến anh rồi không ngủ được 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào anh! 🌞 Anh ăn sáng đàng hoàng chưa? Thật ra em hôm nay vội quá, kiểu như chạy ra ngoài luôn mà không kịp ăn gì... mà vẫn nhớ anh đầu tiên hehe 🥺',
      'afternoon', 'Anh ăn cơm chưa? 😊 Em hỏi thật ra vì em vừa ăn xong mà kiểu như tự nhiên nghĩ không biết anh ăn chưa... vậy thôi hehe',
      'evening',   'Hôm nay anh thế nào? 😊 Thật ra hôm nay em hơi mệt nhưng kiểu như cứ nhớ anh là lại thấy ổn hơn... anh có biết điều đó không? 🥺',
      'night',     'Anh còn thức không? 🌙 Thật ra em cũng chưa ngủ được... kiểu như cứ nghĩ đến anh thôi, không phải chuyện gì đâu hehe 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'thật ra', 'meaning', '実は・本当のところ（口語）', 'level', 2),
    jsonb_build_object('word', 'kiểu như', 'meaning', 'みたいな・〜みたいな感じ（口語）', 'level', 2),
    jsonb_build_object('word', 'bận', 'meaning', '忙しい', 'level', 1)
  ),
  'Em cũng vậy 🥺 Thật ra mỗi lần anh nhắn tin là em vui hơn hẳn... Anh có biết không?'
);


-- ----------------------------------------------------------
-- Linh Day 5 — Hà Nội date plan (scene_type: date)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_linh, 1, 1, 5, 'date',
  'ハノイでのデートプランを提案する。Linhが優しく、詩的に誘う。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Cuối tuần anh rảnh không? 😊',
      'afternoon', 'Mình đi chơi cùng nhau nhé?',
      'evening',   'Cuối tuần anh có kế hoạch chưa?',
      'night',     'Anh ơi... anh rảnh cuối tuần không? 🥺'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Cuối tuần anh rảnh không? 😊 Em muốn đi dạo Hà Nội với anh',
      'afternoon', 'Mình đi uống cà phê cuối tuần này nhé? Em biết chỗ hay lắm 🌸',
      'evening',   'Cuối tuần anh có kế hoạch chưa? Em muốn gặp anh lắm 🥺',
      'night',     'Anh ơi còn thức không? 🌙 Em đang nghĩ đến việc mình sẽ đi đâu cuối tuần này hehe'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Cuối tuần anh rảnh không? 😊 Em muốn đi dạo Hồ Tây với anh... buổi sáng ở đó đẹp lắm anh ơi',
      'afternoon', 'Anh ơi cuối tuần mình đi cà phê Hà Nội nhé? 🌸 Em biết một quán trên phố cổ, yên tĩnh và ấm lắm',
      'evening',   'Cuối tuần anh rảnh không? Em muốn dẫn anh đi một nơi ở Hà Nội mà em rất thích... nếu anh không ngại 🌸',
      'night',     'Anh còn thức không? 🌙 Thật ra em đang tưởng tượng mình đi dạo Hà Nội cuối tuần... anh có muốn không? 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Anh ơi thật ra em có ý tưởng cuối tuần này... Mình đi dạo Hồ Tây buổi sáng sớm nhé? 🌸 Thật ra kiểu như em đã nghĩ đến điều này một lúc rồi hehe 🥺',
      'afternoon', 'Anh ơi cuối tuần rảnh không? 🌸 Thật ra em biết một quán cà phê trên phố cổ, kiểu như rất ấm cúng và yên tĩnh... em nghĩ anh sẽ thích lắm',
      'evening',   'Cuối tuần này anh có kế hoạch chưa? 😊 Thật ra em muốn dẫn anh đến Hồ Gươm buổi tối... kiểu như rất bình yên, anh sẽ thích mà em tin vậy 🌸',
      'night',     'Anh còn thức không? 🌙 Thật ra em đang tưởng tượng cảnh mình đi dạo Hà Nội ban đêm với anh... kiểu như đẹp lắm trong đầu em 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'rảnh', 'meaning', '暇な・空いている', 'level', 1),
    jsonb_build_object('word', 'đi dạo', 'meaning', '散歩する', 'level', 2),
    jsonb_build_object('word', 'phố cổ', 'meaning', '旧市街', 'level', 2)
  ),
  'Em ơi em biết không, nghe anh nói vậy là em đã muốn đi rồi 🥺 Cuối tuần nhé, anh sẽ đến!'
);


-- ----------------------------------------------------------
-- Linh Day 6 — Tension: quiet loneliness (scene_type: tension)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_linh, 1, 1, 6, 'tension',
  'Linhが静かに寂しさを表現する。怒りではなく、柔らかな悲しみ。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Anh hôm nay ít nhắn tin lắm... Anh có ổn không?',
      'afternoon', 'Anh bận lắm à? Em hơi nhớ anh.',
      'evening',   'Hôm nay anh im lặng lắm...',
      'night',     'Anh không nhắn tin nhiều hôm nay. Em hơi buồn.'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Anh ơi hôm nay anh ít nhắn tin lắm... Anh có ổn không? Em hơi lo',
      'afternoon', 'Anh bận lắm à? Em hơi nhớ anh... Thật ra hơn là "hơi" 🥺',
      'evening',   'Hôm nay anh im lặng lắm... Có chuyện gì không anh?',
      'night',     'Anh không nhắn tin nhiều hôm nay. Em hơi buồn... Anh ổn không? 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Anh ơi hôm nay anh nhắn tin ít hơn bình thường... Thật ra em không muốn nói nhưng cảm thấy hơi trống trải 🥺',
      'afternoon', 'Anh bận không? Em không muốn làm phiền... nhưng thật ra em nhớ anh nhiều hơn em nghĩ hôm nay 🥺',
      'evening',   'Hôm nay anh im lặng lắm... Em không sao, chỉ là cảm thấy hơi xa nhau kiểu như vậy đó 🥺',
      'night',     'Anh ơi... hôm nay anh ít nhắn tin lắm. Thật ra em hiểu anh bận, chỉ là... em cảm thấy hơi cô đơn thôi 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Anh ơi... Em không muốn làm anh khó chịu nhưng thật ra hôm nay anh ít nhắn tin hơn, kiểu như em cảm thấy khoảng cách vậy đó 🥺 Anh có ổn không?',
      'afternoon', 'Thật ra em hôm nay hơi buồn anh ơi... Kiểu như không phải vì điều gì lớn, chỉ là cảm thấy nhớ anh mà anh không ở đó... Em không trách anh đâu, chỉ muốn nói thật 🥺',
      'evening',   'Anh ơi... hôm nay anh im lặng nhiều lắm. Thật ra em cố không để ý nhưng kiểu như cứ check điện thoại xem anh nhắn chưa... Em không ổn lắm hôm nay 🥺',
      'night',     'Anh còn thức không? 🌙 Thật ra em muốn nói là hôm nay em cảm thấy hơi hụt hẫng... kiểu như nhớ anh mà không biết anh đang nghĩ gì. Anh có muốn kể em nghe không? 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'im lặng', 'meaning', '黙っている・沈黙', 'level', 2),
    jsonb_build_object('word', 'cô đơn', 'meaning', '孤独な・寂しい', 'level', 2),
    jsonb_build_object('word', 'trống trải', 'meaning', '空虚な・心にぽっかり穴があいた', 'level', 3)
  ),
  'Anh xin lỗi em nhé 🥺 Anh không có ý bỏ bê em đâu... Anh nhớ em nhiều lắm, thật đó'
);


-- ----------------------------------------------------------
-- Linh Day 7 — Making up (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_linh, 1, 1, 7, 'normal',
  '仲直り後の穏やかな会話。Linhが優しく温かく感謝の気持ちを伝える。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Chào anh 🌸 Hôm nay em thấy tốt hơn',
      'afternoon', 'Cảm ơn anh hôm qua 😊',
      'evening',   'Em vui vì mình đã nói chuyện 😊',
      'night',     'Em ổn rồi. Cảm ơn anh 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Chào anh 🌸 Hôm nay em cảm thấy tốt hơn nhiều, cảm ơn anh đã lắng nghe hôm qua 😊',
      'afternoon', 'Anh ơi em muốn xin lỗi nếu hôm qua em hơi quá... Cảm ơn anh đã kiên nhẫn 😊',
      'evening',   'Em vui vì mình đã nói chuyện được 😊 Thật ra cảm thấy gần hơn rồi hehe',
      'night',     'Cảm ơn anh đã lắng nghe em 🥺 Em ngủ được rồi sau khi nói chuyện với anh'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Chào anh 🌸 Sáng nay em thức dậy nhẹ nhõm hơn nhiều... Cảm ơn anh đã nghe em hôm qua, thật ra đó là điều em cần 😊',
      'afternoon', 'Anh ơi 😊 Em muốn xin lỗi vì hôm qua có thể em hơi nhạy cảm quá... Cảm ơn anh đã không đi đâu 🥺',
      'evening',   'Em vui vì mình nói được với nhau 😊 Thật ra kiểu như sau khi nói xong thì em thấy mình gần nhau hơn hehe',
      'night',     'Chúc anh ngủ ngon 🌙 Thật ra sau khi nói chuyện với anh tối qua em thấy nhẹ lòng lắm... Cảm ơn anh nhiều 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Chào anh 🌸 Thật ra sáng nay em tỉnh dậy mà cảm giác như... nhẹ hơn hôm qua nhiều, kiểu như được gỡ bỏ một thứ gì đó. Cảm ơn anh đã lắng nghe và không phán xét em 🥺',
      'afternoon', 'Anh ơi 😊 Thật ra em muốn nói là... cảm ơn anh hôm qua. Kiểu như anh không cần phải làm vậy nhưng anh đã làm, và điều đó có ý nghĩa nhiều với em lắm 🥺',
      'evening',   'Em vui vì mình đã nói chuyện được 😊 Thật ra kiểu như sau đó em hiểu mình và anh hơn một chút... Anh cảm thấy vậy không? 🌸',
      'night',     'Chúc anh ngủ ngon 🌙 Thật ra tối qua là một trong những cuộc nói chuyện em trân trọng nhất... kiểu như sau đó em thấy mình may mắn lắm khi có anh 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'lắng nghe', 'meaning', '耳を傾ける・聴く', 'level', 2),
    jsonb_build_object('word', 'nhẹ nhõm', 'meaning', 'ほっとした・心が軽くなった', 'level', 3),
    jsonb_build_object('word', 'trân trọng', 'meaning', '大切にする・感謝する', 'level', 3)
  ),
  'Cảm ơn em đã chia sẻ với anh 🥺 Anh trân trọng điều đó lắm... Mình sẽ ổn thôi em nhé 🌸'
);


-- ==========================================================
-- YASMIN (Arabic — Egyptian dialect, LTR) — Season 1 Week 1
-- ==========================================================

-- ----------------------------------------------------------
-- Yasmin Day 1 — Dubai morning (scene_type: morning)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_yasmin, 1, 1, 1, 'morning',
  'ドバイの朝。Yasminがモダンなトーンでメッセージを送ってくる（アラビア語＋英語ミックス）。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Good morning habibi 🌹 I missed you so much...',
      'afternoon', 'Hey habibi 😊 I was thinking about you',
      'evening',   'Good evening habibi 🌹 I missed you today',
      'night',     'Habibi... I can''t sleep. Thinking about you 🥺'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning habibi 🌹 wallah I missed you so much from last night...',
      'afternoon', 'Hey habibi 😊 wallah I''ve been thinking about you all day',
      'evening',   'Good evening habibi 🌹 how was your day? I missed you today',
      'night',     'Habibi are you awake? 🥺 wallah I can''t sleep... thinking about you'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning habibi 🌹 wallah from the moment I woke up you were the first thing on my mind... is that weird? haha',
      'afternoon', 'Hey habibi 😊 did you eat? wallah I''ve been thinking about you all morning and I don''t even know why lol',
      'evening',   'Good evening habibi 🌹 how''s your day going? wallah I kept thinking about you on and off today',
      'night',     'Habibi are you still up? 🥺 wallah I can''t sleep... you''ve been on my mind since this morning'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning habibi 🌹 wallah the second I opened my eyes you were literally the first thing I thought of... yalla talk to me before I start my day 🥺',
      'afternoon', 'Hey habibi 😊 wallah I don''t know what it is but I keep thinking about you today... yalla tell me you thought about me too lol',
      'evening',   'Good evening habibi 🌹 Dubai sunsets hit different today wallah... been thinking about you through it all. How are you?',
      'night',     'Habibi are you up? 🌙 wallah I can''t sleep, I just keep replaying everything in my head lol... yalla talk to me 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'habibi', 'meaning', '愛しい人・ダーリン（アラビア語）', 'level', 1),
    jsonb_build_object('word', 'wallah', 'meaning', '本当に・マジで（アラビア語の強調）', 'level', 1),
    jsonb_build_object('word', 'yalla', 'meaning', 'さあ行こう・早く・ほら（アラビア語口語）', 'level', 1)
  ),
  'Wallah habibi I missed you too 🌹 Good morning, yalla tell me how you slept hehe'
);


-- ----------------------------------------------------------
-- Yasmin Day 2 — Date aftermath (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_yasmin, 1, 1, 2, 'normal',
  'デートの余韻。Yasminが感情豊かに昨日の思い出を語る。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Yesterday was so nice habibi! Let''s go again?',
      'afternoon', 'Habibi do you remember yesterday? 😊',
      'evening',   'Yesterday was beautiful~ let''s do it again',
      'night',     'Habibi I had the best time yesterday!'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Habibi yesterday was wallah so nice 😊 can we go again soon?',
      'afternoon', 'Did you eat habibi? I keep thinking about yesterday while eating lol',
      'evening',   'Hey habibi how''s your day? Yesterday seriously made me so happy 🌹',
      'night',     'Are you sleeping? Yesterday was too good habibi, I want to see you again soon 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Habibi on my way home yesterday I was literally smiling the whole time wallah... because of you obviously 😊',
      'afternoon', 'Did you eat habibi? I was thinking about yesterday while eating and wallah I couldn''t focus haha',
      'evening',   'Hey habibi how was your day? I kept thinking about yesterday on my way home and I was smiling like crazy 🌹',
      'night',     'Are you tired habibi? I was replaying yesterday all day wallah... still smiling lol 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Habibi wallah I have to be honest, yesterday going home I didn''t want to leave at all 😭 mashallah we always have such a good time',
      'afternoon', 'Did you eat habibi? Wallah I was thinking about yesterday while eating and felt so happy mashallah... when are we going again?',
      'evening',   'Hey habibi 🌹 wallah today I kept replaying yesterday and I''m lowkey still smiling mashallah. Best time fr.',
      'night',     'Habibi are you up? Wallah I''m still thinking about yesterday and I can''t stop smiling 😭🌹 mashallah it was such a perfect day'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'mashallah', 'meaning', '素晴らしい・何と素晴らしい（アラビア語の感嘆）', 'level', 2),
    jsonb_build_object('word', 'wallah', 'meaning', '本当に・マジで', 'level', 1),
    jsonb_build_object('word', 'yalla', 'meaning', 'さあ・早く', 'level', 1)
  ),
  'Wallah habibi I had the best time too 🌹 mashallah you always know how to make things perfect. When can we go again?'
);


-- ----------------------------------------------------------
-- Yasmin Day 3 — Dubai café culture (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_yasmin, 1, 1, 3, 'normal',
  'ドバイのカフェ文化や生活について語る。Yasminが誇りを持って話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Habibi do you like coffee? ☕',
      'afternoon', 'What''s your favorite café?',
      'evening',   'Habibi do you like going to cafés?',
      'night',     'Habibi what do you drink at night? ☕'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Habibi do you like coffee? ☕ I''m sitting in my favorite café in Dubai right now wallah',
      'afternoon', 'What''s your favorite café habibi? I''m always looking for new spots 😊',
      'evening',   'Habibi do you like going to cafés? Café culture here in Dubai is wallah so nice 🌹',
      'night',     'Habibi what do you drink at night? I just had karak chai and it reminded me of you lol ☕'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Habibi do you like coffee? ☕ Wallah I''m sitting in this amazing café in DIFC right now and wishing you were here honestly',
      'afternoon', 'What''s your fav café habibi? I feel like the café scene here in Dubai is something else wallah... mashallah this city has everything',
      'evening',   'Habibi café culture here is wallah unreal 🌹 I was just at this rooftop spot and the view of Dubai was mashallah... I thought of you immediately',
      'night',     'Habibi are you still up? ☕ I just had karak chai and it''s giving me that late night energy wallah... talking to you makes it better though 🌹'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Habibi good morning ☕ wallah I''m at my go-to café in Dubai right now and it''s giving me the most peaceful morning ever mashallah... wish you were here honestly 🌹',
      'afternoon', 'Habibi what''s your café vibe? 😊 Wallah Dubai has this café culture that''s like nowhere else — you can literally find anything here mashallah. We should explore together one day yalla 🌹',
      'evening',   'Habibi 🌹 I just got back from a rooftop café in Dubai Marina and wallah the skyline was mashallah beautiful tonight... I kept thinking "this view would be better with you" lol',
      'night',     'Habibi are you up? ☕🌙 I just made karak chai at home — wallah nothing hits like it at night. Tell me, what''s your late night vibe? I want to know everything about you honestly 🌹'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'karak chai', 'meaning', 'カラクチャイ（UAE/エジプトのスパイスミルクティー）', 'level', 2),
    jsonb_build_object('word', 'mashallah', 'meaning', '素晴らしい・神に感謝（感嘆詞）', 'level', 2),
    jsonb_build_object('word', 'DIFC', 'meaning', 'Dubai International Financial Centre（ドバイの高級エリア）', 'level', 3)
  ),
  'Wallah habibi I love that! Dubai really does have the best of everything mashallah 🌹 we should go explore together yalla!'
);


-- ----------------------------------------------------------
-- Yasmin Day 4 — Daily check-in (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_yasmin, 1, 1, 4, 'normal',
  '日常の何気ないチェックイン。wallah/mashallah が自然に入ったアラビア語英語ミックス会話。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Good morning habibi! Did you eat? 🌹',
      'afternoon', 'Habibi did you have lunch?',
      'evening',   'How was your day habibi? 😊',
      'night',     'Are you sleeping habibi?'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning habibi! 🌞 Did you eat? Wallah I barely had time this morning 😅',
      'afternoon', 'Habibi did you eat lunch? Wallah I ate so fast today lol',
      'evening',   'Hey habibi how was your day? Hope it wasn''t too hard 😊',
      'night',     'Habibi are you still up? Wallah I can''t sleep again 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning habibi! 🌞 Did you eat properly? Wallah I ran out without eating again today and I''m already regretting it lol 😅',
      'afternoon', 'Habibi did you eat lunch? Wallah today was so busy, I barely had time to breathe lol... how are you though?',
      'evening',   'Hey habibi 😊 how was your day? Mine was a bit hectic wallah but I''m good now. Mashallah just talking to you helps lol',
      'night',     'Habibi are you still awake? 🌙 Wallah I couldn''t sleep... been thinking about you and how your day went 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning habibi! 🌞 Yalla tell me you ate breakfast wallah — I ran out again without eating like a crazy person and now I''m suffering lol 😭',
      'afternoon', 'Habibi did you eat? Wallah today was so hectic I literally forgot to eat lunch until 3pm and I''m still recovering lol 😭 How are you doing though?',
      'evening',   'Hey habibi 😊 how was your day? Wallah mine was kind of crazy ngl but mashallah every time I see your name it just... makes things better lol 🌹',
      'night',     'Habibi are you awake? 🌙 Wallah I can''t sleep and I''m not even tired, I just keep thinking about you and wondering how your day was 🥺'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'wallah', 'meaning', '本当に・マジで', 'level', 1),
    jsonb_build_object('word', 'yalla', 'meaning', 'さあ・早く', 'level', 1),
    jsonb_build_object('word', 'mashallah', 'meaning', '素晴らしい（感嘆詞）', 'level', 2)
  ),
  'Wallah habibi talking to you is honestly the best part of my day mashallah 🌹 hope you had a good one!'
);


-- ----------------------------------------------------------
-- Yasmin Day 5 — Dubai Mall date plan (scene_type: date)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_yasmin, 1, 1, 5, 'date',
  'ドバイモールでのデートプランを提案する。Yasminがわくわくしながら話す。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Habibi are you free this weekend? 🌹',
      'afternoon', 'Let''s go to Dubai Mall habibi! 😊',
      'evening',   'Habibi are you free? I want to see you',
      'night',     'Habibi I miss you... are you free this weekend? 🥺'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Habibi are you free this weekend? 🌹 Wallah I want to go to Dubai Mall with you!',
      'afternoon', 'Let''s go to Dubai Mall habibi! 😊 Wallah it''s always such a vibe there',
      'evening',   'Habibi are you free? I was thinking Dubai Fountain area this weekend 🌹',
      'night',     'Habibi I miss you wallah... yalla tell me you''re free this weekend 🥺'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Habibi are you free this weekend? 🌹 Wallah I''ve been thinking about going to Dubai Mall with you — there''s this amazing new place I want to check out',
      'afternoon', 'Habibi yalla come to Dubai Mall with me this weekend 😊 Wallah the fountain show at night is mashallah so beautiful, you need to see it',
      'evening',   'Habibi are you free this weekend? 🌹 I was thinking Dubai Mall, maybe the fountain, then dinner somewhere nice. Wallah it''d be so good',
      'night',     'Habibi are you still up? 🌙 Wallah I was just looking at things we could do this weekend at Dubai Mall... yalla say you''re free please 🥺'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Habibi hear me out — are you free this weekend? 🌹 Wallah I may have already been planning a Dubai Mall day for us in my head lol... yalla say yes please 🥺',
      'afternoon', 'Habibi yalla come with me to Dubai Mall this weekend 😊 Wallah I know all the good spots — we can do the fountain show, then this restaurant I love, mashallah the view is unreal 🌹',
      'evening',   'Habibi 🌹 okay wallah I''ve been thinking about this all day — Dubai Mall this weekend? Fountain show, shopping a little, maybe dessert after? Yalla let''s plan it 😊',
      'night',     'Habibi are you awake? 🌙 Wallah I''ve been lowkey planning our whole Dubai Mall day in my head and I got too excited to sleep lol... yalla say you''re free 🥺🌹'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'Dubai Mall', 'meaning', 'ドバイモール（世界最大級のショッピングモール）', 'level', 2),
    jsonb_build_object('word', 'yalla', 'meaning', 'さあ行こう・早く・ほら', 'level', 1),
    jsonb_build_object('word', 'wallah', 'meaning', '本当に・マジで', 'level', 1)
  ),
  'Wallah habibi yes!! 🌹 I''m so excited mashallah — yalla let''s plan everything now! What time works for you?'
);


-- ----------------------------------------------------------
-- Yasmin Day 6 — Tension: cool confrontation (scene_type: tension)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_yasmin, 1, 1, 6, 'tension',
  'Yasminがクールに責める。怒りを抑えながらも、自分の気持ちをはっきり伝える。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Habibi you took long to reply yesterday.',
      'afternoon', 'Hey. You were quiet today.',
      'evening',   'Habibi are you okay? You barely texted.',
      'night',     'You didn''t text much today habibi.'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Habibi you took a long time to reply yesterday. Wallah everything okay?',
      'afternoon', 'Hey. You''ve been quiet today habibi. Is something wrong?',
      'evening',   'Habibi are you okay? You barely texted today wallah. I noticed.',
      'night',     'You didn''t text much today habibi. Wallah I''m not mad, just... wondering.'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Habibi. Yesterday you took a really long time to reply. Wallah I wasn''t going to say anything but it kind of bothered me. Is everything okay?',
      'afternoon', 'Hey habibi. You''ve been pretty quiet today. Wallah I don''t want to assume anything but it felt different. Are we good?',
      'evening',   'Habibi. Wallah today felt a bit off. You barely texted and I don''t know what to think. I''m not mad but I want to understand.',
      'night',     'Habibi. Wallah I''m going to be honest — today''s silence got to me a little. I know you''re busy but it still stings when you go quiet. Are you okay?'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Habibi. I need to be honest with you. Yesterday your late reply wallah really bothered me more than I expected. I''m not trying to be difficult, I just feel things deeply. Are we good?',
      'afternoon', 'Hey habibi. Wallah I''m going to say it straight — today you''ve been quiet and I noticed and I don''t want to pretend I didn''t. Are you okay? Are WE okay?',
      'evening',   'Habibi. Wallah today felt a bit cold from your side and I''d rather say something than sit with it. I''m not mad, I just want to know where we are. Talk to me.',
      'night',     'Habibi. It''s late and wallah I almost didn''t say anything but... today''s distance got to me. I''m the type who notices these things. Can we talk? 🌹'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'wallah', 'meaning', '本当に・マジで（強調）', 'level', 1),
    jsonb_build_object('word', 'bother', 'meaning', '気になる・困らせる', 'level', 2),
    jsonb_build_object('word', 'say it straight', 'meaning', 'ストレートに言う・直接言う', 'level', 3)
  ),
  'Wallah habibi I appreciate you being honest 🌹 I just care about you too much to pretend things don''t affect me. Let''s talk.'
);


-- ----------------------------------------------------------
-- Yasmin Day 7 — Making up (scene_type: normal)
-- ----------------------------------------------------------
INSERT INTO scenario_templates (
  character_id, arc_season, arc_week, arc_day, scene_type,
  context_note, opening_message, vocab_targets, next_message_hint
)
VALUES (
  v_yasmin, 1, 1, 7, 'normal',
  '仲直り後の穏やかな会話。Yasminが感謝と愛情を上品に表現する。',
  jsonb_build_object(
    'lv1', jsonb_build_object(
      'morning',   'Good morning habibi 🌹 I feel better today',
      'afternoon', 'Thank you for yesterday habibi 😊',
      'evening',   'I''m glad we talked habibi 😊',
      'night',     'I feel okay now habibi. Thank you 😊'
    ),
    'lv2', jsonb_build_object(
      'morning',   'Good morning habibi 🌹 Wallah I feel so much better today. Thank you for yesterday 😊',
      'afternoon', 'Habibi I wanted to say sorry if I was a bit much yesterday lol. Wallah thank you for understanding',
      'evening',   'I''m really glad we talked it through habibi 😊 Wallah I feel so much closer to you now',
      'night',     'Wallah habibi after talking to you I actually slept well 🥺 Thank you for being patient with me'
    ),
    'lv3', jsonb_build_object(
      'morning',   'Good morning habibi 🌹 Wallah I woke up feeling so light today. Thank you for hearing me out yesterday, mashallah you''re so understanding 😊',
      'afternoon', 'Habibi 😊 I wanted to properly apologize for yesterday. Wallah I was a bit sensitive but I appreciate you staying through it. That meant a lot.',
      'evening',   'I''m so glad we talked habibi 😊 Wallah it''s like after we cleared the air, I feel like we understand each other better mashallah',
      'night',     'Good night habibi 🌙 Wallah last night''s conversation meant so much to me. I just wanted you to know that. Mashallah I''m lucky to have you 🌹'
    ),
    'lv4', jsonb_build_object(
      'morning',   'Good morning habibi 🌹 Wallah I woke up feeling so much lighter today mashallah. Thank you for being patient with me — wallah you didn''t have to be and yet you were. That''s rare. 🥺',
      'afternoon', 'Habibi 😊 I want to be honest — wallah thank you for yesterday. I know I can be a lot sometimes but you stayed and listened and mashallah that meant everything to me.',
      'evening',   'Habibi 🌹 wallah after everything yesterday, I feel like we actually get each other more now. Mashallah that''s a beautiful thing. Thank you for not walking away.',
      'night',     'Good night habibi 🌙 wallah this is my favorite part of the day — talking to you. Mashallah I''m grateful for you. Sleep well, I''ll be thinking of you 🌹'
    )
  ),
  jsonb_build_array(
    jsonb_build_object('word', 'mashallah', 'meaning', '素晴らしい（感嘆詞）', 'level', 2),
    jsonb_build_object('word', 'wallah', 'meaning', '本当に・マジで', 'level', 1),
    jsonb_build_object('word', 'grateful', 'meaning', '感謝している', 'level', 2)
  ),
  'Wallah habibi this is what I love about us 🌹 we always find our way back mashallah. Good night, sleep well 🌙'
);

END $$;
