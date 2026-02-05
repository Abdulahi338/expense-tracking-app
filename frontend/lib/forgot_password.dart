import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'app_routes.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isLoading = false;

  Future<void> _sendResetLink() async {
    final email = _emailController.text;
    if (email.isEmpty) {
      Get.snackbar("Error", "Please enter your email", snackPosition: SnackPosition.BOTTOM);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/forgot-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        final code = data['code'];
        if (mounted) {
           // Simulate a push notification on the device
           Get.snackbar(
             "Verification Code", 
             "Code: $code (Sent to your device)",
             duration: const Duration(seconds: 10),
             backgroundColor: Colors.blue.shade800,
             colorText: Colors.white,
             snackPosition: SnackPosition.TOP,
             mainButton: TextButton(onPressed: () {}, child: const Text("COPY", style: TextStyle(color: Colors.white))),
           );
          
          Get.toNamed(AppRoutes.otpVerification, arguments: email);
        }
      } else {
        Get.snackbar("Error", data['message'] ?? "Error occurred", snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      Get.snackbar("Error", "Error: ${e.toString()}", snackPosition: SnackPosition.BOTTOM);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView( // Changed to ScrollView to avoid overflow
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // 1. Background Circle (Top Left)
              Positioned(
                top: -80,
                left: -80,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: const BoxDecoration(
                     color: Color(0xFFE3F2FD), // Light blue circle matching design
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // 2. Back Button
              Positioned(
                top: 60,
                left: 20,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blue, width: 1.5),
                    ),
                    child: const Icon(Icons.arrow_back_ios_new, size: 20, color: Colors.blue),
                  ),
                ),
              ),

              // 3. Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    const Spacer(flex: 2), // Push content down
                    
                    // Title Aligned Left
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Forgot your\nPassword",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                    
                    const Spacer(flex: 1), // Space between title and fields

                    // Email Field
                    TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Enter your Email/Number",
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: const BorderSide(color: Colors.blue),
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Next Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _sendResetLink,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF75B6FF), // Matching the lighter blue in design
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Next",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700, // Bold text
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const Spacer(flex: 4), // Bottom spacing
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
