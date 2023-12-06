import 'dart:async';
import 'dart:math';

import 'package:bubu_app/view_model/nearby_list.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'location_data.g.dart';

Timer? locationget;

@Riverpod(keepAlive: true)
class LocationDataNotifier extends _$LocationDataNotifier {
  @override
  Future<LatLng?> build() async {
    return null;
  }

  Future<void> positionStream(String id) async {
    final currentPosition = await Geolocator.getCurrentPosition();
    await updateLocation(id, currentPosition);
    locationget = Timer.periodic(const Duration(seconds: 15), (_) async {
      final currentPosition = await Geolocator.getCurrentPosition();
      if (state.value == null ||
          isWithin10Meters(
            state.value!.latitude,
            state.value!.longitude,
            currentPosition.latitude,
            currentPosition.longitude,
          )) {
        await updateLocation(id, currentPosition);
      }
    });
  }

  Future<void> positionStreamCansel(String id) async {
    // ignore: deprecated_member_use
    final databaseReference = FirebaseDatabase(
      databaseURL:
          "https://bobo-app-9e643-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("users");
    locationget?.cancel();
    await databaseReference.child(id).remove();
    state = await AsyncValue.guard(() async {
      return null;
    });
  }

  Future<void> updateLocation(String id, Position event) async {
    final GeoHasher geoHasher = GeoHasher();
    final String geoHash = geoHasher.encode(event.longitude, event.latitude);
    final Map<String, dynamic> data = {
      'geohash': geoHash,
      'latitude': event.latitude,
      'longitude': event.longitude,
    };

    try {
      // ignore: deprecated_member_use
      final databaseReference = FirebaseDatabase(
        databaseURL:
            "https://bobo-app-9e643-default-rtdb.asia-southeast1.firebasedatabase.app",
      ).ref("users");
      await databaseReference.child(id).set(data);
      state = await AsyncValue.guard(() async {
        final notifier = ref.read(nearbyUsersNotifierProvider.notifier);
        notifier.getData(event.latitude, event.longitude, id);
        return LatLng(event.latitude, event.longitude);
      });
    } catch (e) {
      return;
    }
  }
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  const p = 0.017453292519943295;
  const c = cos;
  final a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}

bool isWithin10Meters(
  double baseLat,
  double baseLon,
  double targetLat,
  double targetLon,
) {
  // 距離をキロメートルで計算
  final double distance =
      calculateDistance(baseLat, baseLon, targetLat, targetLon);
  return distance >= 0.01;
}
