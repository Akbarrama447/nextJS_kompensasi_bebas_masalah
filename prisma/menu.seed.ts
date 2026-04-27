import { PrismaPg } from '@prisma/adapter-pg'
import pg from 'pg'
import { PrismaClient } from '../src/generated/prisma'
const { Pool } = pg
const pool = new Pool({ connectionString: process.env.DATABASE_URL })
const adapter = new PrismaPg(pool)
const prisma = new PrismaClient({ adapter })
async function main() {
  console.log('Updating menus...')
  
  const menusData = [
    { key: 'dashboard', label: 'Dashboard', icon: 'LayoutDashboard', path: '/user/dashboard', urutan: 1 },
    { key: 'pekerjaan', label: 'List Pekerjaan', icon: 'Briefcase', path: '/user/pekerjaan', urutan: 2 },
    { key: 'ekuivalensi', label: 'Ekuivalensi', icon: 'BookOpen', path: '/user/ekuivalensi', urutan: 3 },
  ]
  
  for (const menu of menusData) {
    await prisma.menus.upsert({
      where: { key: menu.key },
      update: { label: menu.label, icon: menu.icon, path: menu.path, urutan: menu.urutan },
      create: { key: menu.key, label: menu.label, icon: menu.icon, path: menu.path, urutan: menu.urutan },
    })
    console.log(`Updated: ${menu.label}`)
  }
  
  console.log('Done!')
}
main()
  .catch((e) => {
    console.error('Error:', e.message)
    process.exit(1)
  })
  .finally(async () => {
    await prisma.$disconnect()
    await pool.end()
  })