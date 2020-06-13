import 'package:flutter/material.dart';

import 'package:reciclaly/src/pages/camera.dart';

class MyApp extends StatelessWidget {
  final camera;

  const MyApp({Key key, this.camera}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Camera(camera: camera)
    );
  }
}
