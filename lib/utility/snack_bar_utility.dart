import 'package:flutter/material.dart';

void errorSnackbar(
  BuildContext context, {
  required String text,
  required double? padding,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  // ignore: avoid_dynamic_calls
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: Colors.red,
      margin: padding == null
          ? null
          : EdgeInsets.only(
              bottom: padding,
              left: safeAreaWidth * 0.03,
              right: safeAreaWidth * 0.03,
            ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.centerLeft,
              child: FittedBox(
                fit: BoxFit.fitWidth,
                child: Text(
                  text,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: safeAreaWidth / 25,
                  ),
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
            child: Icon(
              Icons.close,
              color: Colors.white,
              size: safeAreaWidth / 20,
            ),
          )
        ],
      ),
      behavior: SnackBarBehavior.floating,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
      ),
    ),
  );
}
