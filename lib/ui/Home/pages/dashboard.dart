import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Home/pages/dashboardPages/cameraTab.dart';
import 'package:trevo/ui/Home/pages/dashboardPages/hotels.dart';
import 'package:trevo/ui/Home/pages/dashboardPages/places.dart';
import 'package:trevo/ui/Home/pages/dashboardPages/restaurants.dart';
import 'package:trevo/utils/locationProvider.dart';
import 'package:trevo/utils/placesProvider.dart';

class DashBoard extends StatefulWidget {
  final placesProvider, locationProvider;

  const DashBoard({Key key, this.placesProvider, this.locationProvider})
      : super(key: key);

  @override
  _DashBoardState createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard>
    with SingleTickerProviderStateMixin {
  Coordinates currentUserLatLong;
  TabController _tabController;
  bool showExtra = true;

  @override
  void initState() {
     widget.placesProvider.fetchAttractions(widget.locationProvider.cityName);
    super.initState();
    _tabController = TabController(vsync: this, initialIndex: 1, length: 4);
    _tabController.addListener(() {
      if (_tabController.index == 1) {
        showExtra = true;
      } else {
        showExtra = false;
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final locationProvider = Provider.of<LocationProviderClass>(context);
    final placesProvider = Provider.of<PlacesProvider>(context);
    return Scaffold(
      backgroundColor: LightGrey,
      appBar: AppBar(
        actions: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                locationProvider.cityName,
                style: TextStyle(fontSize: 18),
              ),
              IconButton(
                icon: Icon(Icons.search),
                color: White,
                onPressed: () async {
                  var result = await showSearch<String>(
                      context: context, delegate: DataSearch());
                  setState(() {
                    if (result != null) {
                      locationProvider.setCityName(result);
                      placesProvider.fetchAttractions(result);
                    }
                  });
                },
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
        ],
        elevation: 10,
        backgroundColor: BottleGreen,
        title: Text('Trevo'),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorColor: Colors.white,
          labelPadding: EdgeInsets.symmetric(horizontal:20.0),
          indicatorWeight: 3,
          tabs: [
            Tab(
              icon: Icon(
                Icons.camera_alt,
              ),
            ),
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
        controller: _tabController,
        children: [
          CameraTab(),
          Places(
            placesProvider: placesProvider,
            cityName: locationProvider.cityName,
          ),
          Hotels(),
          Restaurants()
        ],
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final cities = [
    "Agra",
    "Ahmedabad",
    "Amritsar",
    "Amsterdam",
    "Antalya",
    "Athens",
    "Atlanta",
    "Auckland",
    "Bangalore",
    "Bangkok",
    "Barcelona",
    "Beijing",
    "Beirut",
    "Berlin",
    "Bhubaneswar",
    "Boston",
    "Brussels",
    "Budapest",
    "Cairo",
    "Chandigarh",
    "Chennai",
    "Chennai",
    "Chicago",
    "Coimbatore",
    "Dabolim",
    "Dallas",
    "Dehradun",
    "Delhi",
    "Dubai",
    "Dublin",
    "Durban",
    "Edinburgh",
    "Florence",
    "Gaya",
    "Guwahati",
    "Hanoi",
    "Houston",
    "Hyderabad",
    "Imphal",
    "Indore",
    "Istanbul",
    "Jabalpur",
    "Jaipur",
    "Jakarta",
    "Jerusalem",
    "Johannesburg",
    "Kannur",
    "Kochi",
    "Kolkata",
    "Kozhikode",
    "Kyoto",
    "Lagos",
    "Las-vegas",
    "Lisbon",
    "London",
    "Lucknow",
    "Macau",
    "Madrid",
    "Madurai",
    "Mangalore",
    "Manila",
    "Mecca",
    "Medina",
    "Miami",
    "Milan",
    "Montreal",
    "Moscow",
    "Mumbai",
    "Munich",
    "Nagpur",
    "New-york-city",
    "Orlando",
    "Osaka",
    "Paris",
    "Pattaya",
    "Philadelphia",
    "Phuket",
    "Prague",
    "Pune",
    "Riyadh",
    "Rome",
    "San-francisco",
    "San-Jose",
    "Seoul",
    "Shanghai",
    "Shenzhen",
    "Siliguri",
    "Singapore",
    "Srinagar",
    "Stockholm",
    "Surat",
    "Sydney",
    "Sao-Paulo",
    "Taipei",
    "Tehran",
    "Tel-aviv",
    "Thiruvananthapuram",
    "Tiruchirappalli",
    "Tokyo",
    "Toronto",
    "Vadodara",
    "Vancouver",
    "Varanasi",
    "Venice",
    "Vienna",
    "Warsaw",
    "Washington-dc",
  ];

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
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = query.isEmpty
        ? cities
        : cities
            .where((element) =>
                element.contains(query) && element.startsWith(query))
            .toList();

    return ListView.builder(
      itemBuilder: (context, index) => ListTile(
        onTap: () {
          close(context, suggestions[index]);
        },
        leading: Icon(Icons.location_city),
        title: RichText(
          text: TextSpan(
              text: suggestions[index].substring(0, query.length),
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 17),
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
