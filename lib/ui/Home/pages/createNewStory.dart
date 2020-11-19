import 'package:custom_radio_grouped_button/CustomButtons/ButtonTextStyle.dart';
import 'package:custom_radio_grouped_button/CustomButtons/CustomCheckBoxGroup.dart';
import 'package:flutter/material.dart';
import 'package:trevo/Models/storyModel.dart';
import 'package:trevo/shared/colors.dart';

enum StoryModes { Editing, Adding }

class CreateNewStory extends StatefulWidget {
  final StoryModel storyModel;
  final StoryModes storyMode;

  const CreateNewStory({Key key, this.storyModel, this.storyMode})
      : super(key: key);

  @override
  _CreateNewStoryState createState() => _CreateNewStoryState();
}

class _CreateNewStoryState extends State<CreateNewStory>
    with SingleTickerProviderStateMixin {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  List<String> tags = [];

  double height, width;
  double _scale;
  AnimationController _controller;
  bool favourites = false;
  bool adventure = false;
  bool personal = false;

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
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: LightGrey,
        body: Stack(
          children: [
            Container(
              color: BottleGreen.withOpacity(0.05),
            ),
            Positioned(
              left: -(height / 2 - width / 2),
              top: -height * 0.2,
              child: Container(
                height: height,
                width: height,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BottleGreen.withOpacity(0.3),
                ),
              ),
            ),
            Positioned(
              left: width * 0.15,
              top: -width * 0.5,
              child: Container(
                height: width * 1.6,
                width: width * 1.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BottleGreen.withOpacity(0.1),
                ),
              ),
            ),
            Positioned(
              right: -width * 0.2,
              top: -50,
              child: Container(
                height: width * 0.6,
                width: width * 0.6,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: BottleGreen.withOpacity(0.1),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.storyMode == StoryModes.Editing
                          ? "Edit Story".toUpperCase()
                          : "Add a story".toUpperCase(),
                      style: TextStyle(
                          color: White,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Material(
                      elevation: 30,
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6)),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: White,
                          ),
                          child: TextFormField(
                            controller: _titleController,
                            onChanged: (v) {
                              setState(() {});
                            },
                            cursorColor: Theme.of(context).primaryColorLight,
                            style: TextStyle(
                              color: BottleGreen,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Enter a title.",
                                hintStyle: TextStyle(
                                    color: BottleGreen, fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Material(
                      elevation: 30,
                      color: Colors.transparent,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(6)),
                        child: Container(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: White,
                          ),
                          child: TextFormField(
                            maxLines: 8,
                            controller: _descriptionController,
                            onChanged: (v) {
                              setState(() {});
                            },
                            cursorColor: Theme.of(context).primaryColorLight,
                            style: TextStyle(
                              color: BottleGreen,
                              fontSize: 18,
                            ),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "What\'s your story today?",
                                hintStyle: TextStyle(
                                    color: BottleGreen, fontSize: 16)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'ADD TAGS:',
                          style: TextStyle(
                              color: White,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat'),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: width,
                          height: 90,
                          decoration: BoxDecoration(
                            color: White,
                            borderRadius: BorderRadius.circular(10),
                              border: Border.all(width: 2,color: Colors.white)
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Teal,
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        topLeft: Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                            value: favourites,
                                            onChanged: (bool value) {
                                              setState(() {
                                                favourites = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          '#favourites',
                                          style: TextStyle(color: White,fontWeight: FontWeight.bold,fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Colors.teal,
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                            value: adventure,
                                            onChanged: (bool value) {
                                              setState(() {
                                                adventure = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          '#adventure',
                                          style: TextStyle(color: White,fontWeight: FontWeight.bold,fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  height: 90,
                                  decoration: BoxDecoration(
                                    color: Teal,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(10),
                                        bottomRight: Radius.circular(10)),
                                  ),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Transform.scale(
                                          scale: 1.3,
                                          child: Checkbox(
                                            value: personal,
                                            onChanged: (bool value) {
                                              setState(() {
                                                personal = value;
                                              });
                                            },
                                          ),
                                        ),
                                        Text(
                                          '#personal',
                                          style: TextStyle(color: White,fontWeight: FontWeight.bold,fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: GestureDetector(
                        onTap: () {},
                        onTapDown: _onTapDown,
                        onTapUp: _onTapUp,
                        child: Transform.scale(
                          scale: _scale,
                          child: Container(
                            height: 60,
                            width: width * 0.7,
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
                                  begin: FractionalOffset.bottomLeft,
                                  end: FractionalOffset.topRight,
                                  tileMode: TileMode.repeated),
                            ),
                            child: Center(
                              child: Text(
                                'Save!',
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
            )
          ],
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
//CustomCheckBoxGroup(
//buttonTextStyle: ButtonTextStyle(
//textStyle: TextStyle(
//fontFamily: 'Montserrat',
//fontSize: 17,
//fontWeight: FontWeight.w500
//),
//),
//unSelectedBorderColor: BottleGreen,
//unSelectedColor: White,
//selectedColor: BottleGreen,
//buttonLables: [
//"#favourites",
//"#adventure",
//'#personal'
//],
//buttonValuesList: [
//"favourites",
//"adventure",
//'personal'
//],
//checkBoxButtonValues: (values) {
//print(values);
//},
//enableButtonWrap: true,
//autoWidth: true,
//height: 40,
//),