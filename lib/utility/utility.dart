import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

double safeHeight(BuildContext context) {
  return MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
}

void bottomSheet(
  BuildContext context,
  Widget page,
) {
  showModalBottomSheet<Widget>(
    isScrollControlled: true,
    context: context,
    elevation: 0,
    backgroundColor: Colors.transparent,
    // shape: const RoundedRectangleBorder(
    //   borderRadius: BorderRadiusDirectional.only(
    //     topEnd: Radius.circular(15),
    //     topStart: Radius.circular(15),
    //   ),
    // ),
    builder: (context) => page,
  );
}

Future getMobileImage({
  required void Function(Uint8List) onSuccess,
  required void Function() onError,
}) async {
  final picker = ImagePicker();
  try {
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
    await launchUrl(setURL);
  } else {
    if (onError != null) {
      onError();
    }
  }
}
