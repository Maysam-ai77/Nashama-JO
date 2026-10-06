import 'package:flutter/material.dart';
import '../constants.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("المساعدة والدعم",
            style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // هيدر الصفحة
            Center(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        color: jordanianRed.withOpacity(0.1),
                        shape: BoxShape.circle
                    ),
                    child: const Icon(Icons.support_agent_rounded, size: 60, color: jordanianRed),
                  ),
                  const SizedBox(height: 16),
                  const Text("كيف يمكننا مساعدتك؟",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const Text("فريق نشامى جو متواجد لخدمتكم 24/7",
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            const SizedBox(height: 40),

            const Text("تواصل سريع", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // خيارات التواصل
            _buildContactCard(
              title: "دردشة مباشرة",
              subtitle: "تحدث مع الدعم الفني الآن",
              icon: Icons.chat_bubble_outline,
              color: Colors.blue,
            ),
            _buildContactCard(
              title: "رقم الدعم الفني",
              subtitle: "+962 79 000 0000",
              icon: Icons.phone_in_talk_outlined,
              color: Colors.green,
            ),
            _buildContactCard(
              title: "البريد الإلكتروني",
              subtitle: "support@nashamajo.com",
              icon: Icons.alternate_email_outlined,
              color: Colors.orange,
            ),

            const SizedBox(height: 30),
            const Text("الأسئلة الشائعة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            _buildFAQTile("كيف أقوم بتغيير موقع المطعم؟"),
            _buildFAQTile("ماذا أفعل إذا تأخر المندوب عن الاستلام؟"),

            const SizedBox(height: 40),
            const Center(
                child: Text("نسخة التطبيق 1.0.0 (Beta)",
                    style: TextStyle(color: Colors.grey, fontSize: 12))
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard({required String title, required String subtitle, required IconData icon, required Color color}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100)
      ),
      child: ListTile(
        leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
            child: Icon(icon, color: color)
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
      ),
    );
  }

  Widget _buildFAQTile(String question) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(question, style: const TextStyle(fontSize: 14, color: Colors.black87)),
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("يمكنك التواصل معنا عبر الأرقام الموضحة أعلاه لمساعدتك فوراً.",
                style: TextStyle(color: Colors.grey, fontSize: 13)),
          )
        ],
      ),
    );
  }
}