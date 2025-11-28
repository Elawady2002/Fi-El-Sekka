import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class SavedPlacesPage extends StatelessWidget {
  const SavedPlacesPage({super.key});

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
          'الأماكن المحفوظة',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(CupertinoIcons.add, color: AppTheme.primaryDark),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildPlaceItem(
            'المنزل',
            'شارع التسعين، التجمع الخامس',
            CupertinoIcons.house_fill,
            Colors.blue,
          ),
          const SizedBox(height: 16),
          _buildPlaceItem(
            'العمل',
            'القرية الذكية، مبنى B12',
            CupertinoIcons.briefcase_fill,
            Colors.orange,
          ),
          const SizedBox(height: 16),
          _buildPlaceItem(
            'الجامعة',
            'الجامعة الألمانية بالقاهرة',
            CupertinoIcons.book_fill,
            AppTheme.primaryColor,
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceItem(
    String title,
    String address,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
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
                  address,
                  style: AppTheme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              CupertinoIcons.pencil,
              color: Colors.grey,
              size: 20,
            ),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
