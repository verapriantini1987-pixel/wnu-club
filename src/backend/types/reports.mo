import Common "common";

module {
  public type Report = {
    id : Common.ReportId;
    citizen : Principal;
    category : Common.ReportCategory;
    wardId : Common.WardId;
    address : Text;
    description : Text;
    photo : ?Text;
    status : Common.ReportStatus;
    assignedRouteId : ?Common.RouteId;
    createdAt : Common.Timestamp;
    updatedAt : Common.Timestamp;
  };

  public type ReportInput = {
    category : Common.ReportCategory;
    wardId : Common.WardId;
    address : Text;
    description : Text;
    photo : ?Text;
  };

  public type StatusChange = {
    status : Common.ReportStatus;
    note : Text;
    changedBy : Principal;
    changedAt : Common.Timestamp;
  };

  public type Comment = {
    id : Nat;
    author : Principal;
    body : Text;
    createdAt : Common.Timestamp;
  };

  public type ReportDetail = {
    report : Report;
    timeline : [StatusChange];
    comments : [Comment];
  };

  public type ReportFilter = {
    status : ?Common.ReportStatus;
    wardId : ?Common.WardId;
    category : ?Common.ReportCategory;
    search : ?Text;
  };
};
