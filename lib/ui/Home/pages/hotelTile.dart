import 'package:flutter/material.dart';
import 'package:trevo/shared/colors.dart';

class HotelTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            elevation: 4,
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5),
                    topLeft: Radius.circular(5)),
                image: DecorationImage(
                    image: NetworkImage(
                        'https://c.ndtvimg.com/2020-01/hqocblio_restaurant-_625x300_14_January_20.jpg'),
                    fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'London House, Putney',
                  style: TextStyle(
                      fontSize: 19,
                      color: BottleGreen,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.location_on,
                          color: Colors.redAccent[100],
                          size: 28,
                        ),
                        Text(
                          '12.5 kms\nfrom City Center',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16,
                              color: BottleGreen,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: (){},
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent[100].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5)
                        ),
                        child: Row(
                          children: [
                            SizedBox(width: 10,),
                            Text(
                              'ReadMore',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: BottleGreen,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.blueAccent[100],
                              size: 32,
                            ),],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
