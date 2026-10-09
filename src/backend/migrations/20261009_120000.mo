import Map "mo:core/Map";
import List "mo:core/List";
import Principal "mo:core/Principal";
import AccessControl "mo:caffeineai-authorization/access-control";

module {
  type OldActor = {};

  type NewActor = {
    accessControlState : AccessControl.AccessControlState;
    wards : Map.Map<Nat, Ward>;
    wardState : { var nextWardId : Nat };
    reports : Map.Map<Nat, Report>;
    reportTimelines : Map.Map<Nat, List.List<StatusChange>>;
    reportComments : Map.Map<Nat, List.List<Comment>>;
    reportState : { var nextReportId : Nat; var nextCommentId : Nat };
    routes : Map.Map<Nat, Route>;
    routeState : { var nextRouteId : Nat; var nextStopId : Nat };
    bins : Map.Map<Nat, Bin>;
    binState : { var nextBinId : Nat };
    profiles : Map.Map<Principal, UserProfile>;
  };

  type DayOfWeek = {
    #monday;
    #tuesday;
    #wednesday;
    #thursday;
    #friday;
    #saturday;
    #sunday;
  };

  type ReportCategory = {
    #missedPickup;
    #overflowingBin;
    #illegalDumping;
    #damagedBin;
    #other;
  };

  type ReportStatus = {
    #submitted;
    #acknowledged;
    #inProgress;
    #resolved;
    #rejected;
  };

  type BinStatus = { #ok; #needsService; #outOfService };

  type StopStatus = { #pending; #collected; #skipped; #issueReported };

  type RouteStatus = { #planned; #active; #completed };

  type Ward = {
    id : Nat;
    name : Text;
    zone : Text;
    pickupDays : [DayOfWeek];
    pickupTime : Text;
    createdAt : Int;
  };

  type Report = {
    id : Nat;
    citizen : Principal;
    category : ReportCategory;
    wardId : Nat;
    address : Text;
    description : Text;
    photo : ?Text;
    status : ReportStatus;
    assignedRouteId : ?Nat;
    createdAt : Int;
    updatedAt : Int;
  };

  type StatusChange = {
    status : ReportStatus;
    note : Text;
    changedBy : Principal;
    changedAt : Int;
  };

  type Comment = {
    id : Nat;
    author : Principal;
    body : Text;
    createdAt : Int;
  };

  type RouteStop = {
    id : Nat;
    wardId : Nat;
    binId : ?Nat;
    stopLabel : Text;
    order : Nat;
    status : StopStatus;
    note : Text;
    updatedAt : Int;
  };

  type Route = {
    id : Nat;
    name : Text;
    driver : ?Principal;
    wardIds : [Nat];
    collectionDays : [DayOfWeek];
    status : RouteStatus;
    stops : [RouteStop];
    createdAt : Int;
  };

  type Bin = {
    id : Nat;
    name : Text;
    wardId : Nat;
    location : Text;
    capacityLitres : Nat;
    lastServicedAt : ?Int;
    status : BinStatus;
    createdAt : Int;
  };

  type UserProfile = {
    principal : Principal;
    displayName : Text;
    phone : Text;
    createdAt : Int;
  };

  public func migration(_ : OldActor) : NewActor {
    let wards = Map.empty<Nat, Ward>();
    let wardNames : [(Text, Text, [DayOfWeek], Text)] = [
      ("Karegaon", "Zone A", [#monday, #thursday], "07:00"),
      ("Vidya Nagar", "Zone A", [#tuesday, #friday], "07:30"),
      ("Malegaon Road", "Zone B", [#wednesday, #saturday], "08:00"),
      ("Bhigwan Road", "Zone B", [#monday, #friday], "08:30"),
      ("Station Road", "Zone C", [#tuesday, #saturday], "09:00"),
    ];
    var nextWardId = 0;
    for ((name, zone, pickupDays, pickupTime) in wardNames.values()) {
      wards.add(nextWardId, {
        id = nextWardId;
        name;
        zone;
        pickupDays;
        pickupTime;
        createdAt = 0;
      });
      nextWardId += 1;
    };

    let routes = Map.empty<Nat, Route>();
    routes.add(0, {
      id = 0;
      name = "Zone A Starter Route";
      driver = null;
      wardIds = [0, 1];
      collectionDays = [#monday, #thursday];
      status = #planned;
      stops = [];
      createdAt = 0;
    });

    {
      accessControlState = AccessControl.initState();
      wards;
      wardState = { var nextWardId = 5 };
      reports = Map.empty();
      reportTimelines = Map.empty();
      reportComments = Map.empty();
      reportState = { var nextReportId = 0; var nextCommentId = 0 };
      routes;
      routeState = { var nextRouteId = 1; var nextStopId = 0 };
      bins = Map.empty();
      binState = { var nextBinId = 0 };
      profiles = Map.empty();
    };
  };
};
