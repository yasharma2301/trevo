class CustomUser {
  final String email,uID,name;

  CustomUser(this.email, this.uID, this.name);

  Map toJson() => {
    'email': email,
    'uID': uID,
    'name': name,
  };

  CustomUser.fromJson(Map json)
      : email = json['email'],
        uID = json['uID'],
        name = json['name'];
}
