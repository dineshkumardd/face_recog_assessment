import 'package:face_recog_assessment/FaceDetectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart';

class FaceRecognitionService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> getImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  Future<List<Face>> detectFaces(File imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faceDetector = GoogleMlKit.vision.faceDetector();
    List<Face> faces = [];

    try {
      faces = await faceDetector.processImage(inputImage);
    } catch (e) {
      print('Error in face detection: $e');
    } finally {
      faceDetector.close();
    }

    return faces;
  }
}

class FaceRecognitionPage extends StatelessWidget {
  final FaceRecognitionService faceRecognitionService = FaceRecognitionService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Face Recognition')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final imageFile = await faceRecognitionService.getImage();
            if (imageFile != null) {
              List<Face> faces = await faceRecognitionService.detectFaces(imageFile);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FaceDetectionScreen(
                    imageFile: imageFile,
                    faces: faces,
                  ),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("No image selected")),
              );
            }
          },
          child: Text('Pick Image and Detect Faces'),
        ),
      ),
    );
  }
}
