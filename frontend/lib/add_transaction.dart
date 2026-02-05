import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'home.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _storage = const FlutterSecureStorage();
  // 0 = Expense, 1 = Income
  int _selectedTab = 0;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String? _selectedCategory;
  String? _selectedPaymentMethod;
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  final List<String> _expenseCategories = [
    "Food",
    "Transport",
    "Rent",
    "Shopping",
    "Entertainment",
    "Health",
    "Other"
  ];

  final List<String> _incomeCategories = [
    "Salary",
    "Business",
    "Gift",
    "Investment",
    "Freelance",
    "Other"
  ];

  final List<String> _paymentMethods = [
    "Cash",
    "Card",
    "Bank Transfer",
    "Mobile Money"
  ];

  // 🔴 CHANGE BASE URL IF NEEDED
  // Android emulator → http://10.0.2.2:5000
  // Web → http://localhost:5000
  final String baseUrl = "http://localhost:5000";

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveTransaction() async {
    if (_amountController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedPaymentMethod == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all required fields" , style: TextStyle(color: Colors.red),)),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final token = await _storage.read(key: 'token');
      final isExpense = _selectedTab == 0;

      final endpoint = isExpense ? "/api/expenses/add-expense" : "/api/incomes/add-income";

      final body = {
        "title": _selectedCategory!, // Use category as title since field is removed
        "amount": double.parse(_amountController.text),
        "category": _selectedCategory,
        "paymentMethod": _selectedPaymentMethod,
        "date": _selectedDate.toIso8601String(),
        "description": _descriptionController.text,
      };

      final response = await http.post(
        Uri.parse("$baseUrl$endpoint"),
        headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token"
        },
        body: jsonEncode(body),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              isExpense
                  ? "Expense added successfully"
                  : "Income added successfully",
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomeScreen()),
        );
      } else {
        // Try to parse error message from backend
        String errorMessage = "Failed to save transaction";
        try {
          final decoded = jsonDecode(response.body);
          if (decoded['message'] != null) {
            errorMessage = decoded['message'];
          }
        } catch (_) {}
        
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error: ${e.toString()}", style: const TextStyle(color: Colors.white)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Transaction"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Toggle
            Row(
              children: [
                _buildToggleBtn("Expense", 0),
                _buildToggleBtn("Income", 1),
              ],
            ),

            const SizedBox(height: 30),

            _buildFieldContainer(
              child: TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: "Amount",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildFieldContainer(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Category"),
                  value: _selectedCategory,
                  items: (_selectedTab == 0
                          ? _expenseCategories
                          : _incomeCategories)
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedCategory = val),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildFieldContainer(
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  hint: const Text("Payment Method"),
                  value: _selectedPaymentMethod,
                  items: _paymentMethods
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text(e),
                          ))
                      .toList(),
                  onChanged: (val) =>
                      setState(() => _selectedPaymentMethod = val),
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildFieldContainer(
              child: InkWell(
                onTap: _pickDate,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                        "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                    const Icon(Icons.calendar_today),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            _buildFieldContainer(
              child: TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: "Description",
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 40),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveTransaction,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Helper Widgets ----------

  Widget _buildToggleBtn(String title, int index) {
    final selected = _selectedTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedTab = index;
            _selectedCategory = null; // Reset category to avoid dropdown crash
          });
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(25),
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: selected ? Colors.white : Colors.black54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: child,
    );
  }
}
