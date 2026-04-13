'use client';

import { useState, useRef, useEffect } from 'react';
import { createClient } from '@/lib/supabase/client';
import { Loader2, Check, AlertCircle } from 'lucide-react';
import toast from 'react-hot-toast';

interface InlineSettingProps {
  setting: {
    id: number;
    kunci: string;
    nilai: string;
    label: string;
    grup: string;
  };
  onUpdate: () => void;
}

export default function InlineSetting({ setting, onUpdate }: InlineSettingProps) {
  const [isEditing, setIsEditing] = useState(false);
  const [value, setValue] = useState(setting.nilai);
  const [saving, setSaving] = useState(false);
  const inputRef = useRef<HTMLInputElement>(null);
  const supabase = createClient();

  // If numeric key, restrict input
  const isNumeric = setting.kunci.includes('nominal') || setting.kunci.includes('harga');

  useEffect(() => {
    if (isEditing && inputRef.current) {
      inputRef.current.focus();
      inputRef.current.select();
    }
  }, [isEditing]);

  const handleSave = async () => {
    if (value === setting.nilai) {
      setIsEditing(false);
      return;
    }

    // Validation
    if (isNumeric && isNaN(Number(value))) {
      toast.error('Nilai harus berupa angka');
      setValue(setting.nilai);
      setIsEditing(false);
      return;
    }

    setSaving(true);
    try {
      const { error } = await supabase
        .from('pengaturan')
        .update({ nilai: value })
        .eq('id', setting.id);

      if (error) throw error;
      
      toast.success(`${setting.label} diperbarui`);
      onUpdate();
    } catch (err: any) {
      toast.error(err.message);
      setValue(setting.nilai);
    } finally {
      setSaving(false);
      setIsEditing(false);
    }
  };

  const handleKeyDown = (e: React.KeyboardEvent) => {
    if (e.key === 'Enter') handleSave();
    if (e.key === 'Escape') {
      setValue(setting.nilai);
      setIsEditing(false);
    }
  };

  return (
    <div className="flex items-center justify-between py-4 border-b border-slate-100 last:border-0 group">
      <div className="flex-1 pr-4">
        <p className="text-sm font-semibold text-slate-700 mb-0.5">{setting.label}</p>
        <p className="text-[10px] font-mono text-slate-400 uppercase tracking-tighter">{setting.kunci}</p>
      </div>

      <div className="flex-shrink-0 min-w-[140px] text-right">
        {isEditing ? (
          <div className="relative">
            <input
              ref={inputRef}
              type={isNumeric ? "number" : "text"}
              className="input-base text-right font-bold text-blue-600 focus:ring-2 pr-8"
              value={value}
              onChange={(e) => setValue(e.target.value)}
              onBlur={handleSave}
              onKeyDown={handleKeyDown}
              disabled={saving}
            />
            {saving && (
              <Loader2 className="absolute right-2 top-1/2 -translate-y-1/2 w-4 h-4 animate-spin text-blue-400" />
            )}
          </div>
        ) : (
          <button
            onClick={() => setIsEditing(true)}
            className="flex flex-col items-end group/btn"
          >
            <span className="text-base font-bold text-slate-900 group-hover/btn:text-blue-600 transition-colors">
              {isNumeric ? Number(value).toLocaleString('id-ID') : value}
              {isNumeric && setting.kunci === 'konversi_nominal_per_jam' && <span className="text-xs font-normal text-slate-400 ml-1">/ jam</span>}
            </span>
            <span className="text-[10px] text-slate-400 opacity-0 group-hover/btn:opacity-100 transition-opacity">
              Klik untuk ubah
            </span>
          </button>
        )}
      </div>
    </div>
  );
}
