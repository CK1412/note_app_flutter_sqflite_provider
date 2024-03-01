import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../functions/future_functions.dart';
import '../l10n/l10n.dart';
import '../providers/label_provider.dart';
import '../providers/locale_provider.dart';
import '../providers/note_provider.dart';
import '../utils/app_dialogs.dart';
import '../widgets/custom_list_tile_widget.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const routeName = '/setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.settings,
          style: TextStyleConstants.titleAppBarStyle,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.delete_all_notes,
            iconData: Icons.note_alt,
            onTap: null,
            trailing: ElevatedButton(
              onPressed: context.watch<NoteProvider>().items.isNotEmpty
                  ? () async {
                      _deleteAllNotes(context);
                      await _deleteFolderContainingImages();
                    }
                  : null,
              child: Text(AppLocalizations.of(context)!.delete_all),
            ),
          ),
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.delete_all_labels,
            iconData: Icons.label,
            onTap: null,
            trailing: ElevatedButton(
              onPressed: context.watch<LabelProvider>().items.isNotEmpty
                  ? () => _deleteAllLabels(context)
                  : null,
              child: Text(AppLocalizations.of(context)!.delete_all),
            ),
          ),
          CustomListTileWidget(
            title: AppLocalizations.of(context)!.language,
            iconData: Icons.language,
            onTap: null,
            trailing: customDropdownButton(context),
          ),
          const Spacer(),
          OutlinedButton(
            onPressed: (context.watch<NoteProvider>().items.isNotEmpty ||
                    context.watch<LabelProvider>().items.isNotEmpty)
                ? () => _resetApp(context)
                : null,
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: (context.watch<NoteProvider>().items.isNotEmpty ||
                        context.watch<LabelProvider>().items.isNotEmpty)
                    ? ColorsConstant.blueColor
                    : ColorsConstant.grayColor,
              ),
            ),
            child: Text(AppLocalizations.of(context)!.reset_app),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  Widget customDropdownButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        border: Border.all(
          color: ColorsConstant.blueColor,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<Locale>(
          value: context.watch<LocaleProvider>().locale,
          style: TextStyleConstants.contentStyle3,
          dropdownColor: ColorsConstant.grayColor,
          iconEnabledColor: ColorsConstant.blueColor,
          elevation: 0,
          isDense: true,
          alignment: AlignmentDirectional.center,
          items: L10n.all.map<DropdownMenuItem<Locale>>((locale) {
            return DropdownMenuItem(
              value: locale,
              child: Text(L10n.getLanguage(code: locale.languageCode)),
              onTap: () {
                context.read<LocaleProvider>().changeLocale(locale);
              },
            );
          }).toList(),
          onChanged: (_) {},
        ),
      ),
    );
  }

  void _deleteAllNotes(BuildContext context) {
    showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context)!.alert,
      content: AppLocalizations.of(context)!
          .the_notes_you_have_added_will_be_deleted_and_cannot_be_recovered,
      actionName: AppLocalizations.of(context)!.delete_all,
    ).then((bool? result) {
      if (result ?? false) {
        context.read<NoteProvider>().deleteAll();
        deleteCacheDir();
      }
    });
  }

  void _deleteAllLabels(BuildContext context) {
    showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context)!.alert,
      content: AppLocalizations.of(context)!
          .the_labels_you_have_added_will_be_deleted_and_cannot_be_recovered,
      actionName: AppLocalizations.of(context)!.delete_all,
    ).then((bool? result) async {
      if (result ?? false) {
        await context.read<LabelProvider>().deleteAll();
        if(context.mounted) {
          unawaited(context.read<NoteProvider>().removeAllLabelContent());
        }
      }
    });
  }

  void _resetApp(BuildContext context) {
    showConfirmDialog(
      context: context,
      title: AppLocalizations.of(context)!.alert,
      content: AppLocalizations.of(context)!
          .all_your_data_will_be_deleted_and_cannot_be_recovered,
      actionName: AppLocalizations.of(context)!.reset,
    ).then((bool? result) async {
      if (result ?? false) {
        await context.read<LabelProvider>().deleteAll();
        if(context.mounted) {
          await Provider.of<NoteProvider>(context,listen: false).deleteAll();
        }
        await _deleteFolderContainingImages();
        unawaited(deleteCacheDir());
      }
    });
  }

  Future<void> _deleteFolderContainingImages() async {
    final appDir = await getApplicationDocumentsDirectory();
    final imagesDir = Directory('${appDir.path}/images/');
    if (imagesDir.existsSync()) {
      imagesDir.deleteSync(recursive: true);
    }
  }
}
