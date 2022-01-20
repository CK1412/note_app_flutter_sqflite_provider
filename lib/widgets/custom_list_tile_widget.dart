import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';

class CustomListTileWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CustomListTileWidget({
    Key? key,
    required this.title,
    required this.iconData,
    required this.onTap,
    this.trailing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyleConstants.titleStyle3,
      ),
      leading: Icon(
        iconData,
      ),
      onTap: onTap,
      trailing: trailing,
    );
  }
}
