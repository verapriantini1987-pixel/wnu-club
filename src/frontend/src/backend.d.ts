import type { Principal } from "@icp-sdk/core/principal";
export interface Some<T> {
    __kind__: "Some";
    value: T;
}
export interface None {
    __kind__: "None";
}
export type Option<T> = Some<T> | None;
export interface Bin {
    id: BinId;
    status: BinStatus;
    name: string;
    createdAt: Timestamp;
    wardId: WardId;
    location: string;
    capacityLitres: bigint;
    lastServicedAt?: Timestamp;
}
export type BinId = bigint;
export interface BinInput {
    name: string;
    wardId: WardId;
    location: string;
    capacityLitres: bigint;
}
export interface Cell {
    value: Value;
    name: string;
}
export interface Comment {
    id: bigint;
    body: string;
    createdAt: Timestamp;
    author: Principal;
}
export interface DashboardStats {
    activeRoutes: bigint;
    openReports: bigint;
    totalReports: bigint;
    resolvedToday: bigint;
    binsNeedingService: bigint;
}
export type Error_ = {
    __kind__: "FrontendOriginsNotConfigured";
    FrontendOriginsNotConfigured: null;
} | {
    __kind__: "MixedSsoSources";
    MixedSsoSources: {
        otherKeys: Array<string>;
        ssoKeys: Array<string>;
    };
} | {
    __kind__: "Stale";
    Stale: {
        ageNs: bigint;
    };
} | {
    __kind__: "MalformedCandid";
    MalformedCandid: null;
} | {
    __kind__: "AmbiguousAttribute";
    AmbiguousAttribute: {
        field: string;
        sources: Array<string>;
    };
} | {
    __kind__: "NoAttributes";
    NoAttributes: null;
} | {
    __kind__: "UnknownNonce";
    UnknownNonce: null;
} | {
    __kind__: "UntrustedSsoSource";
    UntrustedSsoSource: {
        domain: string;
    };
} | {
    __kind__: "MissingField";
    MissingField: string;
} | {
    __kind__: "FrontendOriginMismatch";
    FrontendOriginMismatch: {
        got: string;
        expected: Array<string>;
    };
};
export interface Report {
    id: ReportId;
    status: ReportStatus;
    citizen: Principal;
    createdAt: Timestamp;
    description: string;
    updatedAt: Timestamp;
    assignedRouteId?: RouteId;
    address: string;
    category: ReportCategory;
    wardId: WardId;
    photo?: string;
}
export interface ReportDetail {
    report: Report;
    comments: Array<Comment>;
    timeline: Array<StatusChange>;
}
export interface ReportFilter {
    status?: ReportStatus;
    search?: string;
    category?: ReportCategory;
    wardId?: WardId;
}
export type ReportId = bigint;
export interface ReportInput {
    description: string;
    address: string;
    category: ReportCategory;
    wardId: WardId;
    photo?: string;
}
export interface Result {
    hasMore: boolean;
    rows: Array<Array<Cell>>;
}
export type Result__1 = {
    __kind__: "ok";
    ok: null;
} | {
    __kind__: "err";
    err: Error_;
};
export interface Route {
    id: RouteId;
    wardIds: Array<WardId>;
    status: RouteStatus;
    name: string;
    createdAt: Timestamp;
    stops: Array<RouteStop>;
    driver?: Principal;
    collectionDays: Array<DayOfWeek>;
}
export type RouteId = bigint;
export interface RouteInput {
    wardIds: Array<WardId>;
    name: string;
    driver?: Principal;
    collectionDays: Array<DayOfWeek>;
}
export interface RouteStop {
    id: StopId;
    status: StopStatus;
    order: bigint;
    note: string;
    stopLabel: string;
    updatedAt: Timestamp;
    binId?: BinId;
    wardId: WardId;
}
export interface RouteSummary {
    pending: bigint;
    skipped: bigint;
    name: string;
    collected: bigint;
    totalStops: bigint;
    routeId: RouteId;
    issueReported: bigint;
}
export interface StatusChange {
    status: ReportStatus;
    changedAt: Timestamp;
    changedBy: Principal;
    note: string;
}
export type StopId = bigint;
export type Timestamp = bigint;
export interface UserProfile {
    principal: Principal;
    displayName: string;
    createdAt: bigint;
    phone: string;
}
export interface UserProfileInput {
    displayName: string;
    phone: string;
}
export type Value = {
    __kind__: "int";
    int: bigint;
} | {
    __kind__: "nat";
    nat: bigint;
} | {
    __kind__: "float";
    float: number;
} | {
    __kind__: "bool";
    bool: boolean;
} | {
    __kind__: "null";
    null: null;
} | {
    __kind__: "text";
    text: string;
};
export interface Ward {
    id: WardId;
    name: string;
    createdAt: Timestamp;
    zone: string;
    pickupDays: Array<DayOfWeek>;
    pickupTime: string;
}
export type WardId = bigint;
export interface WardInput {
    name: string;
    zone: string;
    pickupDays: Array<DayOfWeek>;
    pickupTime: string;
}
export enum BinStatus {
    ok = "ok",
    outOfService = "outOfService",
    needsService = "needsService"
}
export enum DayOfWeek {
    tuesday = "tuesday",
    wednesday = "wednesday",
    saturday = "saturday",
    thursday = "thursday",
    sunday = "sunday",
    friday = "friday",
    monday = "monday"
}
export enum ReportCategory {
    illegalDumping = "illegalDumping",
    overflowingBin = "overflowingBin",
    other = "other",
    missedPickup = "missedPickup",
    damagedBin = "damagedBin"
}
export enum ReportStatus {
    resolved = "resolved",
    submitted = "submitted",
    acknowledged = "acknowledged",
    rejected = "rejected",
    inProgress = "inProgress"
}
export enum RouteStatus {
    active = "active",
    completed = "completed",
    planned = "planned"
}
export enum StopStatus {
    pending = "pending",
    skipped = "skipped",
    collected = "collected",
    issueReported = "issueReported"
}
export enum UserRole {
    admin = "admin",
    user = "user",
    guest = "guest"
}
export interface backendInterface {
    addReportComment(id: ReportId, body: string): Promise<Comment | null>;
    assignCallerUserRole(user: Principal, role: UserRole): Promise<void>;
    assignReportRoute(id: ReportId, routeId: RouteId | null, note: string): Promise<Report | null>;
    createBin(input: BinInput): Promise<Bin>;
    createReport(input: ReportInput): Promise<Report>;
    createRoute(input: RouteInput): Promise<Route>;
    createWard(input: WardInput): Promise<Ward>;
    deleteBin(id: BinId): Promise<boolean>;
    deleteRoute(id: RouteId): Promise<boolean>;
    deleteWard(id: WardId): Promise<boolean>;
    execute(qJson: string): Promise<Result>;
    getApiDoc(): Promise<string>;
    getBin(id: BinId): Promise<Bin | null>;
    getCallerUserRole(): Promise<UserRole>;
    getDashboardStats(): Promise<DashboardStats>;
    getMyProfile(): Promise<UserProfile | null>;
    getReport(id: ReportId): Promise<ReportDetail | null>;
    getRoute(id: RouteId): Promise<Route | null>;
    getRouteSummary(routeId: RouteId): Promise<RouteSummary | null>;
    getWard(id: WardId): Promise<Ward | null>;
    isCallerAdmin(): Promise<boolean>;
    listBins(): Promise<Array<Bin>>;
    listMyReports(): Promise<Array<Report>>;
    listMyRoutes(): Promise<Array<Route>>;
    listReports(filter: ReportFilter): Promise<Array<Report>>;
    listRoutes(): Promise<Array<Route>>;
    listWards(): Promise<Array<Ward>>;
    markStop(routeId: RouteId, stopId: StopId, status: StopStatus, note: string): Promise<Route | null>;
    schema(): Promise<string>;
    setBinStatus(id: BinId, status: BinStatus): Promise<Bin | null>;
    updateBin(id: BinId, input: BinInput): Promise<Bin | null>;
    updateReportStatus(id: ReportId, status: ReportStatus, note: string): Promise<Report | null>;
    updateRoute(id: RouteId, input: RouteInput): Promise<Route | null>;
    updateWard(id: WardId, input: WardInput): Promise<Ward | null>;
    upsertMyProfile(input: UserProfileInput): Promise<UserProfile>;
}
