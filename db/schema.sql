-- 钕铁硼废料回收智能系统 - Supabase PostgreSQL 建表脚本
-- 在 Supabase SQL Editor 中执行此脚本创建所有表

-- 报价单
CREATE TABLE IF NOT EXISTS quotes (
  id TEXT PRIMARY KEY,
  sample_no TEXT,
  batch_no TEXT NOT NULL,
  date TEXT NOT NULL,
  division TEXT NOT NULL,
  creator TEXT NOT NULL,
  customer_name TEXT NOT NULL,
  material_name TEXT,
  material_type TEXT NOT NULL,
  net_weight REAL NOT NULL,
  mode TEXT NOT NULL,
  tax_mode TEXT NOT NULL DEFAULT 'inclusive',
  customer_offer REAL DEFAULT 0,
  quoter_name TEXT,
  custom_batch_no TEXT,
  status TEXT DEFAULT 'pending',
  note TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  purchase_low_price REAL,
  purchase_low_price_tax REAL,
  purchase_oxide_total REAL,
  actual_oxide_total REAL,
  total_price_diff REAL,
  total_yield_profit REAL,
  total_profit REAL,
  goods_total_profit REAL,
  processing_fee REAL,
  processing_fee_total REAL,
  processing_fee_net REAL,
  bm REAL,
  bn REAL,
  bp REAL,
  profit_per_ton REAL,
  profit_per_ton_prnd REAL,
  avg_profit REAL,
  unit_price_excl_tax REAL,
  unit_price_incl_tax REAL
);

-- 报价元素明细
CREATE TABLE IF NOT EXISTS quote_elements (
  id SERIAL PRIMARY KEY,
  quote_id TEXT NOT NULL,
  el TEXT NOT NULL,
  pct REAL,
  purchase_price REAL,
  sale_price REAL,
  purchase_output REAL,
  actual_output REAL,
  price_diff REAL,
  yield_profit REAL
);

-- 批次管理
CREATE TABLE IF NOT EXISTS batches (
  id SERIAL PRIMARY KEY,
  batch_no TEXT NOT NULL UNIQUE,
  division TEXT,
  quote_id TEXT,
  customer_name TEXT,
  material_type TEXT,
  net_weight REAL,
  in_stock_weight REAL,
  purchase_cost REAL DEFAULT 0,
  current_value REAL DEFAULT 0,
  potential_profit REAL DEFAULT 0,
  status TEXT DEFAULT 'quoted',
  quoter TEXT,
  purchaser TEXT,
  salesman TEXT,
  site_manager TEXT,
  escort TEXT,
  lab_staff TEXT,
  locked_price REAL,
  in_stock_date TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 化验录入
CREATE TABLE IF NOT EXISTS inspections (
  id SERIAL PRIMARY KEY,
  batch_no TEXT NOT NULL,
  round TEXT NOT NULL,
  date TEXT NOT NULL,
  inspector TEXT NOT NULL,
  la REAL DEFAULT 0,
  ce REAL DEFAULT 0,
  pr REAL DEFAULT 0,
  nd REAL DEFAULT 0,
  gd REAL DEFAULT 0,
  tb REAL DEFAULT 0,
  dy REAL DEFAULT 0,
  ho REAL DEFAULT 0,
  reo REAL DEFAULT 0,
  total_oxide REAL DEFAULT 0,
  net_weight REAL,
  is_external BOOLEAN DEFAULT FALSE,
  reviewer TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 异常管控
CREATE TABLE IF NOT EXISTS anomalies (
  id SERIAL PRIMARY KEY,
  batch_no TEXT NOT NULL,
  division TEXT,
  element TEXT NOT NULL,
  initial_value REAL,
  current_value REAL,
  deviation REAL,
  diff REAL,
  severity TEXT,
  status TEXT DEFAULT 'open',
  round_from TEXT,
  round_to TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 在库库存
CREATE TABLE IF NOT EXISTS inventory (
  id SERIAL PRIMARY KEY,
  batch_no TEXT NOT NULL,
  division TEXT,
  customer_name TEXT,
  material_type TEXT,
  net_weight REAL,
  purchase_cost REAL,
  current_market_value REAL,
  potential_profit REAL,
  status TEXT DEFAULT 'in_stock',
  in_stock_date TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 销售锁价
CREATE TABLE IF NOT EXISTS sales_locks (
  id SERIAL PRIMARY KEY,
  batch_no TEXT NOT NULL,
  quote_id TEXT,
  division TEXT,
  customer_name TEXT,
  material_type TEXT,
  net_weight REAL,
  element_purchase_prices JSONB,
  element_sale_prices JSONB,
  profit_per_ton_prnd REAL,
  unit_cost REAL,
  lock_price REAL,
  total_amount REAL,
  gross_profit REAL,
  profit_margin REAL,
  locked_by TEXT,
  locked_at TEXT,
  status TEXT DEFAULT 'locked',
  sale_date TEXT,
  note TEXT
);

-- 价格记录
CREATE TABLE IF NOT EXISTS price_records (
  id SERIAL PRIMARY KEY,
  date TEXT NOT NULL,
  element TEXT NOT NULL,
  purchase_price REAL,
  sale_price REAL,
  recorder TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 客户管理
CREATE TABLE IF NOT EXISTS customers (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  contact TEXT,
  phone TEXT,
  address TEXT,
  credit_level TEXT,
  division TEXT,
  material_type TEXT,
  total_weight REAL DEFAULT 0,
  total_revenue REAL DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 操作日志
CREATE TABLE IF NOT EXISTS logs (
  id SERIAL PRIMARY KEY,
  action TEXT NOT NULL,
  target TEXT NOT NULL,
  detail TEXT,
  user_name TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 回收站
CREATE TABLE IF NOT EXISTS recycle_bins (
  id SERIAL PRIMARY KEY,
  item_type TEXT NOT NULL,
  batch_no TEXT NOT NULL,
  data TEXT,
  deleted_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ
);

-- 采购台账
CREATE TABLE IF NOT EXISTS purchase_ledgers (
  id TEXT PRIMARY KEY,
  import_date TEXT,
  purchase_date TEXT NOT NULL,
  purchaser TEXT NOT NULL,
  supplier_name TEXT,
  batch_no TEXT,
  material_type TEXT,
  net_weight REAL,
  prnd_quantity REAL,
  prnd_unit_price REAL,
  prnd_total_amount REAL,
  remark TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 销售台账
CREATE TABLE IF NOT EXISTS sales_ledgers (
  id TEXT PRIMARY KEY,
  import_date TEXT,
  sale_date TEXT NOT NULL,
  salesman TEXT NOT NULL,
  customer_name TEXT,
  batch_no TEXT,
  material_type TEXT,
  net_weight REAL,
  prnd_quantity REAL,
  prnd_unit_price REAL,
  prnd_total_amount REAL,
  gross_profit REAL,
  remark TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 系统配置
CREATE TABLE IF NOT EXISTS system_config (
  id SERIAL PRIMARY KEY,
  key TEXT NOT NULL UNIQUE,
  value TEXT,
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 开启 RLS (行级安全) - 允许匿名访问
ALTER TABLE quotes ENABLE ROW LEVEL SECURITY;
ALTER TABLE quote_elements ENABLE ROW LEVEL SECURITY;
ALTER TABLE batches ENABLE ROW LEVEL SECURITY;
ALTER TABLE inspections ENABLE ROW LEVEL SECURITY;
ALTER TABLE anomalies ENABLE ROW LEVEL SECURITY;
ALTER TABLE inventory ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales_locks ENABLE ROW LEVEL SECURITY;
ALTER TABLE price_records ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE recycle_bins ENABLE ROW LEVEL SECURITY;
ALTER TABLE purchase_ledgers ENABLE ROW LEVEL SECURITY;
ALTER TABLE sales_ledgers ENABLE ROW LEVEL SECURITY;
ALTER TABLE system_config ENABLE ROW LEVEL SECURITY;

-- 创建允许所有访问的策略 (使用 service_role key 时不需要，但为安全起见)
CREATE POLICY IF NOT EXISTS allow_all ON quotes FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON quote_elements FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON batches FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON inspections FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON anomalies FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON inventory FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON sales_locks FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON price_records FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON customers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON logs FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON recycle_bins FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON purchase_ledgers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON sales_ledgers FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY IF NOT EXISTS allow_all ON system_config FOR ALL USING (true) WITH CHECK (true);
