'use client';

import { useState } from 'react';
import { AuthProvider } from '@/contexts/AuthContext';
import Sidebar from '@/components/layout/Sidebar';
import Header from '@/components/layout/Header';

export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  const [sidebarOpen, setSidebarOpen] = useState(false);

  return (
    <AuthProvider>
      <div className="min-h-screen bg-slate-50">
        {/* Sidebar — fixed left, 240px wide on desktop */}
        <Sidebar
          open={sidebarOpen}
          onClose={() => setSidebarOpen(false)}
        />

        {/* Header — fixed top, offset by sidebar on desktop */}
        <Header onMenuClick={() => setSidebarOpen((v) => !v)} />

        {/* Main content — offset by both sidebar and header */}
        <main
          className={[
            // Top offset for header
            'pt-16',
            // Left offset for sidebar on desktop
            'md:pl-[240px]',
            // Inner content padding
            'min-h-screen',
          ].join(' ')}
        >
          <div className="p-4 md:p-8 max-w-[1400px] mx-auto">
            {children}
          </div>
        </main>
      </div>
    </AuthProvider>
  );
}
