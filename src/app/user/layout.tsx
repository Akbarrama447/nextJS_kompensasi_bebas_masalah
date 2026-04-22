import { cookies } from 'next/headers'
import prisma from '@/lib/prisma'
import { LayoutDashboard, BookOpen, FileText } from 'lucide-react'

async function getMahasiswa() {
  const cookieStore = await cookies()
  const nim = cookieStore.get('nim')?.value
  if (!nim) return null
  return await prisma.mahasiswa.findUnique({ where: { nim } })
}

export default async function UserLayout({
  children,
}: {
  children: React.ReactNode;
 }) {
  const mahasiswa = await getMahasiswa()
  const nama = mahasiswa?.nama || 'Guest'
  const nim = mahasiswa?.nim || '-'

  return (
    <div className="min-h-screen bg-gray-100">
      <div className="flex">
        <aside className="w-64 bg-[#172554] min-h-screen">
          <div className="p-4 border-b border-[#1e3a8a]">
            <h1 className="text-xl font-bold text-white">Kompensasi</h1>
          </div>
          <nav className="p-4">
            <ul className="space-y-1">
              <li>
                <a href="/user/dashboard" className="flex items-center gap-3 px-4 py-2 rounded-md text-white font-medium hover:bg-[#1e3a8a]">
                  <LayoutDashboard size={20} />
                  Dashboard
                </a>
              </li>
              <li>
                <a href="/user/ekuivalensi" className="flex items-center gap-3 px-4 py-2 rounded-md text-white font-medium hover:bg-[#1e3a8a]">
                  <BookOpen size={20} />
                  Ekuivalensi
                </a>
              </li>
              <li>
                <a href="/user/laporan" className="flex items-center gap-3 px-4 py-2 rounded-md text-white font-medium hover:bg-[#1e3a8a]">
                  <FileText size={20} />
                  Laporan
                </a>
              </li>
            </ul>
          </nav>
        </aside>
        
        <div className="flex-1">
          <header className="bg-white shadow-sm px-6 py-4 flex justify-between items-center">
            <div></div>
            <div className="flex items-center gap-4">
              <div className="text-right">
                <p className="text-sm font-medium text-gray-900">{nama}</p>
                <p className="text-xs text-gray-500">{nim}</p>
              </div>
              <div className="w-10 h-10 bg-[#1e3a5f] rounded-full flex items-center justify-center text-white font-medium">
                {nama.charAt(0).toUpperCase()}
              </div>
            </div>
          </header>
          
          <main className="p-6">
            {children}
          </main>
        </div>
      </div>
    </div>
  );
}