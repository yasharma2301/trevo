import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trevo/Models/places.dart';
import 'package:trevo/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';
import 'package:trevo/ui/Tiles/placesTile.dart';

import 'botPlacesTile.dart';

List<Map> messages = List();

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  @override
  void initState() {
    if(messages.isEmpty){
      messages.insert(0, {
        "data": 0,
        "message": "HHi there! How can I help??"
      });
    }
    super.initState();
  }
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/trevo-brua-9223455e375a.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
    try{
      if (aiResponse
          .getListMessage()[0]["text"]["text"][0]
          .toString()
          .startsWith("This is what I've configured")) {
        // Post transaction to firebase
        addNewTransaction(
            aiResponse.getListMessage()[0]["text"]["text"][0].toString());
      }
    }catch(e){
      print(e);
    }
    setState(() {
      messages.insert(0, {
        "data": 0,
        "message": aiResponse.getListMessage()[0]["text"]["text"].toString()
      });
    });
  }

  final messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Travel Assistant'),
            backgroundColor: Teal,
          ),
          backgroundColor: LightGrey,
          body: Stack(
            children: [
              Center(
                child: Opacity(
                  opacity: 0.5,
                  child: Container(
                    height: 220,
                    width: 220,
                    child: FlareActor('assets/botra.flr',
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "Alarm"),
                  ),
                ),
              ),
              Container(
                child: Column(
                  children: [
                    SizedBox(
                      height: 3,
                    ),
                    Flexible(
                        child: ListView.builder(
                            reverse: true,
                            itemCount: messages.length,
                            itemBuilder: (context, index) => chatBubbleUI(
                                messages[index]["message"].toString(),
                                messages[index]["data"]))),
                    Divider(
                      height: 3,
                      color: BottleGreen,
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 3, left: 5),
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Teal.withOpacity(0.15)),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: TextField(
                                  controller: messageController,
                                  cursorColor:
                                      Theme.of(context).primaryColorLight,
                                  style: TextStyle(
                                    color: BottleGreen,
                                    fontSize: 18,
                                  ),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Enter your message here",
                                      hintStyle: TextStyle(
                                          color: BottleGreen, fontSize: 16)),
                                ),
                              ),
                            ),
                          ),
                          Hero(
                            tag: 'animation2',
                            child: Material(
                              color: Colors.transparent,
                              child: Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Teal.withOpacity(0.15)),
                                margin: EdgeInsets.symmetric(horizontal: 4),
                                child: IconButton(
                                  icon: Icon(Icons.send),
                                  onPressed: () {
                                    if (messageController.text.isEmpty) {
                                      print('empty Message');
                                    } else {
                                      setState(() {
                                        messages.insert(0, {
                                          "data": 1,
                                          "message": messageController.text
                                        });
                                      });
                                      response(messageController.text);
                                      messageController.clear();
                                    }
                                  },
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          )),
    );
  }

  void addNewTransaction(String transactionText) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String uid = sharedPreferences.get('uid');
    CollectionReference collectionRef = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('transactions');
    Map<String, dynamic> data = {
      'timeStamp': DateTime.now().millisecondsSinceEpoch,
      'transactionText': transactionText,
    };
    collectionRef.add(data);
  }

  Widget chatBubbleUI(String message, int data) {
    message = data == 0 ? message.substring(1, message.length - 1) : message;
    List<String> flightLocalMessage;
    List<String> finalMessageLocal;
    List<String> finalMessageLinks;
    PlacesAPI placesAPI;

    if (message.startsWith("Here are some details:")) {
      flightLocalMessage = message.split("```");
    }
    if (message.startsWith("This is what I've configured")) {
      finalMessageLocal = message.split("~~~");
      placesAPI = PlacesAPI.fromJson(jsonDecode(finalMessageLocal[1]));
      finalMessageLinks = finalMessageLocal[2].split("```");
    }

    return Padding(
      padding: EdgeInsets.only(
          top: 5,
          bottom: 7,
          left: data == 0 ? 10 : 50,
          right: data == 0 ? 50 : 10),
      child: Bubble(
        radius: Radius.circular(10.0),
        color: data == 0 ? BottleGreen : Teal.withOpacity(0.8),
        elevation: 0.0,
        alignment: data == 0 ? Alignment.topLeft : Alignment.topRight,
        nip: data == 0 ? BubbleNip.leftTop : BubbleNip.rightBottom,
        child: Padding(
          padding: EdgeInsets.all(2.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Flexible(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
                  child: message.startsWith("Here are some details:")
                      ? FlightMessage(
                          messageList: flightLocalMessage,
                        )
                      : message.startsWith("This is what I've configured")
                          ? FinalMessageWidget(
                              message: finalMessageLocal[0],
                              messageJson: placesAPI,
                              messageList: finalMessageLinks,
                              textColor: White,
                            )
                          : Text(
                              message,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16.5),
                            ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class FlightMessage extends StatelessWidget {
  final messageList;

  const FlightMessage({Key key, this.messageList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          messageList[0],
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.5),
        ),
        ReadMoreButton(
          link: messageList[1].toString().trim(),
        ),
        Text(
          messageList[2].toString().trim(),
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w400, fontSize: 16.5),
        ),
      ],
    );
  }
}

class FinalMessageWidget extends StatelessWidget {
  final message;
  final PlacesAPI messageJson;
  final messageList;
  final textColor;

  const FinalMessageWidget(
      {Key key,
      this.message,
      this.messageJson,
      this.messageList,
      this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          message,
          style: TextStyle(
              color: textColor, fontWeight: FontWeight.w400, fontSize: 16.5),
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            final object = messageJson.places[index];
            return BotPlacesTile(
              attractionName: object.attractionName,
              imageUrl: object.picture,
              description: object.description,
              readMore: object.readMore,
              distance: object.distance,
            );
          },
          itemCount: messageJson.places.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
        ListView.builder(
          itemBuilder: (context, index) {
            final object = messageList[index];
            if (index % 2 == 0) {
              return Text(
                object,
                style: TextStyle(
                    color: textColor,
                    fontWeight: FontWeight.w400,
                    fontSize: 16.5),
              );
            }
            return ReadMoreButton(
              link: object,
            );
          },
          itemCount: messageList.length,
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
        ),
      ],
    );
  }
}

class ReadMoreButton extends StatelessWidget {
  final link;

  const ReadMoreButton({Key key, this.link}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Align(
        alignment: Alignment.center,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => DisplayLink(
                    link: link,
                  ),
                ),
              );
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: White, width: 0.5),
                  color: Teal,
                  borderRadius: BorderRadius.circular(5)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Read More',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: White,
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: White,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
