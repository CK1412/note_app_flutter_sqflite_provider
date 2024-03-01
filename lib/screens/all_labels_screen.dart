import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../models/label.dart';
import '../providers/label_provider.dart';
import '../providers/note_provider.dart';
import '../utils/app_dialogs.dart';
import '../widgets/custom_list_tile_widget.dart';
import '../widgets/dialog_label_widget.dart';
import 'all_notes_by_label_screen.dart';
import 'drawer_screen.dart';

class AllLabelsScreen extends StatelessWidget {
  const AllLabelsScreen({super.key});
  static const routeName = '/all-label';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.all_labels,
          style: TextStyleConstants.titleAppBarStyle,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const DialogLabelWidget(),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      drawer: const DrawerScreen(),
      body: RefreshIndicator(
        onRefresh: () => context.read<LabelProvider>().fetchAndSet(),
        child: Consumer<LabelProvider>(
          builder: (context, labelProvider, child) =>
              labelProvider.items.isEmpty
                  ? child!
                  : LabelListView(labels: labelProvider.items),
          child: messageText(
            AppLocalizations.of(context)!.there_are_currently_no_labels,
          ),
        ),
      ),
    );
  }
}

class LabelListView extends StatelessWidget {
  const LabelListView({
    super.key,
    required this.labels,
  });

  final List<Label> labels;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        final currentLabel = labels[index];

        return Dismissible(
          key: ValueKey<int>(currentLabel.id ?? 0),
          direction: DismissDirection.endToStart,
          background: Container(
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            alignment: Alignment.centerRight,
            child: const Icon(
              Icons.delete,
              color: Colors.white70,
            ),
          ),
          confirmDismiss: (_) => showConfirmDialog(
            context: context,
            title: '${AppLocalizations.of(context)!.remove_label}?',
            content: AppLocalizations.of(context)!
                .we_will_remove_this_label_from_all_your_notes_this_label_will_also_be_removed,
            actionName: AppLocalizations.of(context)!.remove,
          ),
          onDismissed: (_) async {
            await context.read<LabelProvider>().delete(currentLabel.id!);

            if (context.mounted) {
              await Provider.of<NoteProvider>(context, listen: false)
                  .removeLabelContent(
                content: currentLabel.title,
              );
            }
          },
          child: CustomListTileWidget(
            title: currentLabel.title,
            iconData: Icons.label_outline,
            onTap: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) =>
                      AllNotesByLabelScreen(label: currentLabel),
                ),
              );
            },
            trailing: IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => DialogLabelWidget(
                    label: currentLabel,
                  ),
                );
              },
              icon: const Icon(Icons.edit),
            ),
          ),
        );
      },
      itemCount: labels.length,
      padding: const EdgeInsets.only(bottom: 16),
    );
  }
}
