import 'package:flutter/material.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Home/pages/hotelTile.dart';

class Places extends StatefulWidget {
  @override
  _PlacesState createState() => _PlacesState();
}

class _PlacesState extends State<Places> {
  double width;

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        HotelTile(),
      ],
    );
  }
}
