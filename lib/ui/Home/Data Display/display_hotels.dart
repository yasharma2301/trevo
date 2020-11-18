import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:trevo/shared/colors.dart';

class DisplayHotels extends StatefulWidget {
  final cityName;

  DisplayHotels(this.cityName);

  @override
  _DisplayHotelsState createState() => _DisplayHotelsState();
}

class _DisplayHotelsState extends State<DisplayHotels> {
  List distanceData = [], hotelNameData = [];
  List priceData=[];
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
    // print(hotelNameData.toString());
    // print(imgUrls.toString());
    // print(distanceData.toString());
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
    return Scaffold(
        floatingActionButton: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12, offset: Offset(0.0, 1.0), //(x,y)
                  blurRadius: 6.0,
                ),
              ]),
          margin: EdgeInsets.only(left: 20, top: 30),
          child: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        body: Column(children: <Widget>[
          Container(
            color: LightGrey,
            height: MediaQuery.of(context).size.height,
            child: isLoading == true
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemBuilder: (_, index) {
                      return Container(
                        margin:
                            EdgeInsets.only(left: 7.5, right: 7.5, bottom: 15),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              height: 200,
                              child: Swiper(
                                itemBuilder: (_, imgIndex) {
                                  return ClipRRect(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(5),
                                        topRight: Radius.circular(5)),
                                    child: Image.network(
                                      imgUrls[index][imgIndex],
                                      fit: BoxFit.fill,
                                      height: 200,
                                    ),
                                  );
                                },
                                scale: 0.9,
                                viewportFraction: 0.8,
                                itemCount: imgUrls[index].length,
                                pagination: SwiperPagination(),
                                //control: SwiperControl(),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 20,right: 10),
                                    child: Text(
                                      hotelNameData[index],
                                      style: TextStyle(
                                          fontSize: 19,
                                          color: BottleGreen,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(

                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(left: 30),
                                            height: 40,
                                            width: 80,
                                            alignment: Alignment.center,

                                            decoration: BoxDecoration(
                                              color: Colors.red,
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Text(priceData[index],style: TextStyle(
                                                fontSize: 19,
                                                color: Colors.white,
                                                fontFamily: 'Montserrat',
                                                fontWeight: FontWeight.bold)),
                                          )
                                          // Padding(
                                          //   padding: const EdgeInsets.only(
                                          //       right: 10, bottom: 5),
                                          //   child: Icon(
                                          //     Icons.location_on,
                                          //     color: Colors.redAccent[100],
                                          //     size: 28,
                                          //   ),
                                          // ),
                                          // Padding(
                                          //   padding: EdgeInsets.only(right: 2),
                                          //   child: Text(
                                          //     distanceData[index],
                                          //     textAlign: TextAlign.center,
                                          //     style: TextStyle(
                                          //         fontSize: 16,
                                          //         color: BottleGreen,
                                          //         fontFamily: 'Montserrat',
                                          //         fontWeight: FontWeight.w400),
                                          //   ),
                                          // ),
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {},
                                        child: Container(
                                          padding: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                              color: Colors.blueAccent[100]
                                                  .withOpacity(0.1),
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'ReadMore',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 15,
                                                    color: BottleGreen,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              Icon(
                                                Icons.chevron_right,
                                                color: Colors.blueAccent[100],
                                                size: 32,
                                              ),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      );
                    },
                    itemCount: 15,
                  ),
          ),
        ]));
  }
}
