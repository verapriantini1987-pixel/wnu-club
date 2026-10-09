import Map "mo:core/Map";
import Principal "mo:core/Principal";
import Users "../types/users";

module {
  public func getProfile(
    profiles : Map.Map<Principal, Users.UserProfile>,
    principal : Principal,
  ) : ?Users.UserProfile {
    profiles.get(principal);
  };

  public func upsertProfile(
    profiles : Map.Map<Principal, Users.UserProfile>,
    principal : Principal,
    input : Users.UserProfileInput,
    now : Int,
  ) : Users.UserProfile {
    let createdAt = switch (profiles.get(principal)) {
      case (?existing) { existing.createdAt };
      case null { now };
    };
    let profile : Users.UserProfile = {
      principal;
      displayName = input.displayName;
      phone = input.phone;
      createdAt;
    };
    profiles.add(principal, profile);
    profile;
  };
};
