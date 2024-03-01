import 'package:flutter/material.dart';
import '../constants/app_constants.dart';

class CustomListTileWidget extends StatelessWidget {
  final String title;
  final IconData iconData;
  final VoidCallback? onTap;
  final Widget? trailing;

  const CustomListTileWidget({
    super.key,
    required this.title,
    required this.iconData,
    required this.onTap,
    this.trailing,
  });

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
