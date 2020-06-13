import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

import 'src/myApp.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  final cameras = await availableCameras();
  final cameraselected = cameras.first;

  cameras.forEach((element) {print(element);});

  runApp(MyApp(camera: cameraselected));
}


