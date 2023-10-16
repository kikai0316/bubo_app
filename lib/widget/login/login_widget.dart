import 'dart:ui';

import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

Widget privacyText({
  required BuildContext context,
  required void Function()? onTap1,
  required void Function()? onTap2,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  InlineSpan textWidget(
    String text, {
    required bool isBlue,
    required GestureRecognizer? onTap,
  }) {
    return TextSpan(
      text: text,
      recognizer: onTap,
      style: TextStyle(
        fontFamily: "Normal",
        fontVariations: const [FontVariation("wght", 400)],
        color: isBlue ? blueColor : Colors.white,
        fontSize: safeAreaWidth / 35,
        decoration: isBlue ? TextDecoration.underline : null,
      ),
    );
  }

  return RichText(
    textAlign: TextAlign.center,
    text: TextSpan(
      children: [
        textWidget('ログインすると、あなたは当アプリの', isBlue: false, onTap: null),
        textWidget(
          '利用規約',
          isBlue: true,
          onTap: TapGestureRecognizer()..onTap = onTap1,
        ),
        textWidget(
          'に同意することになります。当社における個人情報の取り扱いについては、',
          isBlue: false,
          onTap: null,
        ),
        textWidget(
          'プライバシーポリシー',
          isBlue: true,
          onTap: TapGestureRecognizer()..onTap = onTap2,
        ),
        textWidget('をご覧ください。', isBlue: false, onTap: null),
      ],
    ),
  );
}

class LoginTextField extends HookConsumerWidget {
  const LoginTextField({
    super.key,
    required this.subText,
    required this.isPassword,
    required this.controller,
    required this.icon,
    required this.isError,
    required this.onChanged,
  });
  final String subText;
  final bool isPassword;
  final bool isError;
  final TextEditingController? controller;
  final IconData icon;
  final void Function(String)? onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final isChange = useState<bool>(true);
    return Container(
      width: safeAreaWidth * 0.9,
      decoration: BoxDecoration(
        border: Border.all(color: isError ? Colors.red : Colors.grey),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Padding(
        padding: xPadding(context),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(
                right: safeAreaWidth * 0.03,
                left: safeAreaWidth * 0.02,
              ),
              child: Icon(
                icon,
                color: Colors.black,
              ),
            ),
            Expanded(
              child: TextFormField(
                controller: controller,
                onChanged: onChanged,
                // ignore: avoid_bool_literals_in_conditional_expressions
                obscureText: isPassword ? isChange.value : false,
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontVariations: const [FontVariation("wght", 400)],
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: safeAreaWidth / 28,
                ),
                decoration: InputDecoration(
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  hintText: subText,
                  hintStyle: TextStyle(
                    fontFamily: "Normal",
                    fontVariations: const [FontVariation("wght", 400)],
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: safeAreaWidth / 34,
                  ),
                ),
              ),
            ),
            if (isPassword)
              Padding(
                padding: EdgeInsets.only(
                  right: safeAreaWidth * 0.01,
                  left: safeAreaWidth * 0.01,
                ),
                child: GestureDetector(
                  onTap: () => isChange.value = !isChange.value,
                  child: Icon(
                    isChange.value ? Icons.visibility_off : Icons.visibility,
                    color: Colors.black,
                    size: safeAreaWidth / 18,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

Widget birthdayWidget(
  BuildContext context, {
  required String? text,
  required void Function(String) onDataSet,
  required bool isError,
}) {
  final safeAreaHeight = safeHeight(context);
  final safeAreaWidth = MediaQuery.of(context).size.width;
  final DateTime now = DateTime.now();
  final DateTime twentyYearsAgo = DateTime(now.year - 20);
  DateTime parseDate(String input) {
    final List<String> parts = input.split(' / ');
    final int year = int.parse(parts[0]);
    final int month = int.parse(parts[1]);
    final int day = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  return Material(
    color: Colors.transparent,
    borderRadius: BorderRadius.circular(50),
    child: InkWell(
      onTap: () {
        primaryFocus?.unfocus();
        DatePicker.showDatePicker(
          context,
          minTime: DateTime(1950),
          maxTime: DateTime(2022, 8, 17),
          currentTime: text == null ? twentyYearsAgo : parseDate(text),
          locale: LocaleType.jp,
          onConfirm: (date) {
            final dataSet =
                '${date.year} / ${date.month.toString().padLeft(2, '0')} / ${date.day.toString().padLeft(2, '0')}';
            onDataSet(dataSet);
          },
        );
      },
      borderRadius: BorderRadius.circular(50),
      child: Container(
        alignment: Alignment.centerLeft,
        height: safeAreaHeight * 0.06,
        width: safeAreaWidth * 0.9,
        decoration: BoxDecoration(
          border: Border.all(color: isError ? Colors.red : Colors.grey),
          borderRadius: BorderRadius.circular(50),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            right: safeAreaWidth * 0.03,
            left: safeAreaWidth * 0.05,
          ),
          child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: [
                TextSpan(
                  text: "誕生日：",
                  style: TextStyle(
                    fontFamily: "Normal",
                    fontVariations: const [FontVariation("wght", 700)],
                    color: Colors.black,
                    fontSize: safeAreaWidth / 30,
                  ),
                ),
                TextSpan(
                  text: "　${text ?? "-- / -- / --"}",
                  style: TextStyle(
                    fontFamily: "Normal",
                    fontVariations: const [FontVariation("wght", 700)],
                    color: text == null ? Colors.grey : Colors.black,
                    fontSize: safeAreaWidth / 25,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
