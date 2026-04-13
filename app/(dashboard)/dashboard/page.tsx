'use client';

import { useEffect, useState } from 'react';
import { useAuth } from '@/contexts/AuthContext';
import { createClient } from '@/lib/supabase/client';
import MetricCard from '@/components/ui/MetricCard';
import { SkeletonCard } from '@/components/ui/SkeletonRow';
import { formatJam } from '@/lib/utils';
import {
  Clock, CheckCircle2, Briefcase, Users,
  ClipboardList, Calendar, Star, AlertCircle,
  ArrowRight,
} from 'lucide-react';
import type { Mahasiswa, Staf } from '@/lib/types';
import Link from 'next/link';

// ─────────────────────────────────────────
// Metric Types
// ─────────────────────────────────────────

interface MahasiswaMetrics {
  sisaJam: number;
  jamSelesai: number;
  totalJamWajib: number;
  namaSemester: string;
}

interface StafMetrics {
  pekerjaanAktif: number;
  pendingVerifikasi: number;
  namaSemester: string;
}

interface SuperadminMetrics {
  totalMahasiswa: number;
  pekerjaanSemester: number;
  namaSemester: string;
}

// ─────────────────────────────────────────
// Circular Progress (SVG — no extra lib)
// ─────────────────────────────────────────

function CircularProgress({ percent }: { percent: number }) {
  const r = 54;
  const circ = 2 * Math.PI * r;
  const offset = circ - (Math.min(100, percent) / 100) * circ;

  return (
    <div className="relative inline-flex items-center justify-center">
      <svg width="140" height="140" viewBox="0 0 140 140">
        {/* Track */}
        <circle
          cx="70" cy="70" r={r}
          fill="none" stroke="#e2e8f0" strokeWidth="10"
        />
        {/* Progress */}
        <circle
          cx="70" cy="70" r={r}
          fill="none"
          stroke={percent >= 100 ? '#22c55e' : '#3b82f6'}
          strokeWidth="10"
          strokeLinecap="round"
          strokeDasharray={circ}
          strokeDashoffset={offset}
          className="ring-progress"
          transform="rotate(-90 70 70)"
        />
      </svg>
      <div className="absolute text-center">
        <p className="text-2xl font-bold text-slate-900">{Math.round(percent)}%</p>
        <p className="text-[10px] text-slate-500">lunas</p>
      </div>
    </div>
  );
}

// ─────────────────────────────────────────
// Main Page
// ─────────────────────────────────────────

export default function DashboardPage() {
  const { user } = useAuth();
  const [loading, setLoading] = useState(true);
  const [mahasiswaM, setMahasiswaM] = useState<MahasiswaMetrics | null>(null);
  const [stafM, setStafM] = useState<StafMetrics | null>(null);
  const [superM, setSuperM] = useState<SuperadminMetrics | null>(null);
  const supabase = createClient();

  useEffect(() => {
    if (!user) return;

    const fetchMetrics = async () => {
      setLoading(true);
      try {
        // ── Get active semester ──
        const { data: semester } = await supabase
          .from('semester')
          .select('id, nama')
          .eq('is_aktif', true)
          .maybeSingle();

        const semId = semester?.id ?? 0;
        const namaSemester = semester?.nama ?? 'Belum ada semester aktif';

        // ── MAHASISWA ──
        if (user.roleName === 'mahasiswa') {
          const profile = user.profile as Mahasiswa;

          const { data: kompen } = await supabase
            .from('v_sisa_kompen')
            .select('sisa_jam, jam_selesai, total_jam_wajib')
            .eq('nim', profile.nim)
            .eq('semester_id', semId)
            .maybeSingle();

          setMahasiswaM({
            sisaJam: kompen?.sisa_jam ?? 0,
            jamSelesai: kompen?.jam_selesai ?? 0,
            totalJamWajib: kompen?.total_jam_wajib ?? 0,
            namaSemester,
          });

        // ── SUPERADMIN ──
        } else if (user.roleName === 'superadmin') {
          const [{ count: totalMhs }, { count: totalPek }] = await Promise.all([
            supabase.from('mahasiswa').select('*', { count: 'exact', head: true }),
            supabase
              .from('daftar_pekerjaan')
              .select('*', { count: 'exact', head: true })
              .eq('semester_id', semId),
          ]);

          setSuperM({
            totalMahasiswa: totalMhs ?? 0,
            pekerjaanSemester: totalPek ?? 0,
            namaSemester,
          });

        // ── STAF (dosen, kalab, laboran) ──
        } else {
          const profile = user.profile as Staf;

          const { data: pekerjaanStaf } = await supabase
            .from('daftar_pekerjaan')
            .select('id')
            .eq('staf_nip', profile.nip)
            .eq('semester_id', semId);

          const pekIds = pekerjaanStaf?.map((p) => p.id) ?? [];

          const [{ count: aktif }, { count: pending }] = await Promise.all([
            supabase
              .from('daftar_pekerjaan')
              .select('*', { count: 'exact', head: true })
              .eq('staf_nip', profile.nip)
              .eq('is_aktif', true)
              .eq('semester_id', semId),
            pekIds.length > 0
              ? supabase
                  .from('penugasan')
                  .select('*', { count: 'exact', head: true })
                  .in('pekerjaan_id', pekIds)
                  .eq('status_tugas_id', 2)
              : Promise.resolve({ count: 0 }),
          ]);

          setStafM({
            pekerjaanAktif: aktif ?? 0,
            pendingVerifikasi: (pending ?? 0) as number,
            namaSemester,
          });
        }
      } finally {
        setLoading(false);
      }
    };

    fetchMetrics();
  }, [user?.authId]);

  // ── Loading State ──
  if (loading) {
    return (
      <div className="space-y-6">
        <div className="skeleton h-7 w-56 rounded" />
        <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
          {[1, 2, 3].map((i) => <SkeletonCard key={i} />)}
        </div>
      </div>
    );
  }

  const displayName = user?.displayName ?? '';
  const hour = new Date().getHours();
  const greeting =
    hour < 11 ? 'Selamat pagi' : hour < 15 ? 'Selamat siang' : hour < 18 ? 'Selamat sore' : 'Selamat malam';

  return (
    <div className="space-y-8">
      {/* ── Welcome ── */}
      <div>
        <h1 className="text-2xl font-bold text-slate-900">
          {greeting}, {displayName.split(' ')[0]} 👋
        </h1>
        <p className="text-slate-500 text-sm mt-1">
          Berikut ringkasan aktivitas kompen Anda hari ini.
        </p>
      </div>

      {/* ── MAHASISWA METRICS ── */}
      {mahasiswaM && (
        <>
          {/* Lunas banner */}
          {mahasiswaM.sisaJam === 0 && mahasiswaM.totalJamWajib > 0 && (
            <div className="flex items-center gap-4 bg-green-50 border border-green-200 rounded-xl px-6 py-4">
              <div className="w-10 h-10 bg-green-100 rounded-full flex items-center justify-center flex-shrink-0">
                <Star className="w-5 h-5 text-green-600" />
              </div>
              <div>
                <p className="font-semibold text-green-800">🎉 Selamat! Kompen Lunas</p>
                <p className="text-sm text-green-600">
                  Anda telah menyelesaikan seluruh {mahasiswaM.totalJamWajib} jam kompen semester ini.
                </p>
              </div>
            </div>
          )}

          {/* Circular progress + cards row */}
          <div className="grid grid-cols-1 lg:grid-cols-3 gap-5">
            {/* Progress ring card */}
            <div className="card flex flex-col items-center justify-center gap-4 lg:col-span-1">
              <CircularProgress
                percent={
                  mahasiswaM.totalJamWajib > 0
                    ? (mahasiswaM.jamSelesai / mahasiswaM.totalJamWajib) * 100
                    : 0
                }
              />
              <div className="text-center">
                <p className="text-sm text-slate-500 mb-1">{mahasiswaM.namaSemester}</p>
                <p className="text-sm font-medium text-slate-700">
                  {formatJam(mahasiswaM.jamSelesai)} dari {formatJam(mahasiswaM.totalJamWajib)} selesai
                </p>
              </div>
            </div>

            {/* Metric cards */}
            <div className="lg:col-span-2 grid grid-cols-1 sm:grid-cols-3 gap-5">
              <MetricCard
                title="Sisa Jam Kompen"
                value={`${mahasiswaM.sisaJam} jam`}
                subtitle="Wajib diselesaikan"
                icon={<Clock className="w-5 h-5" />}
                accent={mahasiswaM.sisaJam === 0 ? 'green' : mahasiswaM.sisaJam > 20 ? 'red' : 'yellow'}
              />
              <MetricCard
                title="Jam Selesai"
                value={`${mahasiswaM.jamSelesai} jam`}
                subtitle="Telah diverifikasi"
                icon={<CheckCircle2 className="w-5 h-5" />}
                accent="green"
              />
              <MetricCard
                title="Total Wajib"
                value={`${mahasiswaM.totalJamWajib} jam`}
                subtitle={`Semester ${mahasiswaM.namaSemester}`}
                icon={<AlertCircle className="w-5 h-5" />}
                accent="slate"
              />
            </div>
          </div>

          {/* Quick links for mahasiswa */}
          <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
            <Link
              href="/pekerjaan"
              className="card hover:shadow-md transition-shadow flex items-center justify-between group"
            >
              <div>
                <p className="font-medium text-slate-800">Cari Pekerjaan</p>
                <p className="text-sm text-slate-500 mt-0.5">Lihat pekerjaan kompen yang tersedia</p>
              </div>
              <ArrowRight className="w-5 h-5 text-slate-400 group-hover:text-blue-500 group-hover:translate-x-1 transition-all" />
            </Link>
            <Link
              href="/ekuivalensi"
              className="card hover:shadow-md transition-shadow flex items-center justify-between group"
            >
              <div>
                <p className="font-medium text-slate-800">Ekuivalensi Kelas</p>
                <p className="text-sm text-slate-500 mt-0.5">Submit nota untuk lunas kolektif</p>
              </div>
              <ArrowRight className="w-5 h-5 text-slate-400 group-hover:text-blue-500 group-hover:translate-x-1 transition-all" />
            </Link>
          </div>
        </>
      )}

      {/* ── STAF METRICS ── */}
      {stafM && (
        <>
          <div className="flex items-center gap-2 mb-1">
            <Calendar className="w-4 h-4 text-slate-400" />
            <span className="text-sm text-slate-500">{stafM.namaSemester}</span>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            <MetricCard
              title="Pekerjaan Aktif"
              value={stafM.pekerjaanAktif}
              subtitle="Yang Anda buat semester ini"
              icon={<Briefcase className="w-5 h-5" />}
              accent="blue"
            />
            <MetricCard
              title="Menunggu Verifikasi"
              value={stafM.pendingVerifikasi}
              subtitle="Perlu ditindaklanjuti segera"
              icon={<ClipboardList className="w-5 h-5" />}
              accent={stafM.pendingVerifikasi > 0 ? 'yellow' : 'green'}
            />
          </div>

          {stafM.pendingVerifikasi > 0 && (
            <Link
              href="/dashboard/pekerjaan"
              className="inline-flex items-center gap-2 btn-primary"
            >
              <ClipboardList className="w-4 h-4" />
              Buka Daftar Penugasan ({stafM.pendingVerifikasi} pending)
              <ArrowRight className="w-4 h-4" />
            </Link>
          )}
        </>
      )}

      {/* ── SUPERADMIN METRICS ── */}
      {superM && (
        <>
          <div className="flex items-center gap-2 mb-1">
            <Calendar className="w-4 h-4 text-slate-400" />
            <span className="text-sm text-slate-500">{superM.namaSemester}</span>
          </div>
          <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-5">
            <MetricCard
              title="Total Mahasiswa"
              value={superM.totalMahasiswa.toLocaleString('id-ID')}
              subtitle="Terdaftar di sistem"
              icon={<Users className="w-5 h-5" />}
              accent="blue"
            />
            <MetricCard
              title="Pekerjaan Semester Ini"
              value={superM.pekerjaanSemester}
              subtitle="Total pekerjaan terdaftar"
              icon={<Briefcase className="w-5 h-5" />}
              accent="purple"
            />
            <MetricCard
              title="Semester Aktif"
              value={superM.namaSemester}
              subtitle="Sedang berjalan"
              icon={<Calendar className="w-5 h-5" />}
              accent="green"
            />
          </div>
        </>
      )}
    </div>
  );
}
