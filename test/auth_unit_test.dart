/*
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trevo/utils/auth.dart';

class MockFireBaseAuth extends Mock implements FirebaseAuth{}
class MockUserCredential extends Mock implements UserCredential{}
class MockUser extends Mock implements User{}

void main()
{

  group("Authorization Test", ()
  {
      MockFireBaseAuth auth=  MockFireBaseAuth();
      BehaviorSubject<MockUser> user= BehaviorSubject<MockUser>();
      when(auth.authStateChanges()).thenAnswer((_){
        return user;
      });
      AuthService authService=  AuthService(auth);
      when(auth.signInWithEmailAndPassword(email: "email",password: "password")).thenAnswer((_) async {
        user.add(MockUser());
        return MockUserCredential();
      });
      when(auth.createUserWithEmailAndPassword(email: "email", password: "password")).thenAnswer((_) async{
        user.add(MockUser());
        return MockUserCredential();
      }
      );
      when(auth.signOut()).thenAnswer((_) async {
        return true;
      });
    test("Sign in with correct email and password", () async {
        String confirmation= await authService.signInWithEmailAndPassword("email", "password");
        expect(confirmation, "Sign in Success");
    });
    test("Sign up Test", () async
    {
      String confirmation= await authService.signUpWithEmailAndPassword("email", "password", "name");
      expect(confirmation, "Signed up Successfully");
    });

    test("Sign Out Test", ()
    {

      expect(authService.signOut(), Future<void>(null));
    });

  });

}*/
