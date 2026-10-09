import { Skeleton } from "@/components/ui/skeleton";
import { cn } from "@/lib/utils";

interface LoadingSkeletonProps {
  variant?: "cards" | "table" | "detail";
  count?: number;
  className?: string;
}

export function LoadingSkeleton({
  variant = "cards",
  count = 6,
  className,
}: LoadingSkeletonProps) {
  const ids = Array.from({ length: count }, (_, i) => `skeleton-${i}`);

  if (variant === "table") {
    return (
      <div
        data-ocid="loading_state"
        className={cn("flex flex-col gap-2", className)}
      >
        <Skeleton className="h-10 w-full" />
        {ids.map((id) => (
          <Skeleton key={id} className="h-14 w-full" />
        ))}
      </div>
    );
  }

  if (variant === "detail") {
    return (
      <div
        data-ocid="loading_state"
        className={cn("flex flex-col gap-6", className)}
      >
        <Skeleton className="h-8 w-2/3" />
        <Skeleton className="h-4 w-1/3" />
        <Skeleton className="h-40 w-full" />
        <div className="flex flex-col gap-3">
          <Skeleton className="h-4 w-full" />
          <Skeleton className="h-4 w-5/6" />
          <Skeleton className="h-4 w-4/6" />
        </div>
      </div>
    );
  }

  return (
    <div
      data-ocid="loading_state"
      className={cn(
        "grid grid-cols-1 gap-4 sm:grid-cols-2 lg:grid-cols-3",
        className,
      )}
    >
      {ids.map((id) => (
        <div
          key={id}
          className="flex flex-col gap-3 rounded-xl border border-border bg-card p-5"
        >
          <Skeleton className="h-5 w-1/2" />
          <Skeleton className="h-4 w-3/4" />
          <Skeleton className="h-4 w-2/3" />
          <Skeleton className="h-9 w-28" />
        </div>
      ))}
    </div>
  );
}
