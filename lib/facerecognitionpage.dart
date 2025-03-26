import 'package:face_recog_assessment/FaceDetectionScreen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:google_ml_kit/google_ml_kit.dart'; // Import Google ML Kit package

class FaceRecognitionService {
  final ImagePicker _picker = ImagePicker();

  // Method to pick an image from the gallery or camera
  Future<File?> getImage() async {
    // Using pickImage instead of getImage
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      return File(pickedFile.path);
    }
    return null;
  }

  // Method for face recognition (just a placeholder for your actual logic)
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
            // Step 1: Pick an image
            final imageFile = await faceRecognitionService.getImage();
            if (imageFile != null) {
              // Step 2: Perform face detection
              List<Face> faces = await faceRecognitionService.detectFaces(imageFile);

              // Step 3: Navigate to the next screen with the detected faces
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
              // Show a message if no image was selected
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
