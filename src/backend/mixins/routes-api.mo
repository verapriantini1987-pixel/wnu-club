import Map "mo:core/Map";
import Principal "mo:core/Principal";
import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import Common "../types/common";
import Routes "../types/routes";
import RoutesLib "../lib/routes";

mixin (
  routes : Map.Map<Common.RouteId, Routes.Route>,
  routeState : { var nextRouteId : Nat; var nextStopId : Nat },
  accessControlState : AccessControl.AccessControlState,
) {
  public query ({ caller }) func listRoutes() : async [Routes.Route] {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    RoutesLib.listRoutes(routes);
  };

  public query ({ caller }) func listMyRoutes() : async [Routes.Route] {
    if (caller.isAnonymous()) {
      Runtime.trap("Unauthorized: sign-in required");
    };
    RoutesLib.listRoutesByDriver(routes, caller);
  };

  public query ({ caller }) func getRoute(id : Common.RouteId) : async ?Routes.Route {
    switch (RoutesLib.getRoute(routes, id)) {
      case (?route) {
        let isDriver = switch (route.driver) {
          case (?d) { Principal.equal(d, caller) };
          case null { false };
        };
        if (not (AccessControl.isAdmin(accessControlState, caller) or isDriver)) {
          Runtime.trap("Unauthorized: not your route");
        };
        ?route;
      };
      case null { null };
    };
  };

  public shared ({ caller }) func createRoute(input : Routes.RouteInput) : async Routes.Route {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    RoutesLib.createRoute(routes, routeState, input, Time.now());
  };

  public shared ({ caller }) func updateRoute(id : Common.RouteId, input : Routes.RouteInput) : async ?Routes.Route {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    RoutesLib.updateRoute(routes, id, input);
  };

  public shared ({ caller }) func deleteRoute(id : Common.RouteId) : async Bool {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    RoutesLib.deleteRoute(routes, id);
  };

  public shared ({ caller }) func markStop(
    routeId : Common.RouteId,
    stopId : Common.StopId,
    status : Common.StopStatus,
    note : Text,
  ) : async ?Routes.Route {
    switch (RoutesLib.getRoute(routes, routeId)) {
      case (?route) {
        let isDriver = switch (route.driver) {
          case (?d) { Principal.equal(d, caller) };
          case null { false };
        };
        if (not (AccessControl.isAdmin(accessControlState, caller) or isDriver)) {
          Runtime.trap("Unauthorized: not your route");
        };
      };
      case null { return null };
    };
    RoutesLib.markStop(routes, routeId, stopId, status, note, Time.now());
  };

  public query ({ caller }) func getRouteSummary(routeId : Common.RouteId) : async ?Routes.RouteSummary {
    switch (RoutesLib.getRoute(routes, routeId)) {
      case (?route) {
        let isDriver = switch (route.driver) {
          case (?d) { Principal.equal(d, caller) };
          case null { false };
        };
        if (not (AccessControl.isAdmin(accessControlState, caller) or isDriver)) {
          Runtime.trap("Unauthorized: not your route");
        };
        ?RoutesLib.routeSummary(route);
      };
      case null { null };
    };
  };
};
