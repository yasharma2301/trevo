import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Home/Data%20Display/display_hotels.dart';
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.search),
                  color: White,
                  onPressed: () async {
                    var result = await showSearch<String>(
                        context: context, delegate: DataSearch());
                    setState(() {
                      if (result != null) {
                        cityName = result;
                      }
                    });
                  },
                ),
              ],
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
          title: Row(
            children: [
              Text('Trevo'),
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 50),
                child: Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      color: Colors.blue,
                      size: 22,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      cityName,
                      style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        /*fontWeight: FontWeight.bold*/
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
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
          children: [Places(), DisplayHotels(cityName), Restaurants()],
        ),
      ),
    );
  }
}

class DataSearch extends SearchDelegate<String> {
  final cities = [
    "Abu Dhabi",
    "Agra",
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
    "Buenos Aires",
    "Cairo",
    "Cancún",
    "Cape Town",
    "Chandigarh",
    "Chennai",
    "Chennai",
    "Chicago",
    "Coimbatore",
    "Dabolim",
    "Dallas",
    "Dammam",
    "Dehradun",
    "Delhi",
    "Denpasar",
    "Dubai",
    "Dublin",
    "Durban",
    "Edinburgh",
    "Florence",
    "Gaya",
    "Guangzhou",
    "Guwahati",
    "Hamburg",
    "Hanoi",
    "Ho Chi Minh City",
    "Hong Kong",
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
    "Kuala Lumpur",
    "Kyoto",
    "Lagos",
    "Las Vegas",
    "Lima",
    "Lisbon",
    "London",
    "Los Angeles",
    "Lucknow",
    "Macau",
    "Madrid",
    "Madurai",
    "Mangalore",
    "Mangalore",
    "Manila",
    "Mecca",
    "Medina",
    "Miami",
    "Milan",
    "Montreal",
    "Moscow",
    "Mumbai",
    "Mumbai",
    "Munich",
    "Nagpur",
    "Nashik",
    "New York City",
    "Nice",
    "Orlando",
    "Osaka",
    "Paris",
    "Pattaya",
    "Philadelphia",
    "Phuket",
    "Port Blair",
    "Prague",
    "Pune",
    "Rio de Janeiro",
    "Riyadh",
    "Rome",
    "Saint Petersburg",
    "San Francisco",
    "San Jose",
    "Seoul",
    "Shanghai",
    "Shenzhen",
    "Siliguri",
    "Singapore",
    "Srinagar",
    "Stockholm",
    "Surat",
    "Sydney",
    "São Paulo",
    "Taipei",
    "Tehran",
    "Tel Aviv",
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
    "Washington D.C.",
    "Xiamen",
    "Zhuhai",
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
