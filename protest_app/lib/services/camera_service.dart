import 'dart:io';
import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

///A class for handling camera operations such as taking images and videos
///As well as saving those images and videos on the device memory
class CameraService {
  ///The overall camera controller
  CameraController cameraController;

  ///Initializes the camera service, returns false if failure
  Future<bool> initializeCameraService() async {
    List<CameraDescription> cameras = await availableCameras();

    cameraController = CameraController(cameras.first, ResolutionPreset.medium);

    try {
      await cameraController.initialize();
    } catch (e) {
      print(e.toString());
      return false;
    }
    return true;
  }

  ///Takes an image with the camera controller
  ///returns path if completed correctly
  Future<String> takeImage(String imageID) async {
    Directory tempDirectory = await getTemporaryDirectory();

    final path = join(tempDirectory.path, '$imageID.png');

    try {
      await cameraController.takePicture(path);
      return path;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///Starts taking a video with the camera controller
  ///returns path if completed correctly
  Future<String> startRecordVideo(String videoID) async {
    Directory tempDirectory = await getTemporaryDirectory();

    final path = join(tempDirectory.path, '$videoID.png');

    try {
      await cameraController.startVideoRecording(path);
      return path;
    } catch (e) {
      print(e);
      return null;
    }
  }

  ///Stops taking a video with the camera controller
  ///returns true if completed correctly
  Future<bool> stopVideoRecording(String videoID) async {
    if (!cameraController.value.isRecordingVideo) {
      return true;
    }
    try {
      await cameraController.stopVideoRecording();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
