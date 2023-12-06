import 'dart:ui';

import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/emoji.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class MessageBottomSheet extends HookConsumerWidget {
  const MessageBottomSheet({
    super.key,
    required this.onTap,
  });
  final void Function(String) onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final textValue = useState<String>("");
    final isTapEvent = useState<int?>(null);
    final emoji = emojiData.values.toList();

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0),
        body: Stack(
          children: [
            SafeArea(
              child: Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container(
                    //   height: safeAreaHeight * 0.1,
                    //   width: safeAreaWidth * 0.5,
                    //   color: Colors.red,
                    // ),
                    for (int a = 0; a < 6; a = a + 3) ...{
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          for (int i = 0; i < 3; i++) ...{
                            Padding(
                              padding: EdgeInsets.only(
                                left: safeAreaWidth * 0.04,
                                right: safeAreaWidth * 0.04,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  final setData = emojiData.keys.toList();
                                  isTapEvent.value = null;
                                  onTap(setData[i + a]);
                                  Navigator.pop(context);
                                },
                                onTapDown: (TapDownDetails downDetails) {
                                  isTapEvent.value = i + a;
                                },
                                onTapCancel: () {
                                  isTapEvent.value = null;
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: safeAreaWidth * 0.15,
                                  width: safeAreaWidth * 0.15,
                                  child: Text(
                                    emoji[i + a],
                                    style: TextStyle(
                                      fontSize: safeAreaWidth /
                                          (isTapEvent.value == (i + a)
                                              ? 12
                                              : 9),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          },
                        ],
                      ),
                      SizedBox(
                        height: safeAreaHeight * 0.02,
                      ),
                    },

                    Padding(
                      padding: EdgeInsets.only(
                        top: safeAreaHeight * 0.05,
                        bottom: safeAreaHeight * 0.02,
                      ),
                      child: Container(
                        constraints: BoxConstraints(
                          maxHeight: safeAreaHeight * 0.17,
                        ),
                        width: safeAreaWidth * 0.95,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white, width: 0.5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: safeAreaWidth * 0.05,
                            right: safeAreaWidth * 0.05,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextFormField(
                                  autofocus: true,
                                  maxLines: null,
                                  onChanged: (text) {
                                    textValue.value = text;
                                  },
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: "Normal",
                                    fontVariations: const [
                                      FontVariation("wght", 400),
                                    ],
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: safeAreaWidth / 25,
                                  ),
                                  decoration: InputDecoration(
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                    hintText: "メッセージを送信...",
                                    hintStyle: TextStyle(
                                      fontFamily: "Normal",
                                      fontVariations: const [
                                        FontVariation("wght", 700),
                                      ],
                                      color: Colors.white,
                                      fontSize: safeAreaWidth / 28,
                                    ),
                                  ),
                                ),
                              ),
                              if (textValue.value.isNotEmpty)
                                GestureDetector(
                                  onTap: () {
                                    onTap(textValue.value);
                                    Navigator.pop(context);
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: safeAreaHeight * 0.013,
                                      left: safeAreaWidth * 0.02,
                                    ),
                                    child: nText(
                                      "送信",
                                      color: Colors.white,
                                      fontSize: safeAreaWidth / 22,
                                      bold: 700,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
