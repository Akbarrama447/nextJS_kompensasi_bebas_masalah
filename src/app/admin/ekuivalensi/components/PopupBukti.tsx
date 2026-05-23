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
    noTelepon?: string;
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

        {/* NOMOR TELEPON */}
        {data.noTelepon && (
          <div className="flex items-center justify-between bg-blue-50 border border-blue-200 rounded-xl px-4 py-2.5 mb-3">
            <div className="flex items-center gap-2">
              <span className="text-[10px] sm:text-xs font-medium text-blue-600">No. Telepon Perwakilan:</span>
              <span className="text-xs sm:text-sm font-bold text-blue-800">{data.noTelepon}</span>
            </div>
            <a
              href={`https://wa.me/${data.noTelepon.replace(/[^0-9]/g, '')}`}
              target="_blank"
              rel="noopener noreferrer"
              className="flex items-center gap-1 px-2.5 py-1 text-[10px] sm:text-xs font-bold text-white bg-green-500 hover:bg-green-600 rounded-lg transition"
            >
              <svg className="w-3.5 h-3.5" fill="currentColor" viewBox="0 0 24 24">
                <path d="M17.472 14.382c-.297-.149-1.758-.867-2.03-.967-.273-.099-.471-.148-.67.15-.197.297-.767.966-.94 1.164-.173.199-.347.223-.644.075-.297-.15-1.255-.463-2.39-1.475-.883-.788-1.48-1.761-1.653-2.059-.173-.297-.018-.458.13-.606.134-.133.298-.347.446-.52.149-.174.198-.298.298-.497.099-.198.05-.371-.025-.52-.075-.149-.669-1.612-.916-2.207-.242-.579-.487-.5-.669-.51-.173-.008-.371-.01-.57-.01-.198 0-.52.074-.792.372-.272.297-1.04 1.016-1.04 2.479 0 1.462 1.065 2.875 1.213 3.074.149.198 2.096 3.2 5.077 4.487.709.306 1.262.489 1.694.625.712.227 1.36.195 1.871.118.571-.085 1.758-.719 2.006-1.413.248-.694.248-1.289.173-1.413-.074-.124-.272-.198-.57-.347m-5.421 7.403h-.004a9.87 9.87 0 01-5.031-1.378l-.361-.214-3.741.982.998-3.648-.235-.374a9.86 9.86 0 01-1.51-5.26c.001-5.45 4.436-9.884 9.888-9.884 2.64 0 5.122 1.03 6.988 2.898a9.825 9.825 0 012.893 6.994c-.003 5.45-4.437 9.884-9.885 9.884m8.413-18.297A11.815 11.815 0 0012.05 0C5.495 0 .16 5.335.157 11.892c0 2.096.547 4.142 1.588 5.945L.057 24l6.305-1.654a11.882 11.882 0 005.683 1.448h.005c6.554 0 11.89-5.335 11.893-11.893a11.821 11.821 0 00-3.48-8.413z"/>
              </svg>
              WhatsApp
            </a>
          </div>
        )}

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