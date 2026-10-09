import Common "common";

module {
  public type Ward = {
    id : Common.WardId;
    name : Text;
    zone : Text;
    pickupDays : [Common.DayOfWeek];
    pickupTime : Text;
    createdAt : Common.Timestamp;
  };

  public type WardInput = {
    name : Text;
    zone : Text;
    pickupDays : [Common.DayOfWeek];
    pickupTime : Text;
  };
};
