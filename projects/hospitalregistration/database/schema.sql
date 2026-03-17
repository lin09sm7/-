-- 安康綜合醫院 掛號系統 SQLite Schema
-- Referenced from Hospital Registration UI

PRAGMA foreign_keys = ON;

-- ==============================
-- 縣市表
-- ==============================
CREATE TABLE IF NOT EXISTS cities (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    name TEXT    NOT NULL UNIQUE  -- 縣市名稱
);

-- ==============================
-- 區域表 (關聯縣市)
-- ==============================
CREATE TABLE IF NOT EXISTS districts (
    id      INTEGER PRIMARY KEY AUTOINCREMENT,
    name    TEXT    NOT NULL,      -- 區域名稱
    city_id INTEGER NOT NULL,      -- 所屬縣市
    FOREIGN KEY (city_id) REFERENCES cities(id)
);

-- ==============================
-- 科別表
-- ==============================
CREATE TABLE IF NOT EXISTS departments (
    id   INTEGER PRIMARY KEY AUTOINCREMENT,
    code TEXT    NOT NULL UNIQUE,  -- 科別代碼
    name TEXT    NOT NULL          -- 科別名稱
);

-- ==============================
-- 醫師表 (關聯科別)
-- ==============================
CREATE TABLE IF NOT EXISTS doctors (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    name          TEXT    NOT NULL,  -- 醫師姓名
    department_id INTEGER NOT NULL,  -- 所屬科別
    FOREIGN KEY (department_id) REFERENCES departments(id)
);

-- ==============================
-- 病患資料表 (關聯縣市、區域)
-- ==============================
CREATE TABLE IF NOT EXISTS patients (
    id          INTEGER PRIMARY KEY AUTOINCREMENT,
    medical_no  TEXT    NOT NULL UNIQUE,  -- 病歷號碼
    name        TEXT    NOT NULL,         -- 姓名
    gender      TEXT    CHECK(gender IN ('male', 'female')),
    birthday    TEXT,                     -- YYYY/MM/DD
    age         INTEGER,
    phone       TEXT,
    city_id     INTEGER,                 -- 縣市
    district_id INTEGER,                 -- 區域
    address     TEXT,                    -- 詳細地址
    created_at  TEXT DEFAULT (datetime('now', 'localtime')),
    updated_at  TEXT DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (city_id)     REFERENCES cities(id),
    FOREIGN KEY (district_id) REFERENCES districts(id)
);

-- ==============================
-- 掛號紀錄表
-- ==============================
CREATE TABLE IF NOT EXISTS registrations (
    id            INTEGER PRIMARY KEY AUTOINCREMENT,
    reg_number    TEXT    NOT NULL,
    patient_id    INTEGER NOT NULL,
    visit_type    TEXT    CHECK(visit_type IN ('first', 'return')),
    reg_date      TEXT    NOT NULL,
    department_id INTEGER NOT NULL,
    doctor_id     INTEGER NOT NULL,
    status        TEXT    DEFAULT 'confirmed' CHECK(status IN ('confirmed', 'cancelled', 'completed')),
    created_at    TEXT    DEFAULT (datetime('now', 'localtime')),
    FOREIGN KEY (patient_id)    REFERENCES patients(id),
    FOREIGN KEY (department_id) REFERENCES departments(id),
    FOREIGN KEY (doctor_id)     REFERENCES doctors(id)
);

-- ==============================
-- 索引
-- ==============================
CREATE INDEX idx_districts_city         ON districts(city_id);
CREATE INDEX idx_doctors_department     ON doctors(department_id);
CREATE INDEX idx_patients_medical_no    ON patients(medical_no);
CREATE INDEX idx_patients_city          ON patients(city_id);
CREATE INDEX idx_patients_district      ON patients(district_id);
CREATE INDEX idx_registrations_date     ON registrations(reg_date);
CREATE INDEX idx_registrations_patient  ON registrations(patient_id);

-- ==============================
-- 預設資料：全台灣 22 縣市
-- ==============================
INSERT INTO cities (name) VALUES
    ('台北市'),     -- 1
    ('新北市'),     -- 2
    ('基隆市'),     -- 3
    ('桃園市'),     -- 4
    ('新竹市'),     -- 5
    ('新竹縣'),     -- 6
    ('苗栗縣'),     -- 7
    ('台中市'),     -- 8
    ('彰化縣'),     -- 9
    ('南投縣'),     -- 10
    ('雲林縣'),     -- 11
    ('嘉義市'),     -- 12
    ('嘉義縣'),     -- 13
    ('台南市'),     -- 14
    ('高雄市'),     -- 15
    ('屏東縣'),     -- 16
    ('宜蘭縣'),     -- 17
    ('花蓮縣'),     -- 18
    ('台東縣'),     -- 19
    ('澎湖縣'),     -- 20
    ('金門縣'),     -- 21
    ('連江縣');     -- 22

-- ==============================
-- 預設資料：全台灣區域 (依縣市分組)
-- ==============================

-- 1. 台北市
INSERT INTO districts (name, city_id) VALUES
    ('中正區', 1), ('大同區', 1), ('中山區', 1), ('松山區', 1),
    ('大安區', 1), ('萬華區', 1), ('信義區', 1), ('士林區', 1),
    ('北投區', 1), ('內湖區', 1), ('南港區', 1), ('文山區', 1);

-- 2. 新北市
INSERT INTO districts (name, city_id) VALUES
    ('板橋區', 2), ('三重區', 2), ('中和區', 2), ('永和區', 2),
    ('新莊區', 2), ('新店區', 2), ('土城區', 2), ('蘆洲區', 2),
    ('汐止區', 2), ('樹林區', 2), ('鶯歌區', 2), ('三峽區', 2),
    ('淡水區', 2), ('瑞芳區', 2), ('五股區', 2), ('泰山區', 2),
    ('林口區', 2), ('深坑區', 2), ('石碇區', 2), ('坪林區', 2),
    ('三芝區', 2), ('石門區', 2), ('八里區', 2), ('平溪區', 2),
    ('雙溪區', 2), ('貢寮區', 2), ('金山區', 2), ('萬里區', 2),
    ('烏來區', 2);

-- 3. 基隆市
INSERT INTO districts (name, city_id) VALUES
    ('仁愛區', 3), ('信義區', 3), ('中正區', 3), ('中山區', 3),
    ('安樂區', 3), ('暖暖區', 3), ('七堵區', 3);

-- 4. 桃園市
INSERT INTO districts (name, city_id) VALUES
    ('桃園區', 4), ('中壢區', 4), ('大溪區', 4), ('楊梅區', 4),
    ('蘆竹區', 4), ('大園區', 4), ('龜山區', 4), ('八德區', 4),
    ('龍潭區', 4), ('平鎮區', 4), ('新屋區', 4), ('觀音區', 4),
    ('復興區', 4);

-- 5. 新竹市
INSERT INTO districts (name, city_id) VALUES
    ('東區', 5), ('北區', 5), ('香山區', 5);

-- 6. 新竹縣
INSERT INTO districts (name, city_id) VALUES
    ('竹北市', 6), ('竹東鎮', 6), ('新埔鎮', 6), ('關西鎮', 6),
    ('湖口鄉', 6), ('新豐鄉', 6), ('芎林鄉', 6), ('橫山鄉', 6),
    ('北埔鄉', 6), ('寶山鄉', 6), ('峨眉鄉', 6), ('尖石鄉', 6),
    ('五峰鄉', 6);

-- 7. 苗栗縣
INSERT INTO districts (name, city_id) VALUES
    ('苗栗市', 7), ('頭份市', 7), ('竹南鎮', 7), ('後龍鎮', 7),
    ('通霄鎮', 7), ('苑裡鎮', 7), ('卓蘭鎮', 7), ('造橋鄉', 7),
    ('西湖鄉', 7), ('頭屋鄉', 7), ('公館鄉', 7), ('銅鑼鄉', 7),
    ('三義鄉', 7), ('大湖鄉', 7), ('獅潭鄉', 7), ('三灣鄉', 7),
    ('南庄鄉', 7), ('泰安鄉', 7);

-- 8. 台中市
INSERT INTO districts (name, city_id) VALUES
    ('中區', 8), ('東區', 8), ('南區', 8), ('西區', 8),
    ('北區', 8), ('北屯區', 8), ('西屯區', 8), ('南屯區', 8),
    ('太平區', 8), ('大里區', 8), ('霧峰區', 8), ('烏日區', 8),
    ('豐原區', 8), ('后里區', 8), ('石岡區', 8), ('東勢區', 8),
    ('新社區', 8), ('潭子區', 8), ('大雅區', 8), ('神岡區', 8),
    ('大肚區', 8), ('沙鹿區', 8), ('龍井區', 8), ('梧棲區', 8),
    ('清水區', 8), ('大甲區', 8), ('外埔區', 8), ('大安區', 8),
    ('和平區', 8);

-- 9. 彰化縣
INSERT INTO districts (name, city_id) VALUES
    ('彰化市', 9), ('員林市', 9), ('鹿港鎮', 9), ('和美鎮', 9),
    ('北斗鎮', 9), ('溪湖鎮', 9), ('田中鎮', 9), ('二林鎮', 9),
    ('線西鄉', 9), ('伸港鄉', 9), ('福興鄉', 9), ('秀水鄉', 9),
    ('花壇鄉', 9), ('芬園鄉', 9), ('大村鄉', 9), ('埔鹽鄉', 9),
    ('埔心鄉', 9), ('永靖鄉', 9), ('社頭鄉', 9), ('二水鄉', 9),
    ('田尾鄉', 9), ('埤頭鄉', 9), ('芳苑鄉', 9), ('大城鄉', 9),
    ('竹塘鄉', 9), ('溪州鄉', 9);

-- 10. 南投縣
INSERT INTO districts (name, city_id) VALUES
    ('南投市', 10), ('埔里鎮', 10), ('草屯鎮', 10), ('竹山鎮', 10),
    ('集集鎮', 10), ('名間鄉', 10), ('鹿谷鄉', 10), ('中寮鄉', 10),
    ('魚池鄉', 10), ('國姓鄉', 10), ('水里鄉', 10), ('信義鄉', 10),
    ('仁愛鄉', 10);

-- 11. 雲林縣
INSERT INTO districts (name, city_id) VALUES
    ('斗六市', 11), ('斗南鎮', 11), ('虎尾鎮', 11), ('西螺鎮', 11),
    ('土庫鎮', 11), ('北港鎮', 11), ('古坑鄉', 11), ('大埤鄉', 11),
    ('莿桐鄉', 11), ('林內鄉', 11), ('二崙鄉', 11), ('崙背鄉', 11),
    ('麥寮鄉', 11), ('東勢鄉', 11), ('褒忠鄉', 11), ('台西鄉', 11),
    ('元長鄉', 11), ('四湖鄉', 11), ('口湖鄉', 11), ('水林鄉', 11);

-- 12. 嘉義市
INSERT INTO districts (name, city_id) VALUES
    ('東區', 12), ('西區', 12);

-- 13. 嘉義縣
INSERT INTO districts (name, city_id) VALUES
    ('太保市', 13), ('朴子市', 13), ('布袋鎮', 13), ('大林鎮', 13),
    ('民雄鄉', 13), ('溪口鄉', 13), ('新港鄉', 13), ('六腳鄉', 13),
    ('東石鄉', 13), ('義竹鄉', 13), ('鹿草鄉', 13), ('水上鄉', 13),
    ('中埔鄉', 13), ('竹崎鄉', 13), ('梅山鄉', 13), ('番路鄉', 13),
    ('大埔鄉', 13), ('阿里山鄉', 13);

-- 14. 台南市
INSERT INTO districts (name, city_id) VALUES
    ('中西區', 14), ('東區', 14), ('南區', 14), ('北區', 14),
    ('安平區', 14), ('安南區', 14), ('永康區', 14), ('歸仁區', 14),
    ('新化區', 14), ('左鎮區', 14), ('玉井區', 14), ('楠西區', 14),
    ('南化區', 14), ('仁德區', 14), ('關廟區', 14), ('龍崎區', 14),
    ('官田區', 14), ('麻豆區', 14), ('佳里區', 14), ('西港區', 14),
    ('七股區', 14), ('將軍區', 14), ('學甲區', 14), ('北門區', 14),
    ('新營區', 14), ('後壁區', 14), ('白河區', 14), ('東山區', 14),
    ('六甲區', 14), ('下營區', 14), ('柳營區', 14), ('鹽水區', 14),
    ('善化區', 14), ('大內區', 14), ('山上區', 14), ('新市區', 14),
    ('安定區', 14);

-- 15. 高雄市
INSERT INTO districts (name, city_id) VALUES
    ('楠梓區', 15), ('左營區', 15), ('鼓山區', 15), ('三民區', 15),
    ('鹽埕區', 15), ('前金區', 15), ('新興區', 15), ('苓雅區', 15),
    ('前鎮區', 15), ('旗津區', 15), ('小港區', 15), ('鳳山區', 15),
    ('林園區', 15), ('大寮區', 15), ('大樹區', 15), ('大社區', 15),
    ('仁武區', 15), ('鳥松區', 15), ('岡山區', 15), ('橋頭區', 15),
    ('燕巢區', 15), ('田寮區', 15), ('阿蓮區', 15), ('路竹區', 15),
    ('湖內區', 15), ('茄萣區', 15), ('永安區', 15), ('彌陀區', 15),
    ('梓官區', 15), ('旗山區', 15), ('美濃區', 15), ('六龜區', 15),
    ('甲仙區', 15), ('杉林區', 15), ('內門區', 15), ('茂林區', 15),
    ('桃源區', 15), ('那瑪夏區', 15);

-- 16. 屏東縣
INSERT INTO districts (name, city_id) VALUES
    ('屏東市', 16), ('潮州鎮', 16), ('東港鎮', 16), ('恆春鎮', 16),
    ('萬丹鄉', 16), ('長治鄉', 16), ('麟洛鄉', 16), ('九如鄉', 16),
    ('里港鄉', 16), ('鹽埔鄉', 16), ('高樹鄉', 16), ('萬巒鄉', 16),
    ('內埔鄉', 16), ('竹田鄉', 16), ('新埤鄉', 16), ('枋寮鄉', 16),
    ('新園鄉', 16), ('崁頂鄉', 16), ('林邊鄉', 16), ('南州鄉', 16),
    ('佳冬鄉', 16), ('琉球鄉', 16), ('車城鄉', 16), ('滿州鄉', 16),
    ('枋山鄉', 16), ('霧台鄉', 16), ('瑪家鄉', 16), ('泰武鄉', 16),
    ('來義鄉', 16), ('春日鄉', 16), ('獅子鄉', 16), ('牡丹鄉', 16),
    ('三地門鄉', 16);

-- 17. 宜蘭縣
INSERT INTO districts (name, city_id) VALUES
    ('宜蘭市', 17), ('羅東鎮', 17), ('蘇澳鎮', 17), ('頭城鎮', 17),
    ('礁溪鄉', 17), ('壯圍鄉', 17), ('員山鄉', 17), ('冬山鄉', 17),
    ('五結鄉', 17), ('三星鄉', 17), ('大同鄉', 17), ('南澳鄉', 17);

-- 18. 花蓮縣
INSERT INTO districts (name, city_id) VALUES
    ('花蓮市', 18), ('鳳林鎮', 18), ('玉里鎮', 18), ('新城鄉', 18),
    ('吉安鄉', 18), ('壽豐鄉', 18), ('光復鄉', 18), ('豐濱鄉', 18),
    ('瑞穗鄉', 18), ('富里鄉', 18), ('秀林鄉', 18), ('萬榮鄉', 18),
    ('卓溪鄉', 18);

-- 19. 台東縣
INSERT INTO districts (name, city_id) VALUES
    ('台東市', 19), ('成功鎮', 19), ('關山鎮', 19), ('卑南鄉', 19),
    ('鹿野鄉', 19), ('池上鄉', 19), ('東河鄉', 19), ('長濱鄉', 19),
    ('太麻里鄉', 19), ('大武鄉', 19), ('綠島鄉', 19), ('海端鄉', 19),
    ('延平鄉', 19), ('金峰鄉', 19), ('達仁鄉', 19), ('蘭嶼鄉', 19);

-- 20. 澎湖縣
INSERT INTO districts (name, city_id) VALUES
    ('馬公市', 20), ('湖西鄉', 20), ('白沙鄉', 20), ('西嶼鄉', 20),
    ('望安鄉', 20), ('七美鄉', 20);

-- 21. 金門縣
INSERT INTO districts (name, city_id) VALUES
    ('金城鎮', 21), ('金湖鎮', 21), ('金沙鎮', 21), ('金寧鄉', 21),
    ('烈嶼鄉', 21), ('烏坵鄉', 21);

-- 22. 連江縣
INSERT INTO districts (name, city_id) VALUES
    ('南竿鄉', 22), ('北竿鄉', 22), ('莒光鄉', 22), ('東引鄉', 22);

-- ==============================
-- 預設資料：科別
-- ==============================
INSERT INTO departments (code, name) VALUES
    ('internal',   '內科'),     -- 1
    ('surgery',    '外科'),     -- 2
    ('pediatrics', '小兒科'),   -- 3
    ('obgyn',      '婦產科'),   -- 4
    ('ent',        '耳鼻喉科'), -- 5
    ('derma',      '皮膚科'),   -- 6
    ('eye',        '眼科'),     -- 7
    ('family',     '家醫科');   -- 8

-- ==============================
-- 預設資料：醫師 (每科 3 位)
-- ==============================

-- 內科
INSERT INTO doctors (name, department_id) VALUES
    ('王建明', 1), ('林淑芬', 1), ('陳志豪', 1);

-- 外科
INSERT INTO doctors (name, department_id) VALUES
    ('張文華', 2), ('李美玲', 2), ('黃國榮', 2);

-- 小兒科
INSERT INTO doctors (name, department_id) VALUES
    ('劉怡君', 3), ('吳宗翰', 3), ('許雅婷', 3);

-- 婦產科
INSERT INTO doctors (name, department_id) VALUES
    ('蔡佩珊', 4), ('鄭凱文', 4), ('周淑惠', 4);

-- 耳鼻喉科
INSERT INTO doctors (name, department_id) VALUES
    ('楊俊傑', 5), ('蘇麗華', 5), ('洪振維', 5);

-- 皮膚科
INSERT INTO doctors (name, department_id) VALUES
    ('方雅琪', 6), ('謝承恩', 6), ('盧芷涵', 6);

-- 眼科
INSERT INTO doctors (name, department_id) VALUES
    ('曾國豪', 7), ('廖美慧', 7), ('趙柏翰', 7);

-- 家醫科
INSERT INTO doctors (name, department_id) VALUES
    ('林家豪', 8), ('陳雅文', 8), ('黃志偉', 8);
