import 'package:flutter/cupertino.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProviderClass with ChangeNotifier{
  String cityName="Delhi";
  double latitude;
  double longitude;
  bool locationServiceActive = true;

  Future<void> updateCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    var currentUserLatLong = new Coordinates(position.latitude, position.longitude);
    final address =
    await Geocoder.local.findAddressesFromCoordinates(currentUserLatLong);
    final first = address.first;
    latitude = first.coordinates.latitude;
    longitude = first.coordinates.longitude;
    cityName = first.locality;
    notifyListeners();
  }

  Future<bool> checkGPS() async{
    bool conn = await Geolocator.isLocationServiceEnabled();
    if(conn == false){
      locationServiceActive = false;
    } else {
      locationServiceActive = true;
    }
    notifyListeners();
    return conn;
  }

  LocationProviderClass(){
    checkGPS().then((value) {
      if(value){
          updateCurrentLocation();
      }
    });
  }

  void setCityName(String city){
    cityName = city;
    notifyListeners();
  }

  String getCity(){
    return cityName;
  }

  double getLatitude(){
    return latitude;
}

  double getLongitude(){
    return longitude;
  }
}