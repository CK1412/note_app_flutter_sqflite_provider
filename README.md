# <img align="center" width="30px" src="assets\images\note_logo.png" /> note_app_flutter_sqflite_provider

## 👋 Introduce

This is a note taking app made with **[Flutter](https://flutter.dev/)** that helps you to take notes of important things on your phone anytime without internet connection. (Design ideas based on Google Keep App)

The application I created for the purpose of learning to review knowledge such as CRUD SQlite, Provider (state management) and learn some new knowledge such as application internationalization, freeing memory.

During the implementation process, I encountered some errors and promptly fixed them. Difficulties I have encountered:

- delete image files and cache when not in use
- error when undoing a note
- listen for changes when creating new labels
- display grid list of images
- meet some errors on performance related async/await, query sqlite
- and there are some more problems

Finally after a while looking for a fix, I finished this application. I tried to optimize the lines of code to the best of my ability (at the time of project implementation). To make it better, I look forward to receiving your contributions.

**_Don't hesitate to give this project 1 🌟 if you like it. Thank you_**

## 👀 App preview

![app preview 1](app_preview/Google-Pixel-4-XL-Presentation.png)
![app preview 2](app_preview/Google-Pixel-4-XL-Presentation-2.png)

## 📙 How to Use the Project

You can use the app by installing [Play Store][app_for_android] (applicable to android devices)

## 🥰 The main functions of the application

- add, delete, edit, undo, search notes
- add, delete, edit labels
- add images from camera and gallery
- change note background color
- show notes by label
- display list of notes, labels
- Support 3 languages: Vietnamese, English, Arabic (If the device does not use the above 3 languages, the first installation will default to Vietnamese)
- all data will be saved in local storage

## ℹ️ Version and packages used

- Flutter 3.19.1
- Dart 3.3.0
- perform operations with path: [path][path]
- find commonly used locations on the file system: [path_provider][path_provider]
- store data locally: [sqflite][sqflite]
- state management: [provider][provider]
- use font of google: [google_fonts][google_fonts]
- create staggered grid list: [flutter_staggered_grid_view][flutter_staggered_grid_view]
- store data as key-value (in this project is to save the view mode): [shared_preferences][shared_preferences]
- lauch URL: [url_launcher][url_launcher]
- pick image from camera and gallery: [image_picker][image_picker]
- pick color: [flutter_colorpicker][flutter_colorpicker]
- format date and localizations: [intl][intl]
- zoomable image: [photo_view][photo_view]
- create splash screen: [flutter_native_splash][flutter_native_splash]
- updating app's launcher icon: [flutter_launcher_icons][flutter_launcher_icons]

## 📝 License

You can use the free source code for learning purposes. If you use for other purposes, please quote the source.

<br/>

[app_for_android]: https://play.google.com/store/apps/details?id=github.ck1412.noteApp
[app_apk]: https://drive.google.com/file/d/1TYwtfyO335ej8BSNzWC5NQU_UO7vnAyr/view?usp=sharing

<!-- Packages -->

[path]: https://pub.dev/packages/path
[path_provider]: https://pub.dev/packages/path_provider
[sqflite]: https://pub.dev/packages/sqflite
[provider]: https://pub.dev/packages/provider
[google_fonts]: https://pub.dev/packages/google_fonts
[flutter_staggered_grid_view]: https://pub.dev/packages/flutter_staggered_grid_view
[shared_preferences]: https://pub.dev/packages/shared_preferences
[url_launcher]: https://pub.dev/packages/url_launcher
[image_picker]: https://pub.dev/packages/image_picker
[flutter_colorpicker]: https://pub.dev/packages/flutter_colorpicker
[intl]: https://pub.dev/packages/intl
[photo_view]: https://pub.dev/packages/photo_view
[flutter_native_splash]: https://pub.dev/packages/flutter_native_splash
[flutter_launcher_icons]: https://pub.dev/packages/flutter_launcher_icons

<!--
start : 2/1/2022
end : 20/1/2022
-->
