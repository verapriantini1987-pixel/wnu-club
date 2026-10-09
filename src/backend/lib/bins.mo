import Map "mo:core/Map";
import Nat "mo:core/Nat";
import Common "../types/common";
import Bins "../types/bins";

module {
  public func listBins(bins : Map.Map<Common.BinId, Bins.Bin>) : [Bins.Bin] {
    bins.values().toArray();
  };

  public func getBin(bins : Map.Map<Common.BinId, Bins.Bin>, id : Common.BinId) : ?Bins.Bin {
    bins.get(id);
  };

  public func createBin(
    bins : Map.Map<Common.BinId, Bins.Bin>,
    state : { var nextBinId : Nat },
    input : Bins.BinInput,
    now : Common.Timestamp,
  ) : Bins.Bin {
    let id = state.nextBinId;
    state.nextBinId := id + 1;
    let bin : Bins.Bin = {
      id;
      name = input.name;
      wardId = input.wardId;
      location = input.location;
      capacityLitres = input.capacityLitres;
      lastServicedAt = null;
      status = #ok;
      createdAt = now;
    };
    bins.add(id, bin);
    bin;
  };

  public func updateBin(
    bins : Map.Map<Common.BinId, Bins.Bin>,
    id : Common.BinId,
    input : Bins.BinInput,
  ) : ?Bins.Bin {
    switch (bins.get(id)) {
      case (?existing) {
        let updated : Bins.Bin = {
          id = existing.id;
          name = input.name;
          wardId = input.wardId;
          location = input.location;
          capacityLitres = input.capacityLitres;
          lastServicedAt = existing.lastServicedAt;
          status = existing.status;
          createdAt = existing.createdAt;
        };
        bins.add(id, updated);
        ?updated;
      };
      case null { null };
    };
  };

  public func setBinStatus(
    bins : Map.Map<Common.BinId, Bins.Bin>,
    id : Common.BinId,
    status : Common.BinStatus,
    now : Common.Timestamp,
  ) : ?Bins.Bin {
    switch (bins.get(id)) {
      case (?existing) {
        let servicedAt = switch (status) {
          case (#ok) { ?now };
          case (_) { existing.lastServicedAt };
        };
        let updated : Bins.Bin = {
          id = existing.id;
          name = existing.name;
          wardId = existing.wardId;
          location = existing.location;
          capacityLitres = existing.capacityLitres;
          lastServicedAt = servicedAt;
          status;
          createdAt = existing.createdAt;
        };
        bins.add(id, updated);
        ?updated;
      };
      case null { null };
    };
  };

  public func deleteBin(bins : Map.Map<Common.BinId, Bins.Bin>, id : Common.BinId) : Bool {
    switch (bins.get(id)) {
      case (?_) {
        bins.remove(id);
        true;
      };
      case null { false };
    };
  };
};
