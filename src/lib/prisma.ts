import { PrismaClient, Prisma } from '@/generated/prisma'
import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'

const { Pool } = pg

// Use DIRECT_URL first (bypasses pgBouncer in Supabase dev environment)
// Falls back to DATABASE_URL (for VPS production with direct PostgreSQL)
const connectionString = process.env.DIRECT_URL || process.env.DATABASE_URL

function createPrismaClient() {
  const pool = new Pool({ connectionString })
  const adapter = new PrismaPg(pool)
  return new PrismaClient({ adapter })
}

const prisma = createPrismaClient()

export { Prisma }
export default prisma