import 'package:bubu_app/component/text.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget? appBarWidget(BuildContext context, String title) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return AppBar(
    automaticallyImplyLeading: false,
    elevation: 0,
    backgroundColor: Colors.white,
    title: Stack(
      alignment: Alignment.center,
      children: [
        nText(
          title,
          color: Colors.black,
          fontSize: safeAreaWidth / 16,
          bold: 700,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Icon(
              Icons.close,
              color: Colors.black,
              size: safeAreaWidth / 13,
            ),
          ),
        ),
      ],
    ),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(10),
        topRight: Radius.circular(10),
      ),
    ),
  );
}
