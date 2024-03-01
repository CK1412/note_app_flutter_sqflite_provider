import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../constants/assets_path.dart';

class NoNoteUIWidget extends StatelessWidget {
  const NoNoteUIWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            AssetsPath.note,
            width: 100,
            filterQuality: FilterQuality.high,
            fit: BoxFit.cover,
            color: Colors.white70,
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: FittedBox(
              child: Text(
                title,
                style: TextStyleConstants.contentStyle3
                    .copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
