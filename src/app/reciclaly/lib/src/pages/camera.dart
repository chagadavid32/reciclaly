import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;

import 'package:reciclaly/src/pages/prueba.dart';


class Camera extends StatefulWidget {
  final CameraDescription camera;

  Camera({
    Key key,
    @required this.camera
    }) : super(key: key);

  @override
  _CameraState createState() => _CameraState();

}

class _CameraState extends State<Camera> {
  CameraController _controller;
  Future<void> _initializeControlerFuture;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
    _initializeControlerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Material(
      color: Colors.green,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Stack(
            overflow: Overflow.visible,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: FutureBuilder<void>(
                  future: _initializeControlerFuture,
                  builder: (contex, snapshot){
                    if(snapshot.connectionState == ConnectionState.done){
                      return CameraPreview(_controller);
                    }else{
                      return Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height / 17,
                left: 17,
                child: Row(
                  children: <Widget>[
                    Icon(Icons.menu, size: 32, color: Colors.white),
                    SizedBox(width: MediaQuery.of(context).size.width *.76),
                    Icon(Icons.flash_auto, size: 32, color: Colors.white),
                  ]
                ),
              ),
              Positioned(
                bottom: -30,
                right: MediaQuery.of(context).size.width * .40,
                child: FloatingActionButton(
                  foregroundColor: Colors.grey[300],
                  backgroundColor: Colors.white,
                  materialTapTargetSize: MaterialTapTargetSize.padded,
                  child: Icon(Icons.brightness_1, color: Colors.grey[300], size: 50,),
                  onPressed: () async{
                    try{
                      final path = join(
                        (await getTemporaryDirectory()).path,
                        '${DateTime.now()}.png',
                      );
                      await _controller.takePicture(path);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DisplayPictureScreen(imagePath: path),
                        ),
                      );

                      String url = "https://southcentralus.api.cognitive.microsoft.com/customvision/v3.0/Prediction/8387252a-819f-4d55-b1ca-da6f7a307e7f/classify/iterations/test/url";

                      var response = await http.post(url, 
                      headers: {
                        "Prediction-Key": "baea86091f75406ea8a57f9d83ba7d3b",
                        "Content-Type": "application/json",
                      },
                      body: json.encode({'Url': 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/56/Papierosa_1_ubt_0069.jpeg/1200px-Papierosa_1_ubt_0069.jpeg'}),
                      );


                      final decodedresponse = json.decode(response.body);
                      print(decodedresponse);

                    }catch(ex){
                      print(ex);
                    }
                  },
                ),
              ),
            ]
          ),
        ]
      ),      
    );
  }
} 