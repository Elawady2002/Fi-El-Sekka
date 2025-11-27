import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'map_provider.g.dart';

@riverpod
class MapState extends _$MapState {
  @override
  MapStateModel build() {
    return MapStateModel(
      markers: [],
      selectedPoint: null,
      showDetails: false,
      selectedUniversity: null,
    );
  }

  void selectUniversity(String university) {
    state = state.copyWith(selectedUniversity: university);
    _loadPickupPointsForUniversity(university);
  }

  void _loadPickupPointsForUniversity(String university) {
    // Mock data - different pickup points per university
    final pickupPoints = _getPickupPointsForUniversity(university);

    final List<Marker> markers = [];
    for (var point in pickupPoints) {
      markers.add(
        Marker(
          point: LatLng(point['lat'] as double, point['lng'] as double),
          width: 40,
          height: 40,
          child: GestureDetector(
            onTap: () {
              selectPoint(point['name'] as String);
            },
            child: const Icon(Icons.location_on, color: Colors.red, size: 40),
          ),
        ),
      );
    }
    state = state.copyWith(markers: markers);
  }

  List<Map<String, dynamic>> _getPickupPointsForUniversity(String university) {
    // Mock data for different universities
    final pickupData = {
      'Cairo University': [
        {'id': 'CU1', 'lat': 30.0260, 'lng': 31.2106, 'name': 'Main Gate'},
        {
          'id': 'CU2',
          'lat': 30.0280,
          'lng': 31.2130,
          'name': 'Faculty of Engineering',
        },
        {
          'id': 'CU3',
          'lat': 30.0240,
          'lng': 31.2090,
          'name': 'Faculty of Medicine',
        },
      ],
      'Ain Shams University': [
        {'id': 'AS1', 'lat': 30.0710, 'lng': 31.2770, 'name': 'Main Entrance'},
        {
          'id': 'AS2',
          'lat': 30.0730,
          'lng': 31.2790,
          'name': 'Engineering Gate',
        },
        {'id': 'AS3', 'lat': 30.0690, 'lng': 31.2750, 'name': 'Medicine Gate'},
      ],
      'American University in Cairo': [
        {
          'id': 'AUC1',
          'lat': 29.9773,
          'lng': 31.3910,
          'name': 'AUC New Cairo Gate 1',
        },
        {
          'id': 'AUC2',
          'lat': 29.9790,
          'lng': 31.3930,
          'name': 'AUC New Cairo Gate 2',
        },
      ],
    };

    return pickupData[university] ?? [];
  }

  void addMockMarkers() {
    // This is now called by selectUniversity
  }

  void selectPoint(String pointName) {
    state = state.copyWith(selectedPoint: pointName, showDetails: true);
  }

  void closeDetails() {
    state = state.copyWith(showDetails: false);
  }

  List<String> getPickupPointNames() {
    if (state.selectedUniversity == null) return [];
    return _getPickupPointsForUniversity(
      state.selectedUniversity!,
    ).map((point) => point['name'] as String).toList();
  }
}

class MapStateModel {
  final List<Marker> markers;
  final String? selectedPoint;
  final bool showDetails;
  final String? selectedUniversity;

  MapStateModel({
    required this.markers,
    this.selectedPoint,
    required this.showDetails,
    this.selectedUniversity,
  });

  MapStateModel copyWith({
    List<Marker>? markers,
    String? selectedPoint,
    bool? showDetails,
    String? selectedUniversity,
  }) {
    return MapStateModel(
      markers: markers ?? this.markers,
      selectedPoint: selectedPoint ?? this.selectedPoint,
      showDetails: showDetails ?? this.showDetails,
      selectedUniversity: selectedUniversity ?? this.selectedUniversity,
    );
  }
}
