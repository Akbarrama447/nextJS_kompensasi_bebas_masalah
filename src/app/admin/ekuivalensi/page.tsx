import Sidebar from "@/components/Sidebar";
import ClientPage from "@/app/admin/ekuivalensi/ClientPage";
export default function Page() {
  return (
    <Sidebar role="admin" activePath="/ekuivalensi">
      <ClientPage />
    </Sidebar>
  );
}