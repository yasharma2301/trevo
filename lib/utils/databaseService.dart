import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trevo/Models/customUser.dart';

class DatabaseService{
  final String uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService({this.uid});

  Future addNewUser(String name,String email) async{
    Map<String,dynamic> data = {
      'name': name,
      'email': email,
      'notifications': 1,
    };
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString('name', name);
    sharedPreferences.setString('email', email);
    sharedPreferences.setString('uid', uid);
    return await _db.collection('users').doc(uid).set(data);
  }

  Future updateNotificationChannel(int notification) async{
    Map<String,dynamic> data = {'notifications':notification};
    return await _db.collection('users').doc(uid).update(data);
  }

  void setUserDetailsDuringLogin() async{
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    getUser().then((value) => {
      sharedPreferences.setString('name', value.name),
      sharedPreferences.setString('email', value.email),
      sharedPreferences.setString('uid', uid)
  });
  }

  Future<CustomUser> getUser() async{
    var user = await _db.collection('users').doc(uid).get();
    return CustomUser.fromMap(user.data());
  }

}