"use client";

import { X } from "lucide-react";
import { useState } from "react";

interface Props {
  open: boolean;
  onClose: () => void;
  onSubmit: (alasan: string) => void;
}

export default function PopupTolak({ open, onClose, onSubmit }: Props) {
  const [alasan, setAlasan] = useState("");

  if (!open) return null;

  const handleSubmit = () => {
    if (!alasan.trim()) return;
    onSubmit(alasan);
    setAlasan("");
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-4">
      <div className="bg-white rounded-xl shadow-xl w-full max-w-md overflow-hidden">

        {/* HEADER */}
        <div className="flex justify-between items-center p-4 border-b border-gray-300">
          <h2 className="text-sm font-semibold text-gray-800">
            Tolak Penugasan
          </h2>
          <button onClick={onClose}>
            <X className="w-5 h-5 text-gray-400" />
          </button>
        </div>

        {/* BODY */}
        <div className="p-4">
          <p className="text-xs text-gray-500 mb-4">
            Berikan alasan penolakan yang jelas agar mahasiswa dapat memperbaikinya.
          </p>

          <label className="text-sm font-medium text-gray-800">
            Alasan Penolakan
          </label>

          <textarea
            value={alasan}
            onChange={(e) => setAlasan(e.target.value)}
            placeholder="misal : foto kurang jelas, jumlah biaya (nota) kurang, dll."
            className="w-full mt-2 p-3 border border-blue-300 rounded-lg text-sm focus:outline-none focus:ring-2 focus:ring-blue-500/20 resize-none"
            rows={4}
          />
        </div>

        {/* FOOTER */}
        <div className="flex justify-end gap-2 p-4 border-t border-gray-300 bg-gray-50">
          <button
            onClick={onClose}
            className="px-4 py-1.5 border rounded-md text-sm text-gray-1000 hover:bg-gray-100"
          >
            Batal
          </button>

          <button
            onClick={handleSubmit}
            className="px-4 py-1.5 bg-red-100 text-red-600 border border-red-300 rounded-md text-sm hover:bg-red-200"
          >
            Konfirmasi Tolak
          </button>
        </div>
      </div>
    </div>
  );
}