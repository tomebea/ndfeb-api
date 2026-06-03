import { serve } from '@hono/node-server';
import app from './boot.js';
const PORT = process.env.PORT || 3000;
const HOST = process.env.HOST || '0.0.0.0';
if (!process.env.SUPABASE_URL || !process.env.SUPABASE_SERVICE_ROLE_KEY) {
  console.error('ERROR: SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY required');
  process.exit(1);
}
serve({ fetch: app.fetch, port: parseInt(PORT), hostname: HOST });
console.log(`API: http://${HOST}:${PORT}`);
