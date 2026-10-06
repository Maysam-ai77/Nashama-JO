import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/donation_provider.dart';
import '../models/donation_model.dart';

// استدعاء الشاشات المنفصلة
import 'location_screen.dart';
import 'add_donation_screen.dart';
import 'login_screen.dart';
import 'about_app_screen.dart';
import 'help_support_screen.dart';

// حل مشكلة التعارض: نخفي الشاشات المتكررة من ملف البروفايل
import 'profile_settings_screens.dart' hide LocationScreen, HelpSupportScreen;

class DonorHomeScreen extends StatefulWidget {
  const DonorHomeScreen({super.key});

  @override
  State<DonorHomeScreen> createState() => _DonorHomeScreenState();
}

class _DonorHomeScreenState extends State<DonorHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);

    // تصفية الوجبات: (نشطة) و (سجل مكتمل)
    final activeDonations = donationProvider.donations.where((d) => d.status != "مكتمل").toList();
    final historyDonations = donationProvider.donations.where((d) => d.status == "مكتمل").toList();

    // تحديد عنوان الـ AppBar ديناميكياً
    Widget appBarTitle;
    if (_selectedIndex == 0) {
      appBarTitle = const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("مرحباً بك،", style: TextStyle(fontSize: 14, color: Colors.grey)),
          Text("مطعم وكافيه الأردن", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87))
        ],
      );
    } else if (_selectedIndex == 1) {
      appBarTitle = const Text("سجل التبرعات", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87));
    } else {
      appBarTitle = const Text("حسابي", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87));
    }

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: appBarTitle,
        actions: [
          if (_selectedIndex != 2)
            IconButton(
              icon: Badge(
                label: Text(donationProvider.pendingRequestsCount.toString()),
                child: const Icon(Icons.notifications_active, color: jordanianRed, size: 28),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
              },
            ),
          const SizedBox(width: 15),
        ],
      ),

      body: _selectedIndex == 0
          ? _buildHomeContent(context, donationProvider, activeDonations)
          : _selectedIndex == 1
          ? _buildHistoryContent(historyDonations)
          : _buildProfileContent(context),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            backgroundColor: Colors.white, currentIndex: _selectedIndex, selectedItemColor: jordanianRed, unselectedItemColor: Colors.grey, showUnselectedLabels: true, type: BottomNavigationBarType.fixed,
            onTap: (index) { setState(() { _selectedIndex = index; }); },
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: "الرئيسية"),
              BottomNavigationBarItem(icon: Icon(Icons.history), label: "السجل"),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
            ],
          ),
        ),
      ),
    );
  }

  // 1. محتوى الرئيسية
  Widget _buildHomeContent(BuildContext context, DonationProvider provider, List<Donation> activeDonations) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: _buildStatCard("إجمالي التبرعات", provider.totalDonationsCount.toString(), "وجبة", Icons.volunteer_activism)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatCard("بانتظار الاستلام", provider.pendingRequestsCount.toString(), "طلبات", Icons.pending_actions)),
            ],
          ),
          const SizedBox(height: 30),
          _buildAddDonationCard(context),
          const SizedBox(height: 40),
          const Text("التبرعات الحالية", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          activeDonations.isEmpty
              ? _buildEmptyState("لم تقم بإضافة أي تبرعات حالية بعد.", Icons.fastfood_outlined)
              : Column(children: activeDonations.map((item) => _buildCurrentDonationCard(item, provider)).toList()),
        ],
      ),
    );
  }

  // 2. محتوى السجل
  Widget _buildHistoryContent(List<Donation> historyDonations) {
    if (historyDonations.isEmpty) {
      return _buildEmptyState("سجل التبرعات فارغ حالياً.", Icons.history_rounded);
    }
    return ListView.builder(
      padding: const EdgeInsets.all(24.0),
      itemCount: historyDonations.length,
      itemBuilder: (context, index) {
        var item = historyDonations[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), shape: BoxShape.circle), child: const Icon(Icons.check_circle, color: Colors.green, size: 24)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold)), Text("المستلم: ${item.charityName ?? 'غير معروف'}", style: const TextStyle(fontSize: 12, color: Colors.grey))])),
              const Text("مكتمل", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
        );
      },
    );
  }

  // 3. محتوى حسابي (تفعيل الروابط)
  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(width: 100, height: 100, decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, border: Border.all(color: Colors.grey.shade300, width: 2), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]), child: const Icon(Icons.storefront, size: 50, color: jordanianRed)),
                const SizedBox(height: 16),
                const Text("مطعم وكافيه الأردن", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                const Text("+962 79 123 4567", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 40),

          _buildProfileOption(icon: Icons.person_outline, title: "تعديل بيانات المنشأة", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()))),

          _buildProfileOption(icon: Icons.location_on_outlined, title: "موقع المطعم (الخريطة)", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationScreen()))),

          _buildProfileOption(icon: Icons.notifications_outlined, title: "إعدادات الإشعارات", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()))),

          _buildProfileOption(icon: Icons.lock_outline, title: "تغيير كلمة المرور", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()))),

          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),

          _buildProfileOption(icon: Icons.help_outline, title: "المساعدة والدعم", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen()))),

          _buildProfileOption(icon: Icons.info_outline, title: "عن تطبيق نشامى جو", onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutAppScreen()))),

          const SizedBox(height: 20),
          _buildLogoutBtn(context),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  // دوال مساعدة
  Widget _buildLogoutBtn(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen(userType: "الجهة المانحة")), (route) => false),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.shade100)),
        child: Row(children: [Icon(Icons.logout, color: Colors.red.shade700), const SizedBox(width: 16), Text("تسجيل الخروج", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red.shade700))]),
      ),
    );
  }

  Widget _buildCurrentDonationCard(Donation item, DonationProvider provider) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: item.isPending ? Colors.orange.shade200 : Colors.green.shade200)),
      child: Column(
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: item.isPending ? Colors.orange.shade50 : Colors.green.shade50, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.fastfood, color: item.isPending ? Colors.orange : Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  if (!item.isPending) IconButton(icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20), onPressed: () => provider.cancelDonation(item.id)),
                ]),
                Text("لغاية: ${item.expiryTime}", style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ])),
            ],
          ),
          if (item.isPending) ...[
            const Divider(height: 24),
            _buildBeneficiaryInfoRow(Icons.person, "المستلم: ${item.charityName}"),
            const SizedBox(height: 12),
            SizedBox(width: double.infinity, height: 45, child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () => provider.confirmDelivery(item.id), child: const Text("تأكيد تسليم الوجبة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)))),
          ]
        ],
      ),
    );
  }

  Widget _buildBeneficiaryInfoRow(IconData icon, String text) {
    return Row(children: [Icon(icon, size: 16, color: Colors.orange.shade800), const SizedBox(width: 8), Text(text, style: TextStyle(fontSize: 13, color: Colors.orange.shade900, fontWeight: FontWeight.w500))]);
  }

  Widget _buildProfileOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Padding(padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(icon, color: Colors.black87, size: 24)), const SizedBox(width: 16), Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))), const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16)])));
  }

  Widget _buildStatCard(String title, String count, String unit, IconData icon) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(icon, color: jordanianRed, size: 28), const SizedBox(height: 12), Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)), Row(crossAxisAlignment: CrossAxisAlignment.baseline, textBaseline: TextBaseline.alphabetic, children: [Text(count, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)), const SizedBox(width: 4), Text(unit, style: const TextStyle(fontSize: 12, color: Colors.grey))])]));
  }

  Widget _buildAddDonationCard(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddDonationScreen())),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(gradient: const LinearGradient(colors: [jordanianRed, Color(0xFFC72C31)]), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: jordanianRed.withOpacity(0.3), blurRadius: 15, offset: const Offset(0, 8))]),
        child: const Row(children: [Icon(Icons.add_business, color: Colors.white, size: 30), SizedBox(width: 15), Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text("إضافة فائض طعام", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)), Text("تبرع بالوجبات الزائدة الآن", style: TextStyle(color: Colors.white70, fontSize: 12))])]),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Center(child: Padding(padding: const EdgeInsets.symmetric(vertical: 40.0), child: Column(children: [Icon(icon, size: 60, color: Colors.grey.shade300), const SizedBox(height: 16), Text(message, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))])));
  }
}