import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Tiles/hotelTile.dart';
import 'package:trevo/ui/Tiles/restaurantTile.dart';

class DisplayRestaurants extends StatefulWidget {
  final cityName;

  DisplayRestaurants(this.cityName);
  @override
  _DisplayRestaurantsState createState() => _DisplayRestaurantsState();
}

class _DisplayRestaurantsState extends State<DisplayRestaurants> {
  int cityId;
  List addressData = [], nameData = [];
  List priceData = [];
  List ratingData= [];
  List bookingUrlData= [];
  List imgUrls = [];
  List cuisinesData= [];

  bool isLoading;

  void getImageUrls() async {
    if(this.mounted) {
      setState(() {
        isLoading = true;
      });
    }
    print("run");
    var data = await http
        .get("https://developers.zomato.com/api/v2.1/cities?q=${widget.cityName}&apikey=e29223875940edb7f8c991066d3392bb");
    var JSONData= jsonDecode(data.body);
    final tempList= JSONData["location_suggestions"];
    cityId= tempList[0]["id"];
    data = await http
        .get("https://developers.zomato.com/api/v2.1/search?entity_id=${cityId}&entity_type=city&sort=rating&order=desc&apikey=e29223875940edb7f8c991066d3392bb");
    JSONData = jsonDecode(data.body);
    List restaurantsData = JSONData["restaurants"];
    //print(restaurantsData);
    for (var item in restaurantsData) {
      nameData.add(item["restaurant"]["name"]);
      bookingUrlData.add(item["restaurant"]["url"]);
      addressData.add(item["restaurant"]["location"]["locality_verbose"]);
      ratingData.add(item["restaurant"]["user_rating"]["aggregate_rating"].toString());
      cuisinesData.add(item["restaurant"]["cuisines"]);
      priceData.add(item["restaurant"]["currency"]+" "+item["restaurant"]["average_cost_for_two"].toString());
      if(item["restaurant"]["featured_image"]!="")
        {
          imgUrls.add(item["restaurant"]["featured_image"]);
        }
      else
        {

          imgUrls.add(item["restaurant"]["thumb"]);
        }

    //print(item["restaurant"]["name"]+item["restaurant"]["url"]+item["restaurant"]["location"]["address"]+item["restaurant"]["user_rating"]["aggregate_rating"]+item["restaurant"]["photos_url"]);

    }
    if(this.mounted) {
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
          :
      ListView.builder(
        itemBuilder: (_, index) {
          return RestaurantTile(name: nameData[index],
          address: addressData[index],
          rating: ratingData[index],
          bookingUrl: bookingUrlData[index],
          imgUrl: imgUrls[index],
          cuisine: cuisinesData[index],
          price: priceData[index],);
        },
        itemCount: nameData.length,
      ),
    );
  }
}
