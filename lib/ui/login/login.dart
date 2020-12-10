import 'package:firebase_auth/firebase_auth.dart';
import 'package:flare_flutter/flare_actor.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:trevo/main.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/shared/globalFunctions.dart';
import 'package:trevo/ui/Home/home.dart';
import 'package:trevo/ui/login/signup.dart';
import 'package:trevo/utils/auth.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> with SingleTickerProviderStateMixin {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
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

  bool passwordVisible = true, passwordEmpty = true;

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<AuthService>(context);

    _scale = 1 - _controller.value;
    final double width = MediaQuery.of(context).size.width;
    final double height = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Scaffold(
        backgroundColor: LightGrey,
        body: Padding(
          padding: const EdgeInsets.only(left: 20, right: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 30,
                ),
                Hero(
                  tag: 'TrevoIcon',
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
                  height: 10,
                ),
                Text(
                  'Welcome!',
                  style: TextStyle(
                      color: Teal.withOpacity(0.8),
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Montserrat',
                      fontSize: 32),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: White.withOpacity(0.8)),
                  child: TextField(
                    onChanged: (value) {},
                    controller: _emailController,
                    style: TextStyle(color: BottleGreen),
                    decoration: InputDecoration(
                        icon: Icon(
                          Icons.email,
                          color: Teal,
                        ),
                        border: InputBorder.none,
                        hintText: "Enter Email",
                        hintStyle: TextStyle(color: Teal, fontSize: 17)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: White.withOpacity(0.8)),
                  child: TextField(
                    obscureText: passwordVisible,
                    onChanged: (value) {},
                    controller: _passwordController,
                    style: TextStyle(color: BottleGreen),
                    decoration: InputDecoration(
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          highlightColor: Colors.transparent,
                          icon: Icon(
                            passwordVisible
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: BottleGreen.withOpacity(0.6),
                          ),
                          onPressed: () {
                            setState(() {
                              passwordVisible = !passwordVisible;
                            });
                          },
                        ),
                        icon: Icon(
                          Icons.vpn_key,
                          color: Teal,
                        ),
                        border: InputBorder.none,
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Teal, fontSize: 17)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    _showHintDialog();
                  },
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                          color: Teal,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                GestureDetector(
                  onTap: () {
                    String email = _emailController.text.toString();
                    String password = _passwordController.text.toString();
                    if (email == '' || password == '') {
                      showFlashBar('Fields cannot be empty.', context);
                    } else if (!emailRegexPass(email)) {
                      showFlashBar('Please input a valid email.', context);
                    } else if (!passwordRegexPass(password)) {
                      showFlashBar(
                          'Password should be longer than 6 characters.',
                          context);
                    } else {
                      loginProvider
                          .signInWithEmailAndPassword(email, password)
                          .then((value) => {
                                Navigator.of(context).pushAndRemoveUntil(
                                    MaterialPageRoute(
                                        builder: (context) => Home()),
                                    (Route<dynamic> route) => false)
                              });
                    }
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
                        child: loginProvider.loading == true
                            ? SpinKitCircle(
                                color: LightGrey,
                                size: 35,
                              )
                            : Text(
                                'Log Me In!',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20),
                              ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SignUp()));
                  },
                  child: Text(
                    'Don\'t have an account? Sign Up.',
                    style: TextStyle(
                        color: Teal, fontWeight: FontWeight.w400, fontSize: 16),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showHintDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              backgroundColor: Colors.transparent,
              child: DialogEmail());
        });
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}

class DialogEmail extends StatefulWidget {
  @override
  _DialogEmailState createState() => _DialogEmailState();
}

class _DialogEmailState extends State<DialogEmail> {
  double width;
  double height;

  Future sendPasswordResetLink(String email){
    return FirebaseAuth.instance.sendPasswordResetEmail(email: email);
  }

  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    TextEditingController _emailController = TextEditingController();
    return Container(
      width: width,
      height: 250,
      decoration: BoxDecoration(
        color: LightGrey,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.white24,
                    offset: Offset(0, 0),
                    blurRadius: 10,
                  )
                ],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
                gradient: LinearGradient(
                    colors: [BottleGreen, DarkBottleGreen],
                    begin: FractionalOffset.topLeft,
                    end: FractionalOffset.topRight,
                    tileMode: TileMode.repeated),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 60,
                  ),
                  Text(
                    'Forgot Password',
                    style: TextStyle(
                        color: LightGrey,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrt'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        color: LightGrey,
                        size: 26,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30,left: 10,right: 10),
              child: Column(
                children: [
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: White.withOpacity(0.8)),
                    child: TextField(
                      controller: _emailController,
                      style: TextStyle(color: BottleGreen),
                      decoration: InputDecoration(
                          icon: Icon(
                            Icons.email,
                            color: Teal,
                          ),
                          border: InputBorder.none,
                          hintText: "Enter Email",
                          hintStyle:
                          TextStyle(color: Teal, fontSize: 17)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    child: InkWell(
                      onTap: () {
                        String email = _emailController.text.toString();
                        if(emailRegexPass(email)){
                          sendPasswordResetLink(email).then((value) {
                            showNormalFlashBar('Success!','A password reset link has been sent to your email.',context);
                          });
                        }else{
                          showFlashBar('Please enter a valid email!',context);
                        }
                      },
                      child: Ink(
                        width: width,
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: BottleGreen,
                        ),
                        child: Center(
                          child: Text(
                            "Reset Email",
                            style: TextStyle(
                                color: White,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
