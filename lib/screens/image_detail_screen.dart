import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen({
    Key? key,
    required this.index,
    required this.imagePaths,
  }) : super(key: key);

  final int index;
  final List<String> imagePaths;

  @override
  State<ImageDetailScreen> createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(widget.imagePaths);
          },
          icon: const Icon(
            Icons.arrow_back,
          ),
        ),
        title: Text(
          '${_currentIndex + 1} ${AppLocalizations.of(context)!.out_of} ${widget.imagePaths.length} ${AppLocalizations.of(context)!.pictures}',
          style: TextStyleConstants.titleAppBarStyle,
        ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                widget.imagePaths.removeAt(_currentIndex);
                if (widget.imagePaths.isEmpty) {
                  Navigator.of(context).pop();
                }
                if (widget.imagePaths.length == _currentIndex) {
                  _currentIndex--;
                }
              });
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: SizedBox(
        child: Hero(
          tag: 'viewImg$_currentIndex',
          child: PhotoViewGallery.builder(
            pageController: _pageController,
            itemCount: widget.imagePaths.length,
            builder: (context, index) => PhotoViewGalleryPageOptions(
              imageProvider: FileImage(
                File(widget.imagePaths[index]),
              ),
              minScale: PhotoViewComputedScale.contained,
              maxScale: PhotoViewComputedScale.contained * 4,
              filterQuality: FilterQuality.high,
            ),
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            loadingBuilder: (context, event) => const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      ),
    );
  }
}
