'use client';

import { ReactNode } from 'react';
import { TrendingUp } from 'lucide-react';

interface MetricCardProps {
  title: string;
  value: string | number;
  subtitle?: string;
  icon?: ReactNode;
  /** Trend indicator: positive = green, negative = red */
  trend?: { value: string; positive?: boolean };
  /** Warna strip kiri card */
  accent?: 'blue' | 'green' | 'yellow' | 'red' | 'purple' | 'slate';
}

const accentMap: Record<string, string> = {
  blue:   'border-l-4 border-l-blue-500',
  green:  'border-l-4 border-l-green-500',
  yellow: 'border-l-4 border-l-yellow-500',
  red:    'border-l-4 border-l-red-500',
  purple: 'border-l-4 border-l-purple-500',
  slate:  'border-l-4 border-l-slate-400',
};

const iconBgMap: Record<string, string> = {
  blue:   'bg-blue-50 text-blue-600',
  green:  'bg-green-50 text-green-600',
  yellow: 'bg-yellow-50 text-yellow-600',
  red:    'bg-red-50 text-red-600',
  purple: 'bg-purple-50 text-purple-600',
  slate:  'bg-slate-100 text-slate-500',
};

export default function MetricCard({
  title,
  value,
  subtitle,
  icon,
  trend,
  accent = 'blue',
}: MetricCardProps) {
  return (
    <div className={`card ${accentMap[accent]} transition-shadow duration-200 hover:shadow-md`}>
      <div className="flex items-start justify-between gap-4">
        <div className="flex-1 min-w-0">
          <p className="text-xs font-medium text-slate-500 uppercase tracking-wide mb-2">
            {title}
          </p>
          <p className="text-3xl font-bold text-slate-900 tabular-nums leading-none">
            {value}
          </p>
          {subtitle && (
            <p className="text-sm text-slate-500 mt-2 leading-snug">{subtitle}</p>
          )}
          {trend && (
            <div
              className={`inline-flex items-center gap-1 mt-3 text-xs font-medium ${
                trend.positive !== false ? 'text-green-600' : 'text-red-500'
              }`}
            >
              <TrendingUp className="w-3 h-3" />
              {trend.value}
            </div>
          )}
        </div>

        {icon && (
          <div
            className={`w-12 h-12 rounded-xl flex items-center justify-center flex-shrink-0 ${iconBgMap[accent]}`}
          >
            {icon}
          </div>
        )}
      </div>
    </div>
  );
}
