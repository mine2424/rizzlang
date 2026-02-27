-- relationship_memories テーブル
CREATE TABLE IF NOT EXISTS relationship_memories (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id          UUID REFERENCES users(id) ON DELETE CASCADE,
  character_id     UUID REFERENCES characters(id) ON DELETE CASCADE,
  week_number      INT NOT NULL,
  week_start       DATE NOT NULL,
  week_end         DATE NOT NULL,
  summary          TEXT NOT NULL,
  emotional_weight INT DEFAULT 5 CHECK (emotional_weight BETWEEN 1 AND 10),
  created_at       TIMESTAMPTZ DEFAULT now()
);

-- ユニーク制約（同週の重複防止）
CREATE UNIQUE INDEX ON relationship_memories(user_id, character_id, week_number);

-- インデックス
CREATE INDEX ON relationship_memories(user_id, character_id, week_number DESC);

-- RLS
ALTER TABLE relationship_memories ENABLE ROW LEVEL SECURITY;

CREATE POLICY "users_own_memories" ON relationship_memories
  FOR ALL USING (auth.uid() = user_id);
