mixin () {
  public query func getApiDoc() : async Text {
    "
# Baramati Waste Management — Backend API

This canister backs a municipal waste-management application for Baramati,
Maharashtra. It stores wards, citizen reports (with status timelines and
comments), collection routes (with ordered stops), bins, and per-user profiles.
Three portals use it: Citizen, Admin, and Driver.

All timestamps are `Int` nanoseconds since the Unix epoch (`Time.now()`).
Identifiers (`wardId`, `reportId`, `routeId`, `binId`, `stopId`) are `Nat`
counters that start at 0 and never decrease. `Principal` values are Internet
Computer principals; `?T` is an optional value (`null` when absent).

## Authentication and identity

The frontend authenticates with Internet Identity and pins a derivation origin
published at `/.well-known/ii-derivation-origin`. An agent that already holds
the user's Internet Identity authorization derives the correct per-app principal
against that origin (for example `icp identity link web <name> --app <host>`).
Such a delegation acts with the user's full authority in this app until it
expires.

Registration is a prerequisite for every role-guarded call. A caller registers
by calling `_initialize_access_control()` once while signed in. The **first**
caller to register becomes `#admin`; every subsequent caller becomes `#user`.
Anonymous callers are ignored and remain unregistered. A principal that never
signed in through this app's frontend is unregistered even if it belongs to the
app owner, and a principal derived against a different origin is a different
principal than the one the frontend registered.

An unregistered signed-in caller receives the trap `User is not registered`
from `getCallerUserRole()` and from every admin-guarded endpoint (which calls
`isAdmin`). Anonymous callers receive `Unauthorized: sign-in required` on the
signed-in endpoints, and `User is not registered` on admin-only endpoints.

## Public methods

### Wards

- `listWards() : [Ward]` — query, public. All wards.
- `getWard(id : Nat) : ?Ward` — query, public.
- `createWard(input : WardInput) : Ward` — update, admin only.
- `updateWard(id : Nat, input : WardInput) : ?Ward` — update, admin only.
  Returns `null` when the ward does not exist.
- `deleteWard(id : Nat) : Bool` — update, admin only. `false` when absent.

`WardInput = { name : Text; zone : Text; pickupDays : [DayOfWeek]; pickupTime : Text }`.
`Ward = { id : Nat; name : Text; zone : Text; pickupDays : [DayOfWeek]; pickupTime : Text; createdAt : Int }`.
`DayOfWeek` is one of `#monday` … `#sunday`.

### Reports

- `listReports(filter : ReportFilter) : [Report]` — query, admin only.
- `listMyReports() : [Report]` — query, signed-in. Only the caller's reports.
- `getReport(id : Nat) : ?ReportDetail` — query, admin or the report's citizen.
  Traps `Unauthorized: not your report` otherwise. `null` when absent.
- `createReport(input : ReportInput) : Report` — update, signed-in. The new
  report starts as `#submitted` with `assignedRouteId = null`.
- `updateReportStatus(id : Nat, status : ReportStatus, note : Text) : ?Report` —
  update, admin only. Appends a `StatusChange` to the report's timeline.
- `assignReportRoute(id : Nat, routeId : ?Nat, note : Text) : ?Report` — update,
  admin only. Appends a timeline entry with the report's current status.
- `addReportComment(id : Nat, body : Text) : ?Comment` — update, admin or the
  report's citizen. `null` when the report does not exist.

`ReportInput = { category : ReportCategory; wardId : Nat; address : Text; description : Text; photo : ?Text }`.
`Report = { id : Nat; citizen : Principal; category : ReportCategory; wardId : Nat; address : Text; description : Text; photo : ?Text; status : ReportStatus; assignedRouteId : ?Nat; createdAt : Int; updatedAt : Int }`.
`ReportDetail = { report : Report; timeline : [StatusChange]; comments : [Comment] }`.
`StatusChange = { status : ReportStatus; note : Text; changedBy : Principal; changedAt : Int }`.
`Comment = { id : Nat; author : Principal; body : Text; createdAt : Int }`.
`ReportFilter = { status : ?ReportStatus; wardId : ?Nat; category : ?ReportCategory; search : ?Text }` — `search` matches case-insensitively against `address` and `description`; every `null` field is ignored.
`ReportCategory` is one of `#missedPickup`, `#overflowingBin`, `#illegalDumping`, `#damagedBin`, `#other`.
`ReportStatus` is one of `#submitted`, `#acknowledged`, `#inProgress`, `#resolved`, `#rejected`.

### Routes

- `listRoutes() : [Route]` — query, admin only.
- `listMyRoutes() : [Route]` — query, signed-in. Only routes assigned to the caller as driver.
- `getRoute(id : Nat) : ?Route` — query, admin or the route's driver. Traps `Unauthorized: not your route` otherwise.
- `createRoute(input : RouteInput) : Route` — update, admin only. Starts `#planned` with no stops.
- `updateRoute(id : Nat, input : RouteInput) : ?Route` — update, admin only. Preserves `status` and `stops`.
- `deleteRoute(id : Nat) : Bool` — update, admin only.
- `markStop(routeId : Nat, stopId : Nat, status : StopStatus, note : Text) : ?Route` — update, admin or the route's driver. `null` when the route or stop does not exist.
- `getRouteSummary(routeId : Nat) : ?RouteSummary` — query, admin or the route's driver.

`RouteInput = { name : Text; driver : ?Principal; wardIds : [Nat]; collectionDays : [DayOfWeek] }`.
`Route = { id : Nat; name : Text; driver : ?Principal; wardIds : [Nat]; collectionDays : [DayOfWeek]; status : RouteStatus; stops : [RouteStop]; createdAt : Int }`.
`RouteStop = { id : Nat; wardId : Nat; binId : ?Nat; stopLabel : Text; order : Nat; status : StopStatus; note : Text; updatedAt : Int }`.
`RouteSummary = { routeId : Nat; name : Text; totalStops : Nat; collected : Nat; skipped : Nat; issueReported : Nat; pending : Nat }`.
`RouteStatus` is one of `#planned`, `#active`, `#completed`.
`StopStatus` is one of `#pending`, `#collected`, `#skipped`, `#issueReported`.

### Bins

- `listBins() : [Bin]` — query, public.
- `getBin(id : Nat) : ?Bin` — query, public.
- `createBin(input : BinInput) : Bin` — update, admin only. Starts `#ok`.
- `updateBin(id : Nat, input : BinInput) : ?Bin` — update, admin only.
- `setBinStatus(id : Nat, status : BinStatus) : ?Bin` — update, admin only. Sets `lastServicedAt` to now.
- `deleteBin(id : Nat) : Bool` — update, admin only.

`BinInput = { name : Text; wardId : Nat; location : Text; capacityLitres : Nat }`.
`Bin = { id : Nat; name : Text; wardId : Nat; location : Text; capacityLitres : Nat; lastServicedAt : ?Int; status : BinStatus; createdAt : Int }`.
`BinStatus` is one of `#ok`, `#needsService`, `#outOfService`.

### Profiles

- `getMyProfile() : ?UserProfile` — query, signed-in.
- `upsertMyProfile(input : UserProfileInput) : UserProfile` — update, signed-in.
  Creates the profile on first call and preserves `createdAt` on later calls.

`UserProfileInput = { displayName : Text; phone : Text }`.
`UserProfile = { principal : Principal; displayName : Text; phone : Text; createdAt : Int }`.

### Dashboard

- `getDashboardStats() : DashboardStats` — query, admin only.
  `DashboardStats = { totalReports : Nat; openReports : Nat; resolvedToday : Nat; activeRoutes : Nat; binsNeedingService : Nat }`.
  `openReports` counts every report not `#resolved` and not `#rejected`.
  `resolvedToday` counts reports resolved within the last 24 hours.

### Authorization helpers

- `_initialize_access_control() : async ()` — registers the caller. First caller becomes `#admin`, later callers `#user`.
- `getCallerUserRole() : UserRole` — query. Traps `User is not registered` for an unregistered signed-in caller; returns `#guest` for anonymous.
- `isCallerAdmin() : Bool` — query.
- `assignCallerUserRole(user : Principal, role : UserRole) : async ()` — admin only. Traps `Unauthorized: Only admins can assign user roles` otherwise.
- `_internet_identity_sign_in_start()` / `_internet_identity_sign_in_finish()` — Internet Identity sign-in handshake used by the frontend.

`UserRole` is one of `#admin`, `#user`, `#guest`.

## Lifecycle and polling

All reads are `query` calls and return immediately. All mutations are update
calls. There is no asynchronous job, no queue, and no completion state to poll:
a mutation's effect is visible on the next query. `getDashboardStats` is
computed on demand from current state, so it needs no polling either.

## Mutation retry safety

Mutations are **not idempotent**. `createWard`, `createReport`, `createRoute`,
and `createBin` each allocate a fresh incrementing id, so retrying a call that
already succeeded creates a duplicate. `updateWard`, `updateRoute`,
`updateBin`, `updateReportStatus`, `assignReportRoute`, and `markStop` are
idempotent in effect (they overwrite the same record), but
`updateReportStatus` and `assignReportRoute` **append** a timeline entry on
every call, so retrying them duplicates the timeline. `deleteWard`,
`deleteRoute`, and `deleteBin` return `false` on a second call and are safe to
retry. `upsertMyProfile` is idempotent. Do not retry a mutation blindly after a
timeout; re-read the state first.

## Errors and limits

- Authorization failures trap with `Unauthorized: admin only`,
  `Unauthorized: sign-in required`, `Unauthorized: not your report`,
  `Unauthorized: not your route`, or `User is not registered`.
- Lookup mutations return `null` rather than trapping when the target is absent.
- `getReport` and `getRoute` return `null` when the record does not exist, and
  trap when it exists but the caller is not authorized.
- `listReports` and `getDashboardStats` are admin-only; a citizen uses
  `listMyReports`.
- There is no pagination; list methods return the full collection.

## OQL data exposure

The canister exposes its data to the Caffeine Data Intelligence agent through
OQL (`schema()` and `execute()`). Entities: `ward` (public), `report`
(controller-only), `route` (controller-only), `bin` (controller-only),
`timeline` (controller-only, edges to `report`), `comment` (controller-only,
edges to `report`), and `profile` (controller-or-scoped, owned by `principal`).
"
  };
};
