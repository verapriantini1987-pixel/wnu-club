import Map "mo:core/Map";
import Nat "mo:core/Nat";
import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import Common "../types/common";
import Reports "../types/reports";
import Routes "../types/routes";
import Bins "../types/bins";

mixin (
  reports : Map.Map<Common.ReportId, Reports.Report>,
  routes : Map.Map<Common.RouteId, Routes.Route>,
  bins : Map.Map<Common.BinId, Bins.Bin>,
  accessControlState : AccessControl.AccessControlState,
) {
  public type DashboardStats = {
    totalReports : Nat;
    openReports : Nat;
    resolvedToday : Nat;
    activeRoutes : Nat;
    binsNeedingService : Nat;
  };

  public query ({ caller }) func getDashboardStats() : async DashboardStats {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    var totalReports = 0;
    var openReports = 0;
    var resolvedToday = 0;
    let now = Time.now();
    let dayNanos : Int = 86_400_000_000_000;
    for (report in reports.values()) {
      totalReports += 1;
      switch (report.status) {
        case (#resolved) {
          if (report.updatedAt + dayNanos >= now and report.updatedAt <= now) {
            resolvedToday += 1;
          };
        };
        case (#rejected) {};
        case (_) { openReports += 1 };
      };
    };
    var activeRoutes = 0;
    for (route in routes.values()) {
      switch (route.status) {
        case (#active) { activeRoutes += 1 };
        case (_) {};
      };
    };
    var binsNeedingService = 0;
    for (bin in bins.values()) {
      switch (bin.status) {
        case (#needsService) { binsNeedingService += 1 };
        case (_) {};
      };
    };
    {
      totalReports;
      openReports;
      resolvedToday;
      activeRoutes;
      binsNeedingService;
    };
  };
};
