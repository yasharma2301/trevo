import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

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
  List bookingUrls = [];
  String query = "hotel";
  bool isLoading;

  void getImageUrls() async {
    if (this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    print("run");
    final data = await http
        .get("https://trevo-server.herokuapp.com/hotels/${widget.cityName}");
    final JSONData = jsonDecode(data.body);
    List hotelsListData = JSONData["places"];
    for (var item in hotelsListData) {
      hotelNameData.add(item["hotelName"]);
      imgUrls.add(item["pictures"]);
      distanceData.add(item["distance"]);
      String temp= item["price"];
      temp= temp.replaceAll(",", '');
      temp= temp.substring(2,temp.length);
      double t= double.parse(temp);
      t= t*73.57;
      priceData.add("Rs "+t.toStringAsFixed(2));
      bookingUrls.add(item["viewDealLink"]);
    }

    if (this.mounted) {
      setState(() {
        isLoading = false;
      });
    }
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
              child: SpinKitCircle(color: BottleGreen),
            )
          : ListView.builder(
              itemBuilder: (_, index) {
                return HotelTile(
                  hotelName: hotelNameData[index],
                  imgUrl: imgUrls[index],
                  hotelPrice: priceData[index],
                  bookingUrl: bookingUrls[index],
                );
              },
              itemCount: hotelNameData.length,
            ),
    );
  }
}
