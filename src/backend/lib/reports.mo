import Map "mo:core/Map";
import List "mo:core/List";
import Nat "mo:core/Nat";
import Principal "mo:core/Principal";
import Common "../types/common";
import Reports "../types/reports";

module {
  func matches(report : Reports.Report, filter : Reports.ReportFilter) : Bool {
    let statusOk = switch (filter.status) {
      case (?s) { report.status == s };
      case null { true };
    };
    let wardOk = switch (filter.wardId) {
      case (?w) { report.wardId == w };
      case null { true };
    };
    let categoryOk = switch (filter.category) {
      case (?c) { report.category == c };
      case null { true };
    };
    let searchOk = switch (filter.search) {
      case (?term) {
        let t = term.toLower();
        report.address.toLower().contains(#text t) or report.description.toLower().contains(#text t);
      };
      case null { true };
    };
    statusOk and wardOk and categoryOk and searchOk;
  };

  public func listReports(
    reports : Map.Map<Common.ReportId, Reports.Report>,
    filter : Reports.ReportFilter,
  ) : [Reports.Report] {
    reports.values().toArray().filter(func r = matches(r, filter));
  };

  public func listReportsByCitizen(
    reports : Map.Map<Common.ReportId, Reports.Report>,
    citizen : Principal,
  ) : [Reports.Report] {
    reports.values().toArray().filter(func r = Principal.equal(r.citizen, citizen));
  };

  public func getReport(
    reports : Map.Map<Common.ReportId, Reports.Report>,
    id : Common.ReportId,
  ) : ?Reports.Report {
    reports.get(id);
  };

  public func createReport(
    reports : Map.Map<Common.ReportId, Reports.Report>,
    state : { var nextReportId : Nat },
    citizen : Principal,
    input : Reports.ReportInput,
    now : Common.Timestamp,
  ) : Reports.Report {
    let id = state.nextReportId;
    state.nextReportId := id + 1;
    let report : Reports.Report = {
      id;
      citizen;
      category = input.category;
      wardId = input.wardId;
      address = input.address;
      description = input.description;
      photo = input.photo;
      status = #submitted;
      assignedRouteId = null;
      createdAt = now;
      updatedAt = now;
    };
    reports.add(id, report);
    report;
  };

  func recordStatusChange(
    timelines : Map.Map<Common.ReportId, List.List<Reports.StatusChange>>,
    id : Common.ReportId,
    status : Common.ReportStatus,
    note : Text,
    changedBy : Principal,
    now : Common.Timestamp,
  ) {
    let change : Reports.StatusChange = { status; note; changedBy; changedAt = now };
    switch (timelines.get(id)) {
      case (?list) { list.add(change) };
      case null {
        let list = List.empty<Reports.StatusChange>();
        list.add(change);
        timelines.add(id, list);
      };
    };
  };

  public func updateReportStatus(
    reports : Map.Map<Common.ReportId, Reports.Report>,
    timelines : Map.Map<Common.ReportId, List.List<Reports.StatusChange>>,
    id : Common.ReportId,
    status : Common.ReportStatus,
    note : Text,
    changedBy : Principal,
    now : Common.Timestamp,
  ) : ?Reports.Report {
    switch (reports.get(id)) {
      case (?existing) {
        let updated : Reports.Report = {
          id = existing.id;
          citizen = existing.citizen;
          category = existing.category;
          wardId = existing.wardId;
          address = existing.address;
          description = existing.description;
          photo = existing.photo;
          status;
          assignedRouteId = existing.assignedRouteId;
          createdAt = existing.createdAt;
          updatedAt = now;
        };
        reports.add(id, updated);
        recordStatusChange(timelines, id, status, note, changedBy, now);
        ?updated;
      };
      case null { null };
    };
  };

  public func assignReportRoute(
    reports : Map.Map<Common.ReportId, Reports.Report>,
    timelines : Map.Map<Common.ReportId, List.List<Reports.StatusChange>>,
    id : Common.ReportId,
    routeId : ?Common.RouteId,
    note : Text,
    changedBy : Principal,
    now : Common.Timestamp,
  ) : ?Reports.Report {
    switch (reports.get(id)) {
      case (?existing) {
        let updated : Reports.Report = {
          id = existing.id;
          citizen = existing.citizen;
          category = existing.category;
          wardId = existing.wardId;
          address = existing.address;
          description = existing.description;
          photo = existing.photo;
          status = existing.status;
          assignedRouteId = routeId;
          createdAt = existing.createdAt;
          updatedAt = now;
        };
        reports.add(id, updated);
        recordStatusChange(timelines, id, existing.status, note, changedBy, now);
        ?updated;
      };
      case null { null };
    };
  };

  public func getReportDetail(
    reports : Map.Map<Common.ReportId, Reports.Report>,
    timelines : Map.Map<Common.ReportId, List.List<Reports.StatusChange>>,
    comments : Map.Map<Common.ReportId, List.List<Reports.Comment>>,
    id : Common.ReportId,
  ) : ?Reports.ReportDetail {
    switch (reports.get(id)) {
      case (?report) {
        let timeline = switch (timelines.get(id)) {
          case (?list) { list.toArray() };
          case null { [] };
        };
        let commentList = switch (comments.get(id)) {
          case (?list) { list.toArray() };
          case null { [] };
        };
        ?{ report; timeline; comments = commentList };
      };
      case null { null };
    };
  };

  public func addComment(
    reports : Map.Map<Common.ReportId, Reports.Report>,
    comments : Map.Map<Common.ReportId, List.List<Reports.Comment>>,
    state : { var nextCommentId : Nat },
    id : Common.ReportId,
    author : Principal,
    body : Text,
    now : Common.Timestamp,
  ) : ?Reports.Comment {
    switch (reports.get(id)) {
      case (?_) {
        let commentId = state.nextCommentId;
        state.nextCommentId := commentId + 1;
        let comment : Reports.Comment = { id = commentId; author; body; createdAt = now };
        switch (comments.get(id)) {
          case (?list) { list.add(comment) };
          case null {
            let list = List.empty<Reports.Comment>();
            list.add(comment);
            comments.add(id, list);
          };
        };
        ?comment;
      };
      case null { null };
    };
  };
};
