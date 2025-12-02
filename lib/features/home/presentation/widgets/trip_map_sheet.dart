import 'dart:math' as math;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
// import 'package:geolocator/geolocator.dart'; // Removed temporarily for iOS build
import '../../../../core/theme/app_theme.dart';
import '../../../booking/domain/entities/booking_entity.dart';

class TripMapSheet extends StatefulWidget {
  final BookingEntity booking;

  const TripMapSheet({super.key, required this.booking});

  @override
  State<TripMapSheet> createState() => _TripMapSheetState();
}

class _TripMapSheetState extends State<TripMapSheet> {
  final MapController _mapController = MapController();
  LatLng? _userLocation;
  // Default locations (Madinaty & GUC)
  final LatLng _stationLocation = const LatLng(30.0910, 31.6370); // Madinaty

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    // Temporarily using fixed location to avoid iOS build issues with geolocator_apple
    // TODO: Re-enable when geolocator_apple is updated
    setState(() {
      // Fixed location near Madinaty for testing
      _userLocation = const LatLng(30.0920, 31.6380);
    });

    _fitBounds();

    /* Original geolocator code - commented out temporarily
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return;
    }

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _userLocation = LatLng(position.latitude, position.longitude);
    });

    // Fit bounds to include all markers
    if (_userLocation != null) {
      _fitBounds();
    }
    */
  }

  void _fitBounds() {
    if (_userLocation == null) return;

    final bounds = LatLngBounds.fromPoints([_userLocation!, _stationLocation]);

    _mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: const EdgeInsets.all(80), // Increased padding for better view
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 20,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          // Drag Handle
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'مسار الرحلة',
                  style: AppTheme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(CupertinoIcons.xmark_circle_fill),
                  color: Colors.grey.shade400,
                  iconSize: 30,
                ),
              ],
            ),
          ),

          // Map
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(0),
              ),
              child: FlutterMap(
                mapController: _mapController,
                options: MapOptions(
                  initialCenter: _stationLocation,
                  initialZoom: 13,
                ),
                children: [
                  TileLayer(
                    // Google Maps Tiles
                    urlTemplate:
                        'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                    userAgentPackageName: 'com.abdallahalawdy.my_app',
                  ),
                  // Route Path (Google Maps Style - Blue & Solid)
                  if (_userLocation != null)
                    PolylineLayer(
                      polylines: [
                        Polyline(
                          points: [_userLocation!, _stationLocation],
                          strokeWidth: 5.0,
                          color: const Color(0xFF4285F4), // Google Blue
                          strokeCap: StrokeCap.round,
                          strokeJoin: StrokeJoin.round,
                        ),
                      ],
                    ),
                  MarkerLayer(
                    markers: [
                      // Station Marker (Destination Pin)
                      Marker(
                        point: _stationLocation,
                        width: 60,
                        height: 60,
                        alignment: Alignment.topCenter,
                        child: _buildGooglePin(
                          icon: CupertinoIcons.location_solid,
                          color: const Color(0xFFEA4335), // Google Red
                          label: 'المحطة',
                        ),
                      ),
                      // User Marker (Blue Dot with Halo)
                      if (_userLocation != null)
                        Marker(
                          point: _userLocation!,
                          width: 60,
                          height: 60,
                          child: _buildUserLocationDot(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Info Panel
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildInfoRow(
                  icon: CupertinoIcons.location_solid,
                  color: Colors.red,
                  title: 'نقطة التجمع',
                  subtitle: 'محطة مدينتي الرئيسية',
                ),
                const SizedBox(height: 16),
                if (_userLocation != null)
                  _buildInfoRow(
                    icon: CupertinoIcons.arrow_turn_up_right,
                    color: AppTheme.primaryColor,
                    title: 'المسافة للمحطة',
                    subtitle: _userLocation != null
                        ? '${_calculateDistance(_userLocation!, _stationLocation).toStringAsFixed(1)} كم تقريباً'
                        : 'جاري الحساب...',
                  ),
              ],
            ),
          ),
          SizedBox(height: MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }

  Widget _buildGooglePin({
    required IconData icon,
    required Color color,
    required String label,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.3),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Icon(
          CupertinoIcons.location_solid,
          color: color,
          size: 40,
          shadows: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildUserLocationDot() {
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4285F4).withValues(alpha: 0.2),
          ),
        ),
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF4285F4),
            border: Border.all(color: Colors.white, width: 3),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTheme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Manual distance calculation using Haversine formula (in km)
  double _calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371; // Earth's radius in km

    final double lat1Rad = point1.latitude * (math.pi / 180);
    final double lat2Rad = point2.latitude * (math.pi / 180);
    final double deltaLat =
        (point2.latitude - point1.latitude) * (math.pi / 180);
    final double deltaLon =
        (point2.longitude - point1.longitude) * (math.pi / 180);

    final double a =
        math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1Rad) *
            math.cos(lat2Rad) *
            math.sin(deltaLon / 2) *
            math.sin(deltaLon / 2);
    final double c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }
}
