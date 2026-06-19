'use server'

import prisma from '@/lib/prisma'
import bcrypt from 'bcryptjs'
import { revalidatePath } from 'next/cache'
import { requireSuperadmin } from '@/lib/session'
import { logAudit } from '@/lib/audit'

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
    const session = await requireSuperadmin()

    const { email, kataSandi, roleId, nama, nimOrNip, jurusanId, kelasId } = data

    if (!email || !kataSandi || !roleId || !nama) {
      return { success: false, error: 'Email, Kata Sandi, Role, dan Nama wajib diisi!' }
    }

    const existingUser = await prisma.users.findUnique({
      where: { email }
    })
    if (existingUser) {
      return { success: false, error: 'Email sudah terdaftar di sistem!' }
    }

    const roleObj = await prisma.roles.findUnique({
      where: { id: roleId }
    })
    if (!roleObj) {
      return { success: false, error: 'Role yang dipilih tidak valid!' }
    }

    const roleName = roleObj.nama?.toLowerCase() || ''

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

    const hashedPassword = await bcrypt.hash(kataSandi, 10)

    await prisma.$transaction(async (tx) => {
      const newUser = await tx.users.create({
        data: {
          email,
          kata_sandi: hashedPassword,
          role_id: roleId
        }
      })

      if (roleName === 'mahasiswa') {
        await tx.mahasiswa.create({
          data: {
            nim: nimOrNip!,
            nama,
            user_id: newUser.user_id
          }
        })

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

          await tx.kompen_awal.create({
            data: {
              nim: nimOrNip!,
              semester_id: semId,
              total_jam_wajib: 0
            }
          })
        }
      } else if (roleName === 'admin' || roleName === 'staf' || roleName === 'superadmin') {
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

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'CREATE_USER',
      target: email,
      detail: { role: roleName, nama, nimOrNip },
    })

    revalidatePath('/superadmin/users')
    return { success: true, message: 'User baru berhasil ditambahkan!' }
  } catch (error: any) {
    console.error('Error in createUser server action:', error)
    return { success: false, error: error.message || 'Gagal menambahkan user' }
  }
}

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
    const session = await requireSuperadmin()

    const { userId, email, kataSandi, roleId, nama, nimOrNip, jurusanId, kelasId } = data

    if (!userId || !email || !roleId || !nama) {
      return { success: false, error: 'User ID, Email, Role, dan Nama wajib diisi!' }
    }

    const currentUser = await prisma.users.findUnique({
      where: { user_id: userId },
      include: { role: true, mahasiswa: true, staf: true }
    })
    if (!currentUser) {
      return { success: false, error: 'User tidak ditemukan!' }
    }

    const roleObj = await prisma.roles.findUnique({
      where: { id: roleId }
    })
    if (!roleObj) {
      return { success: false, error: 'Role tidak valid!' }
    }
    const roleName = roleObj.nama?.toLowerCase() || ''

    let hashedPassword = currentUser.kata_sandi
    if (kataSandi && kataSandi.trim() !== '') {
      hashedPassword = await bcrypt.hash(kataSandi, 10)
    }

    await prisma.$transaction(async (tx) => {
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

      if (!wasMahasiswa && isMahasiswa) {
        if (!nimOrNip) throw new Error('NIM wajib diisi untuk Mahasiswa!')

        if (currentUser.staf) {
          await tx.staf.delete({ where: { nip: currentUser.staf.nip } })
        }

        await tx.mahasiswa.create({
          data: {
            nim: nimOrNip,
            nama,
            user_id: userId
          }
        })

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
      } else if (wasMahasiswa && !isMahasiswa) {
        const finalNip = nimOrNip || `STAF_${userId}`

        if (currentUser.mahasiswa) {
          const nim = currentUser.mahasiswa.nim
          await tx.log_potong_jam.deleteMany({ where: { nim } })
          await tx.penugasan.deleteMany({ where: { nim } })
          await tx.ekuivalensi_kelas.deleteMany({ where: { penanggung_jawab_nim: nim } })
          await tx.kompen_awal.deleteMany({ where: { nim } })
          await tx.registrasi_mahasiswa.deleteMany({ where: { nim } })
          await tx.mahasiswa.delete({ where: { nim } })
        }

        await tx.staf.create({
          data: {
            nip: finalNip,
            nama,
            user_id: userId,
            jurisdiction_id: jurusanId || null,
            tipe_staf: roleName === 'superadmin' ? 'superadmin' : 'admin'
          }
        })
      } else if (wasMahasiswa && isMahasiswa) {
        const oldNim = currentUser.mahasiswa!.nim
        const newNim = nimOrNip || oldNim

        if (oldNim !== newNim) {
          const taken = await tx.mahasiswa.findUnique({ where: { nim: newNim } })
          if (taken) throw new Error(`NIM ${newNim} sudah digunakan oleh mahasiswa lain!`)

          await tx.mahasiswa.create({
            data: {
              nim: newNim,
              nama,
              user_id: userId
            }
          })

          await tx.registrasi_mahasiswa.updateMany({
            where: { nim: oldNim },
            data: { nim: newNim }
          })

          await tx.kompen_awal.updateMany({
            where: { nim: oldNim },
            data: { nim: newNim }
          })

          await tx.penugasan.updateMany({ where: { nim: oldNim }, data: { nim: newNim } })
          await tx.log_potong_jam.updateMany({ where: { nim: oldNim }, data: { nim: newNim } })
          await tx.ekuivalensi_kelas.updateMany({ where: { penanggung_jawab_nim: oldNim }, data: { penanggung_jawab_nim: newNim } })

          await tx.mahasiswa.delete({ where: { nim: oldNim } })
        } else {
          await tx.mahasiswa.update({
            where: { nim: oldNim },
            data: { nama }
          })
        }

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
      } else {
        if (currentUser.staf) {
          const oldNip = currentUser.staf.nip
          const newNip = nimOrNip || oldNip

          if (oldNip !== newNip) {
            const taken = await tx.staf.findUnique({ where: { nip: newNip } })
            if (taken) throw new Error(`NIP ${newNip} sudah digunakan oleh staf lain!`)

            await tx.staf.create({
              data: {
                nip: newNip,
                nama,
                user_id: userId,
                jurisdiction_id: jurusanId || null,
                tipe_staf: roleName === 'superadmin' ? 'superadmin' : 'admin'
              }
            })

            await tx.penugasan.updateMany({ where: { diverifikasi_oleh_nip: oldNip }, data: { diverifikasi_oleh_nip: newNip } })
            await tx.import_log.updateMany({ where: { staf_nip: oldNip }, data: { staf_nip: newNip } })
            await tx.ekuivalensi_kelas.updateMany({ where: { verified_by_nip: oldNip }, data: { verified_by_nip: newNip } })
            await tx.daftar_pekerjaan.updateMany({ where: { staf_nip: oldNip }, data: { staf_nip: newNip } })

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

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'UPDATE_USER',
      target: email,
      detail: { userId, newRole: roleName, nama },
    })

    revalidatePath('/superadmin/users')
    return { success: true, message: 'Data user berhasil diperbarui!' }
  } catch (error: any) {
    console.error('Error in updateUser server action:', error)
    return { success: false, error: error.message || 'Gagal memperbarui user' }
  }
}

export async function deleteUser(userId: number) {
  try {
    const session = await requireSuperadmin()

    if (!userId) {
      return { success: false, error: 'User ID wajib dicantumkan!' }
    }

    const user = await prisma.users.findUnique({
      where: { user_id: userId },
      include: { mahasiswa: true, staf: true }
    })

    if (!user) {
      return { success: false, error: 'User tidak ditemukan!' }
    }

    const targetName = user.mahasiswa?.nama || user.staf?.nama || user.email || `user_${userId}`

    await prisma.$transaction(async (tx) => {
      if (user.mahasiswa) {
        const nim = user.mahasiswa.nim
        await tx.log_potong_jam.deleteMany({ where: { nim } })
        await tx.penugasan.deleteMany({ where: { nim } })
        await tx.ekuivalensi_kelas.deleteMany({ where: { penanggung_jawab_nim: nim } })
        await tx.kompen_awal.deleteMany({ where: { nim } })
        await tx.registrasi_mahasiswa.deleteMany({ where: { nim } })
        await tx.mahasiswa.delete({ where: { nim } })
      }

      if (user.staf) {
        const nip = user.staf.nip
        await tx.penugasan.updateMany({ where: { diverifikasi_oleh_nip: nip }, data: { diverifikasi_oleh_nip: null } })
        await tx.ekuivalensi_kelas.updateMany({ where: { verified_by_nip: nip }, data: { verified_by_nip: null } })
        await tx.import_log.deleteMany({ where: { staf_nip: nip } })
        await tx.daftar_pekerjaan.deleteMany({ where: { staf_nip: nip } })
        await tx.staf.delete({ where: { nip } })
      }

      await tx.users.delete({
        where: { user_id: userId }
      })
    })

    await logAudit({
      actorNip: session.identifier,
      actorNama: session.nama,
      aksi: 'DELETE_USER',
      target: targetName,
      detail: { userId, email: user.email },
    })

    revalidatePath('/superadmin/users')
    return { success: true, message: 'User berhasil dihapus secara permanen!' }
  } catch (error: any) {
    console.error('Error in deleteUser server action:', error)
    return { success: false, error: error.message || 'Gagal menghapus user' }
  }
}
