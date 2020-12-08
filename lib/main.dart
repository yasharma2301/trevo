import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:trevo/shared/globalFunctions.dart';
import 'package:trevo/ui/Home/home.dart';
import 'package:trevo/ui/onBoard/onBoard.dart';
import 'package:trevo/utils/auth.dart';
import 'package:trevo/utils/locationProvider.dart';
import 'package:trevo/utils/placesProvider.dart';
import 'package:camera/camera.dart';

List<CameraDescription> cameras;
String cityName;
double latitude;
double longitude;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  bool isLocationServiceEnabled = await Geolocator.isLocationServiceEnabled();
  try{
    if (isLocationServiceEnabled) {
      final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium);
      var currentUserLatLong =
      new Coordinates(position.latitude, position.longitude);
      final address =
      await Geocoder.local.findAddressesFromCoordinates(currentUserLatLong);

      final first = address.first;
      cityName = first.locality;
      latitude = first.coordinates.latitude;
      longitude = first.coordinates.longitude;
    } else {
      // Basically India Gate's coordinates
      cityName = "Delhi";
      latitude = 28.6129;
      longitude = 77.2295;
    }
  }catch(e){
    print('main.dart-Exception: '+e);
    cityName = "Delhi";
    latitude = 28.6129;
    longitude = 77.2295;
  }
  cameras = await availableCameras();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        ChangeNotifierProvider<LocationProviderClass>(
          create: (_) => LocationProviderClass(cityName),
        ),
        ChangeNotifierProvider<PlacesProvider>(
          create: (_) => PlacesProvider(cityName),
        ),
        StreamProvider(
          create: (context) => context.read<AuthService>().authStateChange,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Trevo',
        theme: ThemeData(
          primarySwatch: Colors.teal,
        ),
        home: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseMessaging _fcm = FirebaseMessaging();

  @override
  void initState() {

    _fcm.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("on: $message");
        final notification = message['notification'];
        try{
          Future.delayed(Duration.zero, () {
            showNormalFlashBar(notification['title'],notification['body'],context);
          });
        }catch(e){
          print(e);
        }
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();
    return SafeArea(
      child: Container(
        child: firebaseUser == null ? OnBoard() : Home(),
      ),
    );
  }
}