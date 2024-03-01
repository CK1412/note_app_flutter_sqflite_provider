import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../constants/app_constants.dart';
import '../constants/assets_path.dart';

class ImagesStaggeredGridViewWidget extends StatelessWidget {
  const ImagesStaggeredGridViewWidget({
    super.key,
    required this.imagePaths,
    required this.limitedQuantity,
  });

  final List<String> imagePaths;
  final LimitedQuantity limitedQuantity;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      staggeredTileBuilder: (index) {
        final int total = imagePaths.length;

        return getStaggeredTile(total: total, index: index);
      },
      itemBuilder: (context, index) {
        return FadeInImage(
          placeholder: AssetImage(AssetsPath.placeholderImage),
          fadeInDuration: const Duration(milliseconds: 500),
          image: FileImage(
            File(imagePaths[index]),
          ),
          fit: BoxFit.cover,
          placeholderFit: BoxFit.cover,
        );
      },
      itemCount:
          (limitedQuantity == LimitedQuantity.yes && imagePaths.length <= 6)
              ? imagePaths.length
              : 6,
    );
  }
}
