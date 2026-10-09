import Common "common";

module {
  public type RouteStop = {
    id : Common.StopId;
    wardId : Common.WardId;
    binId : ?Common.BinId;
    stopLabel : Text;
    order : Nat;
    status : Common.StopStatus;
    note : Text;
    updatedAt : Common.Timestamp;
  };

  public type Route = {
    id : Common.RouteId;
    name : Text;
    driver : ?Principal;
    wardIds : [Common.WardId];
    collectionDays : [Common.DayOfWeek];
    status : Common.RouteStatus;
    stops : [RouteStop];
    createdAt : Common.Timestamp;
  };

  public type RouteInput = {
    name : Text;
    driver : ?Principal;
    wardIds : [Common.WardId];
    collectionDays : [Common.DayOfWeek];
  };

  public type RouteSummary = {
    routeId : Common.RouteId;
    name : Text;
    totalStops : Nat;
    collected : Nat;
    skipped : Nat;
    issueReported : Nat;
    pending : Nat;
  };
};
