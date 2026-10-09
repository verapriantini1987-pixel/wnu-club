module {
  public type UserProfile = {
    principal : Principal;
    displayName : Text;
    phone : Text;
    createdAt : Int;
  };

  public type UserProfileInput = {
    displayName : Text;
    phone : Text;
  };
};
