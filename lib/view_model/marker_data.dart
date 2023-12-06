import 'package:bubu_app/utility/utility.dart';
import 'package:bubu_app/view_model/nearby_list.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'marker_data.g.dart';

@Riverpod(keepAlive: true)
class MarkerDataNotifier extends _$MarkerDataNotifier {
  @override
  Future<Set<Marker>> build() async {
    return {};
  }

  Future<void> addData(Marker marker) async {
    final List<String> markerIds =
        state.value!.map((marker) => marker.markerId.value).toList();
    if (!markerIds.contains(marker.markerId.value)) {
      final newMarkers = Set<Marker>.from(state.value!)..add(marker);
      state = await AsyncValue.guard(() async {
        return newMarkers;
      });
    }
  }

  Future<void> upData({
    required double latitude,
    required double longitude,
    required String id,
    required LatLng myPosition,
    required String myID,
  }) async {
    final setData = state.value!;
    final Marker targetMarker = setData.firstWhere(
      (marker) => marker.markerId.value == id,
      orElse: () => const Marker(markerId: MarkerId("")),
    );
    if (targetMarker.mapsId.value != "") {
      if (isWithin150Meters(
        targetMarker.position.latitude,
        targetMarker.position.longitude,
        latitude,
        longitude,
      )) {
        setData.remove(targetMarker);
        final Marker updatedMarker = Marker(
          markerId: MarkerId(targetMarker.mapsId.value),
          position: LatLng(latitude, longitude),
          icon: targetMarker.icon,
        );
        setData.add(updatedMarker);
        state = await AsyncValue.guard(() async {
          return setData;
        });
      } else {
        setData.remove(targetMarker);
        state = await AsyncValue.guard(() async {
          return setData;
        });
        final notifier = ref.read(nearbyUsersNotifierProvider.notifier);
        notifier.deleteData(
          id: id,
        );
      }
    }
  }

  Future<void> markerDelete({
    required String id,
  }) async {
    final setData = state.value!;
    final Marker targetMarker = setData.firstWhere(
      (marker) => marker.markerId.value == id,
      orElse: () => const Marker(markerId: MarkerId("")),
    );
    if (targetMarker.mapsId.value != "") {
      setData.remove(targetMarker);
      state = await AsyncValue.guard(() async {
        return setData;
      });
      final notifier = ref.read(nearbyUsersNotifierProvider.notifier);
      notifier.deleteData(
        id: id,
      );
    }
  }
}
