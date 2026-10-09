import Map "mo:core/Map";
import Nat "mo:core/Nat";
import Common "../types/common";
import Wards "../types/wards";

module {
  public func listWards(wards : Map.Map<Common.WardId, Wards.Ward>) : [Wards.Ward] {
    wards.values().toArray();
  };

  public func getWard(wards : Map.Map<Common.WardId, Wards.Ward>, id : Common.WardId) : ?Wards.Ward {
    wards.get(id);
  };

  public func createWard(
    wards : Map.Map<Common.WardId, Wards.Ward>,
    state : { var nextWardId : Nat },
    input : Wards.WardInput,
    now : Common.Timestamp,
  ) : Wards.Ward {
    let id = state.nextWardId;
    state.nextWardId := id + 1;
    let ward : Wards.Ward = {
      id;
      name = input.name;
      zone = input.zone;
      pickupDays = input.pickupDays;
      pickupTime = input.pickupTime;
      createdAt = now;
    };
    wards.add(id, ward);
    ward;
  };

  public func updateWard(
    wards : Map.Map<Common.WardId, Wards.Ward>,
    id : Common.WardId,
    input : Wards.WardInput,
  ) : ?Wards.Ward {
    switch (wards.get(id)) {
      case (?existing) {
        let updated : Wards.Ward = {
          id = existing.id;
          name = input.name;
          zone = input.zone;
          pickupDays = input.pickupDays;
          pickupTime = input.pickupTime;
          createdAt = existing.createdAt;
        };
        wards.add(id, updated);
        ?updated;
      };
      case null { null };
    };
  };

  public func deleteWard(wards : Map.Map<Common.WardId, Wards.Ward>, id : Common.WardId) : Bool {
    switch (wards.get(id)) {
      case (?_) {
        wards.remove(id);
        true;
      };
      case null { false };
    };
  };
};
