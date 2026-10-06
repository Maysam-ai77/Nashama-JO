import 'package:flutter/material.dart';
import '../constants.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text(
          "عن نشامى جو",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18, fontFamily: 'Tahoma'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // اللوجو في البداية لتعزيز الهوية بصرياً
            Center(
              child: Column(
                children: [
                  Image.asset('default_logo.png', height: 120),
                  const SizedBox(height: 10),
                  const Text(
                    "نحو مجتمع مترابط بلا هدر",
                    style: TextStyle(fontSize: 14, color: jordanianRed, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // قسم: من نحن؟
            _buildSectionHeader(Icons.info_outline, "من نحن؟"),
            _buildSectionBody(
                "نشامى هو تطبيق إنساني ذكي مستوحى من قيم المجتمع الأردني، قائم على النخوة والتكافل. يهدف إلى حفظ النعمة وتقليل هدر الطعام من خلال ربط الجهات التي تمتلك فائضًا من الطعام مع الأشخاص المحتاجين، بطريقة تحفظ كرامتهم بالكامل.\nنشامى ليس مجرد تطبيق، بل منظومة تكافل رقمية تعكس روح المجتمع."),

            // قسم: فكرة التطبيق
            _buildSectionHeader(Icons.lightbulb_outline, "فكرة التطبيق"),
            _buildSectionBody(
                "يوميًا يتم هدر كميات كبيرة من الطعام الصالح للأكل، في الوقت الذي يعاني فيه الكثير من الناس من نقص الغذاء. يعمل نشامى على جمع الطعام الفائض من المطاعم والأفراد، ثم استخدام نظام ذكي لتحديد المستفيد الأنسب، وتقديم الطعام بدون طلب مباشر أو إحراج."),

            // قسم: لماذا اسم نشامى؟
            _buildSectionHeader(Icons.star_outline, "لماذا اسم نشامى؟"),
            _buildSectionBody(
                "لأن النشامى يمثلون الشهامة والكرم ومساعدة الآخرين بدون مقابل. التطبيق هو ترجمة رقمية لهذه القيم، حيث يتم تقديم المساعدة باحترام وكرامة."),

            // قسم: أهدافنا (قائمة نقطية)
            _buildSectionHeader(Icons.ads_click, "أهدافنا"),
            _buildBulletPoint("تقليل هدر الطعام في الأردن."),
            _buildBulletPoint("مساعدة أكبر عدد ممكن من المحتاجين."),
            _buildBulletPoint("تحقيق وصول عادل للغذاء."),
            _buildBulletPoint("تعزيز روح التكافل المجتمعي."),

            // قسم: رؤيتنا
            _buildSectionHeader(Icons.visibility_outlined, "رؤيتنا"),
            _buildSectionBody(
                "أن يصبح نشامى المنصة الأولى في الأردن والعالم العربي لإدارة فائض الطعام وتحويله إلى قيمة إنسانية مستدامة."),

            // قسم: ما الذي يميزنا؟
            _buildSectionHeader(Icons.workspace_premium_outlined, "ما الذي يميزنا؟"),
            _buildBulletPoint("حفظ الكرامة أولاً من خلال نظام لا يعتمد على الطلب المباشر أو الإحراج."),
            _buildBulletPoint("نظام ذكي يقوم في تقليل هدر الطعام وحماية البيئة من خلال منحه للجهة المستفيدة."),
            _buildBulletPoint("التعاون مع المطاعم والجمعيات لضمان عدالة التوزيع."),

            // قسم: كيف يعمل التطبيق؟ (خطوات)
            _buildSectionHeader(Icons.settings_suggest_outlined, "كيف يعمل التطبيق؟"),
            _buildStepPoint(1, "يقوم المطعم أو المستخدم بإضافة وجبة فائضة."),
            _buildStepPoint(2, "يقوم النظام بتحليل البيانات."),
            _buildStepPoint(3, "يتم عرضها على الصفحة الرئيسية حتى يتسنى للمستفيد طلبها."),
            _buildStepPoint(4, "يتم تسليم الوجبة من خلال الجهة المانحة."),

            // قسم: شركاؤنا
            _buildSectionHeader(Icons.handshake_outlined, "شركاؤنا"),
            Row(
              children: [
                _buildPartnerChip("المطاعم"),
                const SizedBox(width: 10),
                _buildPartnerChip("الجمعيات الخيرية"),
              ],
            ),

            const SizedBox(height: 50),
            // تذييل الصفحة
            const Center(
              child: Text(
                "نشامى جو © 2026 - كرم ونخوة",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // --- دوال بناء العناصر المخصصة لتجنب التكرار ولترتيب الشكل ---

  Widget _buildSectionHeader(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: jordanianRed, size: 24),
          const SizedBox(width: 10),
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionBody(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.6, fontFamily: 'Tahoma'),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, right: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("• ", style: TextStyle(color: jordanianRed, fontWeight: FontWeight.bold, fontSize: 18)),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black54, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepPoint(int step, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(color: jordanianRed, shape: BoxShape.circle),
            child: Center(
              child: Text(
                step.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: const BorderSide(color: Colors.grey, width: 0.5),
      labelStyle: const TextStyle(color: Colors.black87, fontSize: 12),
    );
  }
}