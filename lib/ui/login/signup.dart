import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/shared/globalFunctions.dart';
import 'package:trevo/ui/Home/home.dart';
import 'package:trevo/utils/auth.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin{
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _nameController = TextEditingController();

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
                    height: 150,
                    width: 150,
                    child: FlareActor('assets/botra.flr',
                        alignment: Alignment.center,
                        fit: BoxFit.contain,
                        animation: "Alarm"),
                  ),
                ),
                SizedBox(height: 10,),
                Text(
                  'Register',
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
                    onChanged: (value) {},
                    controller: _nameController,
                    style: TextStyle(color: BottleGreen),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Name",
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
                    onChanged: (value) {},
                    controller: _passwordController,
                    style: TextStyle(color: BottleGreen),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Enter Password",
                        hintStyle: TextStyle(color: Teal, fontSize: 17)),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                GestureDetector(
                  onTap:(){
                    String email = _emailController.text;
                    String password = _passwordController.text;
                    String name = _nameController.text;
                    if(email==null || password==null){
                      // Fields cannot be empty
                    }else if(!emailRegexPass(email)){
                      // input a valid email
                    }else if(!passwordRegexPass(password)){
                      // password should be longer than 6 characters
                    }else{
                      loginProvider.signUpWithEmailAndPassword(email, password,name).then((value) =>{
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>Home()))
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
                        child: Text(
                          'Sign Up',
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
                  onTap: (){
//                    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>SignUp()));
                  },
                  child: Text(
                    'Terms and Conditions',
                    style: TextStyle(
                        color: Teal, fontWeight: FontWeight.w400, fontSize: 15,decoration: TextDecoration.underline),
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


  void signUp(){
    String email = _emailController.text;
    String password = _passwordController.text;
    if(email==null || password==null){
      // Fields cannot be empty
    }else if(!emailRegexPass(email)){
      // input a valid email
    }else if(!passwordRegexPass(password)){
      // password should be longer than 6 characters
    }else{
      // Signup
    }
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
