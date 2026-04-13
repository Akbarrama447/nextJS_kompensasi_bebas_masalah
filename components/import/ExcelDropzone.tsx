'use client';

import { useState, useCallback } from 'react';
import { Upload, FileSpreadsheet, X } from 'lucide-react';

interface ExcelDropzoneProps {
  onFileParsed: (file: File, buffer: ArrayBuffer) => void;
  disabled?: boolean;
}

export default function ExcelDropzone({ onFileParsed, disabled }: ExcelDropzoneProps) {
  const [dragging, setDragging] = useState(false);
  const [fileName, setFileName] = useState<string | null>(null);

  const processFile = useCallback(
    (file: File) => {
      if (!file.name.endsWith('.xlsx') && !file.name.endsWith('.xls')) {
        alert('Hanya file .xlsx atau .xls yang diizinkan.');
        return;
      }
      setFileName(file.name);
      const reader = new FileReader();
      reader.onload = (e) => {
        if (e.target?.result instanceof ArrayBuffer) {
          onFileParsed(file, e.target.result);
        }
      };
      reader.readAsArrayBuffer(file);
    },
    [onFileParsed]
  );

  const handleDrop = (e: React.DragEvent) => {
    e.preventDefault();
    setDragging(false);
    const file = e.dataTransfer.files[0];
    if (file) processFile(file);
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) processFile(file);
  };

  if (fileName) {
    return (
      <div className="flex items-center gap-3 bg-blue-50 border border-blue-200 rounded-xl px-5 py-4">
        <FileSpreadsheet className="w-8 h-8 text-blue-500 flex-shrink-0" />
        <div className="flex-1 min-w-0">
          <p className="font-medium text-blue-900 truncate">{fileName}</p>
          <p className="text-xs text-blue-600">File siap diproses</p>
        </div>
        <button
          onClick={() => setFileName(null)}
          className="p-1.5 rounded-lg hover:bg-blue-100 text-blue-400 hover:text-blue-600 transition-colors flex-shrink-0"
          title="Ganti file"
        >
          <X className="w-4 h-4" />
        </button>
      </div>
    );
  }

  return (
    <label
      className={[
        'flex flex-col items-center justify-center gap-3 rounded-xl border-2 border-dashed',
        'cursor-pointer transition-colors duration-200 p-10 text-center',
        dragging
          ? 'border-blue-400 bg-blue-50'
          : 'border-slate-300 bg-slate-50 hover:border-blue-400 hover:bg-blue-50/50',
        disabled ? 'opacity-50 pointer-events-none' : '',
      ].join(' ')}
      onDragOver={(e) => { e.preventDefault(); setDragging(true); }}
      onDragLeave={() => setDragging(false)}
      onDrop={handleDrop}
    >
      <div className="w-12 h-12 bg-blue-100 rounded-xl flex items-center justify-center">
        <Upload className="w-6 h-6 text-blue-500" />
      </div>
      <div>
        <p className="font-medium text-slate-700">
          Seret file Excel ke sini, atau <span className="text-blue-600">klik untuk pilih</span>
        </p>
        <p className="text-xs text-slate-400 mt-1">Format: .xlsx atau .xls</p>
      </div>
      <input
        type="file"
        accept=".xlsx,.xls"
        className="hidden"
        onChange={handleChange}
        disabled={disabled}
      />
    </label>
  );
}
