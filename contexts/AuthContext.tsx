'use client';

import React, {
  createContext,
  useContext,
  useEffect,
  useState,
  useCallback,
} from 'react';
import { useRouter } from 'next/navigation';
import { createClient } from '@/lib/supabase/client';
import type { AppUser, Mahasiswa, Staf } from '@/lib/types';
import type { RoleSlug } from '@/lib/types';

// ─────────────────────────────────────────
// Context types
// ─────────────────────────────────────────

interface AuthContextValue {
  user: AppUser | null;
  loading: boolean;
  signOut: () => Promise<void>;
  refreshUser: () => Promise<void>;
}

const AuthContext = createContext<AuthContextValue>({
  user: null,
  loading: true,
  signOut: async () => {},
  refreshUser: async () => {},
});

// ─────────────────────────────────────────
// Provider
// ─────────────────────────────────────────

export function AuthProvider({ children }: { children: React.ReactNode }) {
  const [user, setUser] = useState<AppUser | null>(null);
  const [loading, setLoading] = useState(true);
  const isRefreshing = React.useRef(false); // Ref to prevent concurrent refreshes
  const router = useRouter();
  const supabase = createClient();

  const buildAppUser = useCallback(
    async (authId: string, email: string): Promise<AppUser | null> => {
      try {
        const { data: userRow, error: userErr } = await supabase
          .from('users')
          .select('user_id, role_id, email')
          .eq('email', email)
          .maybeSingle();

        if (userErr || !userRow) return null;

        const { data: role, error: roleErr } = await supabase
          .from('roles')
          .select('id, nama, key_menu')
          .eq('id', userRow.role_id)
          .single();

        if (roleErr || !role) return null;

        const keyMenu: string[] = Array.isArray(role.key_menu)
          ? role.key_menu
          : [];

        let profile: Mahasiswa | Staf | null = null;
        let displayName = email.split('@')[0];

        const { data: mhs } = await supabase
          .from('mahasiswa')
          .select('nim, user_id, nama, kelas_id')
          .eq('user_id', userRow.user_id)
          .maybeSingle();

        if (mhs) {
          profile = mhs as Mahasiswa;
          displayName = mhs.nama;
        } else {
          const { data: staf } = await supabase
            .from('staf')
            .select('nip, user_id, nama, jurusan_id, tipe_staf')
            .eq('user_id', userRow.user_id)
            .maybeSingle();

          if (staf) {
            profile = staf as Staf;
            displayName = staf.nama;
          }
        }

        return {
          authId,
          email,
          userId: userRow.user_id,
          roleId: userRow.role_id,
          roleName: role.nama as RoleSlug,
          keyMenu,
          profile,
          displayName,
        };
      } catch {
        return null;
      }
    },
    [supabase]
  );

  const refreshUser = useCallback(async () => {
    if (isRefreshing.current) return;
    isRefreshing.current = true;
    
    try {
      // Use getSession for faster client-side recovery, getUser for deep validation
      const { data: { session } } = await supabase.auth.getSession();
      
      if (!session?.user) {
        setUser(null);
        return;
      }

      const appUser = await buildAppUser(session.user.id, session.user.email ?? '');
      setUser(appUser);
    } finally {
      isRefreshing.current = false;
    }
  }, [supabase, buildAppUser]);

  useEffect(() => {
    let mounted = true;

    // Initial load
    const initAuth = async () => {
      await refreshUser();
      if (mounted) setLoading(false);
    };

    initAuth();

    // Listen to auth state changes
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (event === 'SIGNED_OUT') {
        setUser(null);
      } else if (session?.user) {
        // Build user from current session instead of re-fetching
        const appUser = await buildAppUser(session.user.id, session.user.email ?? '');
        if (mounted) setUser(appUser);
      }
    });

    return () => {
      mounted = false;
      subscription.unsubscribe();
    };
  }, [supabase, refreshUser, buildAppUser]);

  const signOut = useCallback(async () => {
    await supabase.auth.signOut();
    setUser(null);
    router.push('/login');
    router.refresh();
  }, [supabase, router]);

  return (
    <AuthContext.Provider value={{ user, loading, signOut, refreshUser }}>
      {children}
    </AuthContext.Provider>
  );
}

// ─────────────────────────────────────────
// Hook
// ─────────────────────────────────────────

export function useAuth() {
  return useContext(AuthContext);
}

/**
 * Cek apakah user memiliki akses ke menu tertentu.
 */
export function useHasMenu(menuKey: string): boolean {
  const { user } = useAuth();
  if (!user) return false;
  return user.keyMenu.includes(menuKey);
}

/**
 * Cek apakah user adalah mahasiswa (berdasarkan role nama).
 */
export function useIsMahasiswa(): boolean {
  const { user } = useAuth();
  return user?.roleName === 'mahasiswa';
}
