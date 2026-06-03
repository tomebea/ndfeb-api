import { createRequire } from 'module';
const require = createRequire(import.meta.url);

import { serve } from '@hono/node-server';

// ===== 全局错误捕获，防止应用静默退出 =====
process.on('uncaughtException', (err) => {
  console.error('[Uncaught Exception]', err);
});
process.on('unhandledRejection', (reason) => {
  console.error('[Unhandled Rejection]', reason);
});

// ===== 环境变量 =====
const SUPABASE_URL = process.env.SUPABASE_URL || '';
const SUPABASE_SERVICE_ROLE_KEY = process.env.SUPABASE_SERVICE_ROLE_KEY || '';
const DATABASE_URL = process.env.DATABASE_URL || '';
const PORT = process.env.PORT || 3000;

console.log('[Server] SUPABASE_URL:', SUPABASE_URL ? '已配置' : '未配置');
console.log('[Server] SUPABASE_SERVICE_ROLE_KEY:', SUPABASE_SERVICE_ROLE_KEY ? '已配置' : '未配置');
console.log('[Server] DATABASE_URL:', DATABASE_URL ? '已配置(直连)' : '未配置');
console.log('[Server] PORT:', PORT);

// ===== 启动 Hono 应用 =====
// boot.js 是 esbuild 打包后的单文件，导出 Hono app 实例
const { default: app } = await import('./boot.js');

serve({
  fetch: app.fetch,
  port: PORT,
}, (info) => {
  console.log(`[Server] Running on http://localhost:${info.port}`);
  console.log(`[Server] Health check: http://localhost:${info.port}/health`);
  console.log(`[Server] API: http://localhost:${info.port}/api/trpc/*`);
});
