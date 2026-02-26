-- Tension シーン 2フェーズ管理カラム追加

ALTER TABLE public.user_scenario_progress
  ADD COLUMN IF NOT EXISTS tension_phase text DEFAULT NULL
    CHECK (tension_phase IN ('friction', 'reconciliation', 'resolved'));

ALTER TABLE public.user_scenario_progress
  ADD COLUMN IF NOT EXISTS tension_turn_count int NOT NULL DEFAULT 0;

COMMENT ON COLUMN public.user_scenario_progress.tension_phase IS
  'tension シーンのフェーズ: null=通常 / friction=摩擦 / reconciliation=仲直り / resolved=完了';

COMMENT ON COLUMN public.user_scenario_progress.tension_turn_count IS
  '現在の tension フェーズ内ターン数（friction 2ターンで reconciliation へ移行）';
