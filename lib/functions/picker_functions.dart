import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

Future<File?> pickImage(ImageSource imageSource) async {
  final _imagePicker = ImagePicker();
  final XFile? imageFile = await _imagePicker.pickImage(
    source: imageSource,
    maxHeight: 2340,
    maxWidth: 1080,
  );

  if (imageFile == null) return null;

  // convert XFile to File
  File tmpImageFile = File(imageFile.path);

  // get Filename of image
  final imageFileName = basename(imageFile.path);

  var appDir = await getApplicationDocumentsDirectory();

  // create a Folder contain images inside appDir
  var _imagesDir = Directory('${appDir.path}/images/');

  if (!await _imagesDir.exists()) {
    _imagesDir = await _imagesDir.create(recursive: true);
  }

  // copy image file to the images folder
  var newFile = await tmpImageFile.copy('${_imagesDir.path}/$imageFileName');

  return newFile;
}

Future<List<File>?> pickManyImages() async {
  final _imagePicker = ImagePicker();

  // get list file images
  final List<XFile>? imageFileList = await _imagePicker.pickMultiImage(
    maxHeight: 2340,
    maxWidth: 1080,
  );

  if (imageFileList == null) return null;

  // convert XFile to File
  List<File> tmpImageFile = imageFileList.map((e) => File(e.path)).toList();

  var appDir = await getApplicationDocumentsDirectory();

  // create a Folder contain images inside appDir
  var _imagesDir = Directory('${appDir.path}/images/');
  if (!await _imagesDir.exists()) {
    _imagesDir = await _imagesDir.create(recursive: true);
  }

  // copy image file list to the images folder
  for (int i = 0; i < tmpImageFile.length; i++) {
    String fileName = basename(tmpImageFile[i].path);
    tmpImageFile[i] =
        await tmpImageFile[i].copy('${_imagesDir.path}/$fileName');
  }
  return tmpImageFile;
}

pickColor({
  required BuildContext context,
  required selectedColor,
  required Function(Color) changeColor,
}) {
  final _screenSize = MediaQuery.of(context).size;
  final _radius = _screenSize.width * .1;

  showModalBottomSheet(
    backgroundColor: ColorsConstant.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(_radius),
        topRight: Radius.circular(_radius),
      ),
    ),
    context: context,
    builder: (context) => Container(
      height: _screenSize.height * .4,
      width: double.infinity,
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            child: Text(
              AppLocalizations.of(context)!
                  .choose_your_favorite_background_color,
              style:
                  TextStyleConstants.titleStyle2.copyWith(color: Colors.black),
            ),
          ),
          Expanded(
            child: BlockPicker(
              pickerColor: selectedColor,
              availableColors: const [
                ColorsConstant.bgScaffoldColor,
                ...ColorsConstant.bgColors,
              ],
              onColorChanged: changeColor,
            ),
          )
        ],
      ),
    ),
  );
}
