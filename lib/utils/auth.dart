import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trevo/utils/databaseService.dart';

class AuthService with ChangeNotifier{
  final FirebaseAuth _auth;
  bool loading = false;
  String userName,userEmail;

  AuthService(this._auth);

  Stream<User> get authStateChange => _auth.authStateChanges();

  Future<String> signInWithEmailAndPassword(String email,
      String password) async {
    loading = true;
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password).then((value) => {
        DatabaseService(uid: value.user.uid).setUserDetailsDuringLogin()
      });
      loading = false;
      notifyListeners();
      return "Sign in Success";
    } on FirebaseAuthException catch (e) {
      loading = false;
      notifyListeners();
      return e.message;
    }
  }

  String getCurrentUserUid(){
    return  _auth.currentUser.uid;
  }

  Future<String> signUpWithEmailAndPassword(String email,
      String password,String name) async {
    print(loading);
    loading = true;
    print(loading);
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await DatabaseService(uid: _auth.currentUser.uid).addNewUser(name, email);
      loading = false;
      print(loading);
      notifyListeners();
      return "Signed up Successfully";
    } on FirebaseAuthException catch (e) {
      loading = false;
      notifyListeners();
      return e.message;
    }
  }


  Future<void> signOut() async {
    await _auth.signOut();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.clear();
  }

}

