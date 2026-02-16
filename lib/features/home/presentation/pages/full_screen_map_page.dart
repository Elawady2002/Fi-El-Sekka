import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../../../../core/theme/app_theme.dart';

class FullScreenMapPage extends StatefulWidget {
  final LatLng startLocation;
  final LatLng endLocation;
  final LatLng currentBusLocation;
  final String? avatarUrl;

  const FullScreenMapPage({
    super.key,
    required this.startLocation,
    required this.endLocation,
    required this.currentBusLocation,
    this.avatarUrl,
  });

  @override
  State<FullScreenMapPage> createState() => _FullScreenMapPageState();
}

class _FullScreenMapPageState extends State<FullScreenMapPage> with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: CupertinoPageScaffold(
        backgroundColor: Colors.black,
        child: Stack(
          children: [
            // Full Screen Map
            Hero(
              tag: 'trip-map',
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: widget.currentBusLocation,
                  initialZoom: 15,
                ),
                children: [
                  ColorFiltered(
                    colorFilter: const ColorFilter.matrix([
                      -1.0, 0.0, 0.0, 0.0, 255.0,
                      0.0, -1.0, 0.0, 0.0, 255.0,
                      0.0, 0.0, -1.0, 0.0, 255.0,
                      0.0, 0.0, 0.0, 1.0, 0.0,
                    ]),
                    child: TileLayer(
                      urlTemplate: 'https://mt1.google.com/vt/lyrs=m&x={x}&y={y}&z={z}',
                      userAgentPackageName: 'com.abdallahalawdy.fi_el_sekka',
                    ),
                  ),
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: [widget.currentBusLocation, widget.endLocation],
                        strokeWidth: 4.0,
                        color: const Color(0xFF007AFF), // Pure Blue
                        strokeCap: StrokeCap.round,
                      ),
                    ],
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        point: widget.endLocation,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          CupertinoIcons.location_solid,
                          color: Colors.red,
                          size: 35,
                        ),
                      ),
                      Marker(
                        point: widget.currentBusLocation,
                        width: 60,
                        height: 60,
                        child: PulsingLiveMarker(
                          controller: _pulseController,
                          imageUrl: widget.avatarUrl,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Back ButtonOverlay
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Icon(
                      CupertinoIcons.back,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PulsingLiveMarker extends StatelessWidget {
  final AnimationController controller;
  final String? imageUrl;

  const PulsingLiveMarker({
    super.key,
    required this.controller,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Pulse effect
            Container(
              width: 40 + (20 * controller.value),
              height: 40 + (20 * controller.value),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: const Color(0xFF007AFF).withValues(alpha: 1 - controller.value),
                  width: 2,
                ),
              ),
            ),
            // Avatar with blue stroke
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF007AFF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF007AFF).withValues(alpha: 0.4),
                    blurRadius: 10,
                  ),
                ],
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl!),
                        fit: BoxFit.cover,
                      )
                    : null,
                color: imageUrl == null ? Colors.grey.shade200 : null,
              ),
              child: imageUrl == null
                  ? const Icon(CupertinoIcons.person_fill, color: Colors.grey, size: 20)
                  : null,
            ),
          ],
        );
      },
    );
  }
}
