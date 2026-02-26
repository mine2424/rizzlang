#!/usr/bin/env bash
# ============================================================
# RizzLang — ローカル開発環境 初回セットアップスクリプト
# 使い方: ./scripts/setup-local.sh
# ============================================================
set -e

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════╗"
echo "║     RizzLang ローカル開発環境セットアップ    ║"
echo "╚══════════════════════════════════════════╝"
echo -e "${NC}"

# ── 依存チェック ──
check_dependency() {
  if ! command -v "$1" &>/dev/null; then
    echo -e "${RED}❌ $1 が見つかりません${NC}"
    echo "   インストール: $2"
    exit 1
  fi
  echo -e "${GREEN}✅ $1${NC}"
}

echo -e "${YELLOW}📋 依存関係を確認します...${NC}"
check_dependency "supabase" "brew install supabase/tap/supabase"
check_dependency "flutter"  "https://flutter.dev/docs/get-started/install"
check_dependency "docker"   "https://www.docker.com/products/docker-desktop"

# Docker 起動確認
if ! docker info &>/dev/null; then
  echo -e "${RED}❌ Docker が起動していません。Docker Desktop を起動してください${NC}"
  exit 1
fi
echo -e "${GREEN}✅ Docker 起動中${NC}"

# ── Flutter 依存インストール ──
echo ""
echo -e "${YELLOW}📦 Flutter 依存関係をインストールします...${NC}"
flutter pub get

# ── Supabase ローカル起動 ──
echo ""
echo -e "${YELLOW}🚀 Supabase ローカルエミュレータを起動します...${NC}"
echo "   (初回は Docker イメージのダウンロードで数分かかります)"
supabase start

# ── DB マイグレーション + シード適用 ──
echo ""
echo -e "${YELLOW}🗄️  DB マイグレーションとシードデータを適用します...${NC}"
supabase db reset

# ── 接続情報を表示 ──
echo ""
echo -e "${GREEN}"
echo "╔═════════════════════════════════════════════════════════╗"
echo "║  ✅ セットアップ完了！                                     ║"
echo "╠═════════════════════════════════════════════════════════╣"
echo "║                                                          ║"
echo "║  Supabase Studio:  http://127.0.0.1:54323               ║"
echo "║  API Endpoint:     http://127.0.0.1:54321               ║"
echo "║  メール確認:        http://127.0.0.1:54324               ║"
echo "║                                                          ║"
echo "║  テストユーザー:   test@rizzlang.local                   ║"
echo "║  パスワード:       test1234                               ║"
echo "║                                                          ║"
echo "╠═════════════════════════════════════════════════════════╣"
echo "║  次のコマンドでアプリを起動:                               ║"
echo "║                                                          ║"
echo "║    make run          # シミュレータ / エミュレータ          ║"
echo "║    make run-device   # 物理デバイス（LAN 接続）            ║"
echo "║                                                          ║"
echo "╚═════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# ── Mac の LAN IP を表示（物理デバイス用）──
LAN_IP=$(ipconfig getifaddr en0 2>/dev/null || hostname -I 2>/dev/null | awk '{print $1}' || echo "取得失敗")
if [ "$LAN_IP" != "取得失敗" ]; then
  echo -e "${YELLOW}📱 物理デバイスで接続する場合:${NC}"
  echo "   make run-device LOCAL_HOST=$LAN_IP"
  echo ""
fi
