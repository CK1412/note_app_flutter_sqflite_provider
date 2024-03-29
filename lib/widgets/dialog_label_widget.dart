import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../models/label.dart';
import '../models/note.dart';
import '../providers/label_provider.dart';
import '../providers/note_provider.dart';

class DialogLabelWidget extends StatefulWidget {
  const DialogLabelWidget({
    super.key,
    this.label,
  });

  final Label? label;

  @override
  State<DialogLabelWidget> createState() => _DialogLabelWidgetState();
}

class _DialogLabelWidgetState extends State<DialogLabelWidget> {
  final _labelController = TextEditingController();

  bool _isSubmitted = false;

  String? get _errorMessage {
    final text = _labelController.text.trim();
    if (text.isEmpty) {
      return AppLocalizations.of(context)!.label_cannot_be_empty;
    }
    if (text.length > 30) {
      return AppLocalizations.of(context)!
          .label_can_not_be_more_than_30_characters;
    }
    final indexLabelExist =
        Provider.of<LabelProvider>(context, listen: false).items.indexWhere(
              (e) => e.title.toLowerCase() == text.toLowerCase(),
            );
    if (indexLabelExist != -1) {
      return AppLocalizations.of(context)!.label_already_exists;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _labelController.text = widget.label?.title ?? '';
  }

  @override
  void dispose() {
    super.dispose();
    _labelController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _labelController,
      builder: (context, value, child) => AlertDialog(
        title: widget.label == null
            ? Text(AppLocalizations.of(context)!.add_label)
            : Text(AppLocalizations.of(context)!.edit_label),
        content: TextField(
          controller: _labelController,
          autofocus: true,
          decoration: InputDecoration(
            errorText: _isSubmitted ? _errorMessage : null,
          ),
          style: TextStyleConstants.contentStyle3,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop('');
            },
            child: Text(AppLocalizations.of(context)!.cancel),
          ),
          ElevatedButton(
            onPressed: _labelController.value.text.isNotEmpty ? _submit : null,
            child: widget.label == null
                ? Text(AppLocalizations.of(context)!.create)
                : Text(AppLocalizations.of(context)!.edit),
          ),
        ],
      ),
    );
  }

  void _submit() {
    setState(() {
      _isSubmitted = true;
    });

    if (_errorMessage == null) {
      if (widget.label == null) {
        _addLabel();
      } else {
        _updateLabel();
      }

      Navigator.of(context).pop(_labelController.text.trim());
    }
  }

  void _addLabel() {
    final label = Label(
      title: _labelController.text.trim(),
    );
    context.read<LabelProvider>().add(label);
  }

  void _updateLabel() {
    final String newTitle = _labelController.text.trim();

    final label = widget.label!.copy(title: newTitle);

    Provider.of<LabelProvider>(context, listen: false).update(label);

    //* update note when label changed

    final List<Note> temptNotes =
        Provider.of<NoteProvider>(context, listen: false)
            .items
            .where((e) => e.label == widget.label!.title)
            .toList();

    final List<Note> notesDidUpdated =
        temptNotes.map((e) => e.copy(label: newTitle)).toList();

    for (int i = 0; i < notesDidUpdated.length; i++) {
      final Note element = notesDidUpdated[i];
      context.read<NoteProvider>().update(element);
    }
  }
}
