import 'package:flutter/material.dart';
import '../constants.dart';
import 'description_screen.dart'; // رح نستدعي شاشة الوصف اللي رح نعملها بالخطوة الجاية

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("من أنت؟", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("يرجى اختيار نوع الحساب للمتابعة", style: TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 40),
            _buildRoleCard(context, "الجمعيات الخيرية", Icons.business, "الجمعية"),
            const SizedBox(height: 16),
            _buildRoleCard(context, "الجهة المانحة", Icons.restaurant, "الجهة المانحة"),
            const SizedBox(height: 16),
            _buildRoleCard(context, "الجهة المستفيدة", Icons.person, "الجهة المستفيدة"),
          ],
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String title, IconData icon, String roleType) {
    return InkWell(
      onTap: () {
        // النقل لشاشة الوصف مع تمرير نوع المستخدم
        Navigator.push(context, MaterialPageRoute(builder: (context) => DescriptionScreen(userType: roleType)));
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
        ),
        child: Row(
          children: [
            Icon(icon, size: 40, color: jordanianRed),
            const SizedBox(width: 20),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Spacer(),
            const Icon(Icons.arrow_back_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    );
  }
}