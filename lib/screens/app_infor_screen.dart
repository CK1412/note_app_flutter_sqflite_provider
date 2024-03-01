import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../constants/app_constants.dart';
import '../widgets/unordered_list_widget.dart';

class AppInforScreen extends StatelessWidget {
  const AppInforScreen({super.key});

  static const routeName = '/app-infor';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          AppLocalizations.of(context)!.app_info,
          style: TextStyleConstants.titleAppBarStyle,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            UnorderedListWidget(
              contentList: [
                Content(
                  content: AppLocalizations.of(context)!
                      .this_app_is_made_for_educational_purposes_only_not_for_commercial_purposes,
                ),
              ],
            ),
            UnorderedListWidget(
              contentList: [
                Content(
                  content: AppLocalizations.of(context)!
                      .images_used_in_the_application_are_not_owned_by_me,
                ),
              ],
            ),
            UnorderedListWidget(
              contentList: [
                Content(
                  content: '${AppLocalizations.of(context)!.connect_with_me}: ',
                  linkName: 'Facebook',
                  link: 'https://www.facebook.com/coolkid48691412',
                ),
                Content(
                  content: ', ',
                  linkName: 'Github',
                  link: 'https://github.com/CK1412',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
