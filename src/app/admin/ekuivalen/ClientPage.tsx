"use client";

import { useState } from "react";
import UserHeader from "@/components/UserHeader";
import PopupBukti from "@/app/admin/ekuivalen/components/PopupBukti";
import PopupTolak from "@/app/admin/ekuivalen/components/PopupTolak";

export default function ClientPage() {
  const [kelas, setKelas] = useState("IK2C");

  const mahasiswa = [
    { nama: "NADHIF DLIYAULHAQ", nim: "3.34.24.0.11", jam: 11 },
    { nama: "NAUFAL BALBUL", nim: "3.34.24.0.14", jam: 64 },
  ];

  const [pekerjaan, setPekerjaan] = useState("");

  const totalJam = mahasiswa.reduce((acc, m) => acc + m.jam, 0);

  const [openPopup, setOpenPopup] = useState(false);
  const [openTolak, setOpenTolak] = useState(false);

  const [status, setStatus] =
    useState<"pending" | "ditolak" | "disetujui">("pending");

  const [alasanTolak, setAlasanTolak] = useState("");

  return (
    <main className="min-h-screen flex flex-col bg-gray-100">
      <UserHeader nama="Admin" role="admin" />

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

          {/* PILIH KELAS */}
          <div className="flex flex-col sm:flex-row sm:items-center gap-2 mb-4">
            <label className="text-sm font-medium text-gray-700">
              Pilih Kelas
            </label>

            <select
              value={kelas}
              onChange={(e) => setKelas(e.target.value)}
              className="w-full sm:w-auto px-3 py-1.5 border border-gray-300 rounded-lg text-sm"
            >
              <option value="IK2A">IK2A</option>
              <option value="IK2B">IK2B</option>
              <option value="IK2C">IK2C</option>
              <option value="IK2D">IK2D</option>
              <option value="IK2E">IK2E</option>
            </select>
          </div>

          {/* TABLE */}
          <div className="border border-gray-200 rounded-lg overflow-x-auto mb-4">
            <table className="min-w-[500px] w-full text-sm text-left">
              <thead className="bg-gray-50 text-gray-600 text-xs uppercase">
                <tr>
                  <th className="px-4 py-3">Nama</th>
                  <th className="px-4 py-3 text-center">NIM</th>
                  <th className="px-4 py-3 text-center">Jam</th>
                </tr>
              </thead>

              <tbody>
                {mahasiswa.map((m, i) => (
                  <tr key={i} className="border-b border-gray-200 last:border-none text-center">
                    <td className="px-4 py-3 text-left">{m.nama}</td>
                    <td>{m.nim}</td>
                    <td>{m.jam}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>

          {/* HEADER (desktop only biar tidak rusak di HP) */}
          <div className="hidden sm:grid grid-cols-6 text-xs text-gray-500 font-medium mb-2 border-t-2 border-gray-300 pt-2">
            <div></div>
            <div></div>
            <div className="col-span-2 text-center">PEKERJAAN</div>
            <div className="text-center">BUKTI</div>
            <div className="text-center">STATUS</div>
          </div>

          {/* BOTTOM SECTION */}
          <div className="flex flex-col sm:grid sm:grid-cols-6 gap-3 sm:gap-2 items-start sm:items-center text-sm">

            {/* TOTAL */}
            <div className="flex justify-between sm:block font-semibold text-gray-700 sm:ml-10">
              TOTAL
            </div>

            <div className="flex justify-between sm:block font-bold text-gray-900 sm:ml-6">
              {totalJam} JAM
            </div>

            {/* PEKERJAAN */}
            <div className="sm:col-span-2 w-full">
              <input
                type="text"
                value={pekerjaan}
                onChange={(e) => setPekerjaan(e.target.value)}
                placeholder="Input pekerjaan..."
                className="w-full px-3 py-2 border border-gray-300 rounded-lg"
              />
            </div>

            {/* BUKTI */}
            <button
              onClick={() => setOpenPopup(true)}
              className="w-full sm:w-auto bg-gray-200 text-gray-700 px-3 py-2 rounded-lg hover:bg-gray-300 transition"
            >
              LIHAT
            </button>

            {/* STATUS */}
            <div className="w-full sm:text-center">
              {status === "pending" && (
                <span className="px-3 py-2 bg-gray-200 text-gray-600 rounded-lg text-sm">
                  Pending
                </span>
              )}

              {status === "ditolak" && (
                <span className="px-3 py-2 bg-red-500 text-white rounded-lg text-sm">
                  DITOLAK
                </span>
              )}

              {status === "disetujui" && (
                <span className="px-3 py-2 bg-green-500 text-white rounded-lg text-sm">
                  DISETUJUI
                </span>
              )}
            </div>
          </div>

          {/* ALASAN TOLAK */}
          {alasanTolak && (
            <div className="mt-4 p-3 border border-red-200 bg-red-50 rounded-lg">
              <p className="text-xs text-red-500 font-medium">
                Alasan Penolakan
              </p>
              <p className="text-sm text-red-700">{alasanTolak}</p>
            </div>
          )}
        </div>
      </div>

      {/* POPUP BUKTI */}
      <PopupBukti
        open={openPopup}
        onClose={() => setOpenPopup(false)}
        onApprove={() => {
          setStatus("disetujui");
          setAlasanTolak("");
          setOpenPopup(false);
        }}
        onReject={() => {
          setOpenPopup(false);
          setOpenTolak(true);
        }}
        data={{
          kelas,
          jam: totalJam,
          nominal: totalJam * 2000,
          tanggal: "19 April 2026 pukul 15.00",
          fotoUrl: "",
        }}
      />

      {/* POPUP TOLAK */}
      <PopupTolak
        open={openTolak}
        onClose={() => {
          setOpenTolak(false);
          setOpenPopup(true);
        }}
        onSubmit={(alasan) => {
          setAlasanTolak(alasan);
          setStatus("ditolak");
          setOpenTolak(false);
        }}
      />
    </main>
  );
}