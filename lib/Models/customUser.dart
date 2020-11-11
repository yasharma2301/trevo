class CustomUser {
  final String email,name;

  CustomUser({this.email, this.name});

  Map toJson() => {
    'email': email,
    'name': name,
  };

  factory CustomUser.fromMap(Map json){
    return CustomUser(
        email : json['email'],
        name : json['name'],
    );
  }
}
