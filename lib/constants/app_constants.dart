import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

class ColorsConstant {
  static const bgScaffoldColor = Color(0xff212121);
  static const bgDrawerColor = Color(0xff292B2D);
  static const whiteColor = Color(0xffF7EDE2);
  static const grayColor = Color(0xff343A40);
  static const textColor = Color(0xffE8E8E8);
  static const blueColor = Color(0xff3C8DAD);

  static const List<Color> bgColors = [
    Color(0xffC68B59),
    Color(0xff46624E),
    Color(0xff21556E),
    Color(0xff944E6C),
    Color(0xffD0637C),
    Color(0xff6E3CBC),
    Color(0xffB13441),
    Color(0xff666653),
    Color(0xff547174),
    Color(0xff9B4D3C),
    Color(0xffBD903F),
  ];
}

class TextStyleConstants {
  static const titleStyle1 = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w500,
    color: ColorsConstant.textColor,
  );

  static const titleStyle2 = TextStyle(
    fontSize: 18,
    color: ColorsConstant.whiteColor,
    fontWeight: FontWeight.w500,
    overflow: TextOverflow.ellipsis,
  );

  static const titleStyle3 = TextStyle(
    fontSize: 16,
    color: ColorsConstant.whiteColor,
    fontWeight: FontWeight.w400,
    overflow: TextOverflow.ellipsis,
  );

  static const contentStyle2 = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w400,
    color: ColorsConstant.textColor,
    // overflow: TextOverflow.ellipsis,
  );

  static const contentStyle3 = TextStyle(
    color: ColorsConstant.textColor,
    fontSize: 16,
    fontWeight: FontWeight.w300,
    overflow: TextOverflow.ellipsis,
  );

  static const contentStyle4 = TextStyle(
    color: ColorsConstant.textColor,
    fontSize: 14,
    // overflow: TextOverflow.ellipsis,
  );

  static const titleAppBarStyle = TextStyle(
    color: ColorsConstant.whiteColor,
  );
}

ThemeData customThemeData(BuildContext context) => ThemeData(
      primaryColor: ColorsConstant.blueColor,
      visualDensity: VisualDensity.adaptivePlatformDensity,
      scaffoldBackgroundColor: ColorsConstant.bgScaffoldColor,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: Color(0xff39A9CB),
        secondary: Color(0xffFEE440),
      ),
      textTheme: GoogleFonts.arimoTextTheme(Theme.of(context).textTheme),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: IconThemeData(color: ColorsConstant.whiteColor),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: ColorsConstant.bgScaffoldColor,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: ColorsConstant.grayColor,
      ),
      iconTheme: const IconThemeData(color: ColorsConstant.whiteColor),
      dialogTheme: const DialogTheme(
        titleTextStyle: TextStyleConstants.titleStyle2,
        contentTextStyle: TextStyleConstants.contentStyle3,
      ),
    );

Widget messageText(String text) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        style: TextStyleConstants.contentStyle3.copyWith(color: Colors.white70),
        textAlign: TextAlign.center,
      ),
    ),
  );
}

enum LimitedQuantity {
  yes,
  no,
}

enum ViewMode {
  staggeredGrid,
  list,
}

StaggeredTile getStaggeredTile({required int total, required int index}) {
  switch (total % 3) {
    case 1:
      if (index == total - 1) {
        return const StaggeredTile.count(3, 2);
      }
      return const StaggeredTile.count(1, 1);
    case 2:
      if (index == total - 1) {
        return const StaggeredTile.count(2, 2);
      } else if (index == total - 2) {
        return const StaggeredTile.count(1, 2);
      }
      return const StaggeredTile.count(1, 1);
    default:
      return const StaggeredTile.count(1, 1);
  }
}

Widget linearGradientIconAdd = ShaderMask(
  blendMode: BlendMode.srcATop,
  shaderCallback: (bounds) => const LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      Color(0xff4E9F3D),
      Color(0xffFF2626),
      Color(0xffFFC900),
      Color(0xff548CFF),
      Color(0xff49BCF6),
      Color(0xff1E2A78),
    ],
  ).createShader(bounds),
  child: const Icon(
    Icons.add,
    size: 40,
  ),
);
