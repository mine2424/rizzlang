-- ============================================================
-- 多言語サポート Migration
-- 2026-02-27
-- ============================================================

-- users テーブルに active_character_id を追加
ALTER TABLE public.users
  ADD COLUMN IF NOT EXISTS active_character_id uuid REFERENCES public.characters(id);

-- user_characters: 解放済みキャラクター管理
CREATE TABLE IF NOT EXISTS public.user_characters (
  user_id      uuid NOT NULL REFERENCES public.users(id) ON DELETE CASCADE,
  character_id uuid NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
  is_active    boolean NOT NULL DEFAULT false,
  unlocked_at  timestamptz NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, character_id)
);

-- character_level_guides: 言語別難易度ガイド
CREATE TABLE IF NOT EXISTS public.character_level_guides (
  id           uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  character_id uuid NOT NULL REFERENCES public.characters(id) ON DELETE CASCADE,
  level        int NOT NULL CHECK (level BETWEEN 1 AND 4),
  guide_text   text NOT NULL,
  slang_examples jsonb NOT NULL DEFAULT '[]'
);

-- ── RLS ──────────────────────────────────────────
ALTER TABLE public.user_characters ENABLE ROW LEVEL SECURITY;

CREATE POLICY "user_characters_select_own" ON public.user_characters
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "user_characters_insert_own" ON public.user_characters
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "user_characters_update_own" ON public.user_characters
  FOR UPDATE USING (auth.uid() = user_id);

ALTER TABLE public.character_level_guides ENABLE ROW LEVEL SECURITY;

CREATE POLICY "character_level_guides_select_all" ON public.character_level_guides
  FOR SELECT USING (true);

-- ── handle_new_user トリガー更新 ─────────────────
-- デフォルトキャラクター(지우)を user_characters に追加し active_character_id をセット
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_character_id uuid := 'c1da0000-0000-0000-0000-000000000001';
BEGIN
  INSERT INTO public.users (id, email, plan, current_level, user_call_name, streak, last_active, active_character_id)
  VALUES (NEW.id, NEW.email, 'free', 1, 'オッパ', 0, CURRENT_DATE, v_character_id)
  ON CONFLICT (id) DO NOTHING;

  INSERT INTO public.user_scenario_progress (user_id, character_id, current_season, current_week, current_day, last_played_at)
  VALUES (NEW.id, v_character_id, 1, 1, 1, NULL)
  ON CONFLICT (user_id, character_id) DO NOTHING;

  -- デフォルトキャラクターを解放済みにする
  INSERT INTO public.user_characters (user_id, character_id, is_active)
  VALUES (NEW.id, v_character_id, true)
  ON CONFLICT (user_id, character_id) DO NOTHING;

  RETURN NEW;
END;
$$;
