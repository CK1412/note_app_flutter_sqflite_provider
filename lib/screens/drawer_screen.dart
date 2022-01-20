import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:note_app_flutter_sqflite_provider/providers/label_provider.dart';
import 'package:note_app_flutter_sqflite_provider/providers/locale_provider.dart';
import 'package:note_app_flutter_sqflite_provider/screens/settings_screen.dart';
import 'package:note_app_flutter_sqflite_provider/utils/app_dialogs.dart';
import 'package:note_app_flutter_sqflite_provider/widgets/custom_list_tile_widget.dart';
import 'package:note_app_flutter_sqflite_provider/widgets/dialog_label_widget.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'all_labels_screen.dart';
import 'all_notes_by_label_screen.dart';
import 'app_infor_screen.dart';

class DrawerScreen extends StatelessWidget {
  const DrawerScreen({Key? key}) : super(key: key);
  static const routeName = '/drawer';
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: ColorsConstant.bgDrawerColor,
      child: ListView(
        children: [
          ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) => const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff49BCF6),
                Color(0xff1E2A78),
              ],
            ).createShader(bounds),
            child: Padding(
              padding:
                  (context.watch<LocaleProvider>().locale.languageCode != 'ar')
                      ? const EdgeInsets.only(left: 16.0)
                      : const EdgeInsets.only(right: 16.0),
              child: Text(
                AppLocalizations.of(context)!.note,
                style: const TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.all_notes,
            iconData: Icons.note_alt,
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.all_labels,
            iconData: Icons.label,
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(AllLabelsScreen.routeName);
            },
          ),
          const Divider(
            thickness: 1,
            color: ColorsConstant.blueColor,
          ),
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.create_new_label,
            iconData: Icons.add,
            onTap: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const DialogLabelWidget(),
              );
            },
          ),
          Consumer<LabelProvider>(
            builder: (context, labelProvider, child) => ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              itemCount: labelProvider.items.length,
              itemBuilder: (context, index) => CustomListTileWidget(
                title: labelProvider.items[index].title,
                iconData: Icons.label_outline,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => AllNotesByLabelScreen(
                        label: labelProvider.items[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const Divider(
            thickness: 1,
            color: ColorsConstant.blueColor,
          ),
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.sync_with_the_cloud,
            iconData: Icons.sync_rounded,
            onTap: () => showNewFeatureNotificationDialog(context),
          ),
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.settings,
            iconData: Icons.settings,
            onTap: () {
              Navigator.of(context).pushNamed(SettingsScreen.routeName);
            },
          ),
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.app_info,
            iconData: Icons.info_outline,
            onTap: () {
              Navigator.of(context).pushNamed(AppInforScreen.routeName);
            },
          ),
          const SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
