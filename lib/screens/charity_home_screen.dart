import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/donation_provider.dart';
import '../models/donation_model.dart';

// 1. استدعاء الشاشات المنفصلة
import 'login_screen.dart';
import 'about_app_screen.dart';
import 'help_support_screen.dart';
import 'location_screen.dart';

// 2. التعديل السحري هنا: نخفي الأسماء المتكررة من هذا الملف (LocationScreen و HelpSupportScreen)
import 'profile_settings_screens.dart' hide LocationScreen, HelpSupportScreen;

class CharityHomeScreen extends StatefulWidget {
  const CharityHomeScreen({super.key});

  @override
  State<CharityHomeScreen> createState() => _CharityHomeScreenState();
}

class _CharityHomeScreenState extends State<CharityHomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final donationProvider = Provider.of<DonationProvider>(context);

    final availableDonations = donationProvider.donations
        .where((d) => d.status == "متاح للطلب")
        .toList();

    final myRequests = donationProvider.donations
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
            const Text("مرحباً بكِ،", style: TextStyle(fontSize: 14, color: Colors.grey)),
            Text(
              _selectedIndex == 0 ? "جمعية الأيادي البيضاء" :
              _selectedIndex == 1 ? "قائمة طلباتي" : "إعدادات الحساب",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
            ),
          ],
        ),
        actions: [
          if (_selectedIndex != 2)
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black87),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen()));
              },
            ),
          const SizedBox(width: 10),
        ],
      ),

      body: _selectedIndex == 0
          ? _buildAvailableDonations(availableDonations, donationProvider)
          : _selectedIndex == 1
          ? _buildMyRequests(myRequests, donationProvider)
          : _buildProfileContent(context),

      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // تبويب الوجبات المتاحة
  Widget _buildAvailableDonations(List<Donation> available, DonationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBox("تظهر لكِ الوجبات المتاحة حالياً، يرجى حجز الوجبة قبل انتهاء وقت الصلاحية."),
          const SizedBox(height: 24),
          const Text("آخر التبرعات المضافة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          available.isEmpty
              ? _buildEmptyState("لا توجد وجبات متاحة حالياً", Icons.search_off_outlined)
              : Column(
            children: available.map((donation) => _buildDonationCard(donation, provider, false)).toList(),
          ),
        ],
      ),
    );
  }

  // تبويب طلباتي
  Widget _buildMyRequests(List<Donation> requests, DonationProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoBox("يرجى التوجه للمطعم وإظهار الرقم التسلسلي لتأكيد استلام الوجبة."),
          const SizedBox(height: 24),
          const Text("وجبات بانتظار استلامك", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          requests.isEmpty
              ? _buildEmptyState("ليس لديكِ طلبات حالية", Icons.shopping_basket_outlined)
              : Column(
            children: requests.map((donation) => _buildDonationCard(donation, provider, true)).toList(),
          ),
        ],
      ),
    );
  }

  // تبويب حسابي
  Widget _buildProfileContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        children: [
          Center(
            child: Column(
              children: [
                Container(
                    width: 100, height: 100,
                    decoration: BoxDecoration(
                        color: Colors.white, shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey.shade300, width: 2),
                        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]
                    ),
                    child: const Icon(Icons.account_balance_rounded, size: 50, color: jordanianRed)
                ),
                const SizedBox(height: 16),
                const Text("جمعية الأيادي البيضاء", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                const Text("الرقم التسلسلي: CH-JO-962-001", style: TextStyle(fontSize: 14, color: Colors.grey)),
              ],
            ),
          ),
          const SizedBox(height: 40),

          _buildProfileOption(
            icon: Icons.edit_note,
            title: "تعديل بيانات الجمعية",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen())),
          ),

          _buildProfileOption(
            icon: Icons.location_on_outlined,
            title: "موقع الجمعية (الخريطة)",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LocationScreen())),
          ),

          _buildProfileOption(
            icon: Icons.notifications_outlined,
            title: "إعدادات الإشعارات",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationSettingsScreen())),
          ),
          _buildProfileOption(
            icon: Icons.lock_outline,
            title: "تغيير كلمة المرور",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen())),
          ),

          const Padding(padding: EdgeInsets.symmetric(vertical: 10), child: Divider()),

          _buildProfileOption(
            icon: Icons.help_outline,
            title: "المساعدة والدعم",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const HelpSupportScreen())),
          ),
          _buildProfileOption(
            icon: Icons.info_outline,
            title: "عن تطبيق نشامى جو",
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AboutAppScreen())),
          ),

          const SizedBox(height: 30),

          _buildLogoutBtn(context),
        ],
      ),
    );
  }

  // دوال مساعدة
  Widget _buildLogoutBtn(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const LoginScreen(userType: "الجمعية")), (route) => false);
      },
      child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.shade100)),
          child: Row(children: [Icon(Icons.logout, color: Colors.red.shade700), const SizedBox(width: 16), Text("تسجيل الخروج", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red.shade700))])),
    );
  }

  Widget _buildDonationCard(Donation donation, DonationProvider provider, bool isMyRequest) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isMyRequest ? Colors.orange.shade200 : Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: isMyRequest ? Colors.orange.shade50 : Colors.green.shade50, borderRadius: BorderRadius.circular(12)), child: Icon(Icons.fastfood, color: isMyRequest ? Colors.orange : Colors.green)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(donation.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)), Text("الكمية: ${donation.quantity} ${donation.unit}", style: const TextStyle(fontSize: 14, color: Colors.grey))])),
            ],
          ),
          const Divider(height: 24),

          if (isMyRequest) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text("الرقم التسلسلي:", style: TextStyle(fontSize: 10, color: Colors.grey)), Text(donation.receiverSerialNumber ?? "", style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16))]),
                TextButton.icon(onPressed: () => provider.cancelRequest(donation.id), icon: const Icon(Icons.cancel_outlined, color: Colors.red, size: 18), label: const Text("إلغاء الحجز", style: TextStyle(color: Colors.red, fontSize: 13))),
              ],
            ),
          ] else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [const Icon(Icons.access_time, size: 14, color: Colors.grey), const SizedBox(width: 4), Text("لغاية ${donation.expiryTime}", style: const TextStyle(fontSize: 12, color: Colors.grey))]),
                ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: jordanianRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))), onPressed: () {
                  provider.requestDonation(donationId: donation.id, name: "جمعية الأيادي البيضاء", type: "جمعية خيرية", serial: "SN-${donation.id.substring(0, 5).toUpperCase()}");
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم حجز الوجبة بنجاح!'), backgroundColor: Colors.green));
                }, child: const Text("حجز الوجبة", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return InkWell(onTap: onTap, borderRadius: BorderRadius.circular(16), child: Padding(padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0), child: Row(children: [Container(padding: const EdgeInsets.all(10), decoration: BoxDecoration(color: Colors.grey.shade100, shape: BoxShape.circle), child: Icon(icon, color: Colors.black87, size: 24)), const SizedBox(width: 16), Expanded(child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87))), const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16)])));
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))]),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        child: BottomNavigationBar(
          backgroundColor: Colors.white, currentIndex: _selectedIndex, selectedItemColor: jordanianRed, unselectedItemColor: Colors.grey, showUnselectedLabels: true, type: BottomNavigationBarType.fixed,
          onTap: (index) { setState(() { _selectedIndex = index; }); },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.volunteer_activism), label: "المتاحة"),
            BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: "طلباتي"),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: "حسابي"),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoBox(String text) {
    return Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.blue.shade50, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.blue.shade100)), child: Row(children: [Icon(Icons.info_outline, color: Colors.blue.shade700), const SizedBox(width: 12), Expanded(child: Text(text, style: const TextStyle(fontSize: 13)))]));
  }

  Widget _buildEmptyState(String title, IconData icon) {
    return Center(child: Column(children: [const SizedBox(height: 60), Icon(icon, size: 80, color: Colors.grey.shade300), const SizedBox(height: 16), Text(title, style: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.bold))]));
  }
}