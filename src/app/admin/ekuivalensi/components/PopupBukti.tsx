"use client";

import { X, Clock, MapPin, CheckCircle, XCircle } from "lucide-react";

interface Props {
  open: boolean;
  onClose: () => void;
  onApprove: () => void;
  onReject: () => void;

  data: {
    kelas: string;
    jam: number;
    nominal: number;
    tanggal: string;
    fotoUrl?: string;
  };
}

export default function PopupBukti({
  open,
  onClose,
  onApprove,
  onReject,
  data,
}: Props) {
  if (!open) return null;

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm p-2 sm:p-3">

      {/* POPUP CONTAINER */}
      <div className="
        bg-white rounded-2xl shadow-xl
        w-full max-w-[95vw] sm:max-w-2xl
        p-3 sm:p-5
        animate-in fade-in zoom-in
      ">

        {/* HEADER (tetap seperti awal, hanya kecil di HP) */}
        <div className="flex items-center gap-2 sm:gap-3 mb-3 pb-3 border-b border-gray-300">

          <span className="px-2 sm:px-3 py-1 text-xs sm:text-sm bg-gray-100 rounded-full whitespace-nowrap">
            {data.kelas}
          </span>

          <span className="px-2 sm:px-3 py-1 text-xs sm:text-sm bg-blue-100 text-blue-600 rounded-full whitespace-nowrap">
            Verifikasi
          </span>

          <button
            onClick={onClose}
            className="ml-auto text-gray-400 hover:text-gray-600"
          >
            <X className="w-4 h-4 sm:w-5 sm:h-5" />
          </button>

        </div>

        {/* FOTO */}
        <div className="mb-4">

          <p className="text-center text-xs sm:text-sm text-gray-500 mb-2">
            FOTO NOTA
          </p>

          <div className="w-full h-36 sm:h-56 bg-gray-200 rounded-xl flex items-center justify-center overflow-hidden">

            {data.fotoUrl ? (
              <img
                src={data.fotoUrl}
                className="object-cover w-full h-full"
              />
            ) : (
              <div className="flex flex-col items-center justify-center text-gray-400">
                <span className="text-xs sm:text-sm font-medium">
                  No Image
                </span>
                <span className="text-[10px] sm:text-xs text-gray-300">
                  Belum ada bukti
                </span>
              </div>
            )}

          </div>
        </div>

        {/* INFO BOX (3 KOLOM TETAP, HANYA DIPERKECIL) */}
        <div className="border border-gray-200 rounded-xl overflow-hidden mb-5">

          <div className="grid grid-cols-[1fr_1fr_2fr] text-center text-[10px] sm:text-sm">

            {/* JAM */}
            <div className="p-2 sm:p-4 border-r border-gray-200">
              <p className="text-[10px] sm:text-xs text-gray-500 mb-1">
                Jam
              </p>
              <p className="text-xs sm:text-base font-semibold text-gray-800">
                {data.jam} JAM
              </p>
            </div>

            {/* NOMINAL */}
            <div className="p-2 sm:p-4 border-r border-gray-200">
              <p className="text-[10px] sm:text-xs text-gray-500 mb-1">
                Nominal
              </p>
              <p className="text-xs sm:text-base font-bold text-green-600">
                Rp. {data.nominal.toLocaleString()}
              </p>
            </div>

            {/* WAKTU + LOKASI */}
            <div className="p-2 sm:p-4 flex flex-col items-center justify-center gap-1 sm:gap-2">

              <div className="flex flex-col items-center gap-1 sm:gap-2 text-[10px] sm:text-sm text-gray-700">

                {/* WAKTU */}
                <div className="flex items-start sm:items-center gap-1 sm:gap-2 text-center sm:text-left leading-tight">
                    <Clock className="w-3 h-3 sm:w-4 sm:h-4 mt-[2px] sm:mt-0" />
                    <span className="break-words text-center">
                    {data.tanggal}
                    </span>
                </div>

                {/* LOKASI */}
                <div className="flex items-center gap-1 sm:gap-2 text-blue-600 cursor-pointer hover:underline">
                    <MapPin className="w-3 h-3 sm:w-4 sm:h-4" />
                    <span className="whitespace-nowrap">
                    Lihat Lokasi
                    </span>
                </div>

                </div>

            </div>

          </div>
        </div>

        {/* ACTION BUTTON (tetap horizontal, tapi kecil di HP) */}
        <div className="flex justify-between gap-2">

          <button
            onClick={onReject}
            className="flex items-center justify-center gap-1 sm:gap-2 px-3 sm:px-4 py-2 border border-red-300 text-red-600 rounded-lg hover:bg-red-50 text-xs sm:text-sm w-full"
          >
            <XCircle className="w-4 h-4" />
            Tolak
          </button>

          <button
            onClick={onApprove}
            className="flex items-center justify-center gap-1 sm:gap-2 px-3 sm:px-4 py-2 bg-blue-600 text-white rounded-lg hover:bg-blue-700 text-xs sm:text-sm w-full"
          >
            <CheckCircle className="w-4 h-4" />
            Setujui dan Potong Jam
          </button>

        </div>

      </div>
    </div>
  );
}