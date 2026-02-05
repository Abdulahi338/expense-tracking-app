import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'login.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String code;

  const ResetPasswordScreen({super.key, required this.email, required this.code});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  Future<void> _resetPassword() async {
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password.isEmpty || confirmPassword.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Passwords do not match")),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/reset-password'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': widget.email,
          'code': widget.code,
          'newPassword': password,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (mounted) {
          _showSuccessDialog();
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? "Failed to reset password")),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Column(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 60),
            SizedBox(height: 10),
            Text("Reset Success!", textAlign: TextAlign.center),
          ],
        ),
        content: const Text(
          "Your password has been changed successfully. You can now login with your new password.",
          textAlign: TextAlign.center,
        ),
        actions: [
          Center(
            child: SizedBox(
              width: 150,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text("Login Now", style: TextStyle(color: Colors.white)),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background Circle
              Positioned(
                top: -80,
                left: -80,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE3F2FD),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // Back Button
              Positioned(
                top: 60,
                left: 20,
                child: GestureDetector(
                  onTap: () => Navigator.pop(context),
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

              // Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    const Spacer(flex: 2),
                    
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Create New\nPassword",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 10),
                    
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Your new password must be different from previous used passwords.",
                        style: TextStyle(color: Colors.grey, fontSize: 14),
                      ),
                    ),

                    const SizedBox(height: 40),

                    // New Password Field
                    _buildPasswordField(
                      controller: _passwordController,
                      hint: "New Password",
                    ),

                    const SizedBox(height: 20),

                    // Confirm Password Field
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      hint: "Confirm New Password",
                    ),

                    const SizedBox(height: 40),

                    // Change Password Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF75B6FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                "Change Password",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const Spacer(flex: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordField({required TextEditingController controller, required String hint}) {
    return TextField(
      controller: controller,
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
    );
  }
}
