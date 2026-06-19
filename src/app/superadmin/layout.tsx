import Sidebar from '@/components/Sidebar'

export default function SuperadminLayout({
  children,
}: {
  children: React.ReactNode
}) {
  return (
    <Sidebar role="superadmin" activePath="/superadmin/dashboard">
      {children}
    </Sidebar>
  )
}
