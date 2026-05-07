import Sidebar from "@/components/Sidebar";
import ClientPage from "@/app/admin/list_pekerjaan/ClientPage";

export default function Page() {
  return (
    <Sidebar role="admin" activePath="/admin/list_pekerjaan">
      <ClientPage />
    </Sidebar>
  );
}