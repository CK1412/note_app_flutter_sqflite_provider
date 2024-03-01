import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/app_constants.dart';
import '../providers/label_provider.dart';
import '../providers/note_provider.dart';

Future refreshOrGetData(BuildContext context) async {
  // * dùng kiểu này bị lỗi
  // await context.read<NoteProvider>().fetchAndSet();
  // context.read<LabelProvider>().fetchAndSet();

  await Provider.of<NoteProvider>(context, listen: false)
      .fetchAndSet()
      .whenComplete(() {
    Provider.of<LabelProvider>(context, listen: false).fetchAndSet();
  });
}

Future? openLink(String urlString) async {
  if (await canLaunchUrl(Uri.parse(urlString))) {
    await canLaunchUrl(Uri.parse(urlString));
  } else {
    throw Exception('Could not launch $urlString');
  }
}

Future<String> getViewMode() async {
  final prefs = await SharedPreferences.getInstance();
  if (!prefs.containsKey('view-mode')) {
    return ViewMode.staggeredGrid.name;
  }

  return prefs.getString('view-mode') ?? ViewMode.staggeredGrid.name;
}

Future<String> changeViewMode(String viewMode) async {
  final prefs = await SharedPreferences.getInstance();
  late final String newViewMode;
  if (viewMode == ViewMode.list.name) {
    newViewMode = ViewMode.staggeredGrid.name;
  } else {
    newViewMode = ViewMode.list.name;
  }
  await prefs.setString('view-mode', newViewMode);
  return newViewMode;
}

Future deleteFile(File file) async {
  try {
    if (file.existsSync()) {
      await file.delete();
    }
  } catch (e) {
    throw Exception('file read error');
  }
}

Future deleteFileList(List<File> fileList) async {
  for (final file in fileList) {
    await deleteFile(file);
  }
}

Future deleteCacheDir() async {
  final cacheDir = await getTemporaryDirectory();
  if (cacheDir.existsSync()) {
    cacheDir.deleteSync(recursive: true);
  }
}
