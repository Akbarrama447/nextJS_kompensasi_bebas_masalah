import Sidebar from "@/components/Sidebar";
import ClientPage from "@/app/admin/ekuivalen/ClientPage";
export default function Page() {
  return (
    <Sidebar role="admin" activePath="/ekuivalen">
      <ClientPage />
    </Sidebar>
  );
}