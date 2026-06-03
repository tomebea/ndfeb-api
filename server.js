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
const DATABASE_URL = process.env.DATABASE_URL || '';
const PORT = process.env.PORT || 3000;

if (!DATABASE_URL) {
  console.error('[Server] FATAL: DATABASE_URL env var is required');
  process.exit(1);
}

console.log('[Server] DATABASE_URL: 已配置');
console.log('[Server] PORT:', PORT);

// ===== 启动 Hono 应用 =====
const { default: app } = await import('./boot.js');

serve({
  fetch: app.fetch,
  port: PORT,
}, (info) => {
  console.log(`[Server] Running on http://localhost:${info.port}`);
  console.log(`[Server] Health check: http://localhost:${info.port}/health`);
  console.log(`[Server] API: http://localhost:${info.port}/api/trpc/*`);
});
