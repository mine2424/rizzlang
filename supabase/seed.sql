-- ============================================================
-- RizzLang — ローカル開発シードデータ
-- `supabase db reset` 時に自動適用される
-- ============================================================

-- シナリオシードデータ（Season 1 Week 1）
\i seeds/season1_week1.sql

-- ============================================================
-- テスト用ユーザーデータ（ローカル開発専用）
-- ============================================================

-- テストユーザー: test@rizzlang.local (パスワード: test1234)
-- ※ Supabase ローカルの auth.users に直接挿入
INSERT INTO auth.users (
  id,
  instance_id,
  email,
  encrypted_password,
  email_confirmed_at,
  created_at,
  updated_at,
  raw_app_meta_data,
  raw_user_meta_data,
  is_super_admin,
  role,
  aud
)
VALUES (
  '00000000-0000-0000-0000-000000000099',
  '00000000-0000-0000-0000-000000000000',
  'test@rizzlang.local',
  crypt('test1234', gen_salt('bf')),
  now(),
  now(),
  now(),
  '{"provider":"email","providers":["email"]}',
  '{}',
  false,
  'authenticated',
  'authenticated'
)
ON CONFLICT (id) DO NOTHING;

-- テストユーザーの users レコード（トリガー経由で作成されるが手動でも追加）
INSERT INTO public.users (id, email, plan, current_level, user_call_name, streak, last_active)
VALUES (
  '00000000-0000-0000-0000-000000000099',
  'test@rizzlang.local',
  'free',
  2,
  'オッパ',
  7,
  CURRENT_DATE
)
ON CONFLICT (id) DO UPDATE SET
  plan = EXCLUDED.plan,
  streak = EXCLUDED.streak,
  last_active = EXCLUDED.last_active;

-- テストユーザーのシナリオ進捗（Day 1 から開始）
INSERT INTO public.user_scenario_progress (user_id, character_id, current_season, current_week, current_day, last_played_at)
VALUES (
  '00000000-0000-0000-0000-000000000099',
  'c1da0000-0000-0000-0000-000000000001',
  1, 1, 1,
  NULL
)
ON CONFLICT (user_id, character_id) DO UPDATE SET
  current_season = EXCLUDED.current_season,
  current_week = EXCLUDED.current_week,
  current_day = EXCLUDED.current_day;

-- テスト語彙データ（語彙帳画面の確認用）
INSERT INTO public.vocabulary (id, user_id, word, meaning, example, language, learned_at, next_review, review_count, ease_factor)
VALUES
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000099', '행복하다', '幸せだ', '어제 진짜 행복했어', 'ko', now() - interval '1 hour', now() + interval '1 day', 0, 2.5),
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000099', '설레다', 'ときめく・胸がはやる', '내일 설레서 잠 못 잘 것 같아', 'ko', now() - interval '2 hours', now() - interval '1 hour', 1, 2.5),
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000099', '고생했겠다', 'お疲れ様', '진짜 고생했겠다 ㅠ', 'ko', now() - interval '1 day', now() - interval '2 hours', 2, 2.6),
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000099', '편의점', 'コンビニ', '편의점 삼각김밥 먹었어', 'ko', now() - interval '2 days', now() + interval '5 days', 3, 2.7),
  (gen_random_uuid(), '00000000-0000-0000-0000-000000000099', '드디어', 'ついに', '드디어 오늘이다!', 'ko', now() - interval '3 days', now() + interval '14 days', 4, 2.8)
ON CONFLICT (user_id, word, language) DO NOTHING;

-- テスト usage_logs（ストリークバー確認用）
INSERT INTO public.usage_logs (user_id, date, turns_used, edit_count, retry_count, character_id)
VALUES (
  '00000000-0000-0000-0000-000000000099',
  CURRENT_DATE,
  2,
  0,
  0,
  'c1da0000-0000-0000-0000-000000000001'
)
ON CONFLICT (user_id, date) DO UPDATE SET
  turns_used = EXCLUDED.turns_used;
