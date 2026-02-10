import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_input.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class PersonalDataPage extends ConsumerStatefulWidget {
  const PersonalDataPage({super.key});

  @override
  ConsumerState<PersonalDataPage> createState() => _PersonalDataPageState();
}

class _PersonalDataPageState extends ConsumerState<PersonalDataPage> {
  late final TextEditingController _nameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authProvider).valueOrNull;
    _nameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phone ?? '');
    _emailController = TextEditingController(text: user?.email ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    // Validate inputs
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال الاسم')),
      );
      return;
    }

    if (_phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('الرجاء إدخال رقم الهاتف')),
      );
      return;
    }

    if (_emailController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء إدخال البريد الإلكتروني'),
        ),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final error = await ref.read(authProvider.notifier).updateProfile(
            fullName: _nameController.text.trim(),
            phone: _phoneController.text.trim(),
            avatarUrl: ref.read(authProvider).valueOrNull?.avatarUrl,
          );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (error != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم حفظ التغييرات بنجاح'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('حدث خطأ: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext viewContext) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.chevron_right, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'البيانات الشخصية',
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
          children: [
            _buildInputField(
              'الاسم بالكامل',
              _nameController,
              CupertinoIcons.person,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'رقم الهاتف',
              _phoneController,
              CupertinoIcons.phone,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _buildInputField(
              'البريد الإلكتروني',
              _emailController,
              CupertinoIcons.mail,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 32),
            CustomButton(
              text: 'حفظ التغييرات',
              onPressed: _handleSave,
              isLoading: _isLoading,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String label,
    TextEditingController controller,
    IconData icon, {
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTheme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        CustomInput(
          controller: controller,
          hintText: label,
          prefixIcon: icon,
          keyboardType: keyboardType,
        ),
      ],
    );
  }
}
