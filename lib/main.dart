import 'package:face_recog_assessment/facerecognitionpage.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Face Recognition App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FaceRecognitionPage(), // Set FaceRecognitionPage as home
    );
  }
}
