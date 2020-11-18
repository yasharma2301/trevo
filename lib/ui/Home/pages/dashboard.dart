import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Home/pages/dashboardPages/hotels.dart';
import 'package:trevo/ui/Home/pages/dashboardPages/places.dart';
import 'package:trevo/ui/Home/pages/dashboardPages/restaurants.dart';

class DashBoard extends StatefulWidget {
  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  Coordinates currentUserLatLong;
  var cityName = "";

  void getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium);
    currentUserLatLong = new Coordinates(position.latitude, position.longitude);
    final address =
        await Geocoder.local.findAddressesFromCoordinates(currentUserLatLong);
    final first = address.first;
    double latitude = first.coordinates.latitude;
    double longitude = first.coordinates.longitude;
    cityName = first.locality;
    print(cityName);
    print(latitude);
    print(longitude);
    setState(() {});
  }

  @override
  void initState() {
    getCurrentLocation();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: LightGrey,
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.search),
              color: White,
              onPressed: () {
                showSearch(context: context, delegate: DataSearch());
              },
            ),
            IconButton(
              icon: Icon(Icons.camera_alt),
              color: White,
              onPressed: () {},
            ),
            SizedBox(
              width: 10,
            ),
          ],
          elevation: 10,
          backgroundColor: BottleGreen,
          title: Text('Trevo'),
          bottom: TabBar(
            indicatorColor: White,
            indicatorWeight: 3,
            tabs: [
              Tab(
                child: Text(
                  'Places',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  'Hotels',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              Tab(
                child: Text(
                  'Restaurants',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [Places(), Hotels(), Restaurants()],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final cities = ["Jaipur", "Jabalpur", "London", "Delhi", "Agra"];
  final recentCities = ["Jaipur"];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
     print(query);
    return Container(height: 100,width: 100, child: Text(query),);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? recentCities
        : cities.where((element) => element.startsWith(query)).toList();
    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: (){
          showResults(context);
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              text: suggestions[index].substring(0, query.length),
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold,fontSize: 17),
              children: [
                TextSpan(
                    text: suggestions[index].substring(query.length),
                    style: TextStyle(color: Colors.grey))
              ]),
        ),
      ),
      itemCount: suggestions.length,
    );
  }
}
