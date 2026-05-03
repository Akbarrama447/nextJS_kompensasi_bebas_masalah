"use client";

interface UserHeaderProps {
  nama: string
  role?: 'mahasiswa' | 'admin'
}

export default function UserHeader({ nama, role = 'mahasiswa' }: UserHeaderProps) {
  const roleLabel = role === 'admin' ? 'Admin' : 'Mahasiswa'
  
  return (
    <header className="bg-white h-14 md:h-16 px-4 md:px-10 flex items-center justify-between border-b border-slate-200 gap-2">
      
      {/* SEARCH BAR */}
      <div className="relative flex-1 max-w-xs md:max-w-sm lg:max-w-md group">
        <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
          <svg className="w-4 h-4 text-slate-400 group-focus-within:text-[#2e5299] transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
          </svg>
        </div>
        <input 
          type="text" 
          placeholder="cari..." 
          className="w-full bg-slate-50 border border-slate-200 text-xs md:text-sm text-slate-600 rounded-lg pl-10 pr-4 py-1.5 md:py-2 outline-none focus:ring-1 focus:ring-[#2e5299]/30 focus:border-[#2e5299]/50 transition-all placeholder:text-slate-400"
        />
      </div>

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
