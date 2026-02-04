import 'package:flutter/material.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String emailOrPhone;
  const OTPVerificationScreen({super.key, required this.emailOrPhone});

  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  // Controllers for 4 digit fields
  final _c1 = TextEditingController();
  final _c2 = TextEditingController();
  final _c3 = TextEditingController();
  final _c4 = TextEditingController();

  // FocusNodes for auto-focus movement
  final _f1 = FocusNode();
  final _f2 = FocusNode();
  final _f3 = FocusNode();
  final _f4 = FocusNode();

  bool _isLoading = false;

  @override
  void dispose() {
    _c1.dispose(); _c2.dispose(); _c3.dispose(); _c4.dispose();
    _f1.dispose(); _f2.dispose(); _f3.dispose(); _f4.dispose();
    super.dispose();
  }

  void _nextField(String value, FocusNode? nextFocus) {
    if (value.length == 1 && nextFocus != null) {
      nextFocus.requestFocus();
    }
  }

  Future<void> _verifyOTP() async {
    String otp = _c1.text + _c2.text + _c3.text + _c4.text;
    if (otp.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter full code")),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    // Simulate API verification
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Code Verified Successfully!")),
      );
      // Logic to navigate to "Reset Password" screen would go here
    }
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
              // 1. Background Circle
              Positioned(
                top: -80,
                left: -80,
                child: Container(
                  width: 320,
                  height: 320,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD), // Light blue circle
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // 2. Back Button
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

              // 3. Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    const Spacer(flex: 2),

                    // Title
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Verify your\nOTP Code",
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                    ),

                    const SizedBox(height: 50),

                    // Subtitle
                    Text(
                      "Enter the verification code we sent on ${widget.emailOrPhone}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),

                    const SizedBox(height: 30),

                    // OTP Fields
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _otpField(_c1, _f1, _f2, "1"),
                        _otpField(_c2, _f2, _f3, "2"),
                        _otpField(_c3, _f3, _f4, "5"),
                        _otpField(_c4, _f4, null, "6"),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Resend Code
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Didn't get the code? ", style: TextStyle(color: Colors.grey)),
                        GestureDetector(
                          onTap: () {
                             ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Code Resent!")),
                            );
                          },
                          child: const Text(
                            "Resend",
                            style: TextStyle(
                              color: Color(0xFF5E35B1), // Deep Purple from design
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 40),

                    // Verify Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _verifyOTP,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF75B6FF), // Blue button
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          elevation: 0,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                        "Verify",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),
                    
                    const Spacer(flex: 3),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpField(TextEditingController controller, FocusNode focusNode, FocusNode? nextFocus, String hint) {
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (val) => _nextField(val, nextFocus),
        maxLength: 1, // Limit to 1 char
        style: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue),
        decoration: InputDecoration(
          counterText: "", // Hide counter
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue.withOpacity(0.3)),
        ),
      ),
    );
  }
}
