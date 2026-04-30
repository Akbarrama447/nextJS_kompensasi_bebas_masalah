'use client'

interface UserHeaderProps {
  nama: string
  role?: 'mahasiswa' | 'admin'
}

export default function UserHeader({ nama, role = 'mahasiswa' }: UserHeaderProps) {
  const roleLabel = role === 'admin' ? 'Admin' : 'Mahasiswa'
  
  return (
    <header className="bg-white h-16 px-4 sm:px-6 lg:px-10 flex items-center justify-between border-b border-slate-200">
      <div className="w-8 lg:w-12" />

      <div className="flex items-center gap-3">
        <div className="flex flex-col text-right">
          <span className="text-sm font-bold text-slate-700">{nama}</span>
          <span className="text-[11px] text-[#2e5299] font-bold">{roleLabel}</span>
        </div>
        <div className="w-9 h-9 rounded-full bg-slate-100 border border-slate-200 shadow-sm"></div>
      </div>
    </header>
  )
}
