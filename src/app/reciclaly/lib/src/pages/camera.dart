import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
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
                    print("yeeeesss");
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