class CustomUser {
  final String email,name;
  final int notifications;

  CustomUser({this.email, this.name,this.notifications});

  Map toJson() => {
    'email': email,
    'name': name,
    'notifications':notifications,
  };

  factory CustomUser.fromMap(Map json){
    return CustomUser(
        email : json['email'],
        name : json['name'],
        notifications: json['notifications'],
    );
  }
}
