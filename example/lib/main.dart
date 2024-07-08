import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_assets_crop/insta_assets_crop.dart';
import 'package:image_picker/image_picker.dart';

class PickedFile {
  const PickedFile({required this.file, required this.size});

  static Future<PickedFile> create(File file) async {
    final decodedImage = await decodeImageFromList(await file.readAsBytes());
    final height = decodedImage.height;
    final width = decodedImage.width;

    return PickedFile(
      file: file,
      size: Size(width.toDouble(), height.toDouble()),
    );
  }

  Future<FileSystemEntity> delete() => file.delete();

  final File file;
  final Size size;
}

void main() {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarBrightness: Brightness.dark,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final cropKey = GlobalKey<CropState>();
  PickedFile? _sample;
  File? _file, _lastCropped;

  @override
  void dispose() {
    super.dispose();
    _file?.delete();
    _sample?.delete();
    _lastCropped?.delete();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Container(
          color: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: _sample == null ? _buildOpeningImage() : _buildCroppingImage(),
        ),
      ),
    );
  }

  Widget _buildOpeningImage() {
    return Center(child: _buildOpenImage());
  }

  Widget _buildCroppingImage() {
    return Column(
      children: <Widget>[
        if (_sample != null)
          Expanded(
            child: Crop(
              child: Image.file(_sample!.file),
              size: _sample!.size,
              key: cropKey,
              disableResize: true,
              aspectRatio: 4 / 5,
            ),
          ),
        Container(
          padding: const EdgeInsets.only(top: 20.0),
          alignment: AlignmentDirectional.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              TextButton(
                child: Text(
                  'Crop Image',
                  style: Theme.of(context)
                      .textTheme
                      .labelLarge
                      ?.copyWith(color: Colors.white),
                ),
                onPressed: () => _cropImage(),
              ),
              _buildOpenImage(),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildOpenImage() {
    return TextButton(
      child: Text(
        'Open Image',
        style: Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(color: Colors.white),
      ),
      onPressed: () => _openImage(),
    );
  }

  Future<void> _openImage() async {
    final xfile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (xfile == null) return;

    final file = File(xfile.path);
    final sample = await InstaAssetsCrop.sampleImage(
      file: file,
      preferredSize: context.size?.longestSide.ceil(),
    );

    _sample?.delete();
    _file?.delete();

    final pickedFile = await PickedFile.create(sample);

    setState(() {
      _sample = pickedFile;
      _file = file;
    });
  }

  Future<void> _cropImage() async {
    final scale = cropKey.currentState?.scale;
    final area = cropKey.currentState?.area;
    if (area == null) {
      // cannot crop, widget is not setup
      return;
    }

    if (_file == null) {
      throw 'error file is null';
    }

    // scale up to use maximum possible number of pixels
    // this will sample image in higher resolution to make cropped image larger
    final sample = await InstaAssetsCrop.sampleImage(
      file: _file!,
      preferredSize: (2000 / (scale ?? 1.0)).round(),
    );

    final file = await InstaAssetsCrop.cropImage(
      file: sample,
      area: area,
    );

    sample.delete();

    _lastCropped?.delete();
    _lastCropped = file;

    debugPrint('$file');
  }
}
