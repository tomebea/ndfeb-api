import { serve } from '@hono/node-server';
import app from './boot.js';

const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';

// 检查必需的 Supabase 环境变量
if (!process.env.SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
  console.error('ERROR: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY environment variables are required.');
  console.error('Please set them in Render Dashboard → Environment.');
  process.exit(1);
}

serve({
  fetch: app.fetch,
  port: parseInt(PORT),
  hostname: HOST,
});

console.log(`============================================`);
console.log(`  钕铁硼废料回收智能系统 - Supabase 版`);
console.log(`  Server running at http://${HOST}:${PORT}`);
console.log(`  API endpoint: http://${HOST}:${PORT}/api/trpc`);
console.log(`  Health check: http://${HOST}:${PORT}/health`);
console.log(`============================================`);
