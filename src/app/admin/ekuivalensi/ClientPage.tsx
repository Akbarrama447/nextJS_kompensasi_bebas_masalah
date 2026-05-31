"use client";

import { useEffect, useState } from "react";
import UserHeader from "@/components/UserHeader";
import PopupBukti from "@/app/admin/ekuivalensi/components/PopupBukti";
import PopupTolak from "@/app/admin/ekuivalensi/components/PopupTolak";

export default function ClientPage({ semesterLabel }: { semesterLabel?: string }) {
  const [kelas, setKelas] = useState("");
  const [classList, setClassList] = useState<any[]>([]);
  const [mahasiswa, setMahasiswa] = useState<any[]>([]);
  const [ekuivalensi, setEkuivalensi] = useState<any>(null);
  const [pekerjaan, setPekerjaan] = useState("");

  const [openPopup, setOpenPopup] = useState(false);
  const [openTolak, setOpenTolak] = useState(false);
  const [loading, setLoading] = useState(false);
  const [autoLoading, setAutoLoading] = useState(false);
  const [autoMsg, setAutoMsg] = useState("");

  // Fetch Class List
  useEffect(() => {
    fetch("/api/kelas")
      .then((res) => res.json())
      .then((data) => {
        if (Array.isArray(data)) {
          setClassList(data);
          if (data.length > 0 && !kelas) {
            setKelas(data[0].nama_kelas);
          }
        }
      })
      .catch((err) => console.error("Error fetch classes:", err));
  }, []);

  // Fetch Data by Kelas
  useEffect(() => {
    if (!kelas) return;

    fetch(`/api/ekuivalensi/by-kelas?kelas=${kelas}`)
      .then((res) => res.json())
      .then((data) => {
        console.log("API RESPONSE:", data);
        if (data.mahasiswa) {
          setMahasiswa(data.mahasiswa);
        } else {
          setMahasiswa([]);
        }
        setEkuivalensi(data.ekuivalensi);
      })
      .catch((err) => {
        console.error("Fetch error:", err);
        setMahasiswa([]);
        setEkuivalensi(null);
      });
  }, [kelas]);

  const totalJam = Array.isArray(mahasiswa)
    ? mahasiswa.reduce((acc, m) => acc + (m.jam || 0), 0)
    : 0;

  const handleAutoAssign = async () => {
    setAutoLoading(true);
    setAutoMsg("");
    try {
      const res = await fetch("/api/ekuivalensi/auto-assign", { method: "POST" });
      const data = await res.json();
      if (data.success) {
        setAutoMsg(`✅ ${data.created} class ter-create, ${data.skipped} class di-skip`);
      } else {
        setAutoMsg("❌ " + (data.message || "Gagal"));
      }
    } catch {
      setAutoMsg("❌ Gagal connect");
    } finally {
      setAutoLoading(false);
      // Refresh current class
      if (kelas) {
        const refreshRes = await fetch(`/api/ekuivalensi/by-kelas?kelas=${kelas}`);
        const refreshData = await refreshRes.json();
        setMahasiswa(refreshData.mahasiswa || []);
        setEkuivalensi(refreshData.ekuivalensi);
      }
    }
  };

  const handleVerify = async (statusId: number, catatan?: string) => {
    if (!ekuivalensi?.id) {
      alert("Data ekuivalensi tidak ditemukan");
      return;
    }

    setLoading(true);
    try {
      const res = await fetch("/api/ekuivalensi/verify", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ekuivalensiId: ekuivalensi.id,
          statusId,
          catatan,
        }),
      });

      if (res.ok) {
        // Refresh data
        const refreshRes = await fetch(`/api/ekuivalensi/by-kelas?kelas=${kelas}`);
        const refreshData = await refreshRes.json();
        setMahasiswa(refreshData.mahasiswa || []);
        setEkuivalensi(refreshData.ekuivalensi);
        setOpenPopup(false);
        setOpenTolak(false);
      } else {
        const error = await res.json();
        alert(error.message || "Gagal melakukan verifikasi");
      }
    } catch (err) {
      console.error("Verify error:", err);
      alert("Terjadi kesalahan koneksi");
    } finally {
      setLoading(false);
    }
  };

  return (
    <main className="min-h-screen flex flex-col bg-gray-100">
      <UserHeader nama="Admin" role="admin" semesterLabel={semesterLabel} />

      <div className="flex-1 p-4 md:p-6 max-w-5xl mx-auto w-full">

        {/* TITLE */}
        <div className="mb-4">
          <h1 className="text-xl font-bold text-gray-900">
            Ekuivalensi Kelas
          </h1>
          <p className="text-sm text-gray-500">
            Verifikasi pengajuan iuran kolektif dari Penanggung Jawab Kelas
          </p>
        </div>

        {/* CARD */}
        <div className="bg-white border border-gray-200 rounded-xl shadow-sm p-4">

          {/* PILIH KELAS + AUTO ASSIGN */}
          <div className="flex flex-col sm:flex-row sm:items-center gap-2 mb-4">
            <label className="text-sm font-medium text-gray-700">
              Pilih Kelas
            </label>

            <select
              value={kelas}
              onChange={(e) => setKelas(e.target.value)}
              suppressHydrationWarning
              className="w-full sm:w-auto px-3 py-1.5 border border-gray-300 rounded-lg text-sm"
            >
              {classList.map((k) => (
                <option key={k.id} value={k.nama_kelas}>
                  {k.nama_kelas}
                </option>
              ))}
            </select>

            <button
              onClick={handleAutoAssign}
              disabled={autoLoading}
              className="ml-auto px-4 py-1.5 bg-amber-500 hover:bg-amber-600 disabled:bg-amber-300 text-white text-xs font-bold rounded-lg transition"
            >
              {autoLoading ? "Proses..." : "Auto Assign Ekuivalensi"}
            </button>

            {autoMsg && (
              <span className="text-xs font-medium text-gray-600">{autoMsg}</span>
            )}
          </div>

          {/* TABLE */}
          <div className="border border-gray-200 rounded-lg overflow-x-auto mb-4">
            <table className="min-w-[500px] w-full text-sm text-left">
              <thead className="bg-gray-50 text-gray-600 text-xs uppercase">
                <tr>
                  <th className="px-4 py-3 text-center w-12">No</th>
                  <th className="px-4 py-3">Nama</th>
                  <th className="px-4 py-3 text-center">NIM</th>
                  <th className="px-4 py-3 text-center">Jam</th>
                </tr>
              </thead>

              <tbody>
                {mahasiswa.length > 0 ? (
                  mahasiswa.map((m, i) => (
                    <tr
                      key={i}
                      className="border-b border-gray-200 last:border-none text-center"
                    >
                      <td className="px-4 py-3 text-gray-400">{i + 1}</td>
                      <td className="px-4 py-3 text-left">{m.nama}</td>
                      <td>{m.nim}</td>
                      <td>{m.jam}</td>
                    </tr>
                  ))
                ) : (
                  <tr>
                    <td colSpan={4} className="px-4 py-10 text-center text-gray-400">
                      Tidak ada data mahasiswa di kelas ini.
                    </td>
                  </tr>
                )}
              </tbody>
            </table>
          </div>

          {/* HEADER */}
          <div className="hidden sm:grid grid-cols-6 text-xs text-gray-500 font-medium mb-2 border-t-2 border-gray-300 pt-2">
            <div></div>
            <div></div>
            <div className="col-span-2 text-center">PEKERJAAN</div>
            <div className="text-center">BUKTI</div>
            <div className="text-center">STATUS</div>
          </div>

          {/* BOTTOM SECTION */}
          <div className="flex flex-col sm:grid sm:grid-cols-6 gap-3 sm:gap-2 items-start sm:items-center text-sm">

            {/* TOTAL & NOMINAL */}
            <div className="w-full flex justify-between sm:contents">
              <div className="flex flex-col sm:block font-semibold text-gray-700 sm:ml-10">
                <div>TOTAL</div>

              </div>

              <div className="flex flex-col sm:block font-bold text-gray-900 sm:ml-6 text-right sm:text-left">
                <div>{totalJam} JAM</div>
                {ekuivalensi?.nominal != null && (
                  <div className="text-xs text-green-600 mt-1">
                    Rp {Number(ekuivalensi.nominal).toLocaleString("id-ID")}
                  </div>
                )}
              </div>
            </div>

            {/* PEKERJAAN */}
            <div className="sm:col-span-2 w-full">
              <input
                type="text"
                value={pekerjaan}
                onChange={(e) => setPekerjaan(e.target.value)}
                placeholder="Input pekerjaan..."
                suppressHydrationWarning
                className="w-full px-3 py-2 border border-gray-300 rounded-lg"
              />
            </div>

            {/* BUKTI */}
            <button
              onClick={() => {
                if (!ekuivalensi) {
                  alert("Tidak ada pengajuan ekuivalensi untuk kelas ini.");
                  return;
                }
                setOpenPopup(true);
              }}
              suppressHydrationWarning
              className="w-full sm:w-auto bg-gray-200 text-gray-700 px-3 py-2 rounded-lg hover:bg-gray-300 transition"
            >
              LIHAT
            </button>

            {/* STATUS */}
            <div className="w-full sm:text-center">
              {!ekuivalensi ? (
                <span className="text-xs text-gray-400">N/A</span>
              ) : (
                <>
                  {(!ekuivalensi.statusId || ekuivalensi.statusId === 1) && (
                    <span className="px-3 py-2 bg-gray-200 text-gray-600 rounded-lg text-sm">
                      Pending
                    </span>
                  )}

                  {ekuivalensi.statusId === 3 && (
                    <span className="px-3 py-2 bg-red-500 text-white rounded-lg text-sm">
                      DITOLAK
                    </span>
                  )}

                  {ekuivalensi.statusId === 2 && (
                    <span className="px-3 py-2 bg-green-500 text-white rounded-lg text-sm">
                      DISETUJUI
                    </span>
                  )}
                </>
              )}
            </div>
          </div>

          {/* NOMOR TELEPON PERWAKILAN */}
          {ekuivalensi?.noTelepon && (
            <div className="mt-4 p-3 border border-blue-200 bg-blue-50 rounded-lg flex items-center justify-between">
              <div>
                <p className="text-xs text-blue-500 font-medium">Nomor Telepon Perwakilan</p>
                <p className="text-sm font-bold text-blue-700">{ekuivalensi.noTelepon}</p>
              </div>
              <a
                href={`https://wa.me/${ekuivalensi.noTelepon.replace(/[^0-9]/g, '')}`}
                target="_blank"
                rel="noopener noreferrer"
                className="px-3 py-1.5 text-xs font-bold text-white bg-green-500 hover:bg-green-600 transition rounded-lg flex items-center gap-1"
              >
                <svg className="w-4 h-4" fill="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                  <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/>
                </svg>
                WhatsApp
              </a>
            </div>
          )}

          {/* ALASAN TOLAK */}
          {ekuivalensi?.catatan && (
            <div className="mt-4 p-3 border border-red-200 bg-red-50 rounded-lg">
              <p className="text-xs text-red-500 font-medium">
                Catatan / Alasan Penolakan
              </p>
              <p className="text-sm text-red-700">{ekuivalensi.catatan}</p>
            </div>
          )}
        </div>
      </div>

      {/* POPUP BUKTI */}
      {ekuivalensi && (
        <PopupBukti
          open={openPopup}
          onClose={() => setOpenPopup(false)}
          onApprove={() => handleVerify(2)}
          onReject={() => {
            setOpenPopup(false);
            setOpenTolak(true);
          }}
            data={{
              kelas,
              jam: ekuivalensi.jam,
              nominal: ekuivalensi.nominal,
              tanggal: new Date(ekuivalensi.tanggal).toLocaleDateString("id-ID", {
                day: "numeric",
                month: "long",
                year: "numeric",
                hour: "2-digit",
                minute: "2-digit",
              }),
              fotoUrl: ekuivalensi.notaUrl || "",
              noTelepon: ekuivalensi.noTelepon || "",
            }}
        />
      )}

      {/* POPUP TOLAK */}
      <PopupTolak
        open={openTolak}
        onClose={() => {
          setOpenTolak(false);
          setOpenPopup(true);
        }}
        onSubmit={(alasan) => handleVerify(3, alasan)}
      />

      {loading && (
        <div className="fixed inset-0 bg-black/20 flex items-center justify-center z-[100]">
          <div className="bg-white p-4 rounded-lg shadow-lg">Processing...</div>
        </div>
      )}
    </main>
  );
}