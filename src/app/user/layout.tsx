import Sidebar from '@/components/Sidebar'

export default async function UserLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return <Sidebar role="mahasiswa" activePath="/user/dashboard">{children}</Sidebar>
}