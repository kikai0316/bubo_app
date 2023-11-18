import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:bubu_app/component/loading.dart';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/snack_bar_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class ImgConfirmation extends HookConsumerWidget {
  ImgConfirmation({super.key, required this.img, required this.onTap});
  final Uint8List img;
  final void Function(Uint8List) onTap;
  final GlobalKey repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final imgData = useState<Uint8List>(img);
    final colorData = useState<List<Color>>([]);

    Future<Uint8List> capturePng() async {
      final RenderRepaintBoundary boundary = repaintBoundaryKey.currentContext!
          .findRenderObject()! as RenderRepaintBoundary;
      final ui.Image image = await boundary.toImage();
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      final Uint8List pngBytes = byteData!.buffer.asUint8List();
      final compressedResult =
          await FlutterImageCompress.compressWithList(pngBytes, quality: 80);
      return Uint8List.fromList(compressedResult);
    }

    useEffect(
      () {
        Future(() async {
          final getColor = await extractMainColorsFromImage(img);
          if (context.mounted) {
            colorData.value = getColor;
          }
        });
        return null;
      },
      [],
    );

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: safeAreaHeight * 1,
          width: safeAreaWidth * 1,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: [
              if (colorData.value.isNotEmpty) ...{
                RepaintBoundary(
                  key: repaintBoundaryKey,
                  child: Stack(
                    children: [
                      Container(
                        height: safeAreaHeight * 1,
                        width: safeAreaWidth * 1,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: FractionalOffset.topLeft,
                            end: FractionalOffset.bottomRight,
                            colors: [
                              colorData.value[0].withOpacity(0.7),
                              colorData.value[1].withOpacity(0.7),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Container(
                        height: safeAreaHeight * 1,
                        width: safeAreaWidth * 1,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(imgData.value),
                            fit: BoxFit.fitWidth,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(bottom: safeAreaHeight * 0.02),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        for (int i = 0; i < 2; i++) ...{
                          GestureDetector(
                            onTap: i == 0
                                ? () async {
                                    await getMobileImage(
                                      onSuccess: (value) async {
                                        colorData.value = [];
                                        final getColor =
                                            await extractMainColorsFromImage(
                                          value,
                                        );
                                        if (context.mounted) {
                                          colorData.value = getColor;
                                          imgData.value = value;
                                        }
                                      },
                                      onError: () {
                                        errorSnackbar(
                                          text: "エラーが発生しました。",
                                          padding: safeAreaHeight * 0.02,
                                        );
                                      },
                                    );
                                  }
                                : () async {
                                    final getData = await capturePng();

                                    if (context.mounted) {
                                      Navigator.pop(context);
                                      onTap(getData);
                                    }
                                  },
                            child: Container(
                              alignment: Alignment.center,
                              height: safeAreaHeight * 0.05,
                              width: safeAreaWidth * 0.45,
                              decoration: BoxDecoration(
                                color: i == 0 ? Colors.white : greenColor,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1),
                                    blurRadius: 10,
                                    spreadRadius: 1.0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: nText(
                                i == 0 ? "他の画像を選択" : "画像を追加",
                                color: i == 0 ? blueColor2 : Colors.white,
                                fontSize: safeAreaWidth / 30,
                                bold: 700,
                              ),
                            ),
                          ),
                        },
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: EdgeInsets.all(safeAreaWidth * 0.03),
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Icon(
                        Icons.close,
                        shadows: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 10.0,
                          ),
                        ],
                        color: Colors.white.withOpacity(1),
                        size: safeAreaWidth / 11,
                      ),
                    ),
                  ),
                ),
              } else ...{
                Container(
                  height: safeAreaHeight * 1,
                  width: safeAreaWidth * 1,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                      loadinPage(context: context, isLoading: true, text: null),
                ),
              },
            ],
          ),
        ),
      ),
    );
  }
}
