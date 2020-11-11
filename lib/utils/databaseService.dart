import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trevo/Models/customUser.dart';

class DatabaseService{
  final String uid;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  DatabaseService({this.uid});

  Future addNewUser(String name,String email) async{
    Map<String,String> data = {
      'name': name,
      'email': email,
    };
    return await _db.collection('users').doc(uid).set(data);
  }

  Future<CustomUser> getUser() async{
    var user = await _db.collection('users').doc(uid).get();
    return CustomUser.fromMap(user.data());
  }

}