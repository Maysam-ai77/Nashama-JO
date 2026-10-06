import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import 'beneficiary_home_screen.dart'; // شاشة المستفيد
import 'donor_home_screen.dart';       // شاشة المانح
import 'charity_home_screen.dart';     // شاشة الجمعية

class OtpEntryScreen extends StatelessWidget {
  final String userType;
  final String sendMethod; // لمعرفة هل تم الإرسال للهاتف أم الإيميل

  const OtpEntryScreen({super.key, required this.userType, required this.sendMethod});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const Icon(Icons.mark_email_read_outlined, size: 60, color: jordanianRed),
              const SizedBox(height: 20),
              const Text('أدخل رمز التحقق', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('لقد قمنا بإرسال رمز مكون من 4 أرقام إلى ${sendMethod == "إيميل" ? "بريدك الإلكتروني" : "رقم هاتفك"}', textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5)),
              const SizedBox(height: 40),

              // مربعات إدخال الرمز (OTP)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOtpBox(context),
                  _buildOtpBox(context),
                  _buildOtpBox(context),
                  _buildOtpBox(context),
                ],
              ),
              const SizedBox(height: 40),

              // زر تأكيد الدخول (مربوط بكل الشاشات حسب نوع المستخدم)
              SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                      onPressed: () {
                        if (userType == "الجهة المستفيدة") {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BeneficiaryHomeScreen()), (route) => false);
                        } else if (userType == "الجهة المانحة") {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DonorHomeScreen()), (route) => false);
                        } else if (userType == "الجمعية") {
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const CharityHomeScreen()), (route) => false);
                        }
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: jordanianRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                      child: const Text('تأكيد الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                  )
              ),
              const SizedBox(height: 30),

              // زر إعادة الإرسال مع الـ SnackBar
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("لم تستلم الرمز؟ ", style: TextStyle(color: Colors.grey)),
                  GestureDetector(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('تم إرسال رمز جديد بنجاح!', style: TextStyle(fontFamily: 'Tahoma', fontSize: 14), textAlign: TextAlign.center,),
                            backgroundColor: jordanianRed,
                            duration: Duration(seconds: 3),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: const Text("إعادة الإرسال", style: TextStyle(color: jordanianRed, fontWeight: FontWeight.bold))
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // مربع صغير لإدخال رقم واحد من الـ OTP
  Widget _buildOtpBox(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60,
      child: TextField(
        autofocus: true,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(1)],
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: jordanianRed, width: 2)),
        ),
        onChanged: (value) {
          if (value.length == 1) {
            FocusScope.of(context).nextFocus(); // للانتقال للمربع التالي تلقائياً
          }
        },
      ),
    );
  }
}