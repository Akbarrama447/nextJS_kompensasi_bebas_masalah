import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'
import { PrismaClient } from '../src/generated/prisma'
import { hash } from 'bcryptjs'

const { Pool } = pg
const pool = new Pool({ connectionString: process.env.DATABASE_URL })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

const testAccounts = [
  { nim: '2372001', password: '2372001', nama: 'Test User 2372001' },
]

async function main() {
  console.log('Seeding test student accounts...')

  for (const account of testAccounts) {
    try {
      // Check if user already exists
      const existingMahasiswa = await prisma.mahasiswa.findUnique({
        where: { nim: account.nim },
        include: { user: true },
      })

      if (existingMahasiswa?.user) {
        console.log(`✓ User ${account.nim} already exists, skipping...`)
        continue
      }

      // Hash password
      const hashedPassword = await hash(account.password, 10)

      // Create user
      const user = await prisma.users.create({
        data: {
          email: `${account.nim}@student.polnes.ac.id`,
          kata_sandi: hashedPassword,
        },
      })

      // Get first class (if available)
      const kelas = await prisma.kelas.findFirst()

      // Create mahasiswa
      await prisma.mahasiswa.upsert({
        where: { nim: account.nim },
        update: { user_id: user.user_id, nama: account.nama },
        create: {
          nim: account.nim,
          user_id: user.user_id,
          nama: account.nama,
          kelas_id: kelas?.id,
        },
      })

      console.log(
        `✓ Created: ${account.nim} (${account.nama}) | Password: ${account.password}`,
      )
    } catch (error) {
      console.error(`✗ Error creating ${account.nim}:`, error instanceof Error ? error.message : error)
    }
  }

  console.log('✓ Seeding completed!')
}

main()
  .catch((e) => {
    console.error('Error:', e)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
    await pool.end()
  })