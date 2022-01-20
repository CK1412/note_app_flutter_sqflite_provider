import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:note_app_flutter_sqflite_provider/constants/app_constants.dart';
import 'package:note_app_flutter_sqflite_provider/functions/future_functions.dart';

class UnorderedListWidget extends StatelessWidget {
  const UnorderedListWidget({
    Key? key,
    required this.contentList,
  }) : super(key: key);

  final List<Content> contentList;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(" •  ", style: TextStyleConstants.titleStyle2),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    for (var item in contentList) ...[
                      TextSpan(
                        text: item.content,
                        style: TextStyleConstants.contentStyle2,
                      ),
                      TextSpan(
                        text: item.linkName,
                        style: TextStyleConstants.contentStyle2
                            .copyWith(color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = (item.link.isNotEmpty)
                              ? () async => await openLink(item.link)
                              : null,
                      )
                    ]
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(
          height: 6,
        ),
      ],
    );
  }
}

class Content {
  final String content;
  final String linkName;
  final String link;

  Content({
    required this.content,
    this.linkName = '',
    this.link = '',
  });
}
