import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trevo/ui/Home/home.dart';
import 'package:trevo/ui/onBoard/onBoard.dart';
import 'package:trevo/utils/auth.dart';
import 'package:trevo/utils/databaseService.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
         StreamProvider(
           create: (context) => context.read<AuthService>().authStateChange,
         )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trevo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: HomePage(),
      ),
    );
  }
}


class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return SafeArea(
      child: Container(
        child: firebaseUser==null?OnBoard():Home(),
      ),
    );
  }
}
