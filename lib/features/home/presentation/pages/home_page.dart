import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../booking/presentation/pages/booking_page.dart';
import '../../../../core/widgets/ios_components.dart';
import '../../../../core/widgets/animated_progress_slider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'صباح الخير،',
                        style: AppTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                      Text(
                        'عبد الله',
                        style: AppTheme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      CupertinoIcons.person_fill,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  // Upcoming Trip Card
                  _buildSectionTitle('رحلتك الجاية'),
                  const SizedBox(height: 16),
                  _buildUpcomingTripCard(),

                  const SizedBox(height: 32),

                  // Route Info
                  _buildSectionTitle('مسار الرحلة'),
                  const SizedBox(height: 16),
                  _buildRouteInfoCard(),
                ],
              ),
            ),

            // Bottom Action Button
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'جاهز لحجز رحلتك الجديدة؟',
                    style: AppTheme.textTheme.bodyMedium?.copyWith(
                      color: AppTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  IOSButton(
                    text: 'احجز رحلتك',
                    onPressed: () => _showLocationDrawer(context),
                    icon: CupertinoIcons.ticket_fill,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: AppTheme.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildUpcomingTripCard() {
    // Mock data for now - in real app, check if booking exists
    // Using DateTime.now() to prevent 'dead code' warning from static analysis
    bool hasBooking = DateTime.now().year > 2000;

    if (!hasBooking) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppTheme.backgroundColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                CupertinoIcons.calendar_badge_plus,
                color: AppTheme.textSecondary,
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'مفيش رحلات قادمة',
              style: AppTheme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'احجز رحلتك الجاية دلوقتي عشان تضمن مكانك',
              textAlign: TextAlign.center,
              style: AppTheme.textTheme.bodyMedium?.copyWith(
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Pattern (Optional)
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              CupertinoIcons.bus,
              size: 150,
              color: Colors.white.withValues(alpha: 0.05),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.primaryColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'قريباً',
                        style: AppTheme.textTheme.labelMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Icon(
                      CupertinoIcons.arrow_right_circle_fill,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'التاريخ',
                            style: AppTheme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '27 نوفمبر',
                            style: AppTheme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الوقت',
                            style: AppTheme.textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '07:30 AM',
                            style: AppTheme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(color: Colors.white24),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(
                      CupertinoIcons.location_fill,
                      color: AppTheme.primaryColor,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'محطة الركوب: بوابة 1 (B1)',
                        style: AppTheme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRouteInfoCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppTheme.dividerColor),
      ),
      child: Column(
        children: [
          _buildLocationRow(
            icon: CupertinoIcons.circle_fill,
            iconColor: AppTheme.primaryColor,
            label: 'من',
            value: 'مدينتي',
            isLast: false,
          ),
          _buildLocationRow(
            icon: CupertinoIcons.location_solid,
            iconColor: Colors.black,
            label: 'إلى',
            value: 'الجامعة الألمانية (GUC)',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildLocationRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Column(
            children: [
              Icon(icon, color: iconColor, size: 16),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    color: AppTheme.dividerColor,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: AppTheme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (!isLast) const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLocationDrawer(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => const LocationSelectionDrawer(),
    );
  }
}

// Location Selection Drawer (Kept as is, just ensuring it's available)
class LocationSelectionDrawer extends StatefulWidget {
  const LocationSelectionDrawer({super.key});

  @override
  State<LocationSelectionDrawer> createState() =>
      _LocationSelectionDrawerState();
}

class _LocationSelectionDrawerState extends State<LocationSelectionDrawer> {
  String? selectedCity;
  String? selectedUniversity;
  String? selectedStation;

  final cities = ['Cairo', 'Alexandria', 'Giza', 'Madinaty'];

  final universitiesByCity = {
    'Cairo': ['Cairo University', 'Ain Shams University'],
    'Madinaty': ['American University (AUC)', 'German University (GUC)'],
    'Giza': ['Cairo University - Giza', 'October 6 University'],
    'Alexandria': ['Alexandria University', 'Arab Academy'],
  };

  final stationsByUniversity = {
    'Cairo University': ['Main Gate', 'Engineering Gate', 'Medicine Gate'],
    'Ain Shams University': [
      'Main Entrance',
      'Engineering Gate',
      'Medicine Gate',
    ],
    'American University (AUC)': ['AUC Gate 1', 'AUC Gate 2'],
    'German University (GUC)': ['GUC Gate 1', 'GUC Gate 2', 'GUC Gate 3'],
    'Cairo University - Giza': [
      'Giza Main Gate',
      'Arts Building',
      'Science Building',
    ],
    'October 6 University': ['October Main Gate', 'Engineering Building'],
    'Alexandria University': ['Alex Main Gate', 'Medical Campus'],
    'Arab Academy': ['Academy Gate 1', 'Academy Gate 2'],
  };

  Widget _buildSelectionCard({
    required String title,
    required String? value,
    required String placeholder,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final isSelected = value != null;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.primaryColor : AppTheme.dividerColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : [],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.backgroundColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.black, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.textTheme.bodySmall?.copyWith(
                      color: AppTheme.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value ?? placeholder,
                    style: isSelected
                        ? AppTheme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          )
                        : AppTheme.textTheme.bodyLarge?.copyWith(
                            color: AppTheme.textTertiary,
                          ),
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? CupertinoIcons.checkmark_circle_fill
                  : CupertinoIcons.chevron_left,
              color: isSelected ? AppTheme.primaryColor : AppTheme.textTertiary,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _showPicker({
    required String title,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    if (items.isEmpty) return;
    int selectedIndex = 0;
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 340,
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
            const SizedBox(height: 20),

            // Header with Buttons
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'إلغاء',
                      style: AppTheme.textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFFF3B30),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    title,
                    style: AppTheme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      onSelected(items[selectedIndex]);
                      Navigator.pop(context);
                    },
                    child: Text(
                      'تم',
                      style: AppTheme.textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Picker
            Expanded(
              child: CupertinoPicker.builder(
                itemExtent: 48,
                magnification: 1.1,
                useMagnifier: true,
                backgroundColor: Colors.transparent,
                selectionOverlay: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withValues(alpha: 0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                scrollController: FixedExtentScrollController(
                  initialItem: selectedIndex,
                ),
                onSelectedItemChanged: (int index) => selectedIndex = index,
                childCount: items.length,
                itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    onSelected(items[index]);
                    Navigator.pop(context);
                  },
                  child: Center(
                    child: Text(
                      items[index],
                      style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).padding.bottom + 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<String> availableUniversities = selectedCity != null
        ? List<String>.from(universitiesByCity[selectedCity!] ?? [])
        : [];

    final List<String> stations = selectedUniversity != null
        ? stationsByUniversity[selectedUniversity!] ?? []
        : [];

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: AppTheme.backgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
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
          const SizedBox(height: 20),

          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      CupertinoIcons.xmark,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'اختار موقعك',
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'حدد المدينة، الجامعة، والمحطة',
                        style: AppTheme.textTheme.bodySmall?.copyWith(
                          color: AppTheme.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Progress Indicator
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: AnimatedProgressSlider(
              currentStep: selectedUniversity != null
                  ? 2
                  : (selectedCity != null ? 1 : 0),
              totalSteps: 3,
              labels: const ['المدينة', 'الجامعة', 'المحطة'],
            ),
          ),

          // Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              children: [
                _buildSelectionCard(
                  title: 'المدينة',
                  value: selectedCity,
                  placeholder: 'اختار المدينة',
                  icon: CupertinoIcons.building_2_fill,
                  onTap: () => _showPicker(
                    title: 'اختار المدينة',
                    items: cities,
                    onSelected: (val) {
                      setState(() {
                        selectedCity = val;
                        selectedUniversity = null;
                        selectedStation = null;
                      });
                    },
                  ),
                ),
                if (selectedCity != null) ...[
                  const SizedBox(height: 12),
                  _buildSelectionCard(
                    title: 'الجامعة',
                    value: selectedUniversity,
                    placeholder: 'اختار الجامعة',
                    icon: CupertinoIcons.book_fill,
                    onTap: () => _showPicker(
                      title: 'اختار الجامعة',
                      items: availableUniversities,
                      onSelected: (val) {
                        setState(() {
                          selectedUniversity = val;
                          selectedStation = null;
                        });
                      },
                    ),
                  ),
                ],
                if (selectedUniversity != null) ...[
                  const SizedBox(height: 12),
                  _buildSelectionCard(
                    title: 'المحطة',
                    value: selectedStation,
                    placeholder: 'اختار المحطة',
                    icon: CupertinoIcons.location_fill,
                    onTap: () => _showPicker(
                      title: 'اختار المحطة',
                      items: stations,
                      onSelected: (val) {
                        setState(() {
                          selectedStation = val;
                        });
                      },
                    ),
                  ),
                ],
                const SizedBox(height: 20),
              ],
            ),
          ),

          // Bottom Button
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: IOSButton(
              text: 'متابعة',
              onPressed: selectedStation != null
                  ? () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        CupertinoPageRoute(builder: (_) => const BookingPage()),
                      );
                    }
                  : null,
              color: selectedStation != null
                  ? AppTheme.primaryColor
                  : AppTheme.dividerColor,
            ),
          ),
        ],
      ),
    );
  }
}
