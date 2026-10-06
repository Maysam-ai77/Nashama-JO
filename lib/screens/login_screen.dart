import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import 'signup_screen.dart';
import 'forgot_password_screen.dart';
import 'otp_choice_screen.dart';
import 'otp_entry_screen.dart';
import 'donor_home_screen.dart';
import 'charity_home_screen.dart';
import 'beneficiary_home_screen.dart';

class LoginScreen extends StatefulWidget {
  final String userType;
  const LoginScreen({super.key, required this.userType});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isPasswordHidden = true;
  final _formKey = GlobalKey<FormState>();

  // ==========================================
  // متغير جديد للتحكم بحالة التحميل
  // ==========================================
  bool _isLoading = false;

  // دالة وهمية لمحاكاة الاتصال بالسيرفر
  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      // 1. تشغيل دائرة التحميل
      setState(() {
        _isLoading = true;
      });

      // 2. انتظار وهمي لمدة ثانيتين (كأننا بنكلم Firebase)
      await Future.delayed(const Duration(seconds: 2));

      // 3. إيقاف دائرة التحميل والانتقال للصفحة المناسبة
      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        if (widget.userType == "الجهة المانحة") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const DonorHomeScreen()), (route) => false);
        } else if (widget.userType == "الجمعية") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const CharityHomeScreen()), (route) => false);
        } else if (widget.userType == "الجهة المستفيدة") {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const BeneficiaryHomeScreen()), (route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isBeneficiary = widget.userType == "الجهة المستفيدة";
    String otpButtonText = isBeneficiary ? "الدخول برمز التحقق (OTP)" : "الدخول برمز التحقق (هاتف/إيميل)";

    return Scaffold(
      backgroundColor: lightBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(icon: const Icon(Icons.arrow_back, color: Colors.black), onPressed: () { Navigator.pop(context); }),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.grey.shade300)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.language, size: 16, color: Colors.grey), SizedBox(width: 6), Text("English", style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold))])),
                  ],
                ),
                const SizedBox(height: 10),
                Image.asset('default_logo.png', width: 150, height: 150, fit: BoxFit.contain),
                const SizedBox(height: 20),
                const Text('نشامى جو', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Text('مرحباً بعودتك، ${widget.userType}', style: const TextStyle(fontSize: 16, color: Colors.grey)),
                const SizedBox(height: 40),

                Form(
                  key: _formKey,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))]),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        isBeneficiary ? _buildPhoneLoginField() : _buildEmailLoginField(),
                        const SizedBox(height: 20),

                        Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("كلمة المرور", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                              GestureDetector(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => ForgotPasswordScreen(userType: widget.userType))); }, child: const Text("نسيت كلمة المرور؟", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: jordanianRed)))
                            ]
                        ),
                        const SizedBox(height: 8),
                        TextFormField(
                          obscureText: _isPasswordHidden,
                          textDirection: TextDirection.ltr,
                          decoration: InputDecoration(hintText: '********', prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey), suffixIcon: IconButton(icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: () { setState(() { _isPasswordHidden = !_isPasswordHidden; }); }), filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
                          validator: (value) {
                            if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
                            if (value.length < 8) return 'كلمة المرور يجب أن لا تقل عن 8 خانات';
                            return null;
                          },
                        ),
                        const SizedBox(height: 30),

                        // ==========================================
                        // زر تسجيل الدخول مع تأثير التحميل
                        // ==========================================
                        SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              // إذا كان بيحمل، بنعطل الزر عشان ما ينكبس كمان مرة
                                onPressed: _isLoading ? null : _handleLogin,
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: jordanianRed,
                                    disabledBackgroundColor: jordanianRed.withOpacity(0.7), // لون الزر وهو معطل
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                    elevation: 0
                                ),
                                child: _isLoading
                                    ? const SizedBox(
                                    height: 24,
                                    width: 24,
                                    child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                                )
                                    : const Text('تسجيل الدخول', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                            )
                        ),

                        const SizedBox(height: 20),
                        Row(children: [Expanded(child: Divider(color: Colors.grey[300])), const Padding(padding: EdgeInsets.symmetric(horizontal: 10), child: Text("أو", style: TextStyle(color: Colors.grey))), Expanded(child: Divider(color: Colors.grey[300]))]),
                        const SizedBox(height: 20),

                        SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                                onPressed: _isLoading ? null : () {
                                  if (isBeneficiary) {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => OtpEntryScreen(userType: widget.userType, sendMethod: "هاتف")));
                                  } else {
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => OtpChoiceScreen(userType: widget.userType)));
                                  }
                                },
                                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[200], elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                                child: Text(otpButtonText, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))
                            )
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("لا تمتلك حساباً؟ ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(onTap: () { Navigator.push(context, MaterialPageRoute(builder: (context) => SignUpScreen(userType: widget.userType))); }, child: const Text("إنشاء حساب", style: TextStyle(color: jordanianRed, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneLoginField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("رقم الهاتف", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.number,
          textDirection: TextDirection.ltr,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
          decoration: InputDecoration(hintText: '7X XXX XXXX', prefixText: '+962  ', prefixStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16), prefixIcon: const Icon(Icons.phone_android, color: Colors.grey), filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى إدخال رقم الهاتف';
            if (!value.startsWith('7')) return 'رقم الهاتف يجب أن يبدأ بالرقم 7';
            if (value.length != 9) return 'رقم الهاتف يجب أن يتكون من 9 أرقام';
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildEmailLoginField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("البريد الإلكتروني", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
        const SizedBox(height: 8),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          textDirection: TextDirection.ltr,
          inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]'))],
          decoration: InputDecoration(hintText: 'info@example.com', prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey), filled: true, fillColor: Colors.grey[100], border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none)),
          validator: (value) {
            if (value == null || value.isEmpty) return 'يرجى إدخال البريد الإلكتروني';
            if (!value.contains('@')) return 'البريد الإلكتروني غير صحيح';
            return null;
          },
        ),
      ],
    );
  }
}