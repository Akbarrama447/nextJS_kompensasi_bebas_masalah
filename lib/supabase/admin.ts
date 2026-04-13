/**
 * PERINGATAN: File ini HANYA boleh diimport di server-side code.
 * Jangan pernah import file ini di Client Components atau file yang
 * diekspos ke browser — SERVICE_ROLE_KEY memberi akses penuh ke database
 * dan mem-bypass semua Row Level Security (RLS).
 *
 * Gunakan hanya di:
 *  - app/api/...  (API Routes)
 *  - Server Actions ('use server')
 *  - lib/supabase/server.ts-based flows
 */

import { createClient } from '@supabase/supabase-js';

export const supabaseAdmin = createClient(
  process.env.NEXT_PUBLIC_SUPABASE_URL!,
  process.env.SUPABASE_SERVICE_ROLE_KEY!, // ← tidak ada prefix NEXT_PUBLIC_, server-only
  {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  }
);
