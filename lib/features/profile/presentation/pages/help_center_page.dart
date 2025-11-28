import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class HelpCenterPage extends StatelessWidget {
  const HelpCenterPage({super.key});

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
          'مركز المساعدة',
          style: AppTheme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'كيف يمكننا مساعدتك؟',
              style: AppTheme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 24),
            _buildFaqItem(
              'كيف يمكنني حجز رحلة؟',
              'يمكنك حجز رحلة عن طريق اختيار نقطة الانطلاق والوصول من الصفحة الرئيسية، ثم اختيار الوقت المناسب وتأكيد الحجز.',
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'كيف يمكنني شحن المحفظة؟',
              'اذهب إلى صفحة المحفظة من الملف الشخصي، واضغط على زر "شحن الرصيد" واختر طريقة الدفع المناسبة.',
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'ما هي طرق الدفع المتاحة؟',
              'نقبل الدفع عن طريق البطاقات البنكية (Visa/Mastercard)، المحافظ الإلكترونية (Vodafone Cash, etc.)، و InstaPay.',
            ),
            const SizedBox(height: 16),
            _buildFaqItem(
              'كيف يمكنني إلغاء رحلة؟',
              'يمكنك إلغاء الرحلة من صفحة "سجل الرحلات" قبل موعد الرحلة بساعة على الأقل.',
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(CupertinoIcons.phone_fill),
                label: const Text('تواصل مع الدعم الفني'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primaryColor,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqItem(String question, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ExpansionTile(
        title: Text(
          question,
          style: AppTheme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Text(
            answer,
            style: AppTheme.textTheme.bodyMedium?.copyWith(
              color: AppTheme.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
