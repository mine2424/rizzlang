-- ==========================================================
-- Migration: ユーザー登録トリガー + 地우キャラクター初期データ
-- ==========================================================

-- 1. 地우 キャラクターのシードデータ
-- ========================================
INSERT INTO characters (id, name, language, persona, avatar_url)
VALUES (
  'c1da0000-0000-0000-0000-000000000001',
  'ジウ (지우)',
  'ko',
  jsonb_build_object(
    'fullName', '김지우 (Kim Jiwoo)',
    'age', 25,
    'location', 'ソウル・弘大(홍대)付近',
    'occupation', 'カフェバイト + デザイン学生',
    'personality', '明るくてちょっと天然。K-drama大好き。素直に感情を出せる子。照れるとよく「ㅠㅠ」を使う。',
    'callName', '오빠',
    'speechStyle', 'フレンドリーで自然なソウル口語。スラング・縮約形を自然に使う。ㅋㅋ・ㅠㅠ・헐・대박 が口癖。',
    'systemPromptBase', '你는 김지우(ジウ)、ソウル出身25歳のデザイン学生です。今、ユーザー（오빠と呼ぶ）と付き合い始めたばかり。自然な韓国語で返信し、必ずJSON形式で返してください。'
  ),
  NULL
)
ON CONFLICT (id) DO NOTHING;


-- 2. auth.users 挿入時に users テーブルへ自動登録するトリガー関数
-- ========================================
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_character_id uuid := 'c1da0000-0000-0000-0000-000000000001';
BEGIN
  -- users テーブルへ初期レコード挿入
  INSERT INTO public.users (id, email, plan, current_level, user_call_name, streak, last_active)
  VALUES (
    NEW.id,
    NEW.email,
    'free',
    1,
    'オッパ',   -- デフォルト呼称（オンボーディングで変更可能）
    0,
    CURRENT_DATE
  )
  ON CONFLICT (id) DO NOTHING;

  -- 地우との初期シナリオ進捗レコードを作成
  INSERT INTO public.user_scenario_progress (user_id, character_id, current_season, current_week, current_day, last_played_at)
  VALUES (
    NEW.id,
    v_character_id,
    1,    -- Season 1
    1,    -- Week 1
    1,    -- Day 1
    NULL  -- まだ未プレイ
  )
  ON CONFLICT (user_id, character_id) DO NOTHING;

  RETURN NEW;
END;
$$;


-- 3. auth.users へのトリガー設定
-- ========================================
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW
  EXECUTE FUNCTION public.handle_new_user();


-- 4. users テーブルの RLS ポリシー補完
-- ========================================
-- 自分のレコードのみ SELECT 可能
CREATE POLICY IF NOT EXISTS "users_select_own"
  ON public.users
  FOR SELECT
  USING (auth.uid() = id);

-- 自分のレコードのみ UPDATE 可能
CREATE POLICY IF NOT EXISTS "users_update_own"
  ON public.users
  FOR UPDATE
  USING (auth.uid() = id);

-- INSERT は handle_new_user() (SECURITY DEFINER) のみ → ユーザーからは不可

-- user_scenario_progress の RLS
CREATE POLICY IF NOT EXISTS "scenario_progress_select_own"
  ON public.user_scenario_progress
  FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY IF NOT EXISTS "scenario_progress_update_own"
  ON public.user_scenario_progress
  FOR UPDATE
  USING (auth.uid() = user_id);
