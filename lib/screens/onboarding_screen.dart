import 'package:flutter/material.dart';
import '../constants.dart';
import 'role_selection_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  final List<Map<String, String>> onboardingData = [
    {
      "title": "أهلاً بك في نشامى جو",
      "subtitle": "نحو مجتمع مترابط يفيض بالكرم، حيث نحول فائض الطعام إلى وجبات تليق بكرامة الإنسان بسواعد وطنية وعزيمة نشامى.",
    },
    {
      "title": "نربط الخير بالخير",
      "subtitle": "نعمل كحلقة وصل ذكية بين المنشآت المانحة، الجمعيات الخيرية، والمستفيدين المستحقين، لضمان وصول وجبتك بسرية تامة ودون إحراج بلمسة كرم أردنية أصيلة.",
    },
    {
      "title": "ابدأ رحلة الخير معنا",
      "subtitle": "انضم الآن وكن جزءاً من مسيرة الخير، وساهم في تقليل الهدر وتحقيق التكافل المجتمعي في وطننا الغالي. كل فائض هو أجر، بجهد النشامى.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        titleSpacing: 24, // عشان يعطي مسافة متساوية من الأطراف
        // ==========================================
        // التعديل هنا: دمجنا زر اللغة وزر التخطي مع بعض
        // ==========================================
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. زر اللغة
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)),
              child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.language, size: 16, color: Colors.grey),
                    SizedBox(width: 6),
                    Text("English", style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold))
                  ]
              ),
            ),

            // 2. زر التخطي
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RoleSelectionScreen()));
              },
              child: const Text("تخطي", style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: onboardingData.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              return OnboardingPage(
                title: onboardingData[index]["title"]!,
                subtitle: onboardingData[index]["subtitle"]!,
                pageIndex: index,
              );
            },
          ),

          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    onboardingData.length,
                        (index) => buildIndicator(index),
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == onboardingData.length - 1) {
                        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RoleSelectionScreen()));
                      } else {
                        _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: jordanianRed,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _currentPage == onboardingData.length - 1 ? "ابدأ الآن" : "التالي",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white, fontFamily: 'Tahoma'),
                        ),
                        const SizedBox(width: 10),
                        Icon(_currentPage == onboardingData.length - 1 ? Icons.check : Icons.arrow_forward, color: Colors.white, size: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildIndicator(int index) {
    bool isCurrent = _currentPage == index;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      height: 8,
      width: isCurrent ? 24 : 8,
      decoration: BoxDecoration(
        color: isCurrent ? jordanianRed : Colors.grey.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }
}

class OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final int pageIndex;

  const OnboardingPage({
    super.key,
    required this.title,
    required this.subtitle,
    required this.pageIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Image.asset(
          'default_logo.png',
          width: 200,
          height: 200,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 60),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              fontFamily: 'Tahoma',
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              height: 1.6,
              fontFamily: 'Tahoma',
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}