import 'package:flutter/material.dart';
import 'package:trevo/shared/colors.dart';

class ProfileTile extends StatefulWidget {
  final width, title, description, icon, dbHelper;

  ProfileTile(
      {Key key, this.width, this.title, this.description, this.icon, this.dbHelper})
      : super(key: key);

  @override
  _ProfileTileState createState() => _ProfileTileState();
}

class _ProfileTileState extends State<ProfileTile> {
  bool isSwitched = true;

  void notificationStatus() {
    widget.dbHelper.getUser().then((value) =>
    {
      setState(() {
        isSwitched = value.notifications == 1 ? true : false;
      })
    });
  }
  void _handleSwitch(bool value) async {
    if( value ) {
      await widget.dbHelper.updateNotificationChannel(1);;
    } else {
      await widget.dbHelper.updateNotificationChannel(0);;
    }
    setState(() {
      isSwitched = value;
    });
  }
  @override
  void initState() {
    super.initState();
    notificationStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        height: 100,
        width: widget.width,
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
                right: -50,
                bottom: -50,
                child: Icon(
                  Icons.apps,
                  size: 140,
                  color: BottleGreen.withOpacity(0.03),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey[300],
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            )
                          ]),
                      child: Icon(
                        widget.icon,
                        color: BottleGreen,
                      ),
                    ),
                    SizedBox(
                      width: 25,
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          widget.title,
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
                  ],
                ),
              ),
            ),
            IgnorePointer(
              ignoring: widget.title == "Notifications" ? false : true,
              child: Opacity(
                opacity: widget.title == "Notifications" ? 1 : 0,
                child: Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Switch(
                      onChanged: (value) async {
                        await _handleSwitch(value);
                      },
                      value: isSwitched,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
