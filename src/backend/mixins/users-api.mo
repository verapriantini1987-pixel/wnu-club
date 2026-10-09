import Map "mo:core/Map";
import Principal "mo:core/Principal";
import Time "mo:core/Time";
import Runtime "mo:core/Runtime";
import Users "../types/users";
import UsersLib "../lib/users";

mixin (
  profiles : Map.Map<Principal, Users.UserProfile>,
) {
  public query ({ caller }) func getMyProfile() : async ?Users.UserProfile {
    if (caller.isAnonymous()) {
      Runtime.trap("Unauthorized: sign-in required");
    };
    UsersLib.getProfile(profiles, caller);
  };

  public shared ({ caller }) func upsertMyProfile(input : Users.UserProfileInput) : async Users.UserProfile {
    if (caller.isAnonymous()) {
      Runtime.trap("Unauthorized: sign-in required");
    };
    UsersLib.upsertProfile(profiles, caller, input, Time.now());
  };
};
