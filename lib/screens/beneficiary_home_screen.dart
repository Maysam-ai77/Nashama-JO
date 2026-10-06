import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/donation_provider.dart';
import '../models/donation_model.dart';

// استدعاء الشاشات المشتركة
import 'login_screen.dart';
import 'about_app_screen.dart';
import 'help_support_screen.dart';
import 'location_screen.dart';
import 'profile_settings_screens.dart' hide LocationScreen, HelpSupportScreen;

class BeneficiaryHomeScreen extends StatefulWidget {
  const BeneficiaryHomeScreen({super.key});

  @override
  State<BeneficiaryHomeScreen> createState() => _BeneficiaryHomeScreenState();
}

class _BeneficiaryHomeScreenState extends State<BeneficiaryHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);

    // الوجبات المتاحة حقيقياً
    final availableDonations = donationProvider.donations
        .where((d) => d.status == "متاح للطلب")
        .toList();

    // طلبات المستفيد بانتظار الاستلام
    final myOrders = donationProvider.donations
        .where((d) => d.status == "بانتظار الاستلام")
        .toList();

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("مرحباً بك يا نشمي،", style: TextStyle(fontSize: 12, color: Colors.grey)),
            Text(
                _selectedIndex == 0 ? "اكتشف الوجبات" :
                _selectedIndex == 1 ? "حجوزاتي الحالية" : "ملفي الشخصي",
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)
            ),
          ],
        ),
      ),
      body: _selectedIndex == 0
          ? _buildHomeContent(context, availableDonations, donationProvider)
          : _selectedIndex == 1
          ? _buildMyRequestsContent(myOrders, donationProvider)
          : _buildProfileContent(context),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // ==========================================
  // 1. تبويب الرئيسية (الوجبات المتاحة)
  // ==========================================
  Widget _buildHomeContent(BuildContext context, List<Donation> available, DonationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBox("جميع الوجبات مجانية وبجودة عالية، يرجى الالتزام بموعد الاستلام."),
          const SizedBox(height: 24),
          const Text("وجبات متوفرة بالقرب منك", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          available.isEmpty
              ? _buildEmptyState("لا يوجد وجبات حالياً، جرب لاحقاً.", Icons.fastfood_outlined)
              : Column(
            children: available.map((meal) => _buildMealCard(context, meal, provider)).toList(),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // 2. تبويب طلباتي
  // ==========================================
  Widget _buildMyRequestsContent(List<Donation> orders, DonationProvider provider) {
    return ListView(
      padding: const EdgeInsets.all(20.0),
      children: [
        orders.isEmpty
            ? _buildEmptyState("لا يوجد لديك طلبات محجوزة.", Icons.shopping_bag_outlined)
            : Column(
          children: orders.map((order) => _buildRequestStatusCard(order, provider)).toList(),
        ),
      ],
    );
  }

  // ==========================================
  // 3. تبويب حسابي (مع إضافة الرقم التسلسلي)
  // ==========================================
  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(width: 90, height: 90, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade200, width: 3)), child: const Icon(Icons.person, size: 45, color: jordanianRed)),
                const SizedBox(height: 12),
                const Text("محمد الأردني", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                // إضافة الرقم التسلسلي للمستفيد لأول مرة
                const Text("الرقم التسلسلي: BN-JO-962-777", style: TextStyle(fontSize: 12, color: Colors.grey, letterSpacing: 1)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          _buildProfileOption(icon: Icons.edit_note, title: "تعديل البيانات الشخصية", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditBeneficiaryProfileScreen()))),
          _buildProfileOption(icon: Icons.location_on_outlined, title: "موقعي الحالي", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationScreen()))),
          _buildProfileOption(icon: Icons.notifications_none, title: "إعدادات الإشعارات", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => BeneficiaryNotificationSettingsScreen()))),
          _buildProfileOption(icon: Icons.privacy_tip_outlined, title: "إعدادات الخصوصية", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PrivacySettingsScreen()))),
          const Divider(height: 32),
          _buildProfileOption(icon: Icons.help_outline, title: "المساعدة والدعم", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()))),
          _buildProfileOption(icon: Icons.info_outline, title: "عن نشامى جو", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutAppScreen()))),
          const SizedBox(height: 20),
          _buildLogoutBtn(context),
        ],
      ),
    );
  }

  // --- عناصر البطاقات ---

  Widget _buildMealCard(BuildContext context, Donation meal, DonationProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade100)),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.fastfood, color: Colors.orange),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(meal.title, style: const TextStyle(fontWeight: FontWeight.bold)), Text("المطعم: مطعم وكافيه الأردن", style: const TextStyle(fontSize: 11, color: Colors.grey))])),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: jordanianRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
              onPressed: () {
                provider.requestDonation(
                  donationId: meal.id,
                  name: "محمد الأردني",
                  type: "مواطن",
                  serial: "NJ-${meal.id.substring(0,4).toUpperCase()}",
                );
              },
              child: const Text("حجز الوجبة", style: TextStyle(color: Colors.white)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRequestStatusCard(Donation order, DonationProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.orange.shade100)),
      child: Column(
        children: [
          const Text("كود الاستلام السري", style: TextStyle(fontSize: 10, color: Colors.grey)),
          Text(order.receiverSerialNumber ?? "", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: jordanianRed, letterSpacing: 2)),
          const Divider(height: 20),
          Text(order.title, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          OutlinedButton(onPressed: () => provider.cancelRequest(order.id), child: const Text("إلغاء الحجز", style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }

  // --- دوال مساعدة إضافية ---
  Widget _buildProfileOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return ListTile(onTap: onTap, leading: Icon(icon, size: 20), title: Text(title, style: const TextStyle(fontSize: 14)), trailing: const Icon(Icons.arrow_back_ios, size: 14));
  }

  Widget _buildLogoutBtn(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen(userType: "مواطن")), (route) => false),
      child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)), child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.logout, color: Colors.red, size: 20), SizedBox(width: 10), Text("تسجيل الخروج", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold))])),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: _selectedIndex, selectedItemColor: jordanianRed,
      onTap: (i) => setState(() => _selectedIndex = i),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "الوجبات"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "طلباتي"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
      ],
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(12)), child: Row(children: [const Icon(Icons.info_outline, color: Colors.blue, size: 20), const SizedBox(width: 10), Expanded(child: Text(text, style: const TextStyle(fontSize: 12)))]));
  }

  Widget _buildEmptyState(String msg, IconData icon) {
    return Center(child: Column(children: [const SizedBox(height: 50), Icon(icon, size: 50, color: Colors.grey.shade300), Text(msg, style: const TextStyle(color: Colors.grey))]));
  }
}

// ==========================================
// 1. شاشة تعديل البيانات الشخصية (مكتملة)
// ==========================================
class EditBeneficiaryProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(title: const Text("تعديل البيانات", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            _buildField("الاسم الكامل", "محمد الأردني"),
            const SizedBox(height: 16),
            _buildField("رقم الهاتف", "+962 79 000 0000"),
            const SizedBox(height: 16),
            _buildField("العنوان / المنطقة", "عمان - شارع الجامعة"),
            const SizedBox(height: 30),
            SizedBox(width: double.infinity, height: 50, child: ElevatedButton(onPressed: () => Navigator.pop(context), style: ElevatedButton.styleFrom(backgroundColor: jordanianRed), child: const Text("حفظ التغييرات", style: TextStyle(color: Colors.white)))),
          ],
        ),
      ),
    );
  }

  Widget _buildField(String label, String value) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: const TextStyle(fontWeight: FontWeight.bold)), const SizedBox(height: 8), TextField(decoration: InputDecoration(hintText: value, filled: true, fillColor: Colors.white, border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none)))]);
  }
}

// ==========================================
// 2. شاشة إعدادات الإشعارات (مكتملة)
// ==========================================
class BeneficiaryNotificationSettingsScreen extends StatefulWidget {
  @override
  State<BeneficiaryNotificationSettingsScreen> createState() => _BeneficiaryNotificationSettingsScreenState();
}

class _BeneficiaryNotificationSettingsScreenState extends State<BeneficiaryNotificationSettingsScreen> {
  bool val1 = true;
  bool val2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(title: const Text("الإشعارات", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            _buildSwitch("إشعارات الوجبات الجديدة", "تنبيهي عند توفر وجبات في منطقتي", val1, (v) => setState(() => val1 = v)),
            const SizedBox(height: 12),
            _buildSwitch("تذكير موعد الاستلام", "تذكيري قبل انتهاء وقت صلاحية الوجبة", val2, (v) => setState(() => val2 = v)),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitch(String t, String s, bool v, Function(bool) onChanged) {
    return Container(decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)), child: SwitchListTile(activeColor: jordanianRed, title: Text(t, style: const TextStyle(fontWeight: FontWeight.bold)), subtitle: Text(s, style: const TextStyle(fontSize: 12)), value: v, onChanged: onChanged));
  }
}

// ==========================================
// 3. شاشة إعدادات الخصوصية (مكتملة)
// ==========================================
class PrivacySettingsScreen extends StatefulWidget {
  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool isAnon = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(title: const Text("الخصوصية", style: TextStyle(color: Colors.black)), backgroundColor: Colors.white, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
          child: SwitchListTile(
            activeColor: jordanianRed,
            title: const Text("إخفاء هويتي (نظام الخصوصية)", style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text("عند التفعيل، سيظهر للمطعم 'كود الاستلام' فقط ولن يتم كشف اسمك الصريح لضمان كرامة المستفيد."),
            value: isAnon,
            onChanged: (v) => setState(() => isAnon = v),
          ),
        ),
      ),
    );
  }
}