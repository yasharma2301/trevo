import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/onBoard/onBoard.dart';
import 'package:trevo/utils/auth.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthService>(context);
    return Container(
      color: Skin,
      child: Center(
        child: RaisedButton(
          onPressed: () {
            loginProvider.signOut().then((value) => Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder: (context) => OnBoard())));
          },
        ),
      ),
    );
  }
}
