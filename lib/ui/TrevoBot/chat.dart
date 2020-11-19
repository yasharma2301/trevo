import 'package:bubble/bubble.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:trevo/shared/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dialogflow/dialogflow_v2.dart';

List<Map> messages = List();

class ChatBot extends StatefulWidget {
  @override
  _ChatBotState createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {
  void response(query) async {
    AuthGoogle authGoogle =
        await AuthGoogle(fileJson: "assets/trevo-brua-9223455e375a.json")
            .build();
    Dialogflow dialogflow =
        Dialogflow(authGoogle: authGoogle, language: Language.english);
    AIResponse aiResponse = await dialogflow.detectIntent(query);
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
                            itemBuilder: (context, index) => ChatBubbleUI(
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

  Widget ChatBubbleUI(String message, int data) {
    message = data == 0 ? message.substring(1, message.length - 1) : message;

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
                  child: Text(
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
