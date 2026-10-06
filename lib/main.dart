import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/donation_provider.dart';
import 'constants.dart';
import 'screens/onboarding_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DonationProvider(),
      child: const NashamaApp(),
    ),
  );
}

class NashamaApp extends StatelessWidget {
  const NashamaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'نشامى جو',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: jordanianRed,
        fontFamily: 'Tahoma',
      ),
      // هذا هو الجزء الذي يضمن أن كل التطبيق يبدأ من اليمين لليسار (عربي)
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
      // البداية من شاشة الشرح كما طلبنا
      home: const OnboardingScreen(),
    );
  }
}