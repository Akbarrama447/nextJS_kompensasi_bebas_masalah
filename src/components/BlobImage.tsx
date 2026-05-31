"use client";

import { useEffect, useState } from "react";
import { ImageOff, Loader2 } from "lucide-react";

interface BlobImageProps {
  /** URL sumber gambar. Bisa path server ("/uploads/x.jpg"), blob:, atau data: URL. */
  src?: string | null;
  alt?: string;
  className?: string;
  /** Teks ditampilkan saat gambar belum tersedia. */
  emptyText?: string;
  /** Teks ditampilkan saat gambar gagal dimuat. */
  errorText?: string;
}

/**
 * Menampilkan gambar (terutama hasil upload seperti bukti kompen / foto pengerjaan)
 * dengan cara mengambilnya sebagai Blob lalu merendernya via object URL.
 *
 * Keuntungan:
 * - Object URL otomatis dibersihkan agar tidak bocor memori.
 * - Sumber yang sudah berupa blob:/data: (mis. hasil capture webcam) dipakai langsung.
 * - Cocok untuk file upload arbitrer; tidak melewati optimizer next/image.
 */
export default function BlobImage({
  src,
  alt = "",
  className = "",
  emptyText = "Tidak ada gambar",
  errorText = "Gagal memuat gambar",
}: BlobImageProps) {
  const [objectUrl, setObjectUrl] = useState<string | null>(null);
  const [status, setStatus] = useState<"idle" | "loading" | "loaded" | "error">("idle");

  useEffect(() => {
    if (!src) {
      setObjectUrl(null);
      setStatus("idle");
      return;
    }

    // Sumber yang sudah berupa blob/data URL dipakai langsung tanpa fetch.
    if (src.startsWith("blob:") || src.startsWith("data:")) {
      setObjectUrl(src);
      setStatus("loaded");
      return;
    }

    let cancelled = false;
    let createdUrl: string | null = null;

    setStatus("loading");
    fetch(src)
      .then((res) => {
        if (!res.ok) throw new Error(`HTTP ${res.status}`);
        return res.blob();
      })
      .then((blob) => {
        if (cancelled) return;
        createdUrl = URL.createObjectURL(blob);
        setObjectUrl(createdUrl);
        setStatus("loaded");
      })
      .catch(() => {
        if (cancelled) return;
        setStatus("error");
      });

    return () => {
      cancelled = true;
      if (createdUrl) URL.revokeObjectURL(createdUrl);
    };
  }, [src]);

  if (!src || status === "idle") {
    return (
      <div className={`flex flex-col items-center justify-center text-gray-400 text-xs gap-1 ${className}`}>
        <ImageOff className="w-5 h-5" />
        <span>{emptyText}</span>
      </div>
    );
  }

  if (status === "loading") {
    return (
      <div className={`flex items-center justify-center text-gray-400 ${className}`}>
        <Loader2 className="w-5 h-5 animate-spin" />
      </div>
    );
  }

  if (status === "error" || !objectUrl) {
    return (
      <div className={`flex flex-col items-center justify-center text-gray-400 text-xs gap-1 ${className}`}>
        <ImageOff className="w-5 h-5" />
        <span>{errorText}</span>
      </div>
    );
  }

  return (
    // Object URL hasil blob; next/image tidak cocok untuk upload arbitrer.
    // eslint-disable-next-line @next/next/no-img-element
    <img src={objectUrl} alt={alt} className={className} />
  );
}
