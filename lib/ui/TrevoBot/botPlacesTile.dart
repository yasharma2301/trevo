import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Tiles/placesTile.dart';

class BotPlacesTile extends StatelessWidget {
  final imageUrl, description, attractionName, distance, readMore;

  const BotPlacesTile(
      {Key key,
        this.imageUrl,
        this.description,
        this.attractionName,
        this.distance,
        this.readMore})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            elevation: 4,
            child: Hero(
              tag: imageUrl,
              child: Container(
                height: 160,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Teal,
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(5),
                      topLeft: Radius.circular(5)),
                ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object exception,
                      StackTrace stackTrace) {
                    return Center(
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
                    );
                  },
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  attractionName,
                  style: TextStyle(
                      fontSize: 18,
                      color: BottleGreen,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 2,
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 5),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.redAccent[100].withOpacity(0.2),
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.redAccent[100],
                              size: 28,
                            ),
                            Text(
                              distance.toString().split('km')[0]+' kms',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  color: BottleGreen,
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w400),
                            )
                          ],
                        ),
                      ),
                      Material(
                        color: Colors.transparent,
                        child: InkWell(
                          splashColor: Colors.blueAccent[100].withOpacity(0.6),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ReadAboutPlace(
                                  attractionName: attractionName,
                                  imageUrl: imageUrl,
                                  description: description,
                                  readMore: readMore,
                                  distance: distance,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                                color: Colors.blueAccent[100].withOpacity(0.2),
                                borderRadius: BorderRadius.circular(5)),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  'Read More',
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
                                  size: 28,
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
