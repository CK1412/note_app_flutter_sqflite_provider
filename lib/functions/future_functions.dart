import 'dart:io';

import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:note_app_flutter_sqflite_provider/providers/label_provider.dart';
import 'package:note_app_flutter_sqflite_provider/providers/note_provider.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

Future refreshOrGetData(BuildContext context) async {
  // * dùng kiểu này bị lỗi
  // await context.read<NoteProvider>().fetchAndSet();
  // context.read<LabelProvider>().fetchAndSet();

  await Provider.of<NoteProvider>(context, listen: false).fetchAndSet();
  Provider.of<LabelProvider>(context, listen: false).fetchAndSet();
}

Future? openLink(String urlString) async {
  if (await canLaunch(urlString)) {
    await launch(urlString);
  } else {
    throw 'Could not launch $urlString';
  }
}

Future<String> getViewMode() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('view-mode')) return ViewMode.staggeredGrid.name;

  return prefs.getString('view-mode') ?? ViewMode.staggeredGrid.name;
}

Future<String> changeViewMode(String viewMode) async {
  final prefs = await SharedPreferences.getInstance();
  if (viewMode == ViewMode.list.name) {
    viewMode = ViewMode.staggeredGrid.name;
  } else {
    viewMode = ViewMode.list.name;
  }
  await prefs.setString('view-mode', viewMode);
  return viewMode;
}

Future deleteFile(File file) async {
  try {
    if (await file.exists()) {
      await file.delete();
    }
  } catch (e) {
    throw 'file read error';
  }
}

Future deleteFileList(List<File> fileList) async {
  for (var file in fileList) {
    await deleteFile(file);
  }
}

Future deleteCacheDir() async {
  final cacheDir = await getTemporaryDirectory();
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}
