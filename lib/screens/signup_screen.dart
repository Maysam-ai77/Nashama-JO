import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants.dart';
import 'otp_entry_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String userType;

  const SignUpScreen({super.key, required this.userType});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordHidden = true;
  final _formKey = GlobalKey<FormState>();

  // ==========================================
  // 1. متغير التحكم بحالة التحميل
  // ==========================================
  bool _isLoading = false;

  // دالة معالجة إنشاء الحساب مع محاكاة التحميل والرسائل
  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // محاكاة الاتصال بالسيرفر (3 ثوانٍ)
      await Future.delayed(const Duration(seconds: 3));

      if (mounted) {
        setState(() {
          _isLoading = false;
        });

        // إظهار رسالة نجاح بسيطة قبل الانتقال
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم إرسال البيانات بنجاح، يرجى تأكيد رقم هاتفك'),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // الانتقال لشاشة الـ OTP
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => OtpEntryScreen(userType: widget.userType, sendMethod: "هاتف"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Text('إنشاء حساب جديد', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 8),
                Text(
                  widget.userType == "الجمعية"
                      ? 'مرحباً بك للتسجيل كجمعية في تطبيق نشامى جو'
                      : widget.userType == "الجهة المانحة"
                      ? 'مرحباً بك للتسجيل كجهة مانحة في تطبيق نشامى جو'
                      : 'مرحباً بك للتسجيل كجهة مستفيدة في تطبيق نشامى جو',
                  style: const TextStyle(fontSize: 14, color: Colors.grey, height: 1.5),
                ),
                const SizedBox(height: 40),

                ..._buildDynamicFields(),

                const SizedBox(height: 16),

                // حقل كلمة المرور
                const Text("كلمة المرور", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
                const SizedBox(height: 8),
                TextFormField(
                  obscureText: _isPasswordHidden,
                  textDirection: TextDirection.ltr,
                  decoration: InputDecoration(
                    hintText: '********',
                    prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                    suffixIcon: IconButton(
                        icon: Icon(_isPasswordHidden ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
                        onPressed: () { setState(() { _isPasswordHidden = !_isPasswordHidden; }); }
                    ),
                    filled: true, fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                    enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'يرجى إدخال كلمة المرور';
                    if (value.length < 8) return 'يجب أن لا تقل عن 8 خانات';
                    if (!RegExp(r'(?=.*[a-z])').hasMatch(value)) return 'يجب أن تحتوي على حرف (a-z)';
                    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) return 'يجب أن تحتوي على حرف (A-Z)';
                    if (!RegExp(r'(?=.*[0-9])').hasMatch(value)) return 'يجب أن تحتوي على رقم (0-9)';
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) return 'يجب أن تحتوي على رمز خاص';
                    return null;
                  },
                ),

                const SizedBox(height: 12),
                _buildPasswordRules(), // استدعاء ويدجت الشروط

                const SizedBox(height: 40),

                // ==========================================
                // زر إنشاء الحساب مع حالة التحميل
                // ==========================================
                SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: _isLoading ? null : _handleSignUp,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: jordanianRed,
                            disabledBackgroundColor: jordanianRed.withOpacity(0.7),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            elevation: 0
                        ),
                        child: _isLoading
                            ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3)
                        )
                            : const Text('إنشاء الحساب', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white))
                    )
                ),

                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("تمتلك حساباً بالفعل؟ ", style: TextStyle(color: Colors.grey)),
                    GestureDetector(onTap: () { Navigator.pop(context); }, child: const Text("تسجيل الدخول", style: TextStyle(color: jordanianRed, fontWeight: FontWeight.bold))),
                  ],
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ويدجت شروط كلمة المرور
  Widget _buildPasswordRules() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("يجب أن تحتوي كلمة المرور على:", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black54)),
          SizedBox(height: 6),
          Text("• 8 خانات على الأقل، أحرف (A-Z, a-z)، رقم، ورمز خاص.", style: TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  List<Widget> _buildDynamicFields() {
    if (widget.userType == "الجهة المستفيدة") {
      return [
        _buildInputField("الاسم الرباعي", "محمد الأردني", Icons.person_outline, validator: (v) => v!.isEmpty ? 'يرجى إدخال الاسم' : null),
        _buildInputField("الرقم الوطني / رقم الوثيقة", "أدخل 10 أرقام", Icons.badge_outlined, isNumber: true, validator: (v) => v!.length != 10 ? 'يجب أن يتكون من 10 أرقام' : null),
        _buildPhoneField(),
      ];
    } else if (widget.userType == "الجمعية") {
      return [
        _buildInputField("اسم الجمعية", "جمعية الأيادي البيضاء", Icons.business, validator: (v) => v!.isEmpty ? 'يرجى إدخال اسم الجمعية' : null),
        _buildInputField("الرقم الوطني للمنشأة", "أدخل 9 أرقام", Icons.app_registration, isNumber: true,
            validator: (v) => (v == null || v.length != 9) ? 'يجب أن يتكون من 9 أرقام' : null),
        _buildPhoneField(),
        _buildEmailField("البريد الإلكتروني", "info@charity.com"),
      ];
    } else {
      return [
        _buildInputField("اسم المنشأة", "مطعم وكافيه الأردن", Icons.storefront, validator: (v) => v!.isEmpty ? 'يرجى إدخال اسم المنشأة' : null),
        _buildPhoneField(),
        _buildEmailField("البريد الإلكتروني", "info@restaurant.com"),
      ];
    }
  }

  Widget _buildInputField(String label, String hint, IconData icon, {bool isNumber = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumber ? [FilteringTextInputFormatter.digitsOnly] : null,
            decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: Colors.grey), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300))),
            validator: validator,
          ),
        ],
      ),
    );
  }

  Widget _buildEmailField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            textDirection: TextDirection.ltr,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9@._-]'))],
            decoration: InputDecoration(hintText: hint, prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300))),
            validator: (value) => (value == null || !value.contains('@')) ? 'البريد الإلكتروني غير صحيح' : null,
          ),
        ],
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("رقم الهاتف", style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 8),
          TextFormField(
            keyboardType: TextInputType.number,
            textDirection: TextDirection.ltr,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(9)],
            decoration: InputDecoration(hintText: '7X XXX XXXX', prefixText: '+962  ', prefixStyle: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16), prefixIcon: const Icon(Icons.phone, color: Colors.grey), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade300))),
            validator: (value) => (value == null || value.length != 9 || !value.startsWith('7')) ? 'رقم الهاتف غير صحيح' : null,
          ),
        ],
      ),
    );
  }
}