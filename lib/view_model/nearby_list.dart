import 'dart:math';

import 'package:bubu_app/view_model/location_data.dart';
import 'package:dart_geohash/dart_geohash.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'nearby_list.g.dart';

@Riverpod(keepAlive: true)
class NearbyUsersNotifier extends _$NearbyUsersNotifier {
  @override
  NearbyUsersData? build() {
    // final dd = await getData();
    return NearbyUsersData(data: [], totalCount: 0);
  }

  Future<void> getData(double latitude, double longitude) async {
    if (state != null && state!.data.length < 11) {
      final userList = await fetchUsers(latitude, longitude);
      final filteredList = userList
          .where(
            (user) => isWithin150Meters(
              latitude,
              longitude,
              user.latitude,
              user.longitude,
            ),
          )
          .toList();
      final sortedList = sortByProximity(filteredList, latitude, longitude);
      final newIds = sortedList
          .where((location) => !state!.data.contains(location.id))
          .map((location) => location.id)
          .toList();
      // ignore: prefer_collection_literals
      final list = [...state!.data, ...newIds].toSet().take(10).toList();
      state = NearbyUsersData(data: list, totalCount: userList.length);
    }
  }

  Future<List<LocationDataEdit>> fetchUsers(
    double latitude,
    double longitude,
  ) async {
    final GeoHasher geoHasher = GeoHasher();
    final String geoHash = geoHasher.encode(longitude, latitude, precision: 7);
    final neighbors = geoHasher.neighbors(geoHash);
    final List<String> geoHashesToQuery = [geoHash, ...neighbors.values];

    // ignore: deprecated_member_use
    final databaseReference = FirebaseDatabase(
      databaseURL:
          "https://bobo-app-9e643-default-rtdb.asia-southeast1.firebasedatabase.app",
    ).ref("users");

    final queries = geoHashesToQuery.map(
      (hash) => databaseReference
          .orderByChild('geohash')
          .startAt(hash)
          .endAt("$hash\uf8ff")
          .once(),
    );

    final results = await Future.wait(queries);
    return processResults(results, state!.data);
  }

  List<LocationDataEdit> processResults(
    List<dynamic> results,
    List<String> existingIds,
  ) {
    final userList = <LocationDataEdit>[];
    for (final result in results) {
      final event = result as DatabaseEvent;
      if (event.snapshot.value != null) {
        final data = event.snapshot.value;
        if (data is Map) {
          data.forEach((key, value) {
            // ignore: avoid_dynamic_calls
            final userID = key as String;
            if (!existingIds.contains(userID)) {
              userList.add(
                LocationDataEdit(
                  // ignore: avoid_dynamic_calls
                  latitude: value["latitude"] as double,
                  // ignore: avoid_dynamic_calls
                  longitude: value["longitude"] as double,
                  id: userID,
                ),
              );
            }
          });
        }
      }
    }
    return userList;
  }

  List<LocationDataEdit> sortByProximity(
    List<LocationDataEdit> locations,
    double currentLat,
    double currentLon,
  ) {
    locations.sort((a, b) {
      final distA =
          _calculateDistance(currentLat, currentLon, a.latitude, a.longitude);
      final distB =
          _calculateDistance(currentLat, currentLon, b.latitude, b.longitude);
      return distA.compareTo(distB);
    });
    return locations;
  }

  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const p = 0.017453292519943295;
    const c = cos;
    final a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }
}

class NearbyUsersData {
  List<String> data;
  int totalCount;
  NearbyUsersData({
    required this.data,
    required this.totalCount,
  });
}

class LocationDataEdit {
  double latitude;
  double longitude;
  String id;
  LocationDataEdit({
    required this.latitude,
    required this.longitude,
    required this.id,
  });
}

bool isWithin150Meters(
  double baseLat,
  double baseLon,
  double targetLat,
  double targetLon,
) {
  // 距離をキロメートルで計算
  final double distance =
      calculateDistance(baseLat, baseLon, targetLat, targetLon);

  // 距離が0.2キロメートル（200メートル）以内かどうかを判断
  return distance <= 0.15;
}
