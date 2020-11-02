import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/shared/delayed_animation.dart';
import 'package:trevo/ui/login/login.dart';

class OnBoard extends StatefulWidget {
  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> with  SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: LightGrey,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40,vertical: 40),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              DelayedAnimation(
                delay: 200,
                child: Container(
                  height: 160,
                  width: 160,
                  child: FlareActor('assets/botra.flr',
                      alignment: Alignment.center,
                      fit: BoxFit.contain,
                      animation: "Alarm"),
                ),
              ),
              SizedBox(
                height: 50,
              ),
              DelayedAnimation(
                delay: 500,
                child: Text(
                  'Hi There!\nI am Trevo',
                  style: TextStyle(
                      color: Teal.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                      fontSize: 32),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              DelayedAnimation(
                delay: 850,
                child: Text(
                  'Your personal travel assistant.\n',
                  style: TextStyle(
                      color: BottleGreen.withOpacity(0.7),
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Montserrat',
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 35,
              ),
              DelayedAnimation(
                delay: 1000,
                child: Text(
                  'Just a few steps and we\'ll get you in the server\n',
                  style: TextStyle(
                      color: BottleGreen.withOpacity(0.4),
                      fontWeight: FontWeight.w300,
                      fontFamily: 'Montserrat',
                      fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50,
              ),
              DelayedAnimation(
                delay: 1200,
                child: GestureDetector(
                  onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Login()));
                  },
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Transform.scale(
                    scale: _scale,
                    child: Container(
                      height: 60,
                      width: width - width * 0.2,
                      decoration: BoxDecoration(
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 10.0,
                              offset: Offset(0.0, 5))
                        ],
                        borderRadius: BorderRadius.circular(50),
                        gradient: LinearGradient(
                            colors: [
                              BottleGreen.withOpacity(0.8),
                              Teal,
                            ],
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.topRight,
                            tileMode: TileMode.repeated),
                      ),
                      child: Center(
                        child: Text(
                          'Let\'s start!',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
