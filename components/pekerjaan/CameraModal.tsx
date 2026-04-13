'use client';

import { useState, useRef, useEffect } from 'react';
import Modal, { ModalFooter } from '@/components/ui/Modal';
import { Camera, MapPin, Smartphone, Clock, Check, RotateCcw, X, Loader2 } from 'lucide-react';
import toast from 'react-hot-toast';

interface CameraModalProps {
  open: boolean;
  onClose: () => void;
  onCapture: (file: File, meta: any) => void;
  title: string;
}

export default function CameraModal({ open, onClose, onCapture, title }: CameraModalProps) {
  const [stream, setStream] = useState<MediaStream | null>(null);
  const [preview, setPreview] = useState<string | null>(null);
  const [metadata, setMetadata] = useState<any>(null);
  const [isCapturing, setIsCapturing] = useState(false);
  const [permissionError, setPermissionError] = useState<string | null>(null);

  const videoRef = useRef<HTMLVideoElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  // Start camera when modal opens
  useEffect(() => {
    if (open && !preview) {
      startCamera();
    }
    return () => stopCamera();
  }, [open, preview]);

  const startCamera = async () => {
    setPermissionError(null);
    try {
      const mediaStream = await navigator.mediaDevices.getUserMedia({
        video: { facingMode: 'environment' },
        audio: false
      });
      setStream(mediaStream);
      if (videoRef.current) {
        videoRef.current.srcObject = mediaStream;
      }
    } catch (err: any) {
      console.error('Camera Error:', err);
      setPermissionError('Gagal mengakses kamera. Pastikan izin kamera telah diberikan.');
    }
  };

  const stopCamera = () => {
    if (stream) {
      stream.getTracks().forEach(track => track.stop());
      setStream(null);
    }
  };

  const takePhoto = async () => {
    if (!videoRef.current || !canvasRef.current) return;

    setIsCapturing(true);
    try {
      const video = videoRef.current;
      const canvas = canvasRef.current;
      const context = canvas.getContext('2d');

      if (!context) return;

      // Set canvas dimensions to match video
      canvas.width = video.videoWidth;
      canvas.height = video.videoHeight;

      // Draw the current frame
      context.drawImage(video, 0, 0, canvas.width, canvas.height);

      // 1. Get Location Metadata
      const geoPromise = new Promise<{ lat: number; lng: number }>((resolve) => {
        if (!navigator.geolocation) {
          resolve({ lat: 0, lng: 0 });
          return;
        }
        navigator.geolocation.getCurrentPosition(
          (pos) => resolve({ lat: pos.coords.latitude, lng: pos.coords.longitude }),
          () => resolve({ lat: 0, lng: 0 }),
          { timeout: 5000 }
        );
      });

      const coords = await geoPromise;
      
      const meta = {
        lat: coords.lat,
        lng: coords.lng,
        ts: new Date().toISOString(),
        device: navigator.userAgent
      };

      // Convert canvas to blob
      canvas.toBlob((blob) => {
        if (blob) {
          const file = new File([blob], `capture-${Date.now()}.jpg`, { type: 'image/jpeg' });
          setMetadata(meta);
          setPreview(URL.createObjectURL(file));
          stopCamera();
        }
      }, 'image/jpeg', 0.8);

    } catch (err: any) {
      toast.error('Gagal mengambil foto: ' + err.message);
    } finally {
      setIsCapturing(false);
    }
  };

  const handleConfirm = () => {
    if (preview && metadata) {
      // Create file from preview blob
      fetch(preview)
        .then(res => res.blob())
        .then(blob => {
          const file = new File([blob], `bukti-${Date.now()}.jpg`, { type: 'image/jpeg' });
          onCapture(file, metadata);
          handleReset();
        });
    }
  };

  const handleReset = () => {
    setPreview(null);
    setMetadata(null);
    setPermissionError(null);
    startCamera();
  };

  const handleClose = () => {
    stopCamera();
    setPreview(null);
    setMetadata(null);
    onClose();
  };

  return (
    <Modal open={open} onClose={handleClose} title={title} size="md">
      <div className="relative">
        {/* Permission Error State */}
        {permissionError && (
          <div className="flex flex-col items-center justify-center py-20 px-6 text-center bg-red-50 rounded-2xl border border-red-100">
             <div className="w-16 h-16 bg-red-100 text-red-600 rounded-full flex items-center justify-center mb-4">
                <X className="w-8 h-8" />
             </div>
             <h3 className="text-lg font-bold text-red-900">Akses Kamera Ditolak</h3>
             <p className="text-sm text-red-600 mt-2">{permissionError}</p>
             <button onClick={startCamera} className="mt-6 btn-primary bg-red-600">Coba Lagi</button>
          </div>
        )}

        {/* Live Stream View */}
        {!preview && !permissionError && (
          <div className="space-y-4">
            <div className="relative aspect-[3/4] rounded-2xl overflow-hidden bg-black border border-slate-200">
              <video 
                ref={videoRef} 
                autoPlay 
                playsInline 
                muted
                className="w-full h-full object-cover"
              />
              
              {/* Overlay Grid/Frame */}
              <div className="absolute inset-0 border-[40px] border-black/40 pointer-events-none">
                 <div className="w-full h-full border-2 border-white/20 rounded-lg"></div>
              </div>

              {/* Status Indicator */}
              <div className="absolute top-4 left-4 flex items-center gap-2 bg-black/40 backdrop-blur-md px-3 py-1.5 rounded-full border border-white/10">
                 <div className="w-2 h-2 bg-red-500 rounded-full animate-pulse"></div>
                 <span className="text-[10px] font-bold text-white uppercase tracking-wider">Live View</span>
              </div>
            </div>

            <div className="flex justify-center pt-2">
              <button 
                onClick={takePhoto}
                disabled={isCapturing || !stream}
                className="w-20 h-20 rounded-full bg-white border-8 border-slate-200 shadow-xl flex items-center justify-center active:scale-95 transition-all group disabled:opacity-50"
              >
                 <div className="w-12 h-12 rounded-full bg-blue-600 group-hover:bg-blue-700 font-bold text-white flex items-center justify-center">
                   {isCapturing ? <Loader2 className="w-6 h-6 animate-spin" /> : <Camera className="w-6 h-6" />}
                 </div>
              </button>
            </div>
            <p className="text-center text-xs text-slate-500 font-medium pb-2">Ketuk tombol di atas untuk mengambil foto</p>
          </div>
        )}

        {/* Preview View */}
        {preview && (
          <div className="space-y-4">
            <div className="relative aspect-[3/4] rounded-2xl overflow-hidden bg-black border border-slate-200 shadow-2xl">
              <img src={preview} alt="Capture Preview" className="w-full h-full object-cover" />
              
              {/* Captured Metadata Info */}
              <div className="absolute bottom-4 left-4 right-4 bg-black/60 backdrop-blur-md border border-white/20 p-4 rounded-xl text-white">
                <div className="grid grid-cols-2 gap-y-2">
                  <div className="flex items-center gap-2">
                    <MapPin className="w-3.5 h-3.5 text-blue-400" />
                    <span className="text-[10px] font-bold uppercase overflow-hidden truncate">
                       {metadata?.lat.toFixed(6)}, {metadata?.lng.toFixed(6)}
                    </span>
                  </div>
                  <div className="flex items-center gap-2 justify-end">
                    <Clock className="w-3.5 h-3.5 text-blue-400" />
                    <span className="text-[10px] font-bold uppercase">{new Date(metadata?.ts).toLocaleTimeString()}</span>
                  </div>
                  <div className="col-span-2 flex items-center gap-2 pt-1 border-t border-white/10 mt-1">
                    <Smartphone className="w-3.5 h-3.5 text-blue-400" />
                    <span className="text-[10px] font-medium opacity-70 truncate">Bukti Terverifikasi Sistem</span>
                  </div>
                </div>
              </div>
            </div>

            <div className="grid grid-cols-2 gap-3">
              <button 
                onClick={handleReset}
                className="btn-ghost border border-slate-200 flex items-center justify-center gap-2 py-3"
              >
                <RotateCcw className="w-4 h-4" /> Foto Ulang
              </button>
              <button 
                onClick={handleConfirm}
                className="btn-primary bg-blue-600 flex items-center justify-center gap-2 py-3 shadow-lg shadow-blue-900/20"
              >
                <Check className="w-4 h-4" /> Kirim Bukti
              </button>
            </div>
          </div>
        )}
      </div>

      {/* Hidden processing canvas */}
      <canvas ref={canvasRef} className="hidden" />
    </Modal>
  );
}
