// Un Widget que muestra la imagen tomada por el usuario
import 'dart:io';

import 'package:flutter/material.dart';

class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key key, this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Display the Picture')),
      // La imagen se almacena como un archivo en el dispositivo. Usa el 
      // constructor `Image.file` con la ruta dada para mostrar la imagen
      body: Image.file(File(imagePath)),
    );
  }
}