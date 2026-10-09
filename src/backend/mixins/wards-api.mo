import Map "mo:core/Map";
import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import AccessControl "mo:caffeineai-authorization/access-control";
import Common "../types/common";
import Wards "../types/wards";
import WardsLib "../lib/wards";

mixin (
  wards : Map.Map<Common.WardId, Wards.Ward>,
  wardState : { var nextWardId : Nat },
  accessControlState : AccessControl.AccessControlState,
) {
  public query func listWards() : async [Wards.Ward] {
    WardsLib.listWards(wards);
  };

  public query func getWard(id : Common.WardId) : async ?Wards.Ward {
    WardsLib.getWard(wards, id);
  };

  public shared ({ caller }) func createWard(input : Wards.WardInput) : async Wards.Ward {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    WardsLib.createWard(wards, wardState, input, Time.now());
  };

  public shared ({ caller }) func updateWard(id : Common.WardId, input : Wards.WardInput) : async ?Wards.Ward {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    WardsLib.updateWard(wards, id, input);
  };

  public shared ({ caller }) func deleteWard(id : Common.WardId) : async Bool {
    if (not AccessControl.isAdmin(accessControlState, caller)) {
      Runtime.trap("Unauthorized: admin only");
    };
    WardsLib.deleteWard(wards, id);
  };
};
