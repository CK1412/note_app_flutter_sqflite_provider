import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../constants/app_constants.dart';
import '../providers/label_provider.dart';
import '../widgets/dialog_label_widget.dart';

class PickLabelScreen extends StatefulWidget {
  const PickLabelScreen({
    super.key,
    required this.labelTitle,
  });

  final String labelTitle;

  @override
  State<PickLabelScreen> createState() => _PickLabelScreenState();
}

class _PickLabelScreenState extends State<PickLabelScreen> {
  late String _labelChoosed;

  @override
  void initState() {
    super.initState();
    _labelChoosed = widget.labelTitle;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked:(didPop)  {
        if(didPop){
          return;
        }
        Navigator.of(context).pop(_labelChoosed);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: () {
              Navigator.of(context).pop(_labelChoosed);
            },
          ),
          actions: [
            IconButton(
              onPressed: () async {
                final String newLabel = await showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => const DialogLabelWidget(),
                );
                setState(() {
                  if (newLabel.isNotEmpty) {
                    _labelChoosed = newLabel;
                  }
                });
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Consumer<LabelProvider>(
          builder: (context, labelProvider, child) =>
          labelProvider.items.isEmpty
              ? child!
              : ListView.builder(
            itemBuilder: (context, index) {
              final currentLabel = labelProvider.items[index];
              return CheckboxListTile(
                value: _labelChoosed == currentLabel.title,
                title: Text(
                  currentLabel.title,
                  style: TextStyleConstants.titleStyle3,
                ),
                secondary: const Icon(Icons.label_outline),
                onChanged: (bool? value) {
                  setState(() {
                    if (value ?? false) {
                      _labelChoosed = currentLabel.title;
                    } else {
                      _labelChoosed = '';
                    }
                  });
                },
                activeColor: ColorsConstant.blueColor,
              );
            },
            itemCount: labelProvider.items.length,
          ),
          child: const SizedBox.shrink(),
        ),
      ),
    );
  }
}
