 import 'package:flutter/material.dart';
import 'dart:convert';

class ExpenseTrackingSystem extends StatelessWidget {
  const ExpenseTrackingSystem({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Sans-Serif',
        scaffoldBackgroundColor: const Color(0xFFF8F9FE),
      ),
      home: RegisterScreen(),
    );
  }
}

// --- REGISTER SCREEN (Task #2 - Part A) ---
class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  bool _isLoading = false;

  // Simulated registration function — no external `http` package required.
  Future<void> registerUser() async {
    setState(() => _isLoading = true);
    try {
      // Simple client-side validation
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Fadlan buuxi dhammaan meelaha looga baahan yahay."),
          ),
        );
        return;
      }

      // Simulate network latency — replace with real request when needed
      await Future.delayed(Duration(seconds: 2));

      // Demo: consider registration successful
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Dhibaato ayaa ka dhacday. Isku day mar kale.")),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              // Background Circles (Sida sawirka ku cad)
              Positioned(
                top: -120,
                left: -60,
                child: CircleAvatar(
                  radius: 150,
                  backgroundColor: Colors.blue[50],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Create an account",
                      style: TextStyle(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey),
                        ),
                        Text(
                          "Login",
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 48),
                    _buildTextField(
                      _nameController,
                      "Name",
                      Icons.person_outline,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      _emailController,
                      "Email/Phone",
                      Icons.email_outlined,
                    ),
                    SizedBox(height: 20),
                    _buildTextField(
                      _passController,
                      "Password",
                      Icons.lock_outline,
                      isPass: true,
                    ),
                    SizedBox(height: 40),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : registerUser,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF4DA6FF),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 18),
                          elevation: 6,
                        ),
                        child: _isLoading
                            ? SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                "Sign up",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String hint,
    IconData icon, {
    bool isPass = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPass,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: Icon(icon, color: Colors.black54),
        filled: true,
        fillColor: Colors.white,
        contentPadding: EdgeInsets.symmetric(vertical: 18),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.grey[200]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(color: Colors.blue[200]!),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
}
