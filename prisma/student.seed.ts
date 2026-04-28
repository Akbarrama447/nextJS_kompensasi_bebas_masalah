import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'
import { PrismaClient } from '../src/generated/prisma'
import { hash } from 'bcryptjs'

const { Pool } = pg
const pool = new Pool({ connectionString: process.env.DATABASE_URL })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

const NIM = '2372001'

async function main() {
  const hashedPassword = await hash(NIM, 10)

  const user = await prisma.users.create({
    data: {
      email: `${NIM}@student.polnes.ac.id`,
      kata_sandi: hashedPassword,
    },
  })

  const kelas = await prisma.kelas.findFirst()
  
  await prisma.mahasiswa.create({
    data: {
      nim: NIM,
      user_id: user.user_id,
      nama: 'Akbar Testing',
      kelas_id: kelas?.id,
    },
  })

  console.log(`Created user: ${NIM} / password: ${NIM}`)
}

main()
  .catch(console.error)
  .finally(async () => {
    await prisma.$disconnect()
    await pool.end()
  })