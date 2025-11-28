import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class RideHistoryPage extends StatefulWidget {
  const RideHistoryPage({super.key});

  @override
  State<RideHistoryPage> createState() => _RideHistoryPageState();
}

class _RideHistoryPageState extends State<RideHistoryPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'سجل الرحلات',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppTheme.primaryDark,
          unselectedLabelColor: Colors.grey,
          indicatorColor: AppTheme.primaryColor,
          indicatorWeight: 3,
          labelStyle: const TextStyle(fontWeight: FontWeight.bold),
          tabs: const [
            Tab(text: 'القادمة'),
            Tab(text: 'السابقة'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [_buildUpcomingRides(), _buildPastRides()],
      ),
    );
  }

  Widget _buildUpcomingRides() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildRideCard(
          'الجامعة الألمانية',
          'التجمع الخامس',
          'غداً، 08:00 ص',
          '50 ج.م',
          'مؤكدة',
          AppTheme.successColor,
        ),
      ],
    );
  }

  Widget _buildPastRides() {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _buildRideCard(
          'الجامعة الألمانية',
          'التجمع الخامس',
          'أمس، 05:00 م',
          '50 ج.م',
          'مكتملة',
          Colors.grey,
        ),
        const SizedBox(height: 16),
        _buildRideCard(
          'التجمع الخامس',
          'الجامعة الألمانية',
          'أمس، 07:30 ص',
          '50 ج.م',
          'ملغاة',
          Colors.red,
        ),
      ],
    );
  }

  Widget _buildRideCard(
    String from,
    String to,
    String date,
    String price,
    String status,
    Color statusColor,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  const Icon(
                    Icons.circle,
                    size: 12,
                    color: AppTheme.primaryColor,
                  ),
                  Container(height: 24, width: 2, color: Colors.grey[300]),
                  const Icon(Icons.location_on, size: 16, color: Colors.red),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      from,
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      to,
                      style: AppTheme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    price,
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primaryDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      status,
                      style: AppTheme.textTheme.bodySmall?.copyWith(
                        color: statusColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            children: [
              const Icon(CupertinoIcons.calendar, size: 16, color: Colors.grey),
              const SizedBox(width: 8),
              Text(
                date,
                style: AppTheme.textTheme.bodySmall?.copyWith(
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
