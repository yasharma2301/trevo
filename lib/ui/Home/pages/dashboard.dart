import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:provider/provider.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/DataDisplay/displayPlaces.dart';
import 'package:trevo/ui/DataDisplay/displayRestaurants.dart';
import 'package:trevo/ui/DataDisplay/display_hotels.dart';
import 'package:trevo/ui/Home/pages/cameraTab.dart';
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
              IconButton(
                icon: Icon(Icons.search),
                color: White,
                onPressed: () async {
                  var result = await showSearch<String>(
                      context: context, delegate: DataSearch());
                  if (result != null) {
                    locationProvider.setCityName(result);
                    placesProvider.fetchAttractions(result);
                  }
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
        title: Container(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Trevo',
                style: TextStyle(
                    fontSize: 19,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold),
              ),
              Row(
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
                    locationProvider.cityName,
                    style: TextStyle(
                        fontSize: 18,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
        ),
        bottom: TabBar(
          isScrollable: true,
          controller: _tabController,
          indicatorColor: Colors.white,
          labelPadding: EdgeInsets.symmetric(horizontal: 20.0),
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
          DisplayPlaces(
            placesProvider: placesProvider,
            cityName: locationProvider.cityName,
          ),
          DisplayHotels(locationProvider.cityName),
          DisplayRestaurants(locationProvider.cityName),
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
    "Dallas",
    "Dehradun",
    "Delhi",
    "Dubai",
    "Dublin",
    "Durban",
    "Edinburgh",
    "Guwahati",
    "Hanoi",
    "Houston",
    "Hyderabad",
    "Imphal",
    "Indore",
    "Istanbul",
    "Jabalpur",
    "Jaipur",
    "Jerusalem",
    "Johannesburg",
    "Kannur",
    "Kochi",
    "Kolkata",
    "Kozhikode",
    "Las-vegas",
    "London",
    "Lucknow",
    "Madrid",
    "Madurai",
    "Mangalore",
    "Manila",
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
                element.toLowerCase().contains(query) && element.toLowerCase().startsWith(query))
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
