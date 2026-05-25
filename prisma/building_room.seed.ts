import { PrismaClient } from '../src/generated/prisma'
import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'
import dotenv from 'dotenv'

dotenv.config({ path: '.env' })

const { Pool } = pg
const pool = new Pool({ connectionString: process.env.DATABASE_URL })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })

async function main() {
  console.log('🌱 Seeding Gedung and Ruangan...')

  const gedungData = [
    { nama_gedung: 'SB 1' },
    { nama_gedung: 'SB 2' },
    { nama_gedung: 'SA 1' },
    { nama_gedung: 'SA 2' },
  ]

  const roomsInSB2 = [
    { nama_ruangan: 'Jaringan Komputer', kode_ruangan: 'SB2-JK' },
    { nama_ruangan: 'Multimedia', kode_ruangan: 'SB2-MM' },
    { nama_ruangan: 'Server', kode_ruangan: 'SB2-SRV' },
    { nama_ruangan: 'Mushola', kode_ruangan: 'SB2-MSH' },
    { nama_ruangan: 'Pemrograman', kode_ruangan: 'SB2-PRG' },
  ]

  try {
    // 1. Seed Gedung
    console.log('  Creating buildings...')
    const upsertedGedung = await Promise.all(
      gedungData.map((g) =>
        prisma.gedung.upsert({
          where: { id: 0 }, // This is a trick because we don't have unique constraint on nama_gedung in schema, but for seeding we can findFirst then upsert
          update: {},
          create: g,
        }).catch(async () => {
             // Fallback if upsert with id 0 fails (which it will if we don't know the ID)
             const existing = await prisma.gedung.findFirst({ where: { nama_gedung: g.nama_gedung } });
             if (existing) return existing;
             return prisma.gedung.create({ data: g });
        })
      )
    )

    const sb2Gedung = upsertedGedung.find((g) => g.nama_gedung === 'SB 2')

    if (sb2Gedung) {
      console.log(`  ✓ Found Gedung: ${sb2Gedung.nama_gedung} (ID: ${sb2Gedung.id})`)
      
      // 2. Seed Ruangan for SB 2
      console.log('  Creating rooms for SB 2...')
      for (const room of roomsInSB2) {
        const existingRoom = await prisma.ruangan.findFirst({
          where: { 
            nama_ruangan: room.nama_ruangan,
            gedung_id: sb2Gedung.id
          }
        })

        if (!existingRoom) {
          await prisma.ruangan.create({
            data: {
              ...room,
              gedung_id: sb2Gedung.id
            }
          })
          console.log(`    ✓ Created Ruangan: ${room.nama_ruangan}`)
        } else {
          console.log(`    - Ruangan already exists: ${room.nama_ruangan}`)
        }
      }
    }

    console.log('✅ Seeding Gedung and Ruangan completed!')
  } catch (error) {
    console.error('❌ Error seeding:', error)
  } finally {
    await prisma.$disconnect()
    await pool.end()
  }
}

main()
