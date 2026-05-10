import 'dotenv/config';
import prisma from './src/lib/prisma';

async function main() {
    try {
        console.log("Creating function calculate_nominal_total...");
        await prisma.$executeRawUnsafe(`
            CREATE OR REPLACE FUNCTION calculate_nominal_total()
            RETURNS TRIGGER AS $$
            BEGIN
                IF NEW.jam_diakui IS NOT NULL THEN
                    NEW.nominal_total := NEW.jam_diakui * 2000;
                ELSE
                    NEW.nominal_total := 0;
                END IF;
                RETURN NEW;
            END;
            $$ LANGUAGE plpgsql;
        `);

        console.log("Dropping existing trigger if any...");
        await prisma.$executeRawUnsafe(`
            DROP TRIGGER IF EXISTS trigger_calculate_nominal_total ON ekuivalensi_kelas;
        `);

        console.log("Creating new trigger...");
        await prisma.$executeRawUnsafe(`
            CREATE TRIGGER trigger_calculate_nominal_total
            BEFORE INSERT OR UPDATE OF jam_diakui
            ON ekuivalensi_kelas
            FOR EACH ROW
            EXECUTE FUNCTION calculate_nominal_total();
        `);
        
        console.log("Updating existing data to match formula...");
        await prisma.$executeRawUnsafe(`
            UPDATE ekuivalensi_kelas SET nominal_total = COALESCE(jam_diakui, 0) * 2000;
        `);

        console.log("SUCCESS: Trigger created and existing records updated.");
    } catch (error) {
        console.error("FAILED TO CREATE TRIGGER:", error);
    }
}

main().catch(console.error).finally(() => process.exit(0));
