import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Widget myChatWidget(
  BuildContext context, {
  required String messeageText,
  required DateTime dateTime,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.only(
      top: safeAreaHeight * 0.03,
      left: safeAreaWidth * 0.04,
      right: safeAreaWidth * 0.04,
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.only(right: safeAreaWidth * 0.01),
          child: Text(
            textAlign: TextAlign.end,
            DateFormat('HH:mm').format(dateTime),
            style: TextStyle(
              color: Colors.white,
              fontSize: safeAreaWidth / 40,
            ),
          ),
        ),
        Container(
          constraints: BoxConstraints(maxWidth: safeAreaWidth * 0.7),
          decoration: BoxDecoration(
            color: blueColor2,
            border: Border.all(color: Colors.black.withOpacity(0.2)),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(25),
              topLeft: Radius.circular(25),
              bottomRight: Radius.circular(25),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(safeAreaWidth * 0.03),
            child: Text(
              messeageText,
              style: TextStyle(
                fontFamily: "Normal",
                fontVariations: const [FontVariation("wght", 700)],
                color: Colors.white,
                fontSize: safeAreaWidth / 30,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget recipientChatWidget(
  BuildContext context, {
  required String messeageText,
  required Uint8List img,
  required DateTime dateTime,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;

  return Padding(
    padding: EdgeInsets.only(
      top: safeAreaHeight * 0.01,
      left: safeAreaWidth * 0.03,
      right: safeAreaWidth * 0.03,
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(right: safeAreaWidth * 0.03),
          child: Container(
            width: safeAreaHeight * 0.04,
            height: safeAreaHeight * 0.04,
            decoration: BoxDecoration(
              image:
                  DecorationImage(image: MemoryImage(img), fit: BoxFit.cover),
              shape: BoxShape.circle,
            ),
          ),
        ),
        Expanded(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                constraints: BoxConstraints(maxWidth: safeAreaWidth * 0.6),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.8),
                  border: Border.all(color: Colors.black.withOpacity(0.2)),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.all(safeAreaWidth * 0.03),
                  child: Text(
                    messeageText,
                    style: TextStyle(
                      fontFamily: "Normal",
                      fontVariations: const [FontVariation("wght", 700)],
                      color: Colors.white,
                      fontSize: safeAreaWidth / 30,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: safeAreaWidth * 0.01),
                child: Text(
                  textAlign: TextAlign.end,
                  DateFormat('HH:mm').format(dateTime),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: safeAreaWidth / 40,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget textFieldWidget({
  required BuildContext context,
  required TextEditingController? controller,
  required void Function()? onTap,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: FractionalOffset.topCenter,
        end: FractionalOffset.bottomCenter,
        colors: [
          blackColor.withOpacity(0),
          blackColor.withOpacity(1),
          blackColor.withOpacity(1),
        ],
      ),
    ),
    child: Padding(
      padding: EdgeInsets.only(
        top: safeAreaHeight * 0.01,
        bottom: safeAreaHeight * 0.01,
        left: safeAreaWidth * 0.03,
        right: safeAreaWidth * 0.03,
      ),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: safeAreaHeight * 0.15,
        ),
        width: safeAreaWidth * 0.95,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 59, 59, 59).withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  left: safeAreaWidth * 0.05,
                  right: safeAreaWidth * 0.03,
                ),
                child: TextFormField(
                  controller: controller,
                  maxLines: null,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontFamily: "Normal",
                    fontVariations: const [FontVariation("wght", 700)],
                    color: Colors.white,
                    fontSize: safeAreaWidth / 25,
                  ),
                  decoration: InputDecoration(
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    hintText: "メッセージを入力...",
                    hintStyle: TextStyle(
                      fontFamily: "Normal",
                      color: Colors.grey,
                      fontVariations: const [FontVariation("wght", 600)],
                      fontSize: safeAreaWidth / 25,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: safeAreaHeight * 0.005,
                bottom: safeAreaHeight * 0.005,
                right: safeAreaHeight * 0.005,
              ),
              child: Material(
                color: blueColor2,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    alignment: Alignment.center,
                    width: safeAreaWidth * 0.15,
                    height: safeAreaHeight * 0.05,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: safeAreaWidth * 0.01,
                      ),
                      child: Transform.rotate(
                        angle: -15 * 2.0 * pi / 180,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                          size: safeAreaWidth / 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
