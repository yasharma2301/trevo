import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/ui/Home/pages/dashboard.dart';
import 'package:trevo/ui/Home/pages/feed.dart';
import 'package:trevo/ui/Home/pages/profile.dart';
import 'package:trevo/ui/TrevoBot/chat.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: LightGrey,
          floatingActionButton: FloatingActionButton(
              elevation: 10,
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (context) => ChatBot()));
              },
              child: FlareActor('assets/botra.flr',
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                  animation: "Alarm"),
              backgroundColor: White,
              tooltip: "Access Assistant"),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          bottomNavigationBar: BubbleBottomBar(
            items: <BubbleBottomBarItem>[
              BubbleBottomBarItem(
                backgroundColor: BottleGreen,
                icon: Icon(
                  Icons.dashboard,
                  color: BottleGreen,
                ),
                activeIcon: Icon(
                  Icons.dashboard,
                  color: BottleGreen,
                ),
                title: Text('Home'),
              ),
              BubbleBottomBarItem(
                backgroundColor: BottleGreen,
                icon: Icon(
                  Icons.create,
                  color: BottleGreen,
                ),
                activeIcon: Icon(
                  Icons.create,
                  color: BottleGreen,
                ),
                title: Text('MyFeed'),
              ),
              BubbleBottomBarItem(
                backgroundColor: BottleGreen,
                icon: Icon(
                  Icons.person,
                  color: BottleGreen,
                ),
                activeIcon: Icon(
                  Icons.person,
                  color: BottleGreen,
                ),
                title: Text('Profile'),
              ),
            ],
            opacity: 0.2,
            backgroundColor: White,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            currentIndex: currentIndex,
            onTap: changePage,
            hasInk: true,
            inkColor: Colors.black12,
            hasNotch: true,
            fabLocation: BubbleBottomBarFabLocation.end,
            elevation: 10,
          ),
          body: (currentIndex == 0)
              ? DashBoard()
              : (currentIndex == 1) ? Feed() : Profile()),
    );
  }
}
