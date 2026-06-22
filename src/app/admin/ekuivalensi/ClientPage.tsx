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
  const [linkBarang, setLinkBarang] = useState("");

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
        setPekerjaan(data.ekuivalensi?.keterangan_pekerjaan || "");
        setLinkBarang(data.ekuivalensi?.link_barang || "");
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
        setAutoMsg(`✔️ ${data.created} class ter-create, ${data.skipped} class di-skip`);
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

  const handleSaveDetails = async () => {
    if (!pekerjaan.trim()) {
      alert("Pekerjaan tidak boleh kosong");
      return;
    }

    setLoading(true);
    try {
      let currentId = ekuivalensi?.id;

      // 1. Simpan Pekerjaan (ini juga bisa men-generate ekuivalensi baru di database jika belum ada)
      const resPekerjaan = await fetch("/api/ekuivalensi/pekerjaan", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ekuivalensiId: currentId,
          keterangan_pekerjaan: pekerjaan,
          kelas: kelas,
        }),
      });

      if (!resPekerjaan.ok) {
        const error = await resPekerjaan.json();
        throw new Error(error.message || "Gagal menyimpan pekerjaan");
      }

      // 2. Jika tadinya belum ada ID, ambil ID yang baru terbuat
      if (!currentId) {
        const fetchNewId = await fetch(`/api/ekuivalensi/by-kelas?kelas=${kelas}`);
        const dataNewId = await fetchNewId.json();
        currentId = dataNewId.ekuivalensi?.id;
      }

      // 3. Simpan Link Barang jika ID sudah tersedia
      if (currentId) {
        const resLink = await fetch("/api/ekuivalensi/link-barang", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            ekuivalensiId: currentId,
            link_barang: linkBarang,
          }),
        });

        if (!resLink.ok) {
          const error = await resLink.json();
          throw new Error(error.message || "Gagal menyimpan link barang");
        }
      }

      alert("Detail Pekerjaan dan Referensi berhasil disimpan!");

      // Refresh Data
      const refreshRes = await fetch(`/api/ekuivalensi/by-kelas?kelas=${kelas}`);
      const refreshData = await refreshRes.json();
      setEkuivalensi(refreshData.ekuivalensi);
      setPekerjaan(refreshData.ekuivalensi?.keterangan_pekerjaan || "");
      setLinkBarang(refreshData.ekuivalensi?.link_barang || "");

    } catch (err: any) {
      console.error("Save details error:", err);
      alert(err.message || "Terjadi kesalahan koneksi saat menyimpan detail");
    } finally {
      setLoading(false);
    }
  };

  const handleExport = async () => {
    if (!kelas) {
      alert("Pilih kelas terlebih dahulu untuk menentukan prodi.");
      return;
    }

    try {
      setLoading(true);
      const res = await fetch(`/api/ekuivalensi/export?kelas=${encodeURIComponent(kelas)}`);
      if (!res.ok) {
        const errData = await res.json().catch(() => ({ message: 'Unknown error' }));
        throw new Error(errData.message || `Gagal mengambil data laporan (${res.status})`);
      }

      const resData = await res.json();
      const { prodiName, semesterName, data } = resData;

      if (!data || data.length === 0) {
        alert("Tidak ada data untuk diekspor");
        return;
      }

      const jsPDF = (await import("jspdf")).default;
      const autoTable = (await import("jspdf-autotable")).default;

      const doc = new jsPDF("p", "pt", "a4");

      // Header
      doc.setFontSize(14);
      doc.setFont("helvetica", "bold");
      doc.text("LAPORAN EKUIVALENSI KOMPENSASI BEBAS MASALAH", doc.internal.pageSize.getWidth() / 2, 40, { align: "center" });

      doc.setFontSize(11);
      doc.setFont("helvetica", "normal");
      doc.text("Sistem Informasi Bebas Masalah", doc.internal.pageSize.getWidth() / 2, 55, { align: "center" });

      doc.setLineWidth(1);
      doc.line(40, 65, doc.internal.pageSize.getWidth() - 40, 65);

      // Info
      doc.setFontSize(10);
      doc.text(`Program Studi`, 40, 85);
      doc.text(`: ${prodiName}`, 120, 85);
      doc.text(`Tahun Ajaran`, 40, 100);
      doc.text(`: ${semesterName}`, 120, 100);
      doc.text(`Tanggal Cetak`, 40, 115);
      const printDate = new Date().toLocaleDateString("id-ID", { day: "numeric", month: "long", year: "numeric" });
      doc.text(`: ${printDate}`, 120, 115);

      // Group Data by Kelas
      const groupedData: Record<string, any[]> = {};
      data.forEach((row: any) => {
        const className = row.Kelas || "Tanpa Kelas";
        if (!groupedData[className]) {
          groupedData[className] = [];
        }
        groupedData[className].push(row);
      });

      let currentY = 135;
      let totalJamAll = 0;
      let totalNominalAll = 0;

      // Generate Tables
      const classKeys = Object.keys(groupedData).sort();
      classKeys.forEach((className) => {
        doc.setFontSize(10);
        doc.setFont("helvetica", "bold");
        doc.text(`Kelas: ${className}`, 40, currentY);
        currentY += 10;

        const tableBody = groupedData[className].map((row, index) => {
          totalJamAll += row['Jam Diakui'] || 0;
          totalNominalAll += row['Total Nominal (Rp)'] || 0;
          return [
            index + 1,
            row.NIM,
            row.Nama,
            row.Pekerjaan || "-",
            row['Jam Diakui'] || 0,
            row.Status || "-"
          ];
        });

        autoTable(doc, {
          startY: currentY,
          head: [['No', 'NIM', 'Nama Mahasiswa', 'Pekerjaan', 'Jam', 'Status']],
          body: tableBody,
          theme: 'grid',
          headStyles: { fillColor: [240, 240, 240], textColor: [0, 0, 0], fontStyle: 'bold' },
          styles: { fontSize: 9, cellPadding: 4 },
          columnStyles: {
            0: { halign: 'center', cellWidth: 30 },
            1: { cellWidth: 60 },
            2: { cellWidth: 120 },
            4: { halign: 'center', cellWidth: 30 },
            5: { halign: 'center', cellWidth: 60 }
          },
          margin: { left: 40, right: 40 },
        });

        currentY = (doc as any).lastAutoTable.finalY + 20;
      });

      if (currentY > doc.internal.pageSize.getHeight() - 150) {
        doc.addPage();
        currentY = 40;
      }

      // Summary
      doc.setFontSize(10);
      doc.setFont("helvetica", "bold");
      doc.text("Ringkasan Total:", 40, currentY);
      doc.setFont("helvetica", "normal");
      doc.text(`- Total Jam Kompensasi Keseluruhan  : ${totalJamAll} Jam`, 40, currentY + 15);
      doc.text(`- Total Nominal Ekuivalensi Keseluruhan : Rp ${totalNominalAll.toLocaleString('id-ID')}`, 40, currentY + 30);

      // Signatures
      currentY += 70;
      const pageWidth = doc.internal.pageSize.getWidth();
      doc.text("Batam, ........................................", pageWidth - 200, currentY);
      doc.text("Mengetahui,", pageWidth - 200, currentY + 15);
      doc.text("Penanggung Jawab / Admin,", pageWidth - 200, currentY + 30);
      doc.text("( ...................................................... )", pageWidth - 200, currentY + 90);

      doc.save(`Laporan_Ekuivalensi_${prodiName.replace(/\s+/g, '_')}_${semesterName.replace(/\s+/g, '_')}.pdf`);

    } catch (error) {
      console.error("Export error:", error);
      alert("Terjadi kesalahan saat membuat PDF.");
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
          <div className="hidden sm:grid grid-cols-12 text-xs text-gray-500 font-medium mb-2 border-t-2 border-gray-300 pt-2">
            <div className="col-span-6 sm:ml-10">RINGKASAN TOTAL</div>
            <div className="col-span-3 text-center">BUKTI</div>
            <div className="col-span-3 text-center">STATUS</div>
          </div>

          {/* BOTTOM SECTION */}
          <div className="flex flex-col sm:grid sm:grid-cols-12 gap-3 sm:gap-2 items-start sm:items-center text-sm">

            {/* TOTAL & NOMINAL */}
            <div className="sm:col-span-6 w-full flex justify-between sm:justify-start">
              <div className="flex flex-col sm:block font-semibold text-gray-700 sm:ml-10">
                <div>TOTAL</div>
              </div>

              <div className="flex flex-col sm:block font-bold text-gray-900 sm:ml-6 text-right sm:text-left">
                <div>{totalJam} JAM</div>
                <div className="text-xs text-green-600 mt-1">
                  Rp {((ekuivalensi?.nominal) || (totalJam * 2000)).toLocaleString("id-ID")}
                </div>
              </div>
            </div>

            {/* BUKTI */}
            <div className="sm:col-span-3 w-full flex justify-center">
              {(() => {
                // Logika warna tombol bukti
                const hasFoto = !!ekuivalensi?.notaUrl;
                const isVerified = ekuivalensi?.statusId === 2;

                let btnClass = "w-full sm:w-auto px-4 py-2 rounded-lg transition text-center font-medium ";

                if (!ekuivalensi || !hasFoto) {
                  // Belum ada bukti → abu-abu
                  btnClass += "bg-gray-200 text-gray-700 hover:bg-gray-300";
                } else if (isVerified) {
                  // Udah diverifikasi → ijo
                  btnClass += "bg-green-500 text-white hover:bg-green-600";
                } else {
                  // Udah ada bukti tapi belum diverifikasi → kuning
                  btnClass += "bg-amber-400 text-white hover:bg-amber-500";
                }

                return (
                  <button
                    onClick={() => {
                      if (!ekuivalensi) {
                        alert("Tidak ada pengajuan ekuivalensi untuk kelas ini.");
                        return;
                      }
                      setOpenPopup(true);
                    }}
                    suppressHydrationWarning
                    className={btnClass}
                  >
                    LIHAT
                  </button>
                );
              })()}
            </div>

            {/* STATUS */}
            <div className="sm:col-span-3 w-full flex justify-center">
              {!ekuivalensi ? (
                <span className="text-xs text-gray-400">N/A</span>
              ) : (
                <>
                  {(!ekuivalensi.statusId || ekuivalensi.statusId === 1) && (
                    <span className="px-3 py-2 bg-gray-200 text-gray-600 rounded-lg text-sm font-medium">
                      Pending
                    </span>
                  )}

                  {ekuivalensi.statusId === 3 && (
                    <span className="px-3 py-2 bg-red-500 text-white rounded-lg text-sm font-medium">
                      DITOLAK
                    </span>
                  )}

                  {ekuivalensi.statusId === 2 && (
                    <span className="px-3 py-2 bg-green-500 text-white rounded-lg text-sm font-medium">
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
                  <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z" />
                </svg>
                WhatsApp
              </a>
            </div>
          )}

          {/* DETAIL PEKERJAAN & LINK BARANG */}
          <div className="mt-4 bg-gray-50 p-4 rounded-lg border border-gray-200">
            <h3 className="text-xs font-semibold text-gray-700 uppercase tracking-wide mb-3">Detail Pekerjaan & Referensi</h3>

            <div className="flex flex-col sm:flex-row gap-4 items-end">
              <div className="w-full sm:flex-1">
                <label className="text-xs font-semibold text-gray-700 block mb-1">Pekerjaan</label>
                <input
                  type="text"
                  value={pekerjaan}
                  onChange={(e) => setPekerjaan(e.target.value)}
                  placeholder="Input pekerjaan..."
                  suppressHydrationWarning
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 text-sm"
                />
              </div>
              <div className="w-full sm:flex-1">
                <label className="text-xs font-semibold text-gray-700 block mb-1">Link Barang</label>
                <input
                  type="text"
                  value={linkBarang}
                  onChange={(e) => setLinkBarang(e.target.value)}
                  placeholder="Input link barang..."
                  suppressHydrationWarning
                  className="w-full px-3 py-2 border border-gray-300 rounded-lg focus:outline-none focus:ring-1 focus:ring-blue-500 text-sm"
                />
              </div>
              <div className="w-full sm:w-auto">
                <button
                  onClick={handleSaveDetails}
                  disabled={loading}
                  suppressHydrationWarning
                  className="w-full sm:w-auto bg-blue-600 text-white px-6 py-2 text-sm font-medium rounded-lg hover:bg-blue-700 transition disabled:opacity-50 disabled:cursor-not-allowed"
                >
                  Simpan
                </button>
              </div>
            </div>
          </div>

          {/* ALASAN TOLAK */}
          {ekuivalensi?.catatan && (
            <div className="mt-4 p-3 border border-red-200 bg-red-50 rounded-lg">
              <p className="text-xs text-red-500 font-medium">
                Catatan / Alasan Penolakan
              </p>
              <p className="text-sm text-red-700">{ekuivalensi.catatan}</p>
            </div>
          )}

          {/* EXPORT BUTTON */}
          <div className="mt-6 flex justify-end">
            <button
              onClick={handleExport}
              className="px-4 py-2 bg-blue-600 hover:bg-blue-700 text-white text-sm font-bold rounded-lg shadow-sm transition flex items-center gap-2"
            >
              <svg className="w-4 h-4" fill="none" stroke="currentColor" strokeWidth="2" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
                <path strokeLinecap="round" strokeLinejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"></path>
              </svg>
              Unduh Laporan (PDF)
            </button>
          </div>
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
            tanggal: new Date(ekuivalensi.tanggal).toLocaleString("id-ID", {
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