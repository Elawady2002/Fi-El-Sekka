import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/ios_components.dart';
import '../providers/map_provider.dart';
import 'home_page.dart';

class UniversitySelectionScreen extends ConsumerStatefulWidget {
  const UniversitySelectionScreen({super.key});

  @override
  ConsumerState<UniversitySelectionScreen> createState() =>
      _UniversitySelectionScreenState();
}

class _UniversitySelectionScreenState
    extends ConsumerState<UniversitySelectionScreen> {
  String? selectedCity;
  String? selectedUniversity;

  final cities = ['Cairo', 'Alexandria', 'Giza', 'Madinaty'];

  final universitiesByCity = {
    'Cairo': ['Cairo University', 'Ain Shams University'],
    'Madinaty': [
      'American University in Cairo (AUC)',
      'German University in Cairo (GUC)',
    ],
    'Giza': ['Cairo University - Giza Campus', 'October 6 University'],
    'Alexandria': ['Alexandria University', 'Arab Academy'],
  };

  void _showPicker(
    String title,
    List<String> items,
    Function(String) onSelected,
  ) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              color: CupertinoColors.secondarySystemBackground.resolveFrom(
                context,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(
                    child: const Text('Cancel'),
                    onPressed: () => Navigator.pop(context),
                  ),
                  CupertinoButton(
                    child: const Text('Done'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 32,
                onSelectedItemChanged: (index) {
                  onSelected(items[index]);
                },
                children: items.map((item) => Text(item)).toList(),
              ),
            ),
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

    return CupertinoPageScaffold(
      backgroundColor: AppTheme.backgroundColor,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Select University'),
        backgroundColor: AppTheme.backgroundColor,
        border: null,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),

              Text(
                'Start your journey',
                style: AppTheme.textTheme.displayMedium,
                textAlign: TextAlign.center,
              ).animate().fadeIn().slideY(),

              const SizedBox(height: 40),

              // City Selection
              IOSListTile(
                title: 'City',
                subtitle: selectedCity ?? 'Select City',
                leading: const Icon(
                  CupertinoIcons.building_2_fill,
                  color: AppTheme.primaryColor,
                ),
                onTap: () => _showPicker('Select City', cities, (val) {
                  setState(() {
                    selectedCity = val;
                    selectedUniversity = null;
                  });
                }),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 16),

              // University Selection
              if (selectedCity != null)
                IOSListTile(
                  title: 'University',
                  subtitle: selectedUniversity ?? 'Select University',
                  leading: const Icon(
                    CupertinoIcons.book_fill,
                    color: AppTheme.primaryColor,
                  ),
                  onTap: () => _showPicker(
                    'Select University',
                    availableUniversities,
                    (val) {
                      setState(() {
                        selectedUniversity = val;
                      });
                    },
                  ),
                ).animate().fadeIn(delay: 300.ms),

              const Spacer(),

              IOSButton(
                text: 'Continue',
                onPressed: selectedUniversity != null
                    ? () {
                        ref
                            .read(mapStateProvider.notifier)
                            .selectUniversity(selectedUniversity!);
                        Navigator.pushReplacement(
                          context,
                          CupertinoPageRoute(builder: (_) => const HomePage()),
                        );
                      }
                    : null,
                color: selectedUniversity != null
                    ? AppTheme.primaryColor
                    : CupertinoColors.systemGrey4,
              ).animate().fadeIn(delay: 400.ms),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
