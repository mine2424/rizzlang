-- 弱点語彙クエリの最適化
CREATE INDEX IF NOT EXISTS idx_user_vocabulary_review
  ON user_vocabulary(user_id, character_id, next_review_at)
  WHERE next_review_at IS NOT NULL;
