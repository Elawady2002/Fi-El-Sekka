import 'dart:async';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'tracking_provider.g.dart';

@riverpod
class TrackingState extends _$TrackingState {
  Timer? _timer;

  @override
  TrackingStateModel build() {
    ref.onDispose(() {
      _timer?.cancel();
    });
    return TrackingStateModel(
      busLocation: const LatLng(30.0444, 31.2357),
      estimatedArrival: "15 mins",
    );
  }

  void startTracking() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      final newLat = state.busLocation.latitude + 0.0001;
      final newLng = state.busLocation.longitude + 0.0001;
      state = state.copyWith(busLocation: LatLng(newLat, newLng));
    });
  }
}

class TrackingStateModel {
  final LatLng busLocation;
  final String estimatedArrival;

  TrackingStateModel({
    required this.busLocation,
    required this.estimatedArrival,
  });

  TrackingStateModel copyWith({LatLng? busLocation, String? estimatedArrival}) {
    return TrackingStateModel(
      busLocation: busLocation ?? this.busLocation,
      estimatedArrival: estimatedArrival ?? this.estimatedArrival,
    );
  }
}
