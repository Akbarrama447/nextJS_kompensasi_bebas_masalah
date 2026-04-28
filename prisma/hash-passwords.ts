import { hash } from 'bcryptjs'
import { PrismaClient } from '@/generated/prisma'
import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'
import dotenv from 'dotenv'

dotenv.config({ path: '../.env' })

const { Pool } = pg

const connectionString = process.env.DATABASE_URL || 'postgresql://postgres:123@localhost:5432/kompen'

const pool = new Pool({ connectionString })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

async function main() {
  const users = await prisma.users.findMany()
  
  for (const user of users) {
     if (user.kata_sandi && !/^\$2[aby]\$/.test(user.kata_sandi)) {
      const hashed = await hash(user.kata_sandi, 10)
      await prisma.users.update({
        where: { user_id: user.user_id },
        data: { kata_sandi: hashed },
      })
      console.log(`Hashed password for user: ${user.username || user.user_id}`)
    }
  }
  
  console.log('All passwords hashed successfully!')
}

main()
  .catch(console.error)
  .finally(() => prisma.$disconnect())
