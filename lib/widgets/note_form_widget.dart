import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../constants/app_constants.dart';

class NoteFormWidget extends StatelessWidget {
  const NoteFormWidget({
    super.key,
    required this.title,
    required this.content,
    required this.onChangedTitle,
    required this.onChangedContent,
  });

  final String title;
  final String content;
  final ValueChanged onChangedTitle;
  final ValueChanged onChangedContent;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        TextFormField(
          maxLines: null,
          initialValue: title,
          style: TextStyleConstants.titleStyle1,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!.title,
          ),
          validator: (value) => value!.length > 50
              ? AppLocalizations.of(context)!
                  .title_should_not_exceed_50_characters
              : null,
          onChanged: onChangedTitle,
          textInputAction: TextInputAction.next,
        ),
        TextFormField(
          maxLines: null,
          initialValue: content,
          style: TextStyleConstants.contentStyle2,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: AppLocalizations.of(context)!.note,
          ),
          validator: (value) =>
              value!.isEmpty ? AppLocalizations.of(context)!.blank_note : null,
          onChanged: onChangedContent,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }
}
