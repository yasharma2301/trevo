import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trevo/Models/places.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/TrevoBot/chat.dart';

class Transactions extends StatefulWidget {
  @override
  _TransactionsState createState() => _TransactionsState();
}

class _TransactionsState extends State<Transactions> {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<DocumentSnapshot>> getData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    QuerySnapshot qn = await db
        .collection('users')
        .doc(sharedPreferences.get('uid'))
        .collection('transactions')
        .get();
    return qn.docs;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: BottleGreen,
          centerTitle: true,
          title: Text(
            'Trip Transactions',
            style: TextStyle(
                fontFamily: 'Montserrat', fontWeight: FontWeight.bold),
          ),
        ),
        backgroundColor: LightGrey,
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemBuilder: (context, index) {
                      DocumentSnapshot documentSnapshot = snapshot.data[index];
                      return Container(
                        child: TransactionTile(
                          documentSnapshot: documentSnapshot,
                          index: index,
                        ),
                      );
                    },
                    itemCount: snapshot.data.length);
              }
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search,size: 50,color: BottleGreen,),
                      SizedBox(height: 20,),
                      Text(
                        'You don\'t have any travel plans configured till now.\n\nChat with Trevo to add some transactions.',
                        style: TextStyle(
                            color: BottleGreen,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize: 19),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Center(
                  child: SpinKitCircle(
                color: BottleGreen,
              ));
            }
          },
        ),
      ),
    );
  }
}

class TransactionTile extends StatefulWidget {
  final documentSnapshot, index;

  const TransactionTile({Key key, this.documentSnapshot, this.index})
      : super(key: key);

  @override
  _TransactionTileState createState() => _TransactionTileState();
}

class _TransactionTileState extends State<TransactionTile> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: AnimatedContainer(
        curve: Curves.easeInOut,
        duration: Duration(seconds: 2),
        width: width,
        decoration: BoxDecoration(
            color: White,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 1.0), //(x,y)
                blurRadius: 6.0,
              )
            ],
            borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned(
                left: -50,
                child: Icon(
                  Icons.apps,
                  size: 140,
                  color: BottleGreen.withOpacity(0.04),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Center(
                child: TransactionTileRow(
                  documentSnapshot: widget.documentSnapshot,
                  index: widget.index,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TransactionTileRow extends StatefulWidget {
  final documentSnapshot, index;

  const TransactionTileRow({Key key, this.documentSnapshot, this.index})
      : super(key: key);

  @override
  _TransactionTileRowState createState() => _TransactionTileRowState();
}

class _TransactionTileRowState extends State<TransactionTileRow>
    with SingleTickerProviderStateMixin {
  bool isClosed = true;
  AnimationController animationController;
  Animation<double> animation;
  List<String> flightLocalMessage;
  List<String> finalMessageLocal;
  List<String> finalMessageLinks;
  PlacesAPI placesAPI;

  @override
  void initState() {
    super.initState();
    String message = widget.documentSnapshot['transactionText'];
    finalMessageLocal = message.split("~~~");
    placesAPI = PlacesAPI.fromJson(jsonDecode(finalMessageLocal[1]));
    finalMessageLinks = finalMessageLocal[2].split("```");

    animationController =
        AnimationController(duration: Duration(milliseconds: 500), vsync: this);
    final curvedAnimation = CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceOut,
        reverseCurve: Curves.easeIn);

    animation =
        Tween<double>(begin: -pi / 2, end: pi / 2).animate(curvedAnimation)
          ..addListener(() {
            setState(() {});
          });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return isClosed
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    'Trip Plan ' + (widget.index + 1).toString(),
                    style: TextStyle(
                        color: BottleGreen,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                        fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    returnDate(widget.documentSnapshot['timeStamp']),
                    style: TextStyle(
                        color: BottleGreen,
                        fontWeight: FontWeight.w300,
                        fontFamily: 'Montserrat',
                        fontSize: 17),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              SizedBox(
                width: 25,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isClosed = !isClosed;
                    if (!isClosed)
                      animationController.forward();
                    else
                      animationController.reverse();
                  });
                },
                child: Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[400],
                          offset: Offset(0.0, 1.0), //(x,y)
                          blurRadius: 6.0,
                        )
                      ]),
                  child: Transform.rotate(
                    angle: animation.value,
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: BottleGreen,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          )
        : Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Trip Plan ' + (widget.index + 1).toString(),
                        style: TextStyle(
                            color: BottleGreen,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat',
                            fontSize: 20),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        returnDate(widget.documentSnapshot['timeStamp']),
                        style: TextStyle(
                            color: BottleGreen,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Montserrat',
                            fontSize: 17),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isClosed = !isClosed;
                        if (!isClosed)
                          animationController.forward();
                        else
                          animationController.reverse();
                      });
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[400],
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            )
                          ]),
                      child: Transform.rotate(
                        angle: animation.value,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: BottleGreen,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              FinalMessageWidget(
                message: finalMessageLocal[0],
                messageJson: placesAPI,
                messageList: finalMessageLinks,
                textColor: Black,
              ),
            ],
          );
  }

  String returnDate(timeInMillis) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeInMillis);
    var formattedDate = DateFormat.yMMMd().format(date);
    return formattedDate;
  }
}
