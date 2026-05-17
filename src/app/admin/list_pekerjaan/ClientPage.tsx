"use client";

import { useState } from "react";
import UserHeader from "@/components/UserHeader";
import { Clipboard, Briefcase, ClipboardCheck, FileText } from "lucide-react";

import TabImport from "@/app/admin/list_pekerjaan/components/TabImport";
import TabKelola from "@/app/admin/list_pekerjaan/components/TabKelola";
import TabPenugasan from "@/app/admin/list_pekerjaan/components/TabPenugasan";
import TabRiwayat from "@/app/admin/list_pekerjaan/components/TabRiwayat";

type Tab = "import" | "kelola" | "penugasan" | "riwayat";

export default function ClientPage({ semesterLabel }: { semesterLabel?: string }) {
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
            <UserHeader nama="Admin" role="admin" semesterLabel={semesterLabel} />

            <div className="p-6 max-w-6xl mx-auto w-full" suppressHydrationWarning>
                <div className="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
                    <div>
                        <h1 className="text-2xl font-bold mb-1 text-gray-900">
                            Kelola Pekerjaan & Penugasan
                        </h1>
                        <p className="text-sm text-gray-500">
                            Atur daftar pekerjaan Anda dan verifikasi penyelesaian mahasiswa
                        </p>
                    </div>

                    {/* TAB */}
                    <div className="flex gap-1.5 bg-slate-100 p-1.5 rounded-xl border border-gray-200/60 w-fit">
                        {tabs.map((tab) => {
                            const Icon = tab.icon;
                            return (
                                <button
                                    key={tab.key}
                                    onClick={() => setActiveTab(tab.key as Tab)}
                                    className={`flex items-center gap-2 px-4 py-2 rounded-lg text-sm font-medium transition-all focus:outline-none ${activeTab === tab.key
                                        ? "bg-white text-[var(--color-primary)] shadow-sm"
                                        : "text-gray-700 hover:text-gray-900 hover:bg-slate-200/50"
                                        }`}
                                >
                                    <Icon className="w-4 h-4" />
                                    {tab.label}
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