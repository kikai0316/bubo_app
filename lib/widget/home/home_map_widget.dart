import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/model/user_data.dart';
import 'package:bubu_app/utility/firebase_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/marker_data.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class OnNearby extends HookConsumerWidget {
  const OnNearby({
    super.key,
    required this.id,
    required this.onTap,
  });
  final String id;
  final void Function() onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTapEvent = useState<bool>(false);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final safeAreaHeight = safeHeight(context);
    final storyList = ref.watch(storyListNotifierProvider);
    final userData = useState<UserData?>(null);

    Future<void> getData({required bool isAddData}) async {
      final getData = await imgMainGet(id);
      if (getData != null && context.mounted) {
        final notifier = ref.read(storyListNotifierProvider.notifier);
        if (isAddData) {
          userData.value = getData;
          notifier.addData(getData);
        } else {
          userData.value = getData;
          notifier.dataUpDate(getData);
        }
      }
    }

    useEffect(
      () {
        final int index = storyList.indexWhere((value) => value.id == id);
        if (index == -1) {
          getData(isAddData: true);
        } else {
          final is12Hours = storyList[index].acquisitionAt == null ||
              is12HoursPassed(storyList[index].acquisitionAt!);
          if (is12Hours) {
            getData(isAddData: false);
          } else {
            userData.value = storyList[index];
          }
        }

        return null;
      },
      [],
    );
    return Padding(
      padding: EdgeInsets.only(right: safeAreaWidth * 0.02),
      child: GestureDetector(
        onTap: () {
          isTapEvent.value = false;
          onTap();
        },
        onTapDown: (TapDownDetails downDetails) {
          isTapEvent.value = true;
        },
        onTapCancel: () {
          isTapEvent.value = false;
        },
        child: Hero(
          tag: id,
          child: Container(
            alignment: Alignment.center,
            height: safeAreaHeight * 0.13,
            width: safeAreaHeight * 0.105,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(
                      isTapEvent.value ? safeAreaWidth * 0.008 : 0,
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      height: safeAreaHeight * 0.105,
                      width: safeAreaHeight * 0.105,
                      decoration: userData.value != null
                          ? BoxDecoration(
                              shape: BoxShape.circle,
                              color: userData.value!.isView
                                  ? Colors.grey.withOpacity(0.5)
                                  : null,
                              gradient: userData.value!.isView
                                  ? null
                                  : const LinearGradient(
                                      begin: FractionalOffset.topRight,
                                      end: FractionalOffset.bottomLeft,
                                      colors: [
                                        Color.fromARGB(255, 4, 15, 238),
                                        Color.fromARGB(255, 6, 120, 255),
                                        Color.fromARGB(255, 4, 200, 255),
                                      ],
                                    ),
                            )
                          : null,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(safeAreaHeight * 0.004),
                            child: Container(
                              alignment: Alignment.center,
                              height: double.infinity,
                              width: double.infinity,
                              decoration: const BoxDecoration(
                                color: blackColor,
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: EdgeInsets.all(safeAreaHeight * 0.002),
                                child: Container(
                                  height: double.infinity,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    shape: BoxShape.circle,
                                    image: userData.value == null
                                        ? null
                                        : DecorationImage(
                                            image: MemoryImage(
                                              userData.value!.imgList.first,
                                            ),
                                            fit: BoxFit.cover,
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
                ),
                Padding(
                  padding: EdgeInsets.only(top: safeAreaHeight * 0.005),
                  child: nText(
                    userData.value == null ? "" : userData.value!.name,
                    color: Colors.white.withOpacity(1),
                    fontSize: safeAreaWidth / 37,
                    bold: 700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool is12HoursPassed(DateTime data) {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(data);
    return difference.inHours >= 12;
  }
}

Widget myAccountWidget(BuildContext context, UserData? userData) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return SizedBox(
    height: safeAreaWidth * 0.21,
    width: safeAreaWidth * 0.17,
    child: Stack(
      alignment: Alignment.topCenter,
      children: [
        Container(
          alignment: Alignment.center,
          height: safeAreaWidth * 0.17,
          width: safeAreaWidth * 0.17,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.5),
                blurRadius: 10,
                spreadRadius: 1.0,
              ),
            ],
            image: userData != null
                ? DecorationImage(
                    image: MemoryImage(userData.imgList.first),
                    fit: BoxFit.cover,
                  )
                : null,
            color: blackColor,
            border: Border.all(
              color: Colors.grey.withOpacity(0.3),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: safeAreaWidth * 0.08,
            width: safeAreaWidth * 0.08,
            decoration: const BoxDecoration(
              color: blueColor2,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.add,
              color: Colors.white,
              shadows: [
                BoxShadow(
                  color: Colors.white,
                  blurRadius: 10,
                  spreadRadius: 1.0,
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

Widget otherWidget(
  BuildContext context, {
  required Widget widget,
  required void Function()? onTap,
}) {
  final safeAreaWidth = MediaQuery.of(context).size.width;
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: safeAreaWidth * 0.17,
      width: safeAreaWidth * 0.17,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            spreadRadius: 1.0,
          ),
        ],
        color: blackColor,
        border: Border.all(
          color: Colors.grey.withOpacity(0.3),
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: widget,
    ),
  );
}

Widget googleMapWidget({
  required LatLng target,
  required void Function(GoogleMapController)? onMapCreated,
  required Set<Marker> markers,
}) {
  return GoogleMap(
    myLocationButtonEnabled: false,
    myLocationEnabled: true,
    initialCameraPosition: const CameraPosition(
      target: LatLng(35.50924, 139.769812),
      zoom: 17.2,
      tilt: 10,
    ),
    onMapCreated: onMapCreated,
    markers: markers,
  );
}

class OnMarker extends HookConsumerWidget {
  OnMarker({
    super.key,
    required this.userData,
  });

  final UserData userData;
  final GlobalKey repaintBoundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaWidth = MediaQuery.of(context).size.width;
    // ignore: deprecated_member_use
    final databaseReference = FirebaseDatabase(
      databaseURL:
          "https://bobo-app-9e643-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("users");
    Future<void> updateMarker() async {
      final snapshot = await databaseReference.child(userData.id).get();
      final getMarker = await getBytesFromWidget(repaintBoundaryKey);
      if (snapshot.exists) {
        // ignore: unused_local_variable, cast_nullable_to_non_nullable
        final lat = snapshot.child('latitude').value as double;
        // ignore: unused_local_variable, cast_nullable_to_non_nullable
        final lon = snapshot.child('longitude').value as double;
        final notifier = ref.read(markerDataNotifierProvider.notifier);
        notifier.addData(
          Marker(
            markerId: MarkerId(userData.id),
            position: LatLng(lat, lon),
            icon: BitmapDescriptor.fromBytes(getMarker),
          ),
        );
      }
    }

    return RepaintBoundary(
      key: repaintBoundaryKey,
      child: Container(
        alignment: Alignment.center,
        height: safeAreaWidth * 0.19,
        width: safeAreaWidth * 0.19,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: blueColor2.withOpacity(0.2),
          border: Border.all(color: blueColor.withOpacity(0.1)),
        ),
        child: Container(
          alignment: Alignment.center,
          height: safeAreaWidth * 0.115,
          width: safeAreaWidth * 0.115,
          decoration:
              const BoxDecoration(shape: BoxShape.circle, color: Colors.white),
          child: ClipOval(
            child: Image.memory(
              userData.imgList.first,
              fit: BoxFit.cover,
              height: safeAreaWidth * 0.11,
              width: safeAreaWidth * 0.11,
              frameBuilder: (
                BuildContext context,
                Widget child,
                int? frame,
                bool wasSynchronouslyLoaded,
              ) {
                if (frame == null) {
                  return const SizedBox();
                } else {
                  updateMarker();
                  return child;
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<Uint8List> getBytesFromWidget(GlobalKey key) async {
    final RenderRepaintBoundary boundary =
        key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
    final ui.Image image = await boundary.toImage(pixelRatio: 2.0);
    final ByteData? byteData =
        await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData!.buffer.asUint8List();
  }
}
