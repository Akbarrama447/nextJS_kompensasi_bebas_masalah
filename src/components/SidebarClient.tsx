"use client";

import { useState, useEffect } from "react";
import * as Icons from "lucide-react";
import Link from "next/link";
import { usePathname } from "next/navigation";
import { LogOut, ChevronLeft, ChevronRight, Menu, X, LucideIcon } from "lucide-react";

interface MenuType {
  id: number;
  key: string | null;
  label: string | null;
  icon: string | null;
  path: string;
  urutan: number | null;
}

interface SidebarClientProps {
  role: "mahasiswa" | "admin" | "superadmin";
  activePath: string;
  nama: string;
  menus: MenuType[];
  id: string;
  children: React.ReactNode;
}

export default function SidebarClient({
  role,
  activePath: initialActivePath,
  nama,
  menus,
  id,
  children,
}: SidebarClientProps) {
  const pathname = usePathname();
  const activePath = pathname || initialActivePath;
  const [isCollapsed, setIsCollapsed] = useState(false);
  const [isMobileOpen, setIsMobileOpen] = useState(false);

  // Persistence for collapse state
  useEffect(() => {
    const saved = localStorage.getItem("sidebar-collapsed");
    if (saved) {
      setIsCollapsed(saved === "true");
    }
  }, []);

  const toggleCollapse = () => {
    setIsCollapsed((prev) => {
      const next = !prev;
      localStorage.setItem("sidebar-collapsed", String(next));
      return next;
    });
  };

  const renderMenuIcon = (iconName: string) => {
    if (!iconName) return <Icons.Circle size={20} />;

    if (iconName.match(/\.(png|jpg|svg)$/i)) {
      return <img src={`/${iconName}`} alt="" className="w-5 h-5 object-contain" />;
    }

    const Icon = Icons[iconName as keyof typeof Icons] as LucideIcon;
    if (Icon) return <Icon size={20} />;

    return <Icons.Circle size={20} />;
  };

  // Helper to determine path by role
  const getHref = (menu: MenuType) => {
    let href = menu.path;
    if (role === "admin") {
      if (menu.key === "pekerjaan") {
        href = "/admin/list_pekerjaan";
      } else {
        href = menu.path.replace("/user/", "/admin/");
      }
    }
    return href;
  };

  return (
    <div className="flex flex-col md:flex-row min-h-screen bg-[#f1f5f9] font-sans antialiased text-slate-900">
      
      {/* MOBILE TOP BAR */}
      <div className="flex md:hidden items-center justify-between bg-[#2e5299] text-white px-5 py-4 sticky top-0 z-30 shadow-md w-full">
        <div className="flex items-center gap-2">
          <img src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png" alt="Logo" className="w-6 h-6 object-contain" />
          <div className="flex flex-col">
            <span className="text-xs font-semibold leading-none">Sistem</span>
            <span className="text-xs font-semibold leading-tight">Kompen</span>
          </div>
        </div>
        <button
          onClick={() => setIsMobileOpen(true)}
          className="p-1.5 hover:bg-white/10 rounded-lg transition-colors focus:outline-none"
        >
          <Menu size={22} />
        </button>
      </div>

      {/* MOBILE DRAWER OVERLAY */}
      {isMobileOpen && (
        <div
          onClick={() => setIsMobileOpen(false)}
          className="fixed inset-0 bg-black/40 backdrop-blur-xs z-40 md:hidden animate-in fade-in duration-200"
        />
      )}

      {/* MOBILE DRAWER */}
      <aside
        className={`fixed top-0 bottom-0 left-0 w-64 bg-[#2e5299] text-white z-50 flex flex-col shadow-2xl md:hidden transition-transform duration-300 ease-out ${
          isMobileOpen ? "translate-x-0" : "-translate-x-full"
        }`}
      >
        <div className="flex items-center justify-between p-6 border-b border-white/10">
          <div className="flex items-center gap-2.5">
            <img src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png" alt="Logo" className="w-6 h-6 object-contain" />
            <div className="flex flex-col">
              <span className="text-base font-semibold leading-none">Sistem</span>
              <span className="text-base font-semibold leading-tight">Kompen</span>
            </div>
          </div>
          <button
            onClick={() => setIsMobileOpen(false)}
            className="p-1.5 hover:bg-white/10 rounded-lg text-white/80 hover:text-white transition-colors"
          >
            <X size={20} />
          </button>
        </div>

        <nav className="flex-1 py-4">
          <ul className="space-y-1">
            {menus.map((menu) => {
              const href = getHref(menu);
              const isActive =
                activePath === href ||
                activePath === menu.path ||
                activePath.startsWith(menu.path + "/") ||
                (menu.key && activePath.includes(menu.key));

              return (
                <li key={menu.id}>
                  <Link href={href} onClick={() => setIsMobileOpen(false)}>
                    <div
                      className={`flex items-center gap-3 transition-all duration-200 ease-in-out ${
                        isActive
                          ? "bg-[#f1f5f9] text-[#2e5299] ml-4 py-2.5 px-5 rounded-l-full shadow-lg"
                          : "px-9 py-3 text-white/80 hover:text-white hover:bg-white/10 hover:translate-x-1 cursor-pointer"
                      }`}
                    >
                      {renderMenuIcon(menu.icon || "")}
                      <span className="font-medium text-[14px]">{menu.label}</span>
                    </div>
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        <div className="p-6 border-t border-white/10">
          <div className="flex items-center gap-3 mb-4">
            <div className="w-9 h-9 rounded-full bg-white/20 border border-white/20 flex items-center justify-center text-white font-medium">
              {nama.charAt(0).toUpperCase()}
            </div>
            <div className="flex flex-col">
              <span className="text-sm font-semibold text-white">{nama}</span>
              <span className="text-[11px] text-white/60">
                {role === "mahasiswa" ? "Mahasiswa" : role === "admin" ? "Admin" : "Super Admin"}
              </span>
            </div>
          </div>
          <Link
            href="/logout"
            className="flex items-center gap-2 text-white/60 hover:text-white text-xs font-medium transition-colors"
          >
            <LogOut size={16} />
            Keluar
          </Link>
        </div>
      </aside>

      {/* DESKTOP SIDEBAR (WITH COLLAPSIBLE FUNCTION) */}
      <aside
        className={`hidden md:flex bg-[#2e5299] text-white flex-col shadow-lg transition-all duration-300 relative z-20 shrink-0 ${
          isCollapsed ? "w-[84px]" : "w-64"
        }`}
      >
        {/* Toggle Collapse Button */}
        <button
          onClick={toggleCollapse}
          className="absolute top-7 -right-3.5 bg-[#2e5299] text-white border border-white/20 rounded-full w-7 h-7 flex items-center justify-center cursor-pointer shadow-md hover:bg-[#1e3d73] active:scale-95 transition-all z-20"
          title={isCollapsed ? "Perbesar Sidebar" : "Perkecil Sidebar"}
        >
          {isCollapsed ? <ChevronRight size={16} /> : <ChevronLeft size={16} />}
        </button>

        {/* Brand Logo & Title */}
        {isCollapsed ? (
          <div className="flex items-center justify-center py-6 mb-2">
            <img
              src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png"
              alt="Logo"
              className="w-8 h-8 object-contain animate-in fade-in duration-300"
            />
          </div>
        ) : (
          <div className="flex items-center gap-2.5 p-6 mb-2 animate-in fade-in duration-300">
            <img src="/LOGO-POLITEKNIK-NEGERI-SEMARANG-2.png" alt="Logo" className="w-6 h-6 object-contain" />
            <div className="flex flex-col">
              <span className="text-base font-semibold leading-none">Sistem</span>
              <span className="text-base font-semibold leading-tight">Kompen</span>
            </div>
          </div>
        )}

        {/* Menu Items */}
        <nav className="flex-1">
          <ul className="space-y-1">
            {menus.map((menu) => {
              const href = getHref(menu);
              const isActive =
                activePath === href ||
                activePath === menu.path ||
                activePath.startsWith(menu.path + "/") ||
                (menu.key && activePath.includes(menu.key));

              return (
                <li key={menu.id}>
                  <Link href={href}>
                    {isCollapsed ? (
                      /* Collapsed Menu Item */
                      <div
                        className={`flex items-center justify-center transition-all duration-200 cursor-pointer p-3 rounded-2xl mx-3 relative group ${
                          isActive
                            ? "bg-[#f1f5f9] text-[#2e5299] shadow-lg"
                            : "text-white/85 hover:text-white hover:bg-white/10"
                        }`}
                      >
                        {renderMenuIcon(menu.icon || "")}
                        
                        {/* Custom Tooltip */}
                        <div className="absolute left-full ml-3 px-3 py-1.5 bg-slate-900 text-white text-xs font-semibold rounded-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 shadow-md whitespace-nowrap z-50">
                          {menu.label}
                        </div>
                      </div>
                    ) : (
                      /* Expanded Menu Item */
                      <div
                        className={`flex items-center gap-3 transition-all duration-200 ease-in-out cursor-pointer ${
                          isActive
                            ? "bg-[#f1f5f9] text-[#2e5299] ml-4 py-2.5 px-5 rounded-l-full shadow-lg"
                            : "px-9 py-3 text-white/80 hover:text-white hover:bg-white/10 hover:translate-x-1"
                        }`}
                      >
                        {renderMenuIcon(menu.icon || "")}
                        <span className="font-medium text-[14px]">{menu.label}</span>
                      </div>
                    )}
                  </Link>
                </li>
              );
            })}
          </ul>
        </nav>

        {/* Footer User Info */}
        {isCollapsed ? (
          /* Collapsed Footer */
          <div className="p-4 border-t border-white/10 flex flex-col items-center gap-4 animate-in fade-in duration-300">
            <div
              className="w-9 h-9 rounded-full bg-white/20 border border-white/20 flex items-center justify-center text-white font-medium cursor-default relative group"
            >
              {nama.charAt(0).toUpperCase()}
              {/* Tooltip Name */}
              <div className="absolute left-full ml-3 px-3 py-1.5 bg-slate-900 text-white text-xs font-semibold rounded-lg opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 shadow-md whitespace-nowrap z-50">
                {nama} ({role === "mahasiswa" ? "Mahasiswa" : role === "admin" ? "Admin" : "Super Admin"})
              </div>
            </div>
            <Link
              href="/logout"
              className="text-white/60 hover:text-white transition-colors p-2 hover:bg-white/10 rounded-xl"
              title="Keluar"
            >
              <LogOut size={20} />
            </Link>
          </div>
        ) : (
          /* Expanded Footer */
          <div className="p-6 border-t border-white/10 animate-in fade-in duration-300">
            <div className="flex items-center gap-3 mb-4">
              <div className="w-9 h-9 rounded-full bg-white/20 border border-white/20 flex items-center justify-center text-white font-medium">
                {nama.charAt(0).toUpperCase()}
              </div>
              <div className="flex flex-col">
                <span className="text-sm font-semibold text-white">{nama}</span>
                <span className="text-[11px] text-white/60">
                  {role === "mahasiswa" ? "Mahasiswa" : role === "admin" ? "Admin" : "Super Admin"}
                </span>
              </div>
            </div>
            <Link
              href="/logout"
              className="flex items-center gap-2 text-white/60 hover:text-white text-xs font-medium transition-colors"
            >
              <LogOut size={16} />
              Keluar
            </Link>
          </div>
        )}
      </aside>

      {/* Main Content Area */}
      <div className="flex-1 flex flex-col min-w-0 transition-all duration-300">
        {children}
      </div>
    </div>
  );
}
