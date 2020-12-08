import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Tiles/placesTile.dart';

class HotelTile extends StatelessWidget {
  final imgUrl, hotelName, hotelPrice,bookingUrl;

  HotelTile({
    this.hotelName,
    this.imgUrl,
    this.hotelPrice,
    this.bookingUrl
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 7.5, right: 7.5, bottom: 15),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            child: Swiper(
              itemBuilder: (_, imgIndex) {
                return ClipRRect(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(5)),
                    child: Image.network(
                      imgUrl[imgIndex],
                      fit: BoxFit.fill,
                      errorBuilder: (_, __, ___) {
                        return Container(
                          color: BottleGreen,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  color: LightGrey,
                                  size: 35,
                                ),
                                Text(
                                  'Aww snap!\nCannot load at the moment.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                    /*CachedNetworkImage(
                    imageUrl: imgUrl[imgIndex],
                    fit: BoxFit.fill,
                    height: 200,
                    errorWidget: (_, __, ___)=> Icon(Icons.error,size: 40,),
                  ),*/
                    );
              },
              scale: 0.9,
              viewportFraction: 0.8,
              itemCount: imgUrl.length,
              pagination: SwiperPagination(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 10),
                  child: Text(
                    hotelName,
                    style: TextStyle(
                        fontSize: 19,
                        color: BottleGreen,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30),
                          height: 40,
                          width: 80,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Text(hotelPrice,
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.bold)),
                        )
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => DisplayLink(
                              link: bookingUrl,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        margin: EdgeInsets.only(right: 10),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.blueAccent[100].withOpacity(0.1),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'Book',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: BottleGreen,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400),
                            ),
                            Icon(
                              Icons.chevron_right,
                              color: Colors.blueAccent[100],
                              size: 32,
                            ),
                          ],
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
