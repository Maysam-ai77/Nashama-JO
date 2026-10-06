import 'package:flutter/material.dart';
import '../constants.dart';
import 'otp_entry_screen.dart';

class OtpChoiceScreen extends StatelessWidget {
  final String userType;
  const OtpChoiceScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.security, size: 50, color: jordanianRed),
            const SizedBox(height: 16),
            const Text('استلام رمز التحقق', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text('أين تريد استلام رمز الدخول المؤقت (OTP)؟', style: TextStyle(fontSize: 14, color: Colors.grey, height: 1.5)),
            const SizedBox(height: 40),

            _buildChoiceCard(context, "البريد الإلكتروني", "إرسال الرمز عبر الإيميل", Icons.email, "إيميل"),
            const SizedBox(height: 16),
            _buildChoiceCard(context, "رسالة نصية (SMS)", "إرسال الرمز إلى رقم الهاتف", Icons.message, "هاتف"),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceCard(BuildContext context, String title, String subtitle, IconData icon, String method) {
    return InkWell(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => OtpEntryScreen(userType: userType, sendMethod: method)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))]),
        child: Row(
          children: [
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle), child: Icon(icon, color: jordanianRed)),
            const SizedBox(width: 16),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey))])),
            const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}