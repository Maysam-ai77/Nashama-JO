import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // 1. استدعاء البروفايدر
import '../constants.dart';
import '../providers/donation_provider.dart'; // 2. استدعاء مخزن البيانات
import '../models/donation_model.dart'; // 3. استدعاء نموذج البيانات

class AddDonationScreen extends StatefulWidget {
  const AddDonationScreen({super.key});

  @override
  State<AddDonationScreen> createState() => _AddDonationScreenState();
}

class _AddDonationScreenState extends State<AddDonationScreen> {
  final _formKey = GlobalKey<FormState>();

  String? _selectedCategory;
  String? _selectedQuantity;
  String? _selectedUnit;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  bool _isLoading = false;

  final List<String> _categories = [
    'وجبات مطبوخة جاهزة',
    'مخبوزات ومعجنات',
    'مواد تموينية (معلبات)',
    'خضار وفواكه طازجة'
  ];

  final List<String> _quantities = List.generate(50, (index) => (index + 1).toString());

  final List<String> _units = [
    'وجبة',
    'كيلو',
    'صندوق',
    'قطعة',
    'لتر'
  ];

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: jordanianRed,
            colorScheme: const ColorScheme.light(primary: jordanianRed),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  // ==========================================
  // دالة النشر المحدثة (الربط مع الـ Logic)
  // ==========================================
  Future<void> _submitDonation() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // محاكاة رفع البيانات (ثانيتين)
      await Future.delayed(const Duration(seconds: 2));

      if (mounted) {
        // --- الجزء السحري: إرسال البيانات للمخزن المركزي ---
        final donationProvider = Provider.of<DonationProvider>(context, listen: false);

        donationProvider.addDonation(
          Donation(
            id: DateTime.now().toString(), // معرف فريد بناءً على الوقت
            title: _descriptionController.text,
            category: _selectedCategory!,
            quantity: _selectedQuantity!,
            unit: _selectedUnit!,
            expiryTime: _timeController.text,
          ),
        );
        // ------------------------------------------------

        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('تم نشر تبرعك بنجاح، شكراً لك يا نشمي!', style: TextStyle(fontFamily: 'Tahoma')),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
          ),
        );

        // العودة للشاشة الرئيسية (التي ستحدث نفسها تلقائياً الآن)
        Navigator.pop(context);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('يرجى تعبئة جميع الحقول المطلوبة قبل التأكيد'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  @override
  void dispose() {
    _timeController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightBackground,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: const Text("إضافة فائض طعام", style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePickerPlaceholder(),
              const SizedBox(height: 30),

              _buildLabel("نوع الطعام"),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: const Text("اختر نوع الطعام"),
                decoration: _buildInputDecoration(Icons.category_outlined),
                items: _categories.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                onChanged: (val) => setState(() => _selectedCategory = val),
                validator: (val) => val == null ? "هذا الحقل مطلوب" : null,
              ),
              const SizedBox(height: 20),

              _buildLabel("وصف الطعام"),
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: _buildInputDecoration(Icons.description_outlined).copyWith(
                  hintText: 'مثال: وجبات أرز مع دجاج مشوي، صالحة للاستهلاك الفوري...',
                ),
                validator: (val) => val!.isEmpty ? "يرجى كتابة وصف بسيط" : null,
              ),
              const SizedBox(height: 20),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("الكمية"),
                        DropdownButtonFormField<String>(
                          value: _selectedQuantity,
                          hint: const Text("الكمية"),
                          decoration: _buildInputDecoration(Icons.numbers),
                          items: _quantities.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _selectedQuantity = val),
                          validator: (val) => val == null ? "مطلوب" : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel("الوحدة"),
                        DropdownButtonFormField<String>(
                          value: _selectedUnit,
                          hint: const Text("الوحدة"),
                          decoration: _buildInputDecoration(Icons.ad_units),
                          items: _units.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                          onChanged: (val) => setState(() => _selectedUnit = val),
                          validator: (val) => val == null ? "مطلوب" : null,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              _buildLabel("آخر وقت متاح للإستلام"),
              TextFormField(
                controller: _timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: _buildInputDecoration(Icons.access_time),
                validator: (val) => val!.isEmpty ? "يرجى اختيار الوقت" : null,
              ),
              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitDonation,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: jordanianRed,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('تأكيد التبرع', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black87)),
    );
  }

  InputDecoration _buildInputDecoration(IconData icon) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200)),
      errorStyle: const TextStyle(fontSize: 12),
    );
  }

  Widget _buildImagePickerPlaceholder() {
    return Container(
      width: double.infinity,
      height: 150,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade300)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add_a_photo_outlined, size: 40, color: Colors.grey.shade400),
          const SizedBox(height: 8),
          const Text("إضافة صورة للطعام (اختياري)", style: TextStyle(color: Colors.grey, fontSize: 14)),
        ],
      ),
    );
  }
}