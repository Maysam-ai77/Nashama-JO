class Donation {
  final String id;
  final String title;
  final String category;
  final String quantity;
  final String unit;
  final String expiryTime;
  String status;
  bool isPending;
  String? charityName; // اسم الجهة أو الشخص
  String? receiverType; // نوع المستلم: "جمعية" أو "مواطن"
  String? receiverSerialNumber; // الرقم التسلسلي للمستلم

  Donation({
    required this.id,
    required this.title,
    required this.category,
    required this.quantity,
    required this.unit,
    required this.expiryTime,
    this.status = "متاح للطلب",
    this.isPending = false,
    this.charityName,
    this.receiverType,
    this.receiverSerialNumber,
  });
}