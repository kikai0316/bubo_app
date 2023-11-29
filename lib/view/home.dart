import 'dart:async';
import 'package:bubu_app/component/text.dart';
import 'package:bubu_app/constant/color.dart';
import 'package:bubu_app/utility/screen_transition_utility.dart';
import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view/account.dart';
import 'package:bubu_app/view/message_page.dart';
import 'package:bubu_app/view_model/location_data.dart';
import 'package:bubu_app/view_model/marker_data.dart';
import 'package:bubu_app/view_model/message_list.dart';
import 'package:bubu_app/view_model/nearby_list.dart';
import 'package:bubu_app/view_model/story_list.dart';
import 'package:bubu_app/view_model/user_data.dart';
import 'package:bubu_app/widget/home/home_map_widget.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// ignore: deprecated_member_use
final databaseReference = FirebaseDatabase(
  databaseURL:
      "https://bobo-app-9e643-default-rtdb.asia-southeast1.firebasedatabase.app",
).ref("users");

class HomePage extends HookConsumerWidget {
  const HomePage({super.key, required this.id});
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final safeAreaHeight = safeHeight(context);
    final safeAreaWidth = MediaQuery.of(context).size.width;
    final mapController = useState<GoogleMapController?>(null);
    final userData = ref.watch(userDataNotifierProvider);
    final storyList = ref.watch(storyListNotifierProvider);
    final markerList = ref.watch(markerDataNotifierProvider);
    final nearbyList = ref.watch(nearbyUsersNotifierProvider);
    final myLocation = ref.watch(locationDataNotifierProvider);
    final messageNotifier = ref.watch(messageListNotifierProvider);
    final databaseSubscriptions = useState<List<SubscriptionsDataList>>([]);
    final markerWidget = useState<List<Widget>>([]);
    final Set<Marker> markerListNotifier = markerList.when(
      data: (data) {
        final ids2 =
            databaseSubscriptions.value.map((value) => value.id).toList();
        for (final marker in data) {
          final getID = marker.markerId.value;
          if (!ids2.contains(getID)) {
            // ignore: cancel_subscriptions
            final subscription =
                databaseReference.child(getID).onValue.listen((event) {
              final data = event.snapshot.value! as Map<dynamic, dynamic>;
              final lat = data['latitude'] as double;
              final lon = data['longitude'] as double;
              if (context.mounted) {
                final notifier = ref.read(markerDataNotifierProvider.notifier);
                notifier.upData(lat, lon, getID);
              }
            });
            if (context.mounted) {
              databaseSubscriptions.value = [
                ...databaseSubscriptions.value,
                SubscriptionsDataList(
                  event: subscription,
                  id: getID,
                ),
              ];
            }
          }
        }
        return data;
      },
      error: (e, s) => <Marker>{},
      loading: () => <Marker>{},
    );
    final messageNotifierCount = messageNotifier.when(
      data: (data) {
        final count = data
            .expand((messageList) => messageList.message)
            .where((messageData) => !messageData.isRead)
            .length;
        FlutterAppBadger.updateBadgeCount(count);
        return count;
      },
      error: (e, s) => 0,
      loading: () => 0,
    );
    myLocation.when(
      error: (e, s) => null,
      loading: () => null,
      data: (data) {
        if (data != null) {
          return mapController.value?.animateCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(target: data, zoom: 17.2, tilt: 15),
            ),
          );
        } else {
          Future(() async {
            final notifier = ref.read(locationDataNotifierProvider.notifier);
            final permission = await checkLocation();
            if (permission && context.mounted) {
              notifier.positionStream(id);
            }
          });
          return null;
        }
      },
    );
    final userDataNotifier = userData.when(
      data: (data) {
        return data;
      },
      error: (e, s) => null,
      loading: () => null,
    );

    useEffect(
      () {
        // print(markerList);
        // final Set<Marker> newMarkers = Set<Marker>();
        // for (final markerData in markerList) {
        //   newMarkers.add(markerData);
        // }
        // marker.value = newMarkers;
        final ids =
            markerListNotifier.map((marker) => marker.markerId.value).toList();
        for (final userData in storyList) {
          if ((nearbyList?.data ?? []).contains(userData.id) &&
              !ids.contains(userData.id)) {
            markerWidget.value = [
              ...markerWidget.value,
              OnMarker(
                userData: userData,
              ),
            ];
          }
        }

        return () {
          for (final subscription in databaseSubscriptions.value) {
            subscription.event.cancel();
          }
        };
      },
      [
        storyList,
      ],
    );

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            // for (final userData in storyList) ...{
            //   if ((nearbyList?.data ?? []).contains(userData.id) &&
            //       markerList
            //           .map((marker) => marker.markerId.value)
            //           .toList()
            //           .contains(userData.id)) ...{
            //     OnMarker(
            //       userData: userData,
            //     ),
            //   },
            // },
            ...markerWidget.value,
            GoogleMap(
              myLocationButtonEnabled: false,
              myLocationEnabled: true,
              initialCameraPosition: const CameraPosition(
                target: LatLng(35.50924, 139.769812),
                zoom: 17.2,
                tilt: 10,
              ),
              onMapCreated: (controller) {
                mapController.value = controller;
                rootBundle
                    .loadString("assets/map/map_style.json")
                    .then((string) {
                  controller.setMapStyle(string);
                });
              },
              markers: markerListNotifier,
            ),
            SafeArea(
              child: Padding(
                padding: EdgeInsets.all(safeAreaWidth * 0.03),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Column(
                    children: [
                      myAccountWidget(context, userDataNotifier),
                      for (int i = 0; i < 2; i++) ...{
                        Padding(
                          padding: EdgeInsets.only(top: safeAreaHeight * 0.015),
                          child: otherWidget(
                            context,
                            onTap: () {
                              if (userDataNotifier != null) {
                                screenTransitionNormal(
                                  context,
                                  i == 0
                                      ? AccountPage(
                                          userData: userDataNotifier,
                                        )
                                      : MessagePage(
                                          userData: userDataNotifier,
                                        ),
                                );
                              }
                            },
                            widget: i == 0
                                ? Icon(
                                    Icons.settings,
                                    color: Colors.white,
                                    size: safeAreaWidth / 10,
                                  )
                                : Padding(
                                    padding:
                                        EdgeInsets.all(safeAreaWidth * 0.01),
                                    child: Stack(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            color: blackColor,
                                            image: const DecorationImage(
                                              image: AssetImage(
                                                "assets/img/talk.png",
                                              ),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Align(
                                          alignment: const Alignment(1.3, -1.3),
                                          child: Transform.scale(
                                            scale: 1.5,
                                            child: Badge.count(
                                              backgroundColor: blueColor2,
                                              count: messageNotifierCount,
                                              isLabelVisible: i == 0 &&
                                                  messageNotifierCount != 0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                          ),
                        ),
                      },
                    ],
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: safeAreaHeight * 0.23,
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      height: safeAreaHeight * 0.12,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 10,
                            spreadRadius: 1.0,
                          ),
                        ],
                        color: blueColor2,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: (nearbyList?.data ?? []).isEmpty
                          ? nText(
                              "周辺に他のユーザーがいないようです",
                              color: Colors.white,
                              fontSize: safeAreaWidth / 23,
                              bold: 700,
                            )
                          : null,
                    ),
                    if ((nearbyList?.data ?? []).isEmpty) ...{
                      Align(
                        alignment: Alignment.topCenter,
                        child: Padding(
                          padding: EdgeInsets.only(top: safeAreaHeight * 0.065),
                          child: Container(
                            height: safeAreaHeight * 0.08,
                            width: safeAreaHeight * 0.08,
                            decoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage("assets/img/emoji1.png"),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    } else ...{
                      Align(
                        alignment: Alignment.topCenter,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(safeAreaWidth * 0.02),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: blackColor.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    top: safeAreaWidth * 0.015,
                                    bottom: safeAreaWidth * 0.015,
                                    left: safeAreaWidth * 0.03,
                                    right: safeAreaWidth * 0.03,
                                  ),
                                  child: nText(
                                    "近くに${(nearbyList?.data ?? []).length}人のユーザーがいます",
                                    color: Colors.white,
                                    fontSize: safeAreaWidth / 38,
                                    bold: 700,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: safeAreaWidth * 1,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: safeAreaWidth * 0.05,
                                    ),
                                    for (int i = 0;
                                        i < (nearbyList?.data ?? []).length;
                                        i++) ...{
                                      OnNearby(
                                        id: nearbyList!.data[i],
                                        onTap: () {},
                                        // onTap: () => screenTransitionHero(
                                        //   context,
                                        //   SwiperPage(
                                        //     myUserData: userData,
                                        //     isMyData: i == 0,
                                        //     index: i == 0 ? 0 : i - 1,
                                        //     storyList: i == 0 ? [userData] : setData,
                                        //   ),
                                        // ),
                                      ),
                                    },
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    },
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

Future<bool> checkLocation() async {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return false;
  }
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return false;
    }
  }
  if (permission == LocationPermission.deniedForever) {
    return false;
  }
  return true;
}

class SubscriptionsDataList {
  String id;
  StreamSubscription<DatabaseEvent> event;
  SubscriptionsDataList({required this.id, required this.event});
}
