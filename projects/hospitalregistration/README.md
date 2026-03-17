# 🏥 安康綜合醫院 門診掛號系統

安康綜合醫院門診掛號系統，採用現代化網頁技術開發，提供病患掛號、資料管理與門診預約功能。

## 系統架構

| 層別 | 技術 | 說明 |
|------|------|------|
| 前端 | React 19 + TypeScript + Vite | 單頁式應用，Tailwind CSS 樣式 |
| 後端 | Node.js + Express 5 | RESTful API 伺服器 |
| 資料庫 | SQLite (better-sqlite3) | WAL 模式，6 張資料表 |

## 專案結構

```
hospitalregistration/
├── frontend/          # React 前端
│   └── src/
│       ├── App.tsx    # 主要元件（病患資訊 + 門診預約）
│       ├── main.tsx   # 進入點
│       └── index.css  # 全域樣式
├── backend/           # Express 後端
│   └── server.js      # API 伺服器（port 3001）
├── database/          # SQLite 資料庫
│   ├── hospital.db    # 資料庫檔案
│   └── schema.sql     # 資料表結構與預設資料
├── docs/              # 文件
│   ├── 掛號系統檔案結構.html   # 資料庫與 UI 設計文件
│   ├── 掛號系統檔案結構.docx   # Word 格式
│   └── 掛號系統檔案結構.pdf    # PDF 格式
├── install.command    # 雙擊安裝（macOS）
└── start.command      # 雙擊啟動（macOS）
```

## 安裝與啟動

### 方法一：使用 .command 檔案（macOS）

1. 雙擊 `install.command` 安裝套件（僅需執行一次）
2. 雙擊 `start.command` 啟動系統，自動開啟瀏覽器

### 方法二：手動執行

```bash
# 安裝後端套件
cd backend
npm install

# 安裝前端套件
cd ../frontend
npm install

# 啟動後端（port 3001）
cd ../backend
node server.js &

# 啟動前端（port 5173）
cd ../frontend
npm run dev
```

開啟瀏覽器前往 http://localhost:5173

## 資料庫設計

參考慈濟醫院門診掛號系統檔案結構，設計 6 張資料表：

| 資料表 | 說明 | 對應慈濟系統 |
|--------|------|-------------|
| cities | 全台 22 縣市 | 縣市主檔 COUNTYTBL |
| districts | 各縣市鄉鎮市區 | 鄉鎮主檔 TOWNTBL |
| departments | 8 大科別 | 院內科別檔 GenSectionTbl |
| doctors | 每科 3 位醫師，共 24 位 | 醫師檔 GenDoctorTbl |
| patients | 病患資料（病歷號碼為唯一識別碼） | （新設計） |
| registrations | 掛號紀錄（自動產生掛號號碼） | 掛號看診檔 OpdRegDiagnosisTbl |

## 系統功能

- **病歷號碼驗證** — 台灣身分證字號 MOD-10 檢查碼即時驗證
- **自動帶入** — 輸入病歷號碼自動查詢並帶入病患資料
- **級聯選單** — 縣市→區域、科別→醫師 動態級聯下拉選單
- **自動計算** — 年齡由生日自動計算、初複診自動判斷
- **自動給號** — 掛號號碼依當日該科累計數自動產生
- **列印功能** — 掛號成功後可列印掛號單

## API 端點

| 方法 | 路徑 | 功能 |
|------|------|------|
| GET | /api/cities | 取得所有縣市 |
| GET | /api/cities/:id/districts | 取得該縣市區域 |
| GET | /api/departments | 取得所有科別 |
| GET | /api/departments/:id/doctors | 取得該科別醫師 |
| GET | /api/patients?medical_no=xxx | 查詢病患 |
| POST | /api/patients | 新增病患 |
| PUT | /api/patients/:id | 更新病患 |
| POST | /api/registrations | 建立掛號紀錄 |
