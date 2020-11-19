import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Tiles/hotelTile.dart';

class DisplayHotels extends StatefulWidget {
  final cityName;

  DisplayHotels(this.cityName);

  @override
  _DisplayHotelsState createState() => _DisplayHotelsState();
}

class _DisplayHotelsState extends State<DisplayHotels> {
  List distanceData = [], hotelNameData = [];
  List priceData = [];
  List<List<dynamic>> imgUrls = new List<List<dynamic>>();
  String query = "hotel";
  bool isLoading;



  void getImageUrls() async {
    setState(() {
      isLoading = true;
    });
    print("run");
    final data = await http
        .get("https://trevo-server.herokuapp.com/hotels/${widget.cityName}");
    final JSONData = jsonDecode(data.body);
    List hotelsListData = JSONData["places"];
    for (var item in hotelsListData) {
      hotelNameData.add(item["hotelName"]);
      imgUrls.add(item["pictures"]);
      distanceData.add(item["distance"]);
      priceData.add(item["price"]);
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    getImageUrls();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: LightGrey,
      child: isLoading == true
          ? Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        itemBuilder: (_, index) {
          return HotelTile(
            hotelName: hotelNameData[index],
            imgUrl: imgUrls[index],
            hotelPrice: priceData[index],
          );
        },
        itemCount: hotelNameData.length,
      ),
    );
  }
}
