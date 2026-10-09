module {
  public type Timestamp = Int;
  public type WardId = Nat;
  public type RouteId = Nat;
  public type BinId = Nat;
  public type ReportId = Nat;
  public type StopId = Nat;

  public type DayOfWeek = {
    #monday;
    #tuesday;
    #wednesday;
    #thursday;
    #friday;
    #saturday;
    #sunday;
  };

  public type ReportCategory = {
    #missedPickup;
    #overflowingBin;
    #illegalDumping;
    #damagedBin;
    #other;
  };

  public type ReportStatus = {
    #submitted;
    #acknowledged;
    #inProgress;
    #resolved;
    #rejected;
  };

  public type BinStatus = {
    #ok;
    #needsService;
    #outOfService;
  };

  public type StopStatus = {
    #pending;
    #collected;
    #skipped;
    #issueReported;
  };

  public type RouteStatus = {
    #planned;
    #active;
    #completed;
  };
};
