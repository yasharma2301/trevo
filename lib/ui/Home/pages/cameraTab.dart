import 'dart:io';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tflite/tflite.dart';
import 'package:trevo/main.dart';
import 'package:trevo/shared/colors.dart';
import 'package:trevo/shared/delayed_animation.dart';
import 'package:trevo/shared/globalFunctions.dart';

class CameraTab extends StatefulWidget {
  @override
  _CameraTabState createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab> {
  CameraController controller;
  var imagePath;
  bool showCapturedPhoto = false;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    controller = CameraController(cameras[0], ResolutionPreset.medium);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    loadModel();
  }

  List _res;

  String confidence = "";
  String monumentLabel = "";

  applyModelOnImage(String path) async {
    var res = await Tflite.runModelOnImage(
        path: path,
        numResults: 2,
        threshold: 0.5,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _res = res;
//      [{confidence: 0.9997568726539612, index: 0, label: 0 Taj Mahal}]
      print(_res);
      monumentLabel = _res[0]['label'];
      confidence = (_res[0]['confidence'] * 100.0).toString().substring(0, 4);
      print(monumentLabel);
      print(confidence);
    });
  }

  loadModel() async {
    var res = await Tflite.loadModel(
        model: "assets/model_unquant.tflite", labels: "assets/labels.txt");
    print("loaded: " + res);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onCaptureButtonPressed() async {
    //on camera button press
    try {
      final path = join(
        (await getTemporaryDirectory()).path, //Temporary path
        '${DateTime.now()}.png',
      );
      imagePath = path;
      await controller.takePicture(path).then((value) {
        print(imagePath);
      }); //take photo
      setState(() {
        applyModelOnImage(imagePath);
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        setState(() {
          imagePath = pickedFile.path;
          showCapturedPhoto = true;
        });
        applyModelOnImage(imagePath);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return Container(
        color: LightGrey,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'Aww Snap!\n You\'ve to switch on your camera permission for this app.',
              style: TextStyle(
                  color: Teal.withOpacity(0.8),
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Montserrat',
                  fontSize: 25),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }
    return showCapturedPhoto == false
        ? Stack(
            fit: StackFit.expand,
            children: [
              AspectRatio(
                  aspectRatio: controller.value.aspectRatio,
                  child: CameraPreview(controller)),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(left: 10),
                        child: GestureDetector(
                          onTap: () {
                            getImage();
                          },
                          child: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: White,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 30,
                              ),
                            ),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: onCaptureButtonPressed,
                        child: Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.transparent,
                              border: Border.all(color: White, width: 3)),
                          child: Center(
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration: BoxDecoration(
                                  color: White.withOpacity(0.2),
                                  shape: BoxShape.circle),
                              child: Center(
                                child: Icon(
                                  Icons.camera_alt,
                                  color: White,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        : Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                File(imagePath),
                fit: BoxFit.fill,
              ),
              Align(
                alignment: Alignment.center,
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      DelayedAnimation(
                        delay:200,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            monumentLabel,
                            style: TextStyle(
                                color: White,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                fontSize: 28),
                          ),
                        ),
                      ),
                      SizedBox(height: 10,),
                      DelayedAnimation(
                        delay:300,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            'Confidence level: $confidence',
                            style: TextStyle(
                                color: White,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        showCapturedPhoto = false;
                      });
                    },
                    child: Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Colors.white),
                        child: Icon(
                          Icons.close,
                          size: 32,
                        )),
                  ),
                ),
              ),
            ],
          );
  }
}
