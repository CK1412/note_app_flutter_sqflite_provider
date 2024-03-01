import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/app_constants.dart';

Future<File?> pickImage(ImageSource imageSource) async {
  final ImagePicker imagePicker = ImagePicker();
  final XFile? imageFile = await imagePicker.pickImage(
    source: imageSource,
    maxHeight: 2340,
    maxWidth: 1080,
  );

  if (imageFile == null) {
    return null;
  }

  // convert XFile to File
  final File tmpImageFile = File(imageFile.path);

  // get Filename of image
  final imageFileName = basename(imageFile.path);

  final appDir = await getApplicationDocumentsDirectory();

  // create a Folder contain images inside appDir
  var imagesDir = Directory('${appDir.path}/images/');

  if (!imagesDir.existsSync()) {
    imagesDir = await imagesDir.create(recursive: true);
  }

  // copy image file to the images folder
  final newFile = await tmpImageFile.copy('${imagesDir.path}/$imageFileName');

  return newFile;
}

Future<List<File>?> pickManyImages() async {
  final imagePicker = ImagePicker();

  // get list file images
  final List<XFile> imageFileList = await imagePicker.pickMultiImage(
    maxHeight: 2340,
    maxWidth: 1080,
  );

  // convert XFile to File
  final List<File> tmpImageFile =
      imageFileList.map((e) => File(e.path)).toList();

  final appDir = await getApplicationDocumentsDirectory();

  // create a Folder contain images inside appDir
  var imagesDir = Directory('${appDir.path}/images/');
  if (!imagesDir.existsSync()) {
    imagesDir = await imagesDir.create(recursive: true);
  }

  // copy image file list to the images folder
  for (int i = 0; i < tmpImageFile.length; i++) {
    final String fileName = basename(tmpImageFile[i].path);
    tmpImageFile[i] = await tmpImageFile[i].copy('${imagesDir.path}/$fileName');
  }
  return tmpImageFile;
}

void pickColor({
  required BuildContext context,
  required Color selectedColor,
  required Function(Color) changeColor,
}) {
  final screenSize = MediaQuery.of(context).size;
  final radius = screenSize.width * .1;

  showModalBottomSheet(
    backgroundColor: ColorsConstant.whiteColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(radius),
        topRight: Radius.circular(radius),
      ),
    ),
    context: context,
    builder: (context) => Container(
      height: screenSize.height * .4,
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
          ),
        ],
      ),
    ),
  );
}
