import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:ui' as ui;

import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/view/home.dart';
import 'package:bubu_app/view/home/not_data_page/not_birthday_page.dart';
import 'package:bubu_app/view/home/not_data_page/not_image_page.dart';
import 'package:bubu_app/view/home/not_data_page/not_instagram_page.dart';
import 'package:bubu_app/view_model/location_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

double safeHeight(BuildContext context) {
  return MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
}

void bottomSheet(
  BuildContext context, {
  required Widget page,
  required bool isBackgroundColor,
  required bool isPOP,
}) {
  showModalBottomSheet<Widget>(
    isScrollControlled: true,
    isDismissible: isPOP,
    enableDrag: isPOP,
    context: context,
    elevation: 0,
    backgroundColor: isBackgroundColor ? Colors.white : Colors.transparent,
    shape: isBackgroundColor
        ? const RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.only(
              topEnd: Radius.circular(15),
              topStart: Radius.circular(15),
            ),
          )
        : null,
    builder: (context) => page,
  );
}

Future getMobileImage({
  required void Function(Uint8List) onSuccess,
  required void Function() onError,
}) async {
  try {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final List<int> imageBytes = await File(pickedFile.path).readAsBytes();
      final String base64Image = base64Encode(imageBytes);
      final Uint8List unit8 = base64Decode(base64Image);
      onSuccess(unit8);
    }
  } catch (e) {
    onError();
  }
}

Future openURL({required String url, required void Function()? onError}) async {
  final Uri setURL = Uri.parse(url);
  if (await canLaunchUrl(setURL)) {
    await launchUrl(setURL, mode: LaunchMode.inAppWebView);
  } else {
    if (onError != null) {
      onError();
    }
  }
}

EdgeInsetsGeometry xPadding(
  BuildContext context,
) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return EdgeInsets.only(
    left: safeAreaWidth * 0.03,
    right: safeAreaWidth * 0.03,
  );
}

void precacheImages(
  BuildContext context,
  List<Uint8List> imageList,
) {
  for (final imageData in imageList) {
    final imageProvider = MemoryImage(imageData);
    precacheImage(imageProvider, context);
  }
}

void showAlertDialog(
  BuildContext context, {
  required void Function()? ontap,
  required String title,
  required String? subTitle,
  required String? buttonText,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: nText(
        title,
        color: Colors.black,
        fontSize: safeAreaWidth / 25,
        bold: 700,
      ),
      content: subTitle != null
          ? Padding(
              padding: EdgeInsets.only(top: safeAreaHeight * 0.01),
              child: Text(
                subTitle,
                style: TextStyle(
                  decoration: TextDecoration.none,
                  fontFamily: "Normal",
                  fontVariations: const [FontVariation("wght", 400)],
                  color: Colors.black.withOpacity(0.7),
                  fontWeight: FontWeight.w100,
                  fontSize: safeAreaWidth / 32,
                ),
              ),
            )
          : null,
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text(
            "キャンセル",
            style: TextStyle(fontSize: safeAreaWidth / 25),
          ),
        ),
        if (buttonText != null) ...{
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: ontap,
            child: Text(
              buttonText,
              style: TextStyle(fontSize: safeAreaWidth / 25),
            ),
          ),
        },
      ],
    ),
  );
}

Future<List<Color>> extractMainColorsFromImage(Uint8List imageData) async {
  // 画像データからui.Imageを作成
  final Completer<ui.Image> completer = Completer();
  ui.decodeImageFromList(imageData, (ui.Image img) {
    completer.complete(img);
  });
  final ui.Image image = await completer.future;

  final ByteData? data = await image.toByteData();
  final int width = image.width;
  final int height = image.height;
  final Color topColor = extractDominantColor(data, width, height, 50);
  final Color bottomColor =
      extractDominantColor(data, width, height, 50, isBottomRegion: true);
  return [topColor, bottomColor];
}

Color extractDominantColor(
  ByteData? data,
  int width,
  int height,
  int regionHeight, {
  bool isBottomRegion = false,
}) {
  if (data == null) return Colors.transparent;
  final int startY = isBottomRegion ? height - regionHeight : 0;
  final int endY = isBottomRegion ? height : regionHeight;
  final Map<int, int> colorCount = {};
  for (int y = startY; y < endY; y++) {
    for (int x = 0; x < width; x++) {
      final int offset = (y * width + x) * 4;
      final int red = data.getUint8(offset);
      final int green = data.getUint8(offset + 1);
      final int blue = data.getUint8(offset + 2);
      final int alpha = data.getUint8(offset + 3);
      final int colorValue = (alpha << 24) | (red << 16) | (green << 8) | blue;
      if (!colorCount.containsKey(colorValue)) {
        colorCount[colorValue] = 1;
      } else {
        colorCount[colorValue] = colorCount[colorValue]! + 1;
      }
    }
  }
  final int dominantColorValue =
      colorCount.entries.reduce((a, b) => a.value > b.value ? a : b).key;
  return Color(dominantColorValue);
}

Widget nextScreenWhisUserDataCheck(UserData userData) {
  return userData.birthday.isEmpty
      ? NotBirthdayPage(
          userData: userData,
        )
      : userData.instagram.isEmpty
          ? NotInstagramPage(
              userData: userData,
            )
          : userData.imgList.isEmpty
              ? NotImgPage(
                  userData: userData,
                )
              : HomePage(id: userData.id);
}

bool isWithin150Meters(
  double baseLat,
  double baseLon,
  double targetLat,
  double targetLon,
) {
  // 距離をキロメートルで計算
  final double distance =
      calculateDistance(baseLat, baseLon, targetLat, targetLon);

  // 距離が0.2キロメートル（200メートル）以内かどうかを判断
  return distance <= 0.15;
}
