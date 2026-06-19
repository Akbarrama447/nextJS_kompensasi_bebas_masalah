import prisma from '@/lib/prisma'
import UsersManagementClient from './UsersManagementClient'

export const dynamic = 'force-dynamic'

export default async function SuperadminUsersPage() {
  // 1. Fetch all users with complete student and staff profile associations
  const users = await prisma.users.findMany({
    include: {
      role: true,
      mahasiswa: {
        include: {
          registrasi_mahasiswa: {
            include: {
              kelas: {
                include: {
                  prodi: {
                    include: {
                      jurisdiction: true
                    }
                  }
                }
              }
            }
          }
        }
      },
      staf: {
        include: {
          jurisdiction: true
        }
      }
    },
    orderBy: {
      user_id: 'desc'
    }
  })

  // 2. Fetch all system roles
  const roles = await prisma.roles.findMany({
    orderBy: {
      id: 'asc'
    }
  })

  // 3. Fetch academic units for filtering and CRUD modals
  const jurusans = await prisma.jurusan.findMany({
    orderBy: {
      nama_jurusan: 'asc'
    }
  })

  const prodis = await prisma.prodi.findMany({
    select: {
      id: true,
      nama_prodi: true,
      jurisdiction_id: true
    },
    orderBy: {
      nama_prodi: 'asc'
    }
  })

  const kelases = await prisma.kelas.findMany({
    select: {
      id: true,
      nama_kelas: true,
      prodi_id: true
    },
    orderBy: {
      nama_kelas: 'asc'
    }
  })

  return (
    <UsersManagementClient
      initialUsers={users}
      roles={roles}
      jurusans={jurusans}
      prodis={prodis}
      kelases={kelases}
    />
  )
}
