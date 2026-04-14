import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/ios_components.dart';
import '../../../../core/services/secure_storage_service.dart';
import 'login_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  final PageController _imagePageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    _imagePageController.dispose();
    super.dispose();
  }

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "احجز.. وما تشيلش هم المشوار",
      subtitle: "بدل ما تقف تستنى وتتعطل على مواعيدك، اطلب عربيتك من دلوقتي واضمن مكانك.",
      image: "assets/images/onboarding-img-1.png",
    ),
    OnboardingData(
      title: "ادفع بأي طريقة تريحك",
      subtitle: "دفع كاش أو بأي محفظة إلكترونية في مصر. مشوارك أسهل بموبايلك.",
      image: "assets/images/onboarding-img-2.png",
    ),
    OnboardingData(
      title: "مشوارك متأمن..",
      subtitle: "رحلاتنا متراقبة عشان راحتك، وعندنا عربيات مخصوص للبنات بس عشان يتحركوا براحتهم.",
      image: "assets/images/onboarding-img-3.png",
    ),
  ];

  void _onFinish() async {
    final storage = SecureStorageService();
    await storage.setNotFirstTime();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primaryColor,
      body: Stack(
        children: [
          // 1. Background Images PageView (Bottom Layer)
          Positioned(
            top: 60,
            left: 0,
            right: 0,
            height: (MediaQuery.of(context).size.height - 320 - 60) / 0.75,
            child: IgnorePointer(
              child: PageView.builder(
                controller: _imagePageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _pages.length,
                itemBuilder: (context, index) {
                  double yOffset = 0;
                  if (index == 0) yOffset = 50;
                  if (index == 1) yOffset = 60;
                  if (index == 2) yOffset = 60;

                  return Container(
                    alignment: Alignment.center,
                    child: Transform.translate(
                      offset: Offset(0, yOffset),
                      child: SizedBox(
                        width: 402,
                        height: 581,
                        child: Image.asset(
                          _pages[index].image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          // 2. Static White Card Background (Middle Layer)
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 320,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(32),
                  topRight: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 20,
                    offset: Offset(0, -5),
                  ),
                ],
              ),
            ),
          ),

          // 3. Text Content PageView (Top Layer - restricted to bottom 320px)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            height: 320,
            child: PageView.builder(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: _pages.length,
              itemBuilder: (context, index) {
                return Container(
                  padding: const EdgeInsets.fromLTRB(24, 32, 24, 100),
                  child: Column(
                    children: [
                      Text(
                        _pages[index].title,
                        textAlign: TextAlign.center,
                        style: AppTheme.textTheme.titleLarge?.copyWith(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _pages[index].subtitle,
                        textAlign: TextAlign.center,
                        style: AppTheme.textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textSecondary,
                          height: 1.4,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Fixed Top Bar (Skip & Dots) with Custom Underline
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: _onFinish,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "تخطي",
                          style: AppTheme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 2),
                          width: 40,
                          height: 2,
                          color: Colors.black,
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.only(left: 4),
                        width: index == _currentPage ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: index == _currentPage ? Colors.black : Colors.black26,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Fixed Bottom Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: IOSButton(
                text: _currentPage == _pages.length - 1 ? "انطلق" : "التالي",
                onPressed: () {
                  if (_currentPage < _pages.length - 1) {
                    final next = _currentPage + 1;
                    _pageController.animateToPage(
                      next,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                    _imagePageController.animateToPage(
                      next,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeInOut,
                    );
                  } else {
                    _onFinish();
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String subtitle;
  final String image;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.image,
  });
}
