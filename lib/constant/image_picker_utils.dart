import 'dart:io';
import 'dart:typed_data';
import 'package:crop_your_image/crop_your_image.dart' as crop;
import 'package:elite_admin/utils/widget/custombutton.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class ImagePickerUtil {
  static final ImagePicker _picker = ImagePicker();

  static Future<XFile?> pickImageFromGallery({
    CropAspectRatio? aspectRatio,
    CropAspectRatioPresetData? initAspectRatio,
    required BuildContext context,
  }) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return await _cropImageDesktop(context, pickedFile!);
    }
    return await _cropImage(pickedFile, aspectRatio, initAspectRatio);
  }

  static Future<XFile?> pickImageFromCamera({
    CropAspectRatio? aspectRatio,
    CropAspectRatioPresetData? initAspectRatio,
    required BuildContext context,
  }) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return await _cropImageDesktop(context, pickedFile!);
    }
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
    XFile? pickedFile,
    CropAspectRatio? aspectRatio,
    CropAspectRatioPresetData? initAspectRatio,
  ) async {
    if (pickedFile == null) return null;

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Proper Image',
          toolbarColor: Colors.white,
          toolbarWidgetColor: Colors.black,
          lockAspectRatio: true,
          initAspectRatio: initAspectRatio ?? CropAspectRatioPreset.original,
        ),
        IOSUiSettings(title: 'Crop Image', aspectRatioLockEnabled: true),
      ],
    );

    return croppedFile != null ? XFile(croppedFile.path) : null;
  }

  static Future<XFile?> _cropImageDesktop(BuildContext context, XFile pickedFile) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => CropYourImageScreen(file: File(pickedFile.path))),
    );

    if (result != null && result is File) {
      return XFile(result.path);
    }
    return null;
  }
}

class CropYourImageScreen extends StatefulWidget {
  final File file;
  const CropYourImageScreen({Key? key, required this.file}) : super(key: key);

  @override
  State<CropYourImageScreen> createState() => _CropYourImageScreenState();
}

class _CropYourImageScreenState extends State<CropYourImageScreen> {
  final crop.CropController _controller = crop.CropController();
  late final Uint8List _imageBytes;

  @override
  void initState() {
    super.initState();
    final raw = widget.file.readAsBytesSync(); // List<int>
    _imageBytes = Uint8List.fromList(raw); // convert to Uint8List
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Crop Image")),
      body: Column(
        children: [
          Expanded(
            child: crop.Crop(
              controller: _controller,
              image: _imageBytes,
              // onCropped now receives CropResult (CropSuccess or CropFailure)
              onCropped: (crop.CropResult result) async {
                if (result is crop.CropSuccess) {
                  final Uint8List bytes = result.croppedImage; // <- correct property
                  // build output path using same extension
                  final ext = p.extension(widget.file.path); // e.g. ".jpg"
                  final dir = p.dirname(widget.file.path);
                  final name = p.basenameWithoutExtension(widget.file.path);
                  final outPath = p.join(dir, '${name}_cropped$ext');

                  final croppedFile = File(outPath)..writeAsBytesSync(bytes);

                  // return cropped file to previous screen
                  Navigator.pop(context, croppedFile);
                } else if (result is crop.CropFailure) {
                  // handle error
                  final cause = result.cause;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Crop failed: $cause')));
                  Navigator.pop(context, null);
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: CustomOutlinedButton(onPressed: () => _controller.crop(), buttonText: "Crop"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
