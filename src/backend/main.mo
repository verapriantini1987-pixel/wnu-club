import Map "mo:core/Map";
import List "mo:core/List";
import Iter "mo:core/Iter";
import Principal "mo:core/Principal";

import AccessControl "mo:caffeineai-authorization/access-control";
import MixinAuthorization "mo:caffeineai-authorization/MixinAuthorization";

import Expose "mo:caffeineai-oql/Expose";
import Entity "mo:caffeineai-oql/Entity";
import MapEntity "mo:caffeineai-oql/MapEntity";
import RecordValue "mo:caffeineai-oql/RecordValue";
import NatValue "mo:caffeineai-oql/NatValue";
import IntValue "mo:caffeineai-oql/IntValue";
import TextValue "mo:caffeineai-oql/TextValue";
import PrincipalValue "mo:caffeineai-oql/PrincipalValue";

import Common "types/common";
import Wards "types/wards";
import Reports "types/reports";
import Routes "types/routes";
import Bins "types/bins";
import Users "types/users";

import WardsApi "mixins/wards-api";
import ReportsApi "mixins/reports-api";
import RoutesApi "mixins/routes-api";
import BinsApi "mixins/bins-api";
import UsersApi "mixins/users-api";
import StatsApi "mixins/stats-api";
import ApiDocMixin "mixins/api-doc";

actor {
  let accessControlState : AccessControl.AccessControlState;

  let wards : Map.Map<Common.WardId, Wards.Ward>;
  let wardState : { var nextWardId : Nat };

  let reports : Map.Map<Common.ReportId, Reports.Report>;
  let reportTimelines : Map.Map<Common.ReportId, List.List<Reports.StatusChange>>;
  let reportComments : Map.Map<Common.ReportId, List.List<Reports.Comment>>;
  let reportState : { var nextReportId : Nat; var nextCommentId : Nat };

  let routes : Map.Map<Common.RouteId, Routes.Route>;
  let routeState : { var nextRouteId : Nat; var nextStopId : Nat };

  let bins : Map.Map<Common.BinId, Bins.Bin>;
  let binState : { var nextBinId : Nat };

  let profiles : Map.Map<Principal, Users.UserProfile>;

  include MixinAuthorization(accessControlState, null);

  include WardsApi(wards, wardState, accessControlState);
  include ReportsApi(reports, reportTimelines, reportComments, reportState, accessControlState);
  include RoutesApi(routes, routeState, accessControlState);
  include BinsApi(bins, binState, accessControlState);
  include UsersApi(profiles);
  include StatsApi(reports, routes, bins, accessControlState);
  include ApiDocMixin();

  transient let anyP = Principal.fromText("aaaaa-aa");

  func timelineRows() : Iter.Iter<(Nat, Reports.StatusChange)> {
    let rows = List.empty<(Nat, Reports.StatusChange)>();
    for ((reportId, changes) in reportTimelines.entries()) {
      for (change in changes.values()) {
        rows.add((reportId, change));
      };
    };
    rows.values();
  };

  func commentRows() : Iter.Iter<(Nat, Reports.Comment)> {
    let rows = List.empty<(Nat, Reports.Comment)>();
    for ((reportId, comments) in reportComments.entries()) {
      for (comment in comments.values()) {
        rows.add((reportId, comment));
      };
    };
    rows.values();
  };

  include Expose({
    entities = [
      wards.toEntityManual("ward", "Ward", "id")
        .sample({ id = 0; name = ""; zone = ""; pickupDays = []; pickupTime = ""; createdAt = 0 })
        .payload("id", func w = w.id)
        .payload("name", func w = w.name)
        .payload("zone", func w = w.zone)
        .payload("pickupTime", func w = w.pickupTime)
        .payload("createdAt", func w = w.createdAt)
        .public_()
        .build(),
      reports.toEntityManual("report", "Report", "id")
        .sample({
          id = 0;
          citizen = Principal.fromText("aaaaa-aa");
          category = #missedPickup;
          wardId = 0;
          address = "";
          description = "";
          photo = null;
          status = #submitted;
          assignedRouteId = null;
          createdAt = 0;
          updatedAt = 0;
        })
        .payload("id", func r = r.id)
        .payload("citizen", func r = r.citizen)
        .payload("wardId", func r = r.wardId)
        .payload("address", func r = r.address)
        .payload("description", func r = r.description)
        .payload("status", func r = switch (r.status) {
          case (#submitted) "submitted";
          case (#acknowledged) "acknowledged";
          case (#inProgress) "inProgress";
          case (#resolved) "resolved";
          case (#rejected) "rejected";
        })
        .payload("createdAt", func r = r.createdAt)
        .payload("updatedAt", func r = r.updatedAt)
        .controllerOnly()
        .build(),
      routes.toEntityManual("route", "Route", "id")
        .sample({
          id = 0;
          name = "";
          driver = null;
          wardIds = [];
          collectionDays = [];
          status = #planned;
          stops = [];
          createdAt = 0;
        })
        .payload("id", func r = r.id)
        .payload("name", func r = r.name)
        .payload("status", func r = switch (r.status) {
          case (#planned) "planned";
          case (#active) "active";
          case (#completed) "completed";
        })
        .payload("createdAt", func r = r.createdAt)
        .controllerOnly()
        .build(),
      bins.toEntityManual("bin", "Bin", "id")
        .sample({
          id = 0;
          name = "";
          wardId = 0;
          location = "";
          capacityLitres = 0;
          lastServicedAt = null;
          status = #ok;
          createdAt = 0;
        })
        .payload("id", func b = b.id)
        .payload("name", func b = b.name)
        .payload("wardId", func b = b.wardId)
        .payload("location", func b = b.location)
        .payload("capacityLitres", func b = b.capacityLitres)
        .payload("status", func b = switch (b.status) {
          case (#ok) "ok";
          case (#needsService) "needsService";
          case (#outOfService) "outOfService";
        })
        .payload("createdAt", func b = b.createdAt)
        .controllerOnly()
        .build(),
      Entity.manual<(Nat, Reports.StatusChange)>(
        "timeline",
        timelineRows,
        "StatusChange",
        "key",
      )
        .sample((0, { status = #submitted; note = ""; changedBy = anyP; changedAt = 0 }))
        .payload("key", func ((reportId, change)) = reportId.toText() # ":" # change.changedAt.toText())
        .payload("reportId", func ((reportId, _)) = reportId)
        .edge("reportId", "report")
        .payload("status", func ((_, change)) = switch (change.status) {
          case (#submitted) "submitted";
          case (#acknowledged) "acknowledged";
          case (#inProgress) "inProgress";
          case (#resolved) "resolved";
          case (#rejected) "rejected";
        })
        .payload("note", func ((_, change)) = change.note)
        .payload("changedBy", func ((_, change)) = change.changedBy)
        .payload("changedAt", func ((_, change)) = change.changedAt)
        .controllerOnly()
        .build(),
      Entity.manual<(Nat, Reports.Comment)>(
        "comment",
        commentRows,
        "Comment",
        "key",
      )
        .sample((0, { id = 0; author = anyP; body = ""; createdAt = 0 }))
        .payload("key", func ((reportId, comment)) = reportId.toText() # ":" # comment.id.toText())
        .payload("reportId", func ((reportId, _)) = reportId)
        .edge("reportId", "report")
        .payload("id", func ((_, comment)) = comment.id)
        .payload("author", func ((_, comment)) = comment.author)
        .payload("body", func ((_, comment)) = comment.body)
        .payload("createdAt", func ((_, comment)) = comment.createdAt)
        .controllerOnly()
        .build(),
      profiles.toEntity("profile", "UserProfile", "principal")
        .sample({ principal = anyP; displayName = ""; phone = ""; createdAt = 0 })
        .ownedBy("principal")
        .controllerOrScoped()
        .build(),
    ];
  });
};
