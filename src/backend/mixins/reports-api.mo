import Map "mo:core/Map";
import List "mo:core/List";
import Principal "mo:core/Principal";
import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import Common "../types/common";
import Reports "../types/reports";
import ReportsLib "../lib/reports";

mixin (
  reports : Map.Map<Common.ReportId, Reports.Report>,
  reportTimelines : Map.Map<Common.ReportId, List.List<Reports.StatusChange>>,
  reportComments : Map.Map<Common.ReportId, List.List<Reports.Comment>>,
  reportState : { var nextReportId : Nat; var nextCommentId : Nat },
  accessControlState : AccessControl.AccessControlState,
) {
  public query ({ caller }) func listReports(filter : Reports.ReportFilter) : async [Reports.Report] {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    ReportsLib.listReports(reports, filter);
  };

  public query ({ caller }) func listMyReports() : async [Reports.Report] {
    if (caller.isAnonymous()) {
      Runtime.trap("Unauthorized: sign-in required");
    };
    ReportsLib.listReportsByCitizen(reports, caller);
  };

  public query ({ caller }) func getReport(id : Common.ReportId) : async ?Reports.ReportDetail {
    let detail = ReportsLib.getReportDetail(reports, reportTimelines, reportComments, id);
    switch (detail) {
      case (?d) {
        if (not (AccessControl.isAdmin(accessControlState, caller) or Principal.equal(d.report.citizen, caller))) {
          Runtime.trap("Unauthorized: not your report");
        };
        ?d;
      };
      case null { null };
    };
  };

  public shared ({ caller }) func createReport(input : Reports.ReportInput) : async Reports.Report {
    if (caller.isAnonymous()) {
      Runtime.trap("Unauthorized: sign-in required");
    };
    ReportsLib.createReport(reports, reportState, caller, input, Time.now());
  };

  public shared ({ caller }) func updateReportStatus(
    id : Common.ReportId,
    status : Common.ReportStatus,
    note : Text,
  ) : async ?Reports.Report {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    ReportsLib.updateReportStatus(reports, reportTimelines, id, status, note, caller, Time.now());
  };

  public shared ({ caller }) func assignReportRoute(
    id : Common.ReportId,
    routeId : ?Common.RouteId,
    note : Text,
  ) : async ?Reports.Report {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    ReportsLib.assignReportRoute(reports, reportTimelines, id, routeId, note, caller, Time.now());
  };

  public shared ({ caller }) func addReportComment(id : Common.ReportId, body : Text) : async ?Reports.Comment {
    if (caller.isAnonymous()) {
      Runtime.trap("Unauthorized: sign-in required");
    };
    switch (ReportsLib.getReport(reports, id)) {
      case (?report) {
        if (not (AccessControl.isAdmin(accessControlState, caller) or Principal.equal(report.citizen, caller))) {
          Runtime.trap("Unauthorized: not your report");
        };
      };
      case null { return null };
    };
    ReportsLib.addComment(reports, reportComments, reportState, id, caller, body, Time.now());
  };
};
