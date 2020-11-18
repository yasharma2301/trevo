class PlacesAPI {
  int totalCount;
  String cityName;
  List<Places> places;

  PlacesAPI({this.totalCount, this.cityName, this.places});

  PlacesAPI.fromJson(Map<String, dynamic> json) {
    totalCount = json['totalCount'];
    cityName = json['cityName'];
    if (json['places'] != null) {
      places = new List<Places>();
      json['places'].forEach((v) {
        places.add(new Places.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCount'] = this.totalCount;
    data['cityName'] = this.cityName;
    if (this.places != null) {
      data['places'] = this.places.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Places {
  int index;
  String attractionName;
  String distance;
  String description;
  String readMore;
  String picture;

  Places(
      {this.index,
        this.attractionName,
        this.distance,
        this.description,
        this.readMore,
        this.picture});

  Places.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    attractionName = json['attractionName'];
    distance = json['distance'];
    description = json['description'];
    readMore = json['readMore'];
    picture = json['picture'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['index'] = this.index;
    data['attractionName'] = this.attractionName;
    data['distance'] = this.distance;
    data['description'] = this.description;
    data['readMore'] = this.readMore;
    data['picture'] = this.picture;
    return data;
  }
}