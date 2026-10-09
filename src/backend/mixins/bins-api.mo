import Map "mo:core/Map";
import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import Common "../types/common";
import Bins "../types/bins";
import BinsLib "../lib/bins";

mixin (
  bins : Map.Map<Common.BinId, Bins.Bin>,
  binState : { var nextBinId : Nat },
  accessControlState : AccessControl.AccessControlState,
) {
  public query func listBins() : async [Bins.Bin] {
    BinsLib.listBins(bins);
  };

  public query func getBin(id : Common.BinId) : async ?Bins.Bin {
    BinsLib.getBin(bins, id);
  };

  public shared ({ caller }) func createBin(input : Bins.BinInput) : async Bins.Bin {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    BinsLib.createBin(bins, binState, input, Time.now());
  };

  public shared ({ caller }) func updateBin(id : Common.BinId, input : Bins.BinInput) : async ?Bins.Bin {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    BinsLib.updateBin(bins, id, input);
  };

  public shared ({ caller }) func setBinStatus(id : Common.BinId, status : Common.BinStatus) : async ?Bins.Bin {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    BinsLib.setBinStatus(bins, id, status, Time.now());
  };

  public shared ({ caller }) func deleteBin(id : Common.BinId) : async Bool {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    BinsLib.deleteBin(bins, id);
  };
};
