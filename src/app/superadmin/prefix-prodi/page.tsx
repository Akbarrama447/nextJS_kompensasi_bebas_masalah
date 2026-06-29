import prisma from '@/lib/prisma'
import PrefixProdiClientPage from './ClientPage'

export const dynamic = 'force-dynamic'

export default async function PrefixProdiPage() {
  const row = await prisma.pengaturan_sistem.findUnique({
    where: { key: 'mapping' },
  })

  const initialMapping: Record<string, string> = row?.value
    ? JSON.parse(row.value)
    : {}

  const prodiList = await prisma.prodi.findMany({
    orderBy: { nama_prodi: 'asc' },
    select: { id: true, nama_prodi: true },
  })

  return (
    <PrefixProdiClientPage
      initialMapping={initialMapping}
      prodiList={prodiList}
    />
  )
}
