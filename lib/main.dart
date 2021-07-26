import 'dart:convert';
import 'dart:ui';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:imgly_sdk/imgly_sdk.dart';
import 'package:video_editor_sdk/video_editor_sdk.dart';

void main() {
  runApp(MyApp());
}

/// The example application for the video_editor_sdk plugin.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Configuration createConfiguration() {
    final flutterSticker = Sticker(
        "example_sticker_logos_flutter", "Flutter", "assets/Flutter-logo.png");
    final imglySticker = Sticker(
        "example_sticker_logos_imgly", "img.ly", "assets/imgly-Logo.png",
        tintMode: TintMode.solid);

    /// A completely custom category.
    final logos = StickerCategory(
        "example_sticker_category_logos", "Logos", "assets/Flutter-logo.png",
        items: [flutterSticker, imglySticker]);

    /// A predefined category.
    final emoticons =
        StickerCategory.existing("imgly_sticker_category_emoticons");

    /// A customized predefined category.
    final shapes =
        StickerCategory.existing("imgly_sticker_category_shapes", items: [
      Sticker.existing("imgly_sticker_shapes_badge_01"),
      Sticker.existing("imgly_sticker_shapes_arrow_02")
    ]);
    var categories = <StickerCategory>[logos, emoticons, shapes];
    final configuration = Configuration(
        sticker:
            StickerOptions(personalStickers: true, categories: categories));
    return configuration;
  }

  Configuration jsCreateConfiguration() {
    final androidConfiguration = Configuration(
        export: ExportOptions(
            video:
                VideoOptions(format: VideoFormat.mp4, codec: VideoCodec.h264)));
    final iosConfiguration = Configuration(
        export: ExportOptions(
            video: VideoOptions(
                format: VideoFormat.quicktime, codec: VideoCodec.hevc)));

    if (Platform.isAndroid)
      return androidConfiguration;
    else
      return iosConfiguration;
    // return configuration;
  }

  @override
  void initState() {
    super.initState();
    VESDK.unlockWithLicense("assets/vesdk_license");
  }

  void presentEditor() async {
    final result = await VESDK.openEditor(Video("assets/Mantis.mp4"),
        configuration: jsCreateConfiguration());
    print(result?.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          appBar: AppBar(
            title: const Text('VideoEditor SDK Example'),
          ),
          body: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text("Open video editor"),
                subtitle: Text("Click to edit a sample video."),
                onTap: presentEditor,
              );
            },
            itemCount: 1,
          )),
    );
  }
}
