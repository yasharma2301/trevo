import 'package:flutter/material.dart';
import 'package:trevo/ui/onBoard/onBoard.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: OnBoard(),
      ),
    );
  }
}
