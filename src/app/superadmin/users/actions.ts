'use server'

import prisma from '@/lib/prisma'
import bcrypt from 'bcryptjs'
import { revalidatePath } from 'next/cache'

/**
 * Get active semester ID
 */
async function getActiveSemesterId() {
  const sem = await prisma.semester.findFirst({
    where: { is_aktif: true },
    select: { id: true }
  })
  if (sem) return sem.id
  const first = await prisma.semester.findFirst({
    select: { id: true },
    orderBy: { id: 'asc' }
  })
  return first ? first.id : null
}

/**
 * Create a new user account and profile (Mahasiswa or Staf)
 */
export async function createUser(data: {
  email: string
  kataSandi: string
  roleId: number
  nama: string
  nimOrNip?: string
  jurusanId?: number
  prodiId?: number
  kelasId?: number
}) {
  try {
    const { email, kataSandi, roleId, nama, nimOrNip, jurusanId, kelasId } = data

    if (!email || !kataSandi || !roleId || !nama) {
      return { success: false, error: 'Email, Kata Sandi, Role, dan Nama wajib diisi!' }
    }

    // 1. Check if email already exists
    const existingUser = await prisma.users.findUnique({
      where: { email }
    })
    if (existingUser) {
      return { success: false, error: 'Email sudah terdaftar di sistem!' }
    }

    // 2. Fetch selected role
    const roleObj = await prisma.roles.findUnique({
      where: { id: roleId }
    })
    if (!roleObj) {
      return { success: false, error: 'Role yang dipilih tidak valid!' }
    }

    const roleName = roleObj.nama?.toLowerCase() || ''

    // 3. Perform specific validation based on Role
    if (roleName === 'mahasiswa') {
      if (!nimOrNip) {
        return { success: false, error: 'NIM wajib diisi untuk role Mahasiswa!' }
      }
      const existingMhs = await prisma.mahasiswa.findUnique({
        where: { nim: nimOrNip }
      })
      if (existingMhs) {
        return { success: false, error: `Mahasiswa dengan NIM ${nimOrNip} sudah ada!` }
      }
    } else if (roleName === 'admin' || roleName === 'staf') {
      if (!nimOrNip) {
        return { success: false, error: 'NIP wajib diisi untuk role Admin/Staf!' }
      }
      const existingStaf = await prisma.staf.findUnique({
        where: { nip: nimOrNip }
      })
      if (existingStaf) {
        return { success: false, error: `Staf dengan NIP ${nimOrNip} sudah ada!` }
      }
    }

    // 4. Hash password
    const hashedPassword = await bcrypt.hash(kataSandi, 10)

    // 5. Create user and profile in transaction
    await prisma.$transaction(async (tx) => {
      // a. Create User credentials
      const newUser = await tx.users.create({
        data: {
          email,
          kata_sandi: hashedPassword,
          role_id: roleId
        }
      })

      // b. Create specific profile
      if (roleName === 'mahasiswa') {
        await tx.mahasiswa.create({
          data: {
            nim: nimOrNip!,
            nama,
            user_id: newUser.user_id
          }
        })

        // Save class registration for active semester if selected
        const semId = await getActiveSemesterId()
        if (kelasId && semId) {
          await tx.registrasi_mahasiswa.create({
            data: {
              nim: nimOrNip!,
              semester_id: semId,
              kelas_id: kelasId,
              status: 'Aktif'
            }
          })

          // Auto-provision initial zero hours for kompen_awal
          await tx.kompen_awal.create({
            data: {
              nim: nimOrNip!,
              semester_id: semId,
              total_jam_wajib: 0
            }
          })
        }
      } else if (roleName === 'admin' || roleName === 'staf' || roleName === 'superadmin') {
        // If superadmin but no NIP, create NIP as fallback to prevent schema issues
        const finalNip = nimOrNip || `SA_${Date.now()}`
        await tx.staf.create({
          data: {
            nip: finalNip,
            nama,
            user_id: newUser.user_id,
            jurisdiction_id: jurusanId || null,
            tipe_staf: roleName === 'superadmin' ? 'superadmin' : 'admin'
          }
        })
      }
    })

    revalidatePath('/superadmin/users')
    return { success: true, message: 'User baru berhasil ditambahkan!' }
  } catch (error: any) {
    console.error('Error in createUser server action:', error)
    return { success: false, error: error.message || 'Gagal menambahkan user' }
  }
}

/**
 * Update an existing user account and profile details
 */
export async function updateUser(data: {
  userId: number
  email: string
  kataSandi?: string
  roleId: number
  nama: string
  nimOrNip?: string
  jurusanId?: number
  prodiId?: number
  kelasId?: number
}) {
  try {
    const { userId, email, kataSandi, roleId, nama, nimOrNip, jurusanId, kelasId } = data

    if (!userId || !email || !roleId || !nama) {
      return { success: false, error: 'User ID, Email, Role, dan Nama wajib diisi!' }
    }

    // 1. Fetch current user data
    const currentUser = await prisma.users.findUnique({
      where: { user_id: userId },
      include: { role: true, mahasiswa: true, staf: true }
    })
    if (!currentUser) {
      return { success: false, error: 'User tidak ditemukan!' }
    }

    // 2. Fetch role details
    const roleObj = await prisma.roles.findUnique({
      where: { id: roleId }
    })
    if (!roleObj) {
      return { success: false, error: 'Role tidak valid!' }
    }
    const roleName = roleObj.nama?.toLowerCase() || ''

    // 3. Prepare hashed password if provided
    let hashedPassword = currentUser.kata_sandi
    if (kataSandi && kataSandi.trim() !== '') {
      hashedPassword = await bcrypt.hash(kataSandi, 10)
    }

    // 4. Update in transaction to preserve integrity
    await prisma.$transaction(async (tx) => {
      // a. Update login credentials
      await tx.users.update({
        where: { user_id: userId },
        data: {
          email,
          kata_sandi: hashedPassword,
          role_id: roleId
        }
      })

      const wasMahasiswa = currentUser.role?.nama?.toLowerCase() === 'mahasiswa'
      const isMahasiswa = roleName === 'mahasiswa'

      // Case A: Role changed from Staf/Superadmin -> Mahasiswa
      if (!wasMahasiswa && isMahasiswa) {
        if (!nimOrNip) throw new Error('NIM wajib diisi untuk Mahasiswa!')
        
        // Remove old staf profile if any
        if (currentUser.staf) {
          await tx.staf.delete({ where: { nip: currentUser.staf.nip } })
        }

        // Create new student profile
        await tx.mahasiswa.create({
          data: {
            nim: nimOrNip,
            nama,
            user_id: userId
          }
        })

        // Create class registration
        const semId = await getActiveSemesterId()
        if (kelasId && semId) {
          await tx.registrasi_mahasiswa.create({
            data: {
              nim: nimOrNip,
              semester_id: semId,
              kelas_id: kelasId,
              status: 'Aktif'
            }
          })
        }
      }
      // Case B: Role changed from Mahasiswa -> Staf/Superadmin/Admin
      else if (wasMahasiswa && !isMahasiswa) {
        const finalNip = nimOrNip || `STAF_${userId}`
        
        // Safe cascading delete for student relations
        if (currentUser.mahasiswa) {
          const nim = currentUser.mahasiswa.nim
          await tx.log_potong_jam.deleteMany({ where: { nim } })
          await tx.penugasan.deleteMany({ where: { nim } })
          await tx.ekuivalensi_kelas.deleteMany({ where: { penanggung_jawab_nim: nim } })
          await tx.kompen_awal.deleteMany({ where: { nim } })
          await tx.registrasi_mahasiswa.deleteMany({ where: { nim } })
          await tx.mahasiswa.delete({ where: { nim } })
        }

        // Create new Staf profile
        await tx.staf.create({
          data: {
            nip: finalNip,
            nama,
            user_id: userId,
            jurisdiction_id: jurusanId || null,
            tipe_staf: roleName === 'superadmin' ? 'superadmin' : 'admin'
          }
        })
      }
      // Case C: Role remained Mahasiswa (Just update fields)
      else if (wasMahasiswa && isMahasiswa) {
        const oldNim = currentUser.mahasiswa!.nim
        const newNim = nimOrNip || oldNim

        // Update Mahasiswa name and handle NIM update
        if (oldNim !== newNim) {
          // Verify new NIM isn't taken
          const taken = await tx.mahasiswa.findUnique({ where: { nim: newNim } })
          if (taken) throw new Error(`NIM ${newNim} sudah digunakan oleh mahasiswa lain!`)

          // Create new record, migrate relations, and delete old one
          await tx.mahasiswa.create({
            data: {
              nim: newNim,
              nama,
              user_id: userId
            }
          })

          // Migrate class registrations
          await tx.registrasi_mahasiswa.updateMany({
            where: { nim: oldNim },
            data: { nim: newNim }
          })
          
          // Migrate kompen
          await tx.kompen_awal.updateMany({
            where: { nim: oldNim },
            data: { nim: newNim }
          })

          // Migrate other tables
          await tx.penugasan.updateMany({ where: { nim: oldNim }, data: { nim: newNim } })
          await tx.log_potong_jam.updateMany({ where: { nim: oldNim }, data: { nim: newNim } })
          await tx.ekuivalensi_kelas.updateMany({ where: { penanggung_jawab_nim: oldNim }, data: { penanggung_jawab_nim: newNim } })

          // Delete old profile
          await tx.mahasiswa.delete({ where: { nim: oldNim } })
        } else {
          await tx.mahasiswa.update({
            where: { nim: oldNim },
            data: { nama }
          })
        }

        // Update class registration for active semester
        const semId = await getActiveSemesterId()
        if (kelasId && semId) {
          const reg = await tx.registrasi_mahasiswa.findFirst({
            where: { nim: newNim, semester_id: semId }
          })
          if (reg) {
            await tx.registrasi_mahasiswa.update({
              where: { id: reg.id },
              data: { kelas_id: kelasId }
            })
          } else {
            await tx.registrasi_mahasiswa.create({
              data: {
                nim: newNim,
                semester_id: semId,
                kelas_id: kelasId,
                status: 'Aktif'
              }
            })
          }
        }
      }
      // Case D: Role remained Staf/Admin/Superadmin (Just update fields)
      else {
        if (currentUser.staf) {
          const oldNip = currentUser.staf.nip
          const newNip = nimOrNip || oldNip

          if (oldNip !== newNip) {
            const taken = await tx.staf.findUnique({ where: { nip: newNip } })
            if (taken) throw new Error(`NIP ${newNip} sudah digunakan oleh staf lain!`)

            // Create new Staf and migrate relations
            await tx.staf.create({
              data: {
                nip: newNip,
                nama,
                user_id: userId,
                jurisdiction_id: jurusanId || null,
                tipe_staf: roleName === 'superadmin' ? 'superadmin' : 'admin'
              }
            })

            // Migrate tasks & logs verifier
            await tx.penugasan.updateMany({ where: { diverifikasi_oleh_nip: oldNip }, data: { diverifikasi_oleh_nip: newNip } })
            await tx.import_log.updateMany({ where: { staf_nip: oldNip }, data: { staf_nip: newNip } })
            await tx.ekuivalensi_kelas.updateMany({ where: { verified_by_nip: oldNip }, data: { verified_by_nip: newNip } })
            await tx.daftar_pekerjaan.updateMany({ where: { staf_nip: oldNip }, data: { staf_nip: newNip } })

            // Delete old profile
            await tx.staf.delete({ where: { nip: oldNip } })
          } else {
            await tx.staf.update({
              where: { nip: oldNip },
              data: {
                nama,
                jurisdiction_id: jurusanId || null,
                tipe_staf: roleName === 'superadmin' ? 'superadmin' : 'admin'
              }
            })
          }
        } else {
          // If no staff profile exists but the user is superadmin/admin/staf, safely provision it
          const finalNip = nimOrNip || `STAF_${userId}`
          await tx.staf.create({
            data: {
              nip: finalNip,
              nama,
              user_id: userId,
              jurisdiction_id: jurusanId || null,
              tipe_staf: roleName === 'superadmin' ? 'superadmin' : 'admin'
            }
          })
        }
      }
    })

    revalidatePath('/superadmin/users')
    return { success: true, message: 'Data user berhasil diperbarui!' }
  } catch (error: any) {
    console.error('Error in updateUser server action:', error)
    return { success: false, error: error.message || 'Gagal memperbarui user' }
  }
}

/**
 * Safely delete user credentials and cascaded profile associations
 */
export async function deleteUser(userId: number) {
  try {
    if (!userId) {
      return { success: false, error: 'User ID wajib dicantumkan!' }
    }

    // 1. Fetch user to identify profile type
    const user = await prisma.users.findUnique({
      where: { user_id: userId },
      include: { mahasiswa: true, staf: true }
    })

    if (!user) {
      return { success: false, error: 'User tidak ditemukan!' }
    }

    // 2. Perform cascading deletion in transaction
    await prisma.$transaction(async (tx) => {
      // A. Delete Student Associations
      if (user.mahasiswa) {
        const nim = user.mahasiswa.nim
        await tx.log_potong_jam.deleteMany({ where: { nim } })
        await tx.penugasan.deleteMany({ where: { nim } })
        await tx.ekuivalensi_kelas.deleteMany({ where: { penanggung_jawab_nim: nim } })
        await tx.kompen_awal.deleteMany({ where: { nim } })
        await tx.registrasi_mahasiswa.deleteMany({ where: { nim } })
        await tx.mahasiswa.delete({ where: { nim } })
      }

      // B. Delete Staff Associations
      if (user.staf) {
        const nip = user.staf.nip
        // Nullify reference or safe delete logs
        await tx.penugasan.updateMany({ where: { diverifikasi_oleh_nip: nip }, data: { diverifikasi_oleh_nip: null } })
        await tx.ekuivalensi_kelas.updateMany({ where: { verified_by_nip: nip }, data: { verified_by_nip: null } })
        await tx.import_log.deleteMany({ where: { staf_nip: nip } })
        await tx.daftar_pekerjaan.deleteMany({ where: { staf_nip: nip } })
        await tx.staf.delete({ where: { nip } })
      }

      // C. Delete parent User
      await tx.users.delete({
        where: { user_id: userId }
      })
    })

    revalidatePath('/superadmin/users')
    return { success: true, message: 'User berhasil dihapus secara permanen!' }
  } catch (error: any) {
    console.error('Error in deleteUser server action:', error)
    return { success: false, error: error.message || 'Gagal menghapus user' }
  }
}
