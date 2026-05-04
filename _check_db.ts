import { config } from 'dotenv'
config()

import prisma from './src/lib/prisma'

async function main() {
  const tugas = await prisma.penugasan.findMany({
    take: 2,
    include: {
      pekerjaan: {
        include: {
          ruangan: true,
          tipe_pekerjaan: true
        }
      },
      status_tugas: true
    }
  })
  console.log(JSON.stringify(tugas, null, 2))
  await prisma.$disconnect()
}

main()
