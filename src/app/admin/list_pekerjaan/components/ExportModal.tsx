"use client";

import { useState, useEffect } from "react";
import { X, FileDown, Loader2, AlertCircle, CheckCircle } from "lucide-react";
import { getDataLaporanKompensasi, getExportFilters } from "../actions/export";
import type { ExportFiltersResult, LaporanKompensasiResult } from "../types";
import jsPDF from "jspdf";
import autoTable from "jspdf-autotable";
import ExcelJS from "exceljs";

interface ExportModalProps {
  isOpen: boolean;
  onClose: () => void;
  semesterId: number;
}

type FormatType = "pdf" | "excel";

export default function ExportModal({ isOpen, onClose, semesterId }: ExportModalProps) {
  const [filters, setFilters] = useState<ExportFiltersResult>({ prodi: [], kelas: [] });
  const [prodiFilter, setProdiFilter] = useState<number | null>(null);
  const [kelasFilter, setKelasFilter] = useState<number | null>(null);
  const [formatType, setFormatType] = useState<FormatType>("pdf");
  const [isLoading, setIsLoading] = useState(false);
  const [isDownloading, setIsDownloading] = useState(false);
  const [previewData, setPreviewData] = useState<LaporanKompensasiResult["data"] | null>(null);
  const [error, setError] = useState<string | null>(null);

  const filteredKelas = prodiFilter
    ? filters.kelas.filter(k => k.prodi_id === prodiFilter)
    : filters.kelas;

  // Reset cascading when parent filter changes
  useEffect(() => {
    setKelasFilter(null);
  }, [prodiFilter]);

  useEffect(() => {
    if (isOpen) {
      loadFilters();
      fetchPreviewData();
    } else {
      setProdiFilter(null);
      setKelasFilter(null);
      setFormatType("pdf");
      setPreviewData(null);
      setError(null);
      setFilters({ prodi: [], kelas: [] });
    }
  }, [isOpen, semesterId]);

  const loadFilters = async () => {
    try {
      const result = await getExportFilters();
      setFilters(result);
    } catch (err) {
      console.error('Gagal memuat filter export:', err);
    }
  };

  const fetchPreviewData = async () => {
    setIsLoading(true);
    setError(null);

    try {
      const params: {
        semester_id: number;
        prodi_id?: number;
        kelas_id?: number;
      } = {
        semester_id: semesterId,
      };

      if (prodiFilter) params.prodi_id = prodiFilter;
      if (kelasFilter) params.kelas_id = kelasFilter;

      const result = await getDataLaporanKompensasi(params);

      if (result.success && result.data) {
        setPreviewData(result.data);
      } else {
        setError(result.error || "Gagal mengambil data");
        setPreviewData(null);
      }
    } catch (err) {
      setError("Terjadi kesalahan sistem");
      setPreviewData(null);
    } finally {
      setIsLoading(false);
    }
  };

  useEffect(() => {
    if (isOpen) {
      fetchPreviewData();
    }
  }, [prodiFilter, kelasFilter, isOpen]);

  const formatDate = (dateString: string) => {
    const date = new Date(dateString);
    return date.toLocaleDateString("id-ID", {
      day: "numeric",
      month: "long",
      year: "numeric",
    });
  };

  const getAngkatanDisplayLabel = (angkatanNum: number) => {
    if (angkatanNum === 0) return "Lainnya";
    return `Kelas ${angkatanNum}`;
  };

  const getLabelById = (id: number | null, items: { id: number; nama: string }[]) => {
    if (!id) return null;
    return items.find(i => i.id === id)?.nama || null;
  };

  const generateFilename = (format: "pdf" | "excel") => {
    if (!previewData) return "";

    const { metadata } = previewData;
    const parts = [
      'Laporan_Kompensasi',
      getLabelById(metadata.prodi_filter, filters.prodi) || null,
      getLabelById(metadata.kelas_filter, filters.kelas) || null,
      `${metadata.semester_nama}${metadata.semester_tahun}`.replace(/\s+/g, ""),
      new Date().toISOString().split("T")[0].replace(/-/g, ""),
    ].filter(Boolean);

    const ext = format === "pdf" ? "pdf" : "xlsx";
    return `${parts.join('_')}.${ext}`;
  };

  const handleDownloadPDF = async () => {
    if (!previewData) return;

    setIsDownloading(true);
    setError(null);

    try {
      const doc = new jsPDF("landscape", "mm", "a4");
      const pageWidth = doc.internal.pageSize.getWidth();
      let currentY = 15;

      doc.setFontSize(16);
      doc.setFont("helvetica", "bold");
      doc.text("LAPORAN KOMPENSASI MAHASISWA", pageWidth / 2, currentY, { align: "center" });
      currentY += 7;

      doc.setFontSize(12);
      doc.text(`PROGRAM STUDI ${previewData.metadata.prodi_nama.toUpperCase()}`, pageWidth / 2, currentY, { align: "center" });
      currentY += 6;
      doc.text("POLITEKNIK NEGERI MALANG", pageWidth / 2, currentY, { align: "center" });
      currentY += 10;

      doc.setLineWidth(0.5);
      doc.line(14, currentY, pageWidth - 14, currentY);
      currentY += 6;

      doc.setFontSize(10);
      doc.setFont("helvetica", "normal");
      doc.text(`Semester: ${previewData.metadata.semester_nama} - ${previewData.metadata.semester_tahun}`, 14, currentY);
      currentY += 6;
      doc.text(`Tanggal: ${formatDate(previewData.metadata.tanggal_generate)}`, 14, currentY);
      currentY += 10;

      for (let i = 0; i < previewData.mahasiswa_by_angkatan.length; i++) {
        const angkatan = previewData.mahasiswa_by_angkatan[i];

        if (currentY > 180) {
          doc.addPage();
          currentY = 20;
        }

        doc.setFontSize(12);
        doc.setFont("helvetica", "bold");
        doc.text(getAngkatanDisplayLabel(angkatan.angkatan).toUpperCase(), 14, currentY);
        currentY += 8;

        autoTable(doc, {
          startY: currentY,
          head: [["No", "NIM", "Nama", "Kelas", "Jam Kompen", "Status", "Pekerjaan"]],
          body: angkatan.mahasiswa.map((m, idx) => [
            idx + 1,
            m.nim,
            m.nama,
            m.kelas,
            `${Math.floor(m.jam_sisa)}/${Math.floor(m.total_jam_wajib)}`,
            m.status_lunas ? "Lunas" : "Belum Lunas",
            m.pekerjaan_list.length > 0 ? m.pekerjaan_list.join(", ") : "-",
          ]),
          theme: "grid",
          styles: { fontSize: 8, cellPadding: 2 },
          headStyles: {
            fillColor: [41, 128, 185],
            textColor: 255,
            fontStyle: "bold",
            halign: "center",
          },
          columnStyles: {
            0: { halign: "center", cellWidth: 10 },
            1: { halign: "left", cellWidth: 25 },
            2: { halign: "left", cellWidth: 40 },
            3: { halign: "center", cellWidth: 15 },
            4: { halign: "center", cellWidth: 20 },
            5: { halign: "center", cellWidth: 20 },
            6: { halign: "left", cellWidth: "auto" },
          },
          didParseCell: function (data) {
            if (data.column.index === 5 && data.section === "body") {
              const status = data.cell.raw as string;
              if (status === "Lunas") {
                data.cell.styles.fillColor = [212, 237, 218];
                data.cell.styles.textColor = [21, 87, 36];
              } else {
                data.cell.styles.fillColor = [248, 215, 218];
                data.cell.styles.textColor = [114, 28, 36];
              }
            }
          },
        });

        currentY = (doc as any).lastAutoTable.finalY + 5;

        doc.setFontSize(9);
        doc.setFont("helvetica", "bold");
        doc.text(
          `Total: ${angkatan.summary.total_mahasiswa} mahasiswa | Lunas: ${angkatan.summary.total_lunas} | Belum Lunas: ${angkatan.summary.total_belum_lunas}`,
          14,
          currentY
        );
        currentY += 10;
      }

      const pageCount = doc.getNumberOfPages();
      for (let i = 1; i <= pageCount; i++) {
        doc.setPage(i);
        doc.setFontSize(8);
        doc.setFont("helvetica", "italic");
        doc.text(
          `Halaman ${i} dari ${pageCount}`,
          pageWidth / 2,
          doc.internal.pageSize.getHeight() - 10,
          { align: "center" }
        );
      }

      doc.save(generateFilename("pdf"));
    } catch (err) {
      console.error("Error generating PDF:", err);
      setError("Gagal membuat file PDF");
    } finally {
      setIsDownloading(false);
    }
  };

  const handleDownloadExcel = async () => {
    if (!previewData) return;

    setIsDownloading(true);
    setError(null);

    try {
      const workbook = new ExcelJS.Workbook();
      workbook.creator = "Sistem Kompensasi - Polinema";
      workbook.created = new Date();

      for (const angkatan of previewData.mahasiswa_by_angkatan) {
        const sheet = workbook.addWorksheet(getAngkatanDisplayLabel(angkatan.angkatan));

        sheet.mergeCells("A1:I1");
        const titleCell = sheet.getCell("A1");
        titleCell.value = "LAPORAN KOMPENSASI MAHASISWA";
        titleCell.font = { size: 14, bold: true };
        titleCell.alignment = { horizontal: "center", vertical: "middle" };
        sheet.getRow(1).height = 25;

        sheet.mergeCells("A2:I2");
        const prodiCell = sheet.getCell("A2");
        prodiCell.value = `PROGRAM STUDI ${previewData.metadata.prodi_nama.toUpperCase()}`;
        prodiCell.font = { size: 12, bold: true };
        prodiCell.alignment = { horizontal: "center" };
        sheet.getRow(2).height = 20;

        sheet.mergeCells("A3:I3");
        const institutionCell = sheet.getCell("A3");
        institutionCell.value = "POLITEKNIK NEGERI MALANG";
        institutionCell.font = { size: 11, bold: true };
        institutionCell.alignment = { horizontal: "center" };
        sheet.getRow(3).height = 18;

        sheet.getCell("A5").value = "Semester:";
        sheet.getCell("A5").font = { bold: true };
        sheet.getCell("B5").value = `${previewData.metadata.semester_nama} - ${previewData.metadata.semester_tahun}`;

        sheet.getCell("A6").value = "Angkatan:";
        sheet.getCell("A6").font = { bold: true };
        sheet.getCell("B6").value = getAngkatanDisplayLabel(angkatan.angkatan);

        sheet.getCell("A7").value = "Tanggal:";
        sheet.getCell("A8").font = { bold: true };
        sheet.getCell("B8").value = formatDate(previewData.metadata.tanggal_generate);

        const headerRow = sheet.getRow(8);
        headerRow.values = [
          "No", "NIM", "Nama", "Kelas", "Total Jam Wajib", "Jam Dikurangi",
          "Jam Sisa", "Status", "Pekerjaan yang Diambil",
        ];
        headerRow.font = { bold: true };
        headerRow.fill = { type: "pattern", pattern: "solid", fgColor: { argb: "FF2980B9" } };
        headerRow.font = { bold: true, color: { argb: "FFFFFFFF" } };
        headerRow.alignment = { vertical: "middle", horizontal: "center" };
        headerRow.height = 20;

        angkatan.mahasiswa.forEach((m, idx) => {
          const row = sheet.addRow([
            idx + 1, m.nim, m.nama, m.kelas,
            Math.floor(m.total_jam_wajib), Math.floor(m.jam_sudah_dikurangi),
            Math.floor(m.jam_sisa),
            m.status_lunas ? "Lunas" : "Belum Lunas",
            m.pekerjaan_list.length > 0 ? m.pekerjaan_list.join(", ") : "-",
          ]);

          const statusCell = row.getCell(8);
          if (m.status_lunas) {
            statusCell.fill = { type: "pattern", pattern: "solid", fgColor: { argb: "FFD4EDDA" } };
            statusCell.font = { color: { argb: "FF155724" }, bold: true };
          } else {
            statusCell.fill = { type: "pattern", pattern: "solid", fgColor: { argb: "FFF8D7DA" } };
            statusCell.font = { color: { argb: "FF721C24" }, bold: true };
          }

          row.getCell(1).alignment = { horizontal: "center" };
          row.getCell(4).alignment = { horizontal: "center" };
          row.getCell(5).alignment = { horizontal: "center" };
          row.getCell(6).alignment = { horizontal: "center" };
          row.getCell(7).alignment = { horizontal: "center" };
          row.getCell(8).alignment = { horizontal: "center" };
        });

        const lastDataRow = 8 + angkatan.mahasiswa.length;
        const summaryRowNum = lastDataRow + 2;
        const summaryRow = sheet.getRow(summaryRowNum);
        summaryRow.getCell(1).value = `Total: ${angkatan.summary.total_mahasiswa} mahasiswa | Lunas: ${angkatan.summary.total_lunas} | Belum Lunas: ${angkatan.summary.total_belum_lunas}`;
        summaryRow.font = { bold: true };
        sheet.mergeCells(summaryRowNum, 1, summaryRowNum, 9);

        sheet.columns = [
          { width: 6 }, { width: 18 }, { width: 30 }, { width: 10 },
          { width: 15 }, { width: 15 }, { width: 12 }, { width: 15 }, { width: 50 },
        ];

        for (let rowNum = 8; rowNum <= lastDataRow; rowNum++) {
          const row = sheet.getRow(rowNum);
          for (let colNum = 1; colNum <= 9; colNum++) {
            const cell = row.getCell(colNum);
            cell.border = {
              top: { style: "thin" }, left: { style: "thin" },
              bottom: { style: "thin" }, right: { style: "thin" },
            };
          }
        }
      }

      const buffer = await workbook.xlsx.writeBuffer();
      const blob = new Blob([buffer], {
        type: "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
      });
      const url = URL.createObjectURL(blob);
      const a = document.createElement("a");
      a.href = url;
      a.download = generateFilename("excel");
      a.click();
      URL.revokeObjectURL(url);
    } catch (err) {
      console.error("Error generating Excel:", err);
      setError("Gagal membuat file Excel");
    } finally {
      setIsDownloading(false);
    }
  };

  const handleDownload = () => {
    if (formatType === "pdf") {
      handleDownloadPDF();
    } else {
      handleDownloadExcel();
    }
  };

  const getTotalMahasiswa = () => {
    if (!previewData) return 0;
    return previewData.mahasiswa_by_angkatan.reduce((sum, a) => sum + a.summary.total_mahasiswa, 0);
  };

  const getTotalLunas = () => {
    if (!previewData) return 0;
    return previewData.mahasiswa_by_angkatan.reduce((sum, a) => sum + a.summary.total_lunas, 0);
  };

  const getTotalBelumLunas = () => {
    if (!previewData) return 0;
    return previewData.mahasiswa_by_angkatan.reduce((sum, a) => sum + a.summary.total_belum_lunas, 0);
  };

  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
      <div className="bg-white rounded-xl shadow-xl w-full max-w-2xl overflow-hidden animate-in fade-in zoom-in duration-200">
        <div className="flex justify-between items-center p-5 border-b border-gray-200">
          <h2 className="text-lg font-bold text-gray-900">Export Laporan Kompensasi</h2>
          <button
            onClick={onClose}
            className="text-gray-400 hover:text-gray-600 focus:outline-none transition-colors"
          >
            <X className="w-6 h-6" />
          </button>
        </div>

        <div className="p-6">
          {error && (
            <div className="mb-4 flex items-center gap-2 p-3 text-sm bg-red-50 border border-red-200 rounded-lg text-red-700">
              <AlertCircle className="w-4 h-4" />
              {error}
            </div>
          )}

          {/* Prodi */}
          <div className="mb-4">
            <label className="block text-sm font-semibold text-gray-900 mb-2">📚 Program Studi</label>
            <select
              value={prodiFilter ?? ''}
              onChange={(e) => setProdiFilter(e.target.value ? Number(e.target.value) : null)}
              disabled={filters.prodi.length === 0}
              className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white text-gray-700 disabled:bg-gray-100 disabled:text-gray-400"
            >
              <option value="">Semua Prodi</option>
              {filters.prodi.map((p) => (
                <option key={p.id} value={p.id}>{p.nama}</option>
              ))}
            </select>
          </div>

          {/* Kelas */}
          <div className="mb-6">
            <label className="block text-sm font-semibold text-gray-900 mb-2">🏛️ Kelas</label>
            <select
              value={kelasFilter ?? ''}
              onChange={(e) => setKelasFilter(e.target.value ? Number(e.target.value) : null)}
              disabled={filteredKelas.length === 0}
              className="w-full px-3 py-2 border border-gray-200 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 focus:border-blue-500 transition-all bg-white text-gray-700 disabled:bg-gray-100 disabled:text-gray-400"
            >
              <option value="">Semua Kelas</option>
              {filteredKelas.map((k) => (
                <option key={k.id} value={k.id}>{k.nama}</option>
              ))}
            </select>
          </div>

          {/* Format */}
          <div className="mb-6">
            <label className="block text-sm font-semibold text-gray-900 mb-3">📄 Format Export</label>
            <div className="flex gap-3">
              <label className="flex-1 flex items-center justify-center gap-2 p-3 border-2 border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                <input
                  type="radio"
                  name="format"
                  value="pdf"
                  checked={formatType === "pdf"}
                  onChange={() => setFormatType("pdf")}
                  className="w-4 h-4 text-blue-600 focus:ring-2 focus:ring-blue-500"
                />
                <span className="text-sm font-medium text-gray-700">PDF</span>
              </label>
              <label className="flex-1 flex items-center justify-center gap-2 p-3 border-2 border-gray-200 rounded-lg hover:bg-gray-50 cursor-pointer transition-colors">
                <input
                  type="radio"
                  name="format"
                  value="excel"
                  checked={formatType === "excel"}
                  onChange={() => setFormatType("excel")}
                  className="w-4 h-4 text-blue-600 focus:ring-2 focus:ring-blue-500"
                />
                <span className="text-sm font-medium text-gray-700">Excel</span>
              </label>
            </div>
          </div>

          {/* Preview */}
          {isLoading ? (
            <div className="p-6 bg-gray-50 border border-gray-200 rounded-lg flex items-center justify-center">
              <Loader2 className="w-5 h-5 animate-spin text-gray-400 mr-2" />
              <span className="text-sm text-gray-500">Memuat preview data...</span>
            </div>
          ) : previewData ? (
            <div className="p-4 bg-blue-50 border border-blue-200 rounded-lg">
              <div className="flex items-start gap-2 mb-3">
                <CheckCircle className="w-5 h-5 text-blue-600 mt-0.5" />
                <div className="flex-1">
                  <h4 className="text-sm font-semibold text-blue-900 mb-2">Preview Data:</h4>
                  <ul className="space-y-1 text-sm text-blue-800">
                    <li>• Total Mahasiswa: <span className="font-semibold">{getTotalMahasiswa()} orang</span></li>
                    <li>• Lunas: <span className="font-semibold text-green-700">{getTotalLunas()}</span> | Belum Lunas: <span className="font-semibold text-red-700">{getTotalBelumLunas()}</span></li>
                    <li>• Periode: <span className="font-semibold">{previewData.metadata.semester_nama} - {previewData.metadata.semester_tahun}</span></li>
                    <li>• Tanggal: <span className="font-semibold">{formatDate(previewData.metadata.tanggal_generate)}</span></li>
                  </ul>
                </div>
              </div>
            </div>
          ) : null}
        </div>

        <div className="flex justify-end gap-3 p-5 border-t border-gray-100 bg-gray-50/50">
          <button
            onClick={onClose}
            disabled={isDownloading}
            className="px-5 py-2.5 border border-gray-300 text-gray-700 font-medium text-sm rounded-lg hover:bg-gray-100 transition-colors focus:outline-none disabled:opacity-50"
          >
            Batal
          </button>
          <button
            onClick={handleDownload}
            disabled={isDownloading || isLoading || !previewData}
            className="flex items-center gap-2 px-5 py-2.5 bg-green-600 text-white font-medium text-sm rounded-lg hover:bg-green-700 transition-colors focus:outline-none disabled:opacity-50 disabled:cursor-not-allowed"
          >
            {isDownloading ? (
              <>
                <Loader2 className="w-4 h-4 animate-spin" />
                Memproses...
              </>
            ) : (
              <>
                <FileDown className="w-4 h-4" />
                Download Laporan
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
}
