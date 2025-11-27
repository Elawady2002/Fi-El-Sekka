import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/ios_components.dart';
import '../providers/map_provider.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final MapController _mapController = MapController();

  static const LatLng _kInitialPosition = LatLng(30.0444, 31.2357);

  @override
  Widget build(BuildContext context) {
    final mapState = ref.watch(mapStateProvider);

    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Select Pickup'),
        backgroundColor: AppTheme.surfaceColor,
        border: null,
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: const MapOptions(
              initialCenter: _kInitialPosition,
              initialZoom: 14.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.abdallah.universitytransport',
              ),
              MarkerLayer(markers: mapState.markers),
            ],
          ),

          // Top Info Card
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: IOSGlassContainer(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        CupertinoIcons.book_fill,
                        color: AppTheme.primaryColor,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          mapState.selectedUniversity ?? 'University',
                          style: AppTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Bottom Sheet (if point selected)
          if (mapState.selectedPoint != null)
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child:
                  IOSCard(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pickup Point',
                                  style: AppTheme.textTheme.bodyMedium
                                      ?.copyWith(color: AppTheme.textSecondary),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  mapState.selectedPoint!,
                                  style: AppTheme.textTheme.titleLarge,
                                ),
                              ],
                            ),
                            CupertinoButton(
                              padding: EdgeInsets.zero,
                              child: const Icon(
                                CupertinoIcons.xmark_circle_fill,
                                color: CupertinoColors.systemGrey,
                              ),
                              onPressed: () {
                                ref
                                    .read(mapStateProvider.notifier)
                                    .closeDetails();
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              CupertinoIcons.location_fill,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Tap here to see location',
                              style: AppTheme.textTheme.bodyMedium?.copyWith(
                                color: AppTheme.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ).animate().slideY(
                    begin: 1,
                    end: 0,
                    duration: 300.ms,
                    curve: Curves.easeOut,
                  ),
            ),
        ],
      ),
    );
  }
}
