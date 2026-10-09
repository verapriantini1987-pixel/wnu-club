import Map "mo:core/Map";
import Nat "mo:core/Nat";
import Principal "mo:core/Principal";
import Common "../types/common";
import Routes "../types/routes";

module {
  public func listRoutes(routes : Map.Map<Common.RouteId, Routes.Route>) : [Routes.Route] {
    routes.values().toArray();
  };

  public func listRoutesByDriver(
    routes : Map.Map<Common.RouteId, Routes.Route>,
    driver : Principal,
  ) : [Routes.Route] {
    routes.values().toArray().filter(func r = switch (r.driver) {
      case (?d) { Principal.equal(d, driver) };
      case null { false };
    });
  };

  public func getRoute(
    routes : Map.Map<Common.RouteId, Routes.Route>,
    id : Common.RouteId,
  ) : ?Routes.Route {
    routes.get(id);
  };

  public func createRoute(
    routes : Map.Map<Common.RouteId, Routes.Route>,
    state : { var nextRouteId : Nat },
    input : Routes.RouteInput,
    now : Common.Timestamp,
  ) : Routes.Route {
    let id = state.nextRouteId;
    state.nextRouteId := id + 1;
    let route : Routes.Route = {
      id;
      name = input.name;
      driver = input.driver;
      wardIds = input.wardIds;
      collectionDays = input.collectionDays;
      status = #planned;
      stops = [];
      createdAt = now;
    };
    routes.add(id, route);
    route;
  };

  public func updateRoute(
    routes : Map.Map<Common.RouteId, Routes.Route>,
    id : Common.RouteId,
    input : Routes.RouteInput,
  ) : ?Routes.Route {
    switch (routes.get(id)) {
      case (?existing) {
        let updated : Routes.Route = {
          id = existing.id;
          name = input.name;
          driver = input.driver;
          wardIds = input.wardIds;
          collectionDays = input.collectionDays;
          status = existing.status;
          stops = existing.stops;
          createdAt = existing.createdAt;
        };
        routes.add(id, updated);
        ?updated;
      };
      case null { null };
    };
  };

  public func deleteRoute(routes : Map.Map<Common.RouteId, Routes.Route>, id : Common.RouteId) : Bool {
    switch (routes.get(id)) {
      case (?_) {
        routes.remove(id);
        true;
      };
      case null { false };
    };
  };

  public func markStop(
    routes : Map.Map<Common.RouteId, Routes.Route>,
    routeId : Common.RouteId,
    stopId : Common.StopId,
    status : Common.StopStatus,
    note : Text,
    now : Common.Timestamp,
  ) : ?Routes.Route {
    switch (routes.get(routeId)) {
      case (?existing) {
        var found = false;
        let updatedStops = existing.stops.map(
          func(stop) {
            if (stop.id == stopId) {
              found := true;
              { stop with status; note; updatedAt = now };
            } else {
              stop;
            };
          }
        );
        if (not found) {
          return null;
        };
        let updated : Routes.Route = {
          id = existing.id;
          name = existing.name;
          driver = existing.driver;
          wardIds = existing.wardIds;
          collectionDays = existing.collectionDays;
          status = existing.status;
          stops = updatedStops;
          createdAt = existing.createdAt;
        };
        routes.add(routeId, updated);
        ?updated;
      };
      case null { null };
    };
  };

  public func routeSummary(route : Routes.Route) : Routes.RouteSummary {
    var collected = 0;
    var skipped = 0;
    var issueReported = 0;
    var pending = 0;
    for (stop in route.stops.values()) {
      switch (stop.status) {
        case (#collected) { collected += 1 };
        case (#skipped) { skipped += 1 };
        case (#issueReported) { issueReported += 1 };
        case (#pending) { pending += 1 };
      };
    };
    {
      routeId = route.id;
      name = route.name;
      totalStops = route.stops.size();
      collected;
      skipped;
      issueReported;
      pending;
    };
  };
};
