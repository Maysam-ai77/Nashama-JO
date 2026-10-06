import 'package:flutter/material.dart';
import '../constants.dart';
import 'login_screen.dart'; // رح نفعله بالدفعة الجاية

class DescriptionScreen extends StatelessWidget {
  final String userType;

  const DescriptionScreen({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    String descriptionTitle = "";
    String descriptionBody = "";
    IconData descriptionIcon = Icons.info_outline;

    if (userType == "الجمعية") {
      descriptionTitle = "دور الجمعيات الخيرية"; descriptionIcon = Icons.business; descriptionBody = "أنتم 'صلة الوصل الكريمة'. دوركم هو استلام الوجبات، التأكد من سلامتها، وتوزيعها بكرامة للأسر المستفيدة المسجلة لديكم، مع ضمان الرقابة العادلة.";
    } else if (userType == "الجهة المانحة") {
      descriptionTitle = "دور الجهة المانحة"; descriptionIcon = Icons.restaurant; descriptionBody = "أنتم 'منبع الكرم الأردني'. سواء كنتم مطعماً، مخبزاً، أو فندقاً، دوركم هو إعداد وجبات فائضة سليمة وقابلة للأكل، وتجهيزها للاستلام.";
    } else if (userType == "الجهة المستفيدة") {
      descriptionTitle = "دور الجهة المستفيدة"; descriptionIcon = Icons.person; descriptionBody = "أنتم 'أهل الكرامة'. هذه الخدمة وجدت لأجلكم. دوركم هو طلب الطعام من الجهة المانحة واستلامه.";
    }

    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('default_logo.png', width: 150, height: 150, fit: BoxFit.contain),
              const SizedBox(height: 30),
              Icon(descriptionIcon, size: 60, color: jordanianRed),
              const SizedBox(height: 20),
              Text(descriptionTitle, textAlign: TextAlign.center, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              Text(descriptionBody, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16, color: Colors.grey, height: 1.6)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen(userType: userType)));
                    print("تم الضغط للانتقال لشاشة تسجيل الدخول");
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: jordanianRed, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), elevation: 0),
                  child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.arrow_back, color: Colors.white, size: 20), SizedBox(width: 8), Text('التالي', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white))]),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}