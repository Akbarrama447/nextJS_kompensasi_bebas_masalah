import Sidebar from "@/components/Sidebar";
import ClientPage from "@/app/admin/list_pekerjaan/ClientPage";

export default function Page() {
  return (
    <Sidebar role="admin" activePath="/list-pekerjaan">
      <ClientPage />
    </Sidebar>
  );
}