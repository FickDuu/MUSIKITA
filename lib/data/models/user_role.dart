enum UserRole {
  musician, organizer;

  //convert enum to string
  String toJson() => name;

  //create enum from string
  static UserRole fromJson(String json){
    return UserRole.values.firstWhere(
      (role) => role.name == json,
      orElse: () => UserRole.musician,
    );
  }

  String get displayName{
    switch(this){
      case UserRole.musician:
        return 'Musician';
      case UserRole.organizer:
          return 'Event Organizer';
    }
  }

  //description
  String get description{
    switch(this){
      case UserRole.musician:
        return 'looking for gigs';
      case UserRole.organizer:
          return 'looking to book for gigs';
    }
  }
}