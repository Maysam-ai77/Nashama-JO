import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final String userType;
  const ForgotPasswordScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    bool isBeneficiary = userType == "الجهة المستفيدة";
    String hintText = isBeneficiary ? "رقم الهاتف" : "رقم الهاتف أو الإيميل";

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_reset, size: 50, color: jordanianRed),
              const SizedBox(height: 16),
              const Text('نسيت كلمة المرور؟', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('الرجاء إدخال $hintText المرتبط بحسابك وسنقوم بإرسال رمز لاستعادة كلمة المرور.', style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5)),
              const SizedBox(height: 40),

              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)]),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(hintText, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                    const SizedBox(height: 8),
                    TextField(
                        keyboardType: isBeneficiary ? TextInputType.phone : TextInputType.emailAddress,
                        inputFormatters: isBeneficiary ? [FilteringTextInputFormatter.digitsOnly] : null,
                        decoration: InputDecoration(
                            hintText: isBeneficiary ? '+962 7X XXX XXXX' : 'أدخل $hintText',
                            prefixIcon: Icon(isBeneficiary ? Icons.phone_android : Icons.email_outlined, color: Colors.grey),
                            filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)
                        )
                    ),
                    const SizedBox(height: 30),
                    SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: jordanianRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0), child: const Text('إرسال رمز التحقق', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}