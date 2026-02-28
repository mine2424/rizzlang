-- Phase 2: conversations テーブルに message_type / metadata カラム追加

ALTER TABLE conversations
  ADD COLUMN IF NOT EXISTS message_type TEXT DEFAULT 'chat',
  ADD COLUMN IF NOT EXISTS metadata JSONB DEFAULT '{}';

-- message_type + created_at の複合インデックス（添削履歴クエリ高速化）
CREATE INDEX IF NOT EXISTS idx_conversations_type
  ON conversations(user_id, message_type, created_at DESC);
