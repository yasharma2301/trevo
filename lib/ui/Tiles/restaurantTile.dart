import 'package:flutter/material.dart';
import 'package:trevo/shared/colors.dart';

class RestaurantTile extends StatelessWidget {
  final name, address, rating, bookingUrl, imgUrl, cuisine,price;

  RestaurantTile(
      {this.name, this.address, this.rating, this.bookingUrl, this.imgUrl, this.cuisine,this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(5)
    ),
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(left: 5, right: 5, bottom: 5, top: 5),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5), color: BottleGreen),
            height: 95,
            width: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: Image.network(
                imgUrl,
                fit: BoxFit.fill,
                errorBuilder: (_, __, ___) {
                  return Center(
                    child: Icon(
                      Icons.restaurant,
                      size: 25,
                      color: Colors.white,
                    ),
                  );
                },
              ),
            ),
          ),
          Flexible(
              child: Container(
                margin: EdgeInsets.only(left: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        name,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(height: 25,
                    width: 40,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: BottleGreen,
                      borderRadius: BorderRadius.circular(4)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.star,color: Colors.white,size: 15,),
                        Text(rating,style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold))
                      ],
                    ),)
                  ],
                ),
                SizedBox(height: 5,),
                Text(cuisine,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.w400),),
                SizedBox(height: 4,),
                Text(address,
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 4,),
                Text(price+" for two people",
                  style: TextStyle(
                      fontSize: 13,
                      color: Colors.black,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.w400),
                ),
              ],
            ),
          ))
        ],
      ),
    );
  }
}
