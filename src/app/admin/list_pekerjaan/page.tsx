import Sidebar from "@/components/Sidebar";
import SidebarLayout from "@/components/SidebarLayout";
import ClientPage from "@/app/admin/list_pekerjaan/ClientPage";

export default function Page() {
  return (
    <SidebarLayout
      sidebar={<Sidebar role="admin" activePath="/admin/list_pekerjaan" />}
    >
      <ClientPage />
    </SidebarLayout>
  );
}