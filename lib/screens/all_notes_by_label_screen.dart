import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/app_constants.dart';
import '../functions/future_functions.dart';
import '../models/label.dart';
import '../providers/note_provider.dart';
import '../utils/note_search.dart';
import '../widgets/note_list_view_widget.dart';
import '../widgets/note_note_ui_widget.dart';
import 'drawer_screen.dart';
import 'edit_note_screen.dart';

class AllNotesByLabelScreen extends StatefulWidget {
  const AllNotesByLabelScreen({
    super.key,
    required this.label,
  });

  final Label label;

  @override
  State<AllNotesByLabelScreen> createState() => _AllNotesByLabelScreenState();
}

class _AllNotesByLabelScreenState extends State<AllNotesByLabelScreen> {
  var _viewMode = ViewMode.staggeredGrid.name;
  bool _isLoading = false;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    setState(() {
      _isLoading = true;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isLoading) {
      Future.wait([
        _loadViewMode(),
        refreshOrGetData(context),
      ]).whenComplete(() {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  Future _loadViewMode() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('view-mode')) {
      return;
    }

    if (context.mounted) {
      setState(() {
        _viewMode = prefs.getString('view-mode') ?? ViewMode.staggeredGrid.name;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          widget.label.title,
          style: TextStyleConstants.titleAppBarStyle,
        ),
        actions: [
          if (context
              .watch<NoteProvider>()
              .itemsByLabel(widget.label.title)
              .isNotEmpty)
            IconButton(
              onPressed: () {
                showSearch(
                  context: context,
                  delegate: NoteSearch(
                    isNoteByLabel: true,
                    label: widget.label.title,
                  ),
                );
              },
              icon: const Icon(Icons.search),
            ),
          IconButton(
            onPressed: () async {
              final result = await changeViewMode(_viewMode);
              setState(() {
                _viewMode = result;
              });
            },
            icon: _viewMode == ViewMode.staggeredGrid.name
                ? const Icon(Icons.view_stream)
                : const Icon(Icons.grid_view),
          ),
          const SizedBox(
            width: 6,
          ),
        ],
      ),
      drawer: const DrawerScreen(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: () => refreshOrGetData(context),
              child: Consumer<NoteProvider>(
                builder: (context, noteProvider, child) => noteProvider
                        .itemsByLabel(widget.label.title)
                        .isEmpty
                    ? child!
                    : NoteListViewWidget(
                        notes: noteProvider.itemsByLabel(widget.label.title),
                        viewMode: _viewMode,
                        scaffoldContext: _scaffoldKey.currentContext,
                      ),
                child: NoNoteUIWidget(
                  title: AppLocalizations.of(context)!
                      .there_are_no_notes_for_this_label,
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: linearGradientIconAdd,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  EditNoteScreen(defaultLabel: widget.label.title),
            ),
          );
        },
      ),
    );
  }
}
