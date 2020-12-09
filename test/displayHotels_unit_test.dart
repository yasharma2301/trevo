import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:trevo/ui/DataDisplay/display_hotels.dart';

void main()
{

  group("Display Hotels Unit Test", ()
  {
    test("Api call test when city name is correct", (){
      final hotel= new DisplayHotels("Dehradun");
      final hotelState= hotel.createState();
      hotelState.hotelNameData=[];
      hotelState.bookingUrls=[];
      hotelState.priceData=[];
      hotelState.distanceData=[];
      hotelState.getImageUrls();
      expect(hotelState.hotelNameData.isNotEmpty, true);
    });
  });
}