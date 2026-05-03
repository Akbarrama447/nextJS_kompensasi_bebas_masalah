"use client";

import { useState } from "react";
import UserHeader from "@/components/UserHeader";
import { Clipboard, Briefcase, ClipboardCheck, FileText } from "lucide-react";

import TabImport from "@/app/admin/list_pekerjaan/components/TabImport";
import TabKelola from "@/app/admin/list_pekerjaan/components/TabKelola";
import TabPenugasan from "@/app/admin/list_pekerjaan/components/TabPenugasan";
import TabRiwayat from "@/app/admin/list_pekerjaan/components/TabRiwayat";

type Tab = "import" | "kelola" | "penugasan" | "riwayat";

export default function ClientPage() {
    const [activeTab, setActiveTab] = useState<Tab>("penugasan");

    const tabs = [
        { key: "import", label: "Import", icon: Clipboard },
        { key: "kelola", label: "Kelola", icon: Briefcase },
        { key: "penugasan", label: "Penugasan", icon: ClipboardCheck },
        { key: "riwayat", label: "Riwayat", icon: FileText },
    ];

    const renderTab = () => {
        switch (activeTab) {
            case "import": return <TabImport />;
            case "kelola": return <TabKelola />;
            case "penugasan": return <TabPenugasan />;
            case "riwayat": return <TabRiwayat />;
        }
    };

    return (
        <main className="flex-1 flex flex-col" suppressHydrationWarning>
            <UserHeader nama="Admin" role="admin" />

            <div className="px-3 md:px-6 py-4 md:py-6 w-full overflow-x-hidden" suppressHydrationWarning>
                <div className="flex flex-col gap-4 mb-4 md:mb-6">
                    <div>
                        <h1 className="text-xl md:text-2xl font-bold mb-1 text-gray-900">
                            Kelola Pekerjaan & Penugasan
                        </h1>
                        <p className="text-xs md:text-sm text-gray-500">
                            Atur daftar pekerjaan Anda dan verifikasi penyelesaian mahasiswa
                        </p>
                    </div>

                    {/* TAB */}
                    <div className="flex gap-1 md:gap-1.5 bg-slate-100 p-1 md:p-1.5 rounded-xl border border-gray-200/60 overflow-x-auto">
                        {tabs.map((tab) => {
                            const Icon = tab.icon;
                            return (
                                <button
                                    key={tab.key}
                                    onClick={() => setActiveTab(tab.key as Tab)}
                                    className={`flex items-center gap-1 md:gap-2 px-2 md:px-4 py-1.5 md:py-2 rounded-lg text-xs md:text-sm font-medium transition-all focus:outline-none whitespace-nowrap flex-shrink-0 ${activeTab === tab.key
                                        ? "bg-white text-[var(--color-primary)] shadow-sm"
                                        : "text-gray-700 hover:text-gray-900 hover:bg-slate-200/50"
                                        }`}
                                >
                                    <Icon className="w-3 h-3 md:w-4 md:h-4" />
                                    <span className="hidden sm:inline">{tab.label}</span>
                                </button>
                            );
                        })}
                    </div>
                </div>

                {/* CONTENT */}
                {renderTab()}
            </div>
        </main>
    );
}