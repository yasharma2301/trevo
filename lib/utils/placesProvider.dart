import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trevo/Models/places.dart';

class PlacesProvider with ChangeNotifier {
  bool loading = true;
  String error;
  PlacesAPI placesAPI = new PlacesAPI();

  Future<bool> fetchAttractions(String cityName) async {
    setLoading(true);
    await PlacesAPICall(cityName).fetchAttractionsFromAPI().then((data) {
      if (data.statusCode == 200) {
        placesAPI = PlacesAPI.fromJson(jsonDecode(data.body));
        print(placesAPI.totalCount);
        setLoading(false);
        notifyListeners();
        return true;
      } else {
        print('error');
        return false;
      }
    });
  }

  void setError(value) {
    error = value;
    notifyListeners();
  }

  String getError() {
    return error;
  }
  void setLoading(value) {
    loading = value;
    notifyListeners();
  }

  bool isLoading() {
    return loading;
  }
}

class PlacesAPICall {
  final String cityName;
  final String baseUrl = 'https://trevo-server.herokuapp.com/attractions/';

  PlacesAPICall(this.cityName);

  Future<http.Response> fetchAttractionsFromAPI() {
    return http.get(baseUrl + cityName);

  }
}
