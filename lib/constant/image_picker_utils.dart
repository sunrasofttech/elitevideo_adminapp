import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImageFromGallery(
      {CropAspectRatio? aspectRatio, CropAspectRatioPresetData? initAspectRatio}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    return await _cropImage(pickedFile, aspectRatio, initAspectRatio);
  }

  static Future<XFile?> pickImageFromCamera(
      {CropAspectRatio? aspectRatio, CropAspectRatioPresetData? initAspectRatio}) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    return await _cropImage(pickedFile, aspectRatio, initAspectRatio);
  }

  static Future<XFile?> pickVideoFromGallery(BuildContext context) async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.gallery);
    
    return pickedFile;
  }

  static Future<XFile?> pickVideoFromCamera() async {
    final pickedFile = await _picker.pickVideo(source: ImageSource.camera);
    return pickedFile;
  }

  static Future<XFile?> _cropImage(
      XFile? pickedFile, CropAspectRatio? aspectRatio, CropAspectRatioPresetData? initAspectRatio) async {
    if (pickedFile == null) return null;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      // aspectRatio: aspectRatio ?? const CropAspectRatio(ratioX: 16, ratioY: 9),
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Proper Image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          lockAspectRatio: true,
          initAspectRatio: initAspectRatio ?? CropAspectRatioPreset.original,
        ),
        IOSUiSettings(
          title: 'Crop Image',
          aspectRatioLockEnabled: true,
        ),
      ],
    );

    return croppedFile != null ? XFile(croppedFile.path) : null;
  }

}
