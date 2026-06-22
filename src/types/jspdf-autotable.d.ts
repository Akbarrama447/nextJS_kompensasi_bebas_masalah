import { jsPDF } from "jspdf";

export interface AutoTableOptions {
  startY?: number;
  head?: (string | number)[][];
  body?: (string | number | null | undefined)[][];
  theme?: "striped" | "grid" | "plain";
  headStyles?: Partial<AutoTableStyles>;
  styles?: Partial<AutoTableStyles>;
  columnStyles?: Record<number, Partial<AutoTableStyles & { cellWidth?: number }>>;
  margin?: { left?: number; right?: number; top?: number; bottom?: number };
}

export interface AutoTableStyles {
  fillColor?: number[];
  textColor?: number[];
  fontStyle?: "normal" | "bold" | "italic";
  fontSize?: number;
  cellPadding?: number;
  halign?: "left" | "center" | "right";
}

export interface AutoTableResult {
  finalY: number;
}

declare module "jspdf" {
  interface jsPDF {
    lastAutoTable: AutoTableResult;
    autoTable: (options: AutoTableOptions) => void;
  }
}

// Default export for standalone usage: autoTable(doc, { ... })
declare const autoTable: {
  (doc: jsPDF, options: AutoTableOptions): void;
};

export default autoTable;
