import type {
  Bin,
  BinId,
  BinStatus,
  Comment,
  DashboardStats,
  DayOfWeek,
  Report,
  ReportCategory,
  ReportDetail,
  ReportFilter,
  ReportId,
  ReportStatus,
  Route,
  RouteId,
  RouteStatus,
  RouteStop,
  RouteSummary,
  StatusChange,
  StopId,
  StopStatus,
  UserProfile,
  Ward,
  WardId,
} from "@/backend";

export type {
  Bin,
  BinId,
  BinStatus,
  Comment,
  DashboardStats,
  DayOfWeek,
  Report,
  ReportCategory,
  ReportDetail,
  ReportFilter,
  ReportId,
  ReportStatus,
  Route,
  RouteId,
  RouteStatus,
  RouteStop,
  RouteSummary,
  StatusChange,
  StopId,
  StopStatus,
  UserProfile,
  Ward,
  WardId,
};

export type { UserRole } from "@/backend";

/** A navigation entry rendered in the header, sidebar, and mobile drawer. */
export interface NavItem {
  label: string;
  to: string;
  icon: string;
}
