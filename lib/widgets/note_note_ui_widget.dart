import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:note_app_flutter_sqflite_provider/constants/assets_path.dart';

class NoNoteUIWidget extends StatelessWidget {
  const NoNoteUIWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

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
          )
        ],
      ),
    );
  }
}
