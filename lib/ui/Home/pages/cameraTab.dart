import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:trevo/main.dart';
import 'package:trevo/shared/colors.dart';

class CameraTab extends StatefulWidget {
  @override
  _CameraTabState createState() => _CameraTabState();
}

class _CameraTabState extends State<CameraTab> {
  CameraController controller;
  var imagePath;
  bool showCapturedPhoto = false;

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
      await controller.takePicture(path); //take photo

      setState(() {
        showCapturedPhoto = true;
      });
    } catch (e) {
      print(e);
    }
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
            child: GestureDetector(
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
                          ))),
                ),
              ),
            ),
          ),
        )
      ],
    )
        : Center(child: Image.file(File(imagePath),fit: BoxFit.contain,));
  }
}