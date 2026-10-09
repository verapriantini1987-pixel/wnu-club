import type { DayOfWeek } from "@/types";

/**
 * Motoko `Time.now()` values are nanosecond bigints. Convert through this
 * helper before any JavaScript Date operation.
 */
export function timestampToDate(timestamp: bigint): Date | null {
  const date = new Date(Number(timestamp / 1_000_000n));
  return Number.isNaN(date.getTime()) ? null : date;
}

export function formatDate(timestamp: bigint): string {
  const date = timestampToDate(timestamp);
  if (!date) return "—";
  return date.toLocaleDateString("en-IN", {
    day: "numeric",
    month: "short",
    year: "numeric",
  });
}

export function formatDateTime(timestamp: bigint): string {
  const date = timestampToDate(timestamp);
  if (!date) return "—";
  return date.toLocaleString("en-IN", {
    day: "numeric",
    month: "short",
    year: "numeric",
    hour: "2-digit",
    minute: "2-digit",
  });
}

export function formatRelative(timestamp: bigint): string {
  const date = timestampToDate(timestamp);
  if (!date) return "—";
  const diffMs = Date.now() - date.getTime();
  const diffMins = Math.round(diffMs / 60_000);
  if (diffMins < 1) return "just now";
  if (diffMins < 60) return `${diffMins}m ago`;
  const diffHours = Math.round(diffMins / 60);
  if (diffHours < 24) return `${diffHours}h ago`;
  const diffDays = Math.round(diffHours / 24);
  if (diffDays < 30) return `${diffDays}d ago`;
  return formatDate(timestamp);
}

export function formatNumber(value: bigint | number): string {
  return Number(value).toLocaleString("en-IN");
}

/** Convert a backend enum variant like `illegalDumping` to `Illegal Dumping`. */
export function humanize(value: string): string {
  return value
    .replace(/([a-z])([A-Z])/g, "$1 $2")
    .replace(/^./, (char) => char.toUpperCase());
}

export function formatDay(day: DayOfWeek): string {
  return day.charAt(0).toUpperCase() + day.slice(1);
}

export function formatDays(days: DayOfWeek[]): string {
  if (days.length === 0) return "No scheduled days";
  if (days.length === 7) return "Every day";
  return days.map(formatDay).join(", ");
}

export function truncatePrincipal(principal: string): string {
  if (principal.length <= 12) return principal;
  return `${principal.slice(0, 5)}…${principal.slice(-4)}`;
}
