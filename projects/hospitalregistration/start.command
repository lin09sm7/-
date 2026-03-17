#!/bin/bash
cd "$(dirname "$0")"

echo "============================================"
echo "  安康綜合醫院 掛號系統 - 啟動中..."
echo "============================================"
echo ""

# 啟動後端 (port 3001)
echo "[1/2] 啟動後端伺服器 (port 3001)..."
cd backend
node server.js &
BACKEND_PID=$!
echo "✓ 後端已啟動 (PID: $BACKEND_PID)"
echo ""

# 等待後端啟動
sleep 2

# 啟動前端 (port 5173)
echo "[2/2] 啟動前端伺服器..."
cd ../frontend
npm run dev &
FRONTEND_PID=$!
echo "✓ 前端已啟動 (PID: $FRONTEND_PID)"
echo ""

# 等待前端啟動後開啟瀏覽器
sleep 3
open http://localhost:5173

echo "============================================"
echo "  系統已啟動！"
echo "  前端：http://localhost:5173"
echo "  後端：http://localhost:3001"
echo ""
echo "  按 Ctrl+C 停止系統"
echo "============================================"

# 捕捉關閉信號，同時終止前後端
trap "kill $BACKEND_PID $FRONTEND_PID 2>/dev/null; exit" INT TERM

# 等待，保持視窗開啟
wait
