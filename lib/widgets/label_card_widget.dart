import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class LabelCardWidget extends StatelessWidget {
  const LabelCardWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(top: 12),
      elevation: 0,
      color: const Color(0xffC4B6B6).withAlpha(120),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Text(
          title,
          style: TextStyleConstants.contentStyle4,
        ),
      ),
    );
  }
}
