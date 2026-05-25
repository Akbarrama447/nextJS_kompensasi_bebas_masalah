"use client";

interface UserHeaderProps {
  nama: string
  role?: 'mahasiswa' | 'admin'
  semesterLabel?: string
}

export default function UserHeader({ nama, role = 'mahasiswa', semesterLabel }: UserHeaderProps) {
  const roleLabel = role === 'admin' ? 'Admin' : 'Mahasiswa'
  
  return (
    <header className="bg-white h-14 md:h-16 px-4 md:px-10 flex items-center justify-between border-b border-slate-200 gap-2">
      
      {semesterLabel && (
        <div className="flex items-center gap-2">
          <span className="text-xs md:text-sm font-semibold text-[#2e5299] bg-[#eef2ff] px-3 py-1.5 rounded-lg">
            {semesterLabel}
          </span>
        </div>
      )}

      <div className="flex items-center gap-2 md:gap-3 ml-auto">
        <div className="flex flex-col text-right hidden sm:flex">
          <span className="text-xs md:text-sm font-bold text-slate-700">{nama}</span>
          <span className="text-[9px] md:text-[11px] text-[#2e5299] font-bold">{roleLabel}</span>
        </div>
        <div className="w-7 h-7 md:w-9 md:h-9 rounded-full bg-slate-100 border border-slate-200 shadow-sm flex-shrink-0"></div>
      </div>
    </header>
  )
}
