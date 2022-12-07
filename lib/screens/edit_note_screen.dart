import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:note_app_flutter_sqflite_provider/constants/assets_path.dart';
import 'package:note_app_flutter_sqflite_provider/functions/future_functions.dart';
import 'package:note_app_flutter_sqflite_provider/functions/picker_functions.dart';
import 'package:note_app_flutter_sqflite_provider/models/note.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:note_app_flutter_sqflite_provider/providers/note_provider.dart';
import 'package:note_app_flutter_sqflite_provider/utils/app_dialogs.dart';
import 'package:note_app_flutter_sqflite_provider/widgets/label_card_widget.dart';
import 'package:note_app_flutter_sqflite_provider/widgets/note_form_widget.dart';
import 'package:provider/provider.dart';

import 'image_detail_screen.dart';
import 'pick_label_screen.dart';

class EditNoteScreen extends StatefulWidget {
  const EditNoteScreen({
    Key? key,
    this.note,
    this.defaultLabel,
  }) : super(key: key);

  final Note? note;
  final String? defaultLabel;

  @override
  _EditNoteScreenState createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  // list of temporarily deleted image files
  final List<File> _tmpDeletedImageFiles = [];
  // list of temporarily added image files
  final List<File> _tmpAddedImageFiles = [];

  late String _title;
  late String _content;
  late String _label;
  late Color _bgColor;
  late List<String> _imagePaths;

  late String _defaultLabel;

  @override
  void initState() {
    super.initState();
    _defaultLabel = widget.defaultLabel ?? '';

    _title = widget.note?.title ?? '';
    _content = widget.note?.content ?? '';
    _bgColor = widget.note?.bgColor ?? ColorsConstant.bgScaffoldColor;
    _imagePaths = widget.note?.imagePaths ?? [];

    if (_defaultLabel.isNotEmpty) {
      _label = _defaultLabel;
    } else {
      _label = widget.note?.label ?? '';
    }
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(
          systemNavigationBarColor: ColorsConstant.grayColor,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: SystemUiOverlayStyle(systemNavigationBarColor: _bgColor),
      child: WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pop();
          deleteFileList(_tmpAddedImageFiles);
          return false;
        },
        child: Scaffold(
          backgroundColor: _bgColor,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                deleteFileList(_tmpAddedImageFiles);
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.camera_alt),
                onPressed: () => _addImageFromCamera(ImageSource.camera),
              ),
              IconButton(
                onPressed: _addManyImagesFromGallery,
                icon: const Icon(Icons.photo),
              ),
              IconButton(
                onPressed: _deleteNote,
                icon: const Icon(Icons.delete),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                  onPressed: _saveNote,
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              )
            ],
          ),
          body: ListView(
            children: [
              ImagesStaggeredGridView(
                imagePaths: _imagePaths,
                tmpDeletedImagePaths: _tmpDeletedImageFiles,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Form(
                      key: _formKey,
                      child: NoteFormWidget(
                        title: _title,
                        content: _content,
                        onChangedTitle: (value) => _title = value,
                        onChangedContent: (value) => _content = value,
                      ),
                    ),
                    if (_label.isNotEmpty) LabelCardWidget(title: _label)
                  ],
                ),
              )
            ],
          ),
          bottomNavigationBar: SizedBox(
            height: MediaQuery.of(context).size.height * .06,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _defaultLabel.isEmpty ? _addOrChangeLabel : null,
                  icon: const Icon(Icons.label),
                ),
                IconButton(
                  onPressed: () => pickColor(
                    context: context,
                    selectedColor: _bgColor,
                    changeColor: (value) {
                      setState(() {
                        _bgColor = value;
                      });
                    },
                  ),
                  icon: const Icon(Icons.color_lens_outlined),
                ),
                Expanded(
                  child: Center(
                    child: Text(
                      '${AppLocalizations.of(context)!.edited}: ${DateFormat.yMd().format(DateTime.now())}',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _saveNote() async {
    final bool isValid = _formKey.currentState!.validate();

    if (isValid) {
      final bool isUpdate = (widget.note != null);

      if (isUpdate) {
        _updateNote();
      } else {
        _addNote();
      }
      Navigator.of(context).pop();
      deleteFileList(_tmpDeletedImageFiles);
    }
  }

  _addNote() {
    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch,
      title: _title.trim(),
      content: _content.trim(),
      createdTime: DateTime.now(),
      label: _label,
      imagePaths: _imagePaths,
      bgColor: _bgColor,
    );

    Provider.of<NoteProvider>(context, listen: false).add(note);
  }

  _updateNote() {
    final note = widget.note!.copy(
      title: _title.trim(),
      content: _content.trim(),
      createdTime: DateTime.now(),
      label: _label,
      imagePaths: _imagePaths,
      bgColor: _bgColor,
    );

    Provider.of<NoteProvider>(context, listen: false).update(note);
  }

  _deleteNote() async {
    if (widget.note != null) {
      final action = await showConfirmDialog(
        context: context,
        title: AppLocalizations.of(context)!.remove_note + '?',
        content: AppLocalizations.of(context)!
            .are_you_sure_you_want_to_delete_this_note,
        actionName: AppLocalizations.of(context)!.remove,
      );
      if (action == true) {
        await context.read<NoteProvider>().delete(widget.note!.id);

        // return the note so it can be undone
        Navigator.of(context).pop(widget.note);

        deleteFileList(_tmpAddedImageFiles);
      }
    } else {
      Navigator.of(context).pop(widget.note);
      deleteFileList(_tmpAddedImageFiles);
    }
  }

  _addImageFromCamera(ImageSource camera) async {
    try {
      File? imgFile = await pickImage(ImageSource.camera);

      if (imgFile == null) return;

      setState(() {
        _imagePaths.insert(0, imgFile.path);
        _tmpAddedImageFiles.add(imgFile);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  _addManyImagesFromGallery() async {
    try {
      List<File>? imgFileList = await pickManyImages();

      if (imgFileList == null) return;

      final imgPathList = imgFileList.map((e) => e.path).toList();

      setState(() {
        _imagePaths.insertAll(0, imgPathList);
        _tmpAddedImageFiles.addAll(imgFileList);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  _addOrChangeLabel() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PickLabelScreen(labelTitle: _label),
      ),
    );
    setState(() {
      _label = result;
    });
  }
}

class ImagesStaggeredGridView extends StatefulWidget {
  const ImagesStaggeredGridView({
    Key? key,
    required this.imagePaths,
    required this.tmpDeletedImagePaths,
  }) : super(key: key);

  final List<String> imagePaths;
  final List<File> tmpDeletedImagePaths;

  @override
  State<ImagesStaggeredGridView> createState() =>
      _ImagesStaggeredGridViewState();
}

class _ImagesStaggeredGridViewState extends State<ImagesStaggeredGridView> {
  @override
  Widget build(BuildContext context) {
    if (widget.imagePaths.isEmpty) {
      return const SizedBox.shrink();
    } else {
      return StaggeredGridView.countBuilder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        crossAxisCount: 3,
        staggeredTileBuilder: (index) {
          int total = widget.imagePaths.length;

          return getStaggeredTile(total: total, index: index);
        },
        itemBuilder: (context, index) => InkWell(
          onTap: () async {
            await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => ImageDetailScreen(
                  index: index,
                  imagePaths: widget.imagePaths,
                ),
              ),
            );
            setState(() {});
          },
          onLongPress: () async {
            final result = await showConfirmDialog(
                context: context,
                title: AppLocalizations.of(context)!.delete_photos + '?',
                content:
                    AppLocalizations.of(context)!.you_want_to_remove_this_image,
                actionName: AppLocalizations.of(context)!.remove);
            if (result == true) {
              setState(() {
                widget.tmpDeletedImagePaths.add(File(widget.imagePaths[index]));
                widget.imagePaths.removeAt(index);
              });
            }
          },
          child: Hero(
            tag: 'viewImg$index',
            child: FadeInImage(
              placeholder: AssetImage(AssetsPath.placeholderImage),
              fadeInDuration: const Duration(milliseconds: 500),
              image: FileImage(
                File(widget.imagePaths[index]),
              ),
              fit: BoxFit.cover,
              placeholderFit: BoxFit.cover,
            ),
          ),
        ),
        itemCount: widget.imagePaths.length,
      );
    }
  }
}
