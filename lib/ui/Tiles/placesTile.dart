import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trevo/shared/colors.dart';

class PlacesTile extends StatelessWidget {
  final imageUrl, description, attractionName, distance, readMore;

  const PlacesTile(
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
            child: Hero(
              tag: imageUrl,
              child: Container(
                height: 190,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: BottleGreen,
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
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  attractionName,
                  style: TextStyle(
                      fontSize: 19,
                      color: BottleGreen,
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold),
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
                              distance,
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

class ReadAboutPlace extends StatefulWidget {
  final imageUrl, description, attractionName, distance, readMore;

  const ReadAboutPlace(
      {Key key,
      this.imageUrl,
      this.description,
      this.attractionName,
      this.distance,
      this.readMore})
      : super(key: key);

  @override
  _ReadAboutPlaceState createState() => _ReadAboutPlaceState();
}

class _ReadAboutPlaceState extends State<ReadAboutPlace> {
  double height, width;

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: White,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: widget.imageUrl,
            child: Stack(
              children: [
                Container(
                  height: 400,
                  width: width,
                  decoration: BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: DecorationImage(
                        image: NetworkImage(widget.imageUrl),
                        fit: BoxFit.cover),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, White]),
                      shape: BoxShape.rectangle,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Material(
                    color: Colors.transparent,
                    elevation: 30,
                    child: Container(
                      height: 60,
                      width: 60,
                      decoration:
                          BoxDecoration(color: White, shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(
                          Icons.link,
                          color: BottleGreen,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Row(
                    children: [
                      Icon(Icons.location_on),
                      Material(
                        color: Colors.transparent,
                        child: Text(
                          widget.distance,
                          style: TextStyle(
                              color: BottleGreen,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Montserrat',
                              fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    widget.attractionName,
                    style: TextStyle(
                        color: BottleGreen,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 28),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.description,
                    style: TextStyle(
                        color: BottleGreen,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Montserrat',
                        fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
