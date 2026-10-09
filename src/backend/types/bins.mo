import Common "common";

module {
  public type Bin = {
    id : Common.BinId;
    name : Text;
    wardId : Common.WardId;
    location : Text;
    capacityLitres : Nat;
    lastServicedAt : ?Common.Timestamp;
    status : Common.BinStatus;
    createdAt : Common.Timestamp;
  };

  public type BinInput = {
    name : Text;
    wardId : Common.WardId;
    location : Text;
    capacityLitres : Nat;
  };
};
