import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/settings_screen.dart';
import 'l10n/l10n.dart';
import 'providers/label_provider.dart';
import 'providers/locale_provider.dart';
import 'providers/note_provider.dart';
import 'package:provider/provider.dart';

import 'constants/app_constants.dart';
import 'screens/all_labels_screen.dart';
import 'screens/all_notes_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'screens/app_infor_screen.dart';
import 'screens/drawer_screen.dart';

main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarColor: ColorsConstant.grayColor,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NoteProvider()),
        ChangeNotifierProvider(create: (_) => LabelProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      builder: (context, child) => MaterialApp(
        title: 'Note-App',
        debugShowCheckedModeBanner: false,
        themeMode: ThemeMode.dark,
        theme: customThemeData(context),
        initialRoute: '/',
        routes: {
          '/': (context) => const AllNotesScreen(),
          DrawerScreen.routeName: (context) => const DrawerScreen(),
          AllLabelsScreen.routeName: (context) => const AllLabelsScreen(),
          AppInforScreen.routeName: (context) => const AppInforScreen(),
          SettingsScreen.routeName: (context) => const SettingsScreen(),
        },
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: L10n.all,
        locale: context.watch<LocaleProvider>().locale,
      ),
    );
  }
}
