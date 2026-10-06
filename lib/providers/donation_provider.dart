import 'package:flutter/material.dart';
import '../models/donation_model.dart';

class DonationProvider with ChangeNotifier {
  final List<Donation> _donations = [];

  // جلب قائمة التبرعات كاملة
  List<Donation> get donations => [..._donations];

  // 1. إضافة تبرع جديد (يستدعيها المانح/المطعم)
  void addDonation(Donation donation) {
    _donations.insert(0, donation);
    notifyListeners();
  }

  // إحصائيات ذكية
  int get totalDonationsCount => _donations.length;

  // يعد فقط الوجبات التي تم حجزها ولم تُسلّم بعد
  int get pendingRequestsCount =>
      _donations.where((d) => d.status == "بانتظار الاستلام").length;

  // ==========================================
  // 2. حجز الوجبة (تستدعيها الجمعية/المواطن)
  // ==========================================
  void requestDonation({
    required String donationId,
    required String name,
    required String type,
    required String serial,
  }) {
    final index = _donations.indexWhere((d) => d.id == donationId);
    if (index >= 0) {
      _donations[index].status = "بانتظار الاستلام";
      _donations[index].isPending = true; // تتحول للون البرتقالي عند المانح
      _donations[index].charityName = name;
      _donations[index].receiverType = type;
      _donations[index].receiverSerialNumber = serial;
      notifyListeners();
    }
  }

  // ==========================================
  // 3. إلغاء الحجز (تستدعيها الجمعية إذا تراجعت عن الحجز)
  // ==========================================
  void cancelRequest(String donationId) {
    final index = _donations.indexWhere((d) => d.id == donationId);
    if (index >= 0) {
      _donations[index].status = "متاح للطلب"; // تعود متاحة للجميع
      _donations[index].isPending = false;    // تعود للون الأخضر عند المانح
      _donations[index].charityName = null;   // مسح بيانات المستلم
      _donations[index].receiverType = null;
      _donations[index].receiverSerialNumber = null;
      notifyListeners();
    }
  }

  // ==========================================
  // 4. تأكيد التسليم (يستدعيها المانح عند وصول المندوب)
  // ==========================================
  void confirmDelivery(String donationId) {
    final index = _donations.indexWhere((d) => d.id == donationId);
    if (index >= 0) {
      _donations[index].status = "مكتمل"; // تنتقل تلقائياً لتبويب "السجل"
      _donations[index].isPending = false;
      notifyListeners();
    }
  }

  // ==========================================
  // 5. حذف التبرع نهائياً (يستدعيها المانح للإلغاء قبل الحجز)
  // ==========================================
  void cancelDonation(String donationId) {
    _donations.removeWhere((d) => d.id == donationId);
    notifyListeners();
  }
}