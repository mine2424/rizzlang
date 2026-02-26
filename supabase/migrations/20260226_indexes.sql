-- パフォーマンス改善インデックス
-- Task 12.2: DB レベルでのクエリ最適化

CREATE INDEX IF NOT EXISTS idx_conversations_user_date ON conversations(user_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_vocabulary_next_review ON vocabulary(user_id, next_review);
CREATE INDEX IF NOT EXISTS idx_usage_logs_user_date ON usage_logs(user_id, date DESC);
CREATE INDEX IF NOT EXISTS idx_fcm_tokens_user_enabled ON fcm_tokens(user_id, enabled);
