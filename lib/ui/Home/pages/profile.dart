import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/shared/delayed_animation.dart';
import 'package:trevo/ui/Home/pages/logoutButton.dart';
import 'package:trevo/ui/Tiles/profileTile.dart';
import 'package:trevo/utils/auth.dart';
import 'package:trevo/utils/databaseService.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String name = '';
  String email = '';

  void retrieve() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    setState(() {
      name = sharedPreferences.getString('name') ?? 'User Name';
      email = sharedPreferences.getString('email') ?? 'User Email';
    });
  }

  @override
  void initState() {
    super.initState();
    retrieve();
  }

  double height, width;

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<AuthService>(context);
    DatabaseService databaseService =
        new DatabaseService(uid: profileProvider.getCurrentUserUid());

    width = MediaQuery.of(context).size.width;
    return DelayedAnimation(
      delay: 10,
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                greeting(),
                style: TextStyle(
                    color: BottleGreen,
                    fontWeight: FontWeight.w300,
                    fontFamily: 'Montserrat',
                    fontSize: 24),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5,
              ),
              ProfileTile(
                width: width,
                icon: Icons.person,
                title: 'Name',
                description: name,
                dbHelper: databaseService,
              ),
              ProfileTile(
                width: width,
                icon: Icons.email,
                title: 'Email',
                description: email,
                dbHelper: databaseService,
              ),
              ProfileTile(
                width: width,
                icon: Icons.notifications,
                title: 'Notifications',
                description: 'Always Send',
                dbHelper: databaseService,
              ),
              ProfileTile(
                width: width,
                icon: Icons.info,
                title: 'Transactions',
                description: 'Your travel plans',
                dbHelper: databaseService,
              ),
              Logout(),
            ],
          ),
        ),
      ),
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning!';
    }
    if (hour < 17) {
      return 'Good Afternoon!';
    }
    return 'Good Evening!';
  }
}
