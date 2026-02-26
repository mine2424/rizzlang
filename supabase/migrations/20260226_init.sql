-- RizzLang データベーススキーマ

-- ユーザー
CREATE TABLE public.users (
  id              uuid PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
  email           text UNIQUE NOT NULL,
  plan            text NOT NULL DEFAULT 'free' CHECK (plan IN ('free', 'pro')),
  stripe_customer_id text,
  current_level   int NOT NULL DEFAULT 1 CHECK (current_level BETWEEN 1 AND 4),
  user_call_name  text NOT NULL DEFAULT 'オッパ',
  streak          int NOT NULL DEFAULT 0,
  last_active     date,
  created_at      timestamptz NOT NULL DEFAULT now()
);

-- キャラクター
CREATE TABLE public.characters (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  name        text NOT NULL,
  language    text NOT NULL,
  persona     jsonb NOT NULL,
  avatar_url  text,
  created_at  timestamptz NOT NULL DEFAULT now()
);

-- 会話セッション（1ユーザー×1キャラ×1日 = 1レコード）
CREATE TABLE public.conversations (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  character_id  uuid NOT NULL REFERENCES public.characters(id),
  date          date NOT NULL DEFAULT CURRENT_DATE,
  messages      jsonb NOT NULL DEFAULT '[]',
  turns_used    int NOT NULL DEFAULT 0,
  created_at    timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, character_id, date)
);

-- シナリオテンプレート
CREATE TABLE public.scenario_templates (
  id              uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  character_id    uuid NOT NULL REFERENCES public.characters(id),
  arc_season      int NOT NULL,
  arc_week        int NOT NULL,
  arc_day         int NOT NULL CHECK (arc_day BETWEEN 1 AND 7),
  scene_type      text NOT NULL CHECK (scene_type IN ('daily','emotional','discovery','event','tension')),
  opening_message jsonb NOT NULL,
  vocab_targets   jsonb NOT NULL DEFAULT '[]',
  next_message_hint text,
  created_at      timestamptz NOT NULL DEFAULT now(),
  UNIQUE(character_id, arc_season, arc_week, arc_day)
);

-- シナリオ進捗
CREATE TABLE public.user_scenario_progress (
  user_id       uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  character_id  uuid NOT NULL REFERENCES public.characters(id),
  current_season int NOT NULL DEFAULT 1,
  current_week   int NOT NULL DEFAULT 1,
  current_day    int NOT NULL DEFAULT 1,
  last_played_at timestamptz,
  PRIMARY KEY (user_id, character_id)
);

-- 語彙帳
CREATE TABLE public.vocabulary (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  word          text NOT NULL,
  meaning       text NOT NULL,
  example       text,
  language      text NOT NULL DEFAULT 'ko',
  learned_at    timestamptz NOT NULL DEFAULT now(),
  next_review   timestamptz NOT NULL DEFAULT now() + interval '1 day',
  review_count  int NOT NULL DEFAULT 0,
  ease_factor   float NOT NULL DEFAULT 2.5,
  UNIQUE(user_id, word, language)
);

-- 使用量ログ
CREATE TABLE public.usage_logs (
  id            uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id       uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  date          date NOT NULL DEFAULT CURRENT_DATE,
  turns_used    int NOT NULL DEFAULT 0,
  edit_count    int NOT NULL DEFAULT 0,
  retry_count   int NOT NULL DEFAULT 0,
  character_id  uuid REFERENCES public.characters(id),
  UNIQUE(user_id, date)
);

-- Push サブスクリプション（FCM トークン）
CREATE TABLE public.push_subscriptions (
  id          uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id     uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  fcm_token   text NOT NULL,
  enabled     boolean NOT NULL DEFAULT true,
  platform    text CHECK (platform IN ('ios', 'android')),
  created_at  timestamptz NOT NULL DEFAULT now(),
  UNIQUE(user_id, fcm_token)
);

-- インデックス
CREATE INDEX idx_conversations_user_date ON public.conversations(user_id, date);
CREATE INDEX idx_vocabulary_next_review ON public.vocabulary(next_review);
CREATE INDEX idx_usage_logs_user_date ON public.usage_logs(user_id, date);

-- RLS 有効化
ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.conversations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vocabulary ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.usage_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_scenario_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.push_subscriptions ENABLE ROW LEVEL SECURITY;

-- RLS ポリシー
CREATE POLICY "users_own" ON public.users USING (auth.uid() = id);
CREATE POLICY "conversations_own" ON public.conversations USING (auth.uid() = user_id);
CREATE POLICY "vocabulary_own" ON public.vocabulary USING (auth.uid() = user_id);
CREATE POLICY "usage_logs_own" ON public.usage_logs USING (auth.uid() = user_id);
CREATE POLICY "progress_own" ON public.user_scenario_progress USING (auth.uid() = user_id);
CREATE POLICY "push_own" ON public.push_subscriptions USING (auth.uid() = user_id);

-- キャラクターとシナリオは全ユーザーが読める
ALTER TABLE public.characters ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.scenario_templates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "characters_read" ON public.characters FOR SELECT USING (true);
CREATE POLICY "scenarios_read" ON public.scenario_templates FOR SELECT USING (true);

-- 使用量インクリメント関数（RLSをバイパスするためService Roleで実行）
CREATE OR REPLACE FUNCTION public.increment_usage(p_user_id uuid, p_date date)
RETURNS void LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.usage_logs (user_id, date, turns_used)
  VALUES (p_user_id, p_date, 1)
  ON CONFLICT (user_id, date)
  DO UPDATE SET turns_used = usage_logs.turns_used + 1;
END;
$$;

-- 初回ログイン時にユーザーレコード自動作成トリガー
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger LANGUAGE plpgsql SECURITY DEFINER AS $$
BEGIN
  INSERT INTO public.users (id, email)
  VALUES (NEW.id, NEW.email)
  ON CONFLICT (id) DO NOTHING;
  RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
