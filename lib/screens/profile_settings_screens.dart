import 'package:flutter/material.dart';
import '../constants.dart';

// ==========================================
// 1. شاشة تعديل بيانات المنشأة
// ==========================================
class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(title: const Text("تعديل بيانات المنشأة", style: TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Center(
              child: Stack(
                children: [
                  Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300, width: 2)), child: const Icon(Icons.storefront, size: 50, color: jordanianRed)),
                  Positioned(bottom: 0, right: 0, child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: jordanianRed, shape: BoxShape.circle), child: const Icon(Icons.camera_alt, color: Colors.white, size: 16))),
                ],
              ),
            ),
            const SizedBox(height: 30),
            _buildTextField("اسم المنشأة", "مطعم وكافيه الأردن", Icons.business),
            const SizedBox(height: 16),
            _buildTextField("رقم الهاتف", "+962 79 123 4567", Icons.phone),
            const SizedBox(height: 16),
            _buildTextField("البريد الإلكتروني", "info@restaurant.com", Icons.email),
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: jordanianRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text("حفظ التعديلات", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String hint, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(decoration: InputDecoration(hintText: hint, prefixIcon: Icon(icon, color: Colors.grey), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)), enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)))),
      ],
    );
  }
}

// ==========================================
// 2. شاشة الموقع (الخريطة)
// ==========================================
class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(title: const Text("موقع المطعم", style: TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("تحديد الموقع على الخريطة", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 200, width: double.infinity,
              decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
              child: const Column(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.map, size: 50, color: Colors.grey), SizedBox(height: 8), Text("هنا ستظهر خريطة جوجل", style: TextStyle(color: Colors.grey))]),
            ),
            const SizedBox(height: 24),
            const Text("العنوان بالتفصيل", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(maxLines: 2, decoration: InputDecoration(hintText: "عمان، شارع الجامعة، بجانب مستشفى الإسراء", filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)))),
            const Spacer(),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: jordanianRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text("تحديث الموقع", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))),
          ],
        ),
      ),
    );
  }
}

// ==========================================
// 3. شاشة إعدادات الإشعارات (زي الصورة اللي طلبتيها)
// ==========================================
class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool val1 = true;
  bool val2 = true;
  bool val3 = true;
  bool val4 = false;
  bool val5 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(title: const Text("إعدادات الإشعارات", style: TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          _buildSwitch("إشعارات حجز الوجبات من المستفيدين", val1, (val) => setState(() => val1 = val)),
          const Divider(),
          _buildSwitch("إشعارات قبول الطلب من الجمعيات", val2, (val) => setState(() => val2 = val)),
          const Divider(),
          _buildSwitch("تحديثات حالة استلام الوجبات", val3, (val) => setState(() => val3 = val)),
          const Divider(),
          _buildSwitch("تذكير بمواعيد انتهاء صلاحية التبرع", val4, (val) => setState(() => val4 = val)),
          const Divider(),
          _buildSwitch("أخبار وتحديثات تطبيق نشامى جو", val5, (val) => setState(() => val5 = val)),
        ],
      ),
    );
  }

  Widget _buildSwitch(String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      value: value,
      activeColor: jordanianRed,
      onChanged: onChanged,
      contentPadding: EdgeInsets.zero,
    );
  }
}

// ==========================================
// 4. شاشة تغيير كلمة المرور
// ==========================================
class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(title: const Text("تغيير كلمة المرور", style: TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildPassField("كلمة المرور الحالية"),
            const SizedBox(height: 16),
            _buildPassField("كلمة المرور الجديدة"),
            const SizedBox(height: 16),
            _buildPassField("تأكيد كلمة المرور الجديدة"),
            const SizedBox(height: 40),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () { Navigator.pop(context); }, style: ElevatedButton.styleFrom(backgroundColor: jordanianRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))), child: const Text("حفظ كلمة المرور", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)))),
          ],
        ),
      ),
    );
  }

  Widget _buildPassField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        TextField(obscureText: true, decoration: InputDecoration(hintText: "********", prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey), filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade300)))),
      ],
    );
  }
}

// ==========================================
// 5. شاشة المساعدة والدعم
// ==========================================
class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(title: const Text("المساعدة والدعم", style: TextStyle(color: Colors.black)), backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.support_agent, size: 80, color: jordanianRed),
            const SizedBox(height: 16),
            const Text("كيف يمكننا مساعدتك اليوم؟", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _buildContactCard(Icons.phone, "اتصل بنا", "0791234567"),
            const SizedBox(height: 16),
            _buildContactCard(Icons.email, "البريد الإلكتروني", "support@nashamajo.com"),
            const SizedBox(height: 16),
            _buildContactCard(Icons.chat, "تحدث معنا (واتساب)", "0791234567"),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(IconData icon, String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: jordanianRed.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: jordanianRed)),
          const SizedBox(width: 16),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 14, color: Colors.grey))]),
        ],
      ),
    );
  }
}