import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bubu_app/component/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
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
      final compressedResult =
          await FlutterImageCompress.compressWithList(unit8, quality: 50);
      onSuccess(Uint8List.fromList(compressedResult));
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
