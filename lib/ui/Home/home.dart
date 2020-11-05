import 'package:flutter/material.dart';
import 'package:trevo/shared/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Skin,
      child: Center(
        child: Text('HOME'),
      ),
    );
  }
}
