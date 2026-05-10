import prisma from './src/lib/prisma';
async function run() {
  try {
    const statuses = await prisma.ref_status_ekuivalensi.findMany();
    console.log(JSON.stringify(statuses, null, 2));
  } catch(e) {
    console.error(e);
  } finally {
    process.exit(0);
  }
}
run();
