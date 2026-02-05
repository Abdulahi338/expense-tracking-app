import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'app_routes.dart';

class AddIncomeScreen extends StatefulWidget {
  const AddIncomeScreen({super.key});

  @override
  State<AddIncomeScreen> createState() => _AddIncomeScreenState();
}

class _AddIncomeScreenState extends State<AddIncomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _storage = const FlutterSecureStorage();

  final TextEditingController amountController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String? selectedSource;
  String? selectedPaymentMethod;

  final List<String> sources = ["Salary", "Business", "Gift"];
  final List<String> paymentMethods = ["Cash", "Bank", "Mobile Money"];

  /// DATE PICKER 
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  bool _isLoading = false;

  Future<void> saveForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      
      try {
        final token = await _storage.read(key: 'token');
        final url = Uri.parse('http://localhost:5000/api/incomes/add-income');
        
        final body = {
            "title": selectedSource, // Default title to source
            "amount": double.parse(amountController.text),
            "category": selectedSource,
            "description": descriptionController.text,
            "date": DateTime.parse(dateController.text).toIso8601String(),
        };

        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(body),
        );

        if (response.statusCode == 200 || response.statusCode == 201) {
          Get.snackbar(
            "Success",
            "Income Added Successfully ✅",
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
            snackPosition: SnackPosition.BOTTOM,
          );
          Get.offNamed(AppRoutes.home);
        } else {
             Get.snackbar(
               "Error",
               "Failed to save income",
               backgroundColor: Colors.red.withOpacity(0.1),
               colorText: Colors.red,
               snackPosition: SnackPosition.BOTTOM,
             );
        }
      } catch (e) {
          Get.snackbar(
            "Error",
            "Error: $e",
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
            snackPosition: SnackPosition.BOTTOM,
          );
      } finally {
        if(mounted) setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  const Text(
                    "Create New Income",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE9F4FF),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _label("Amount"),
                          _textField(
                            controller: amountController,
                            hint: "Enter amount",
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return "Amount is required";
                              }
                              if (double.tryParse(v) == null) {
                                return "Enter valid number";
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 14),

                          _label("Source"),
                          _dropdown(
                            value: selectedSource,
                            items: sources,
                            onChanged: (v) =>
                                setState(() => selectedSource = v),
                            validator: (v) =>
                                v == null ? "Source is required" : null,
                          ),

                          const SizedBox(height: 14),

                          _label("Date"),
                          TextFormField(
                            controller: dateController,
                            readOnly: true,
                            onTap: pickDate,
                            decoration: _inputDecoration(
                              hint: "Select date",
                              icon: Icons.calendar_month,
                            ),
                            validator: (v) =>
                                v == null || v.isEmpty ? "Date required" : null,
                          ),

                          const SizedBox(height: 14),

                          _label("Payment Method"),
                          _dropdown(
                            value: selectedPaymentMethod,
                            items: paymentMethods,
                            onChanged: (v) => setState(
                                () => selectedPaymentMethod = v),
                            validator: (v) => v == null
                                ? "Payment method required"
                                : null,
                          ),

                          const SizedBox(height: 14),

                          _label("Description"),
                          _textField(
                            controller: descriptionController,
                            hint: "Optional",
                            maxLines: 3,
                          ),

                          const SizedBox(height: 24),

                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                    const Color(0xFF8EC3FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                              onPressed: _isLoading ? null : saveForm,
                              child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text(
                                "Save",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// ===== REUSABLE WIDGETS =====

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(
          text,
          style:
              const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
        ),
      );

  Widget _textField({
    required TextEditingController controller,
    String? hint,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      decoration: _inputDecoration(hint: hint),
    );
  }

  Widget _dropdown({
    required List<String> items,
    required String? value,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map((e) =>
              DropdownMenuItem(value: e, child: Text(e)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
      decoration: _inputDecoration(hint: "Select"),
    );
  }

  InputDecoration _inputDecoration({String? hint, IconData? icon}) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      suffixIcon:
          icon != null ? Icon(icon, color: Colors.blue) : null,
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
    );
  }
}
