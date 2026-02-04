import 'package:flutter/material.dart';
import 'login.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),

              // Title Section
              const Text(
                "Welcome to",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Expense Tracker",
                style: TextStyle(
                  fontSize: 28,
                  color: Color(0xFF2196F3), // Blue color matching design
                  fontWeight: FontWeight.bold,
                ),
              ),

              const Spacer(flex: 1),

              // Illustration
              // Using a placeholder container or a network image for now.
              // Ideally, you should add the asset to pubspec.yaml and use Image.asset
              Container(
                height: 250,
                width: double.infinity,
                decoration: BoxDecoration(
                   // Placeholder color or image
                   color: Colors.blue.shade50,
                   borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.savings_outlined, // Placeholder icon
                  size: 100,
                  color: Colors.blue,
                ),
              ),
              
              const Spacer(flex: 1),

              // Subtitle
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    height: 1.3,
                  ),
                  children: [
                    TextSpan(text: "Master Your\n"),
                    TextSpan(
                      text: "Money Flow",
                      style: TextStyle(color: Color(0xFF2196F3)),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Description
              const Text(
                "Smart tracking for every penny. See where your money goes and watch your savings grow.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  height: 1.5,
                ),
              ),

              const Spacer(flex: 2),

              // Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF64B5F6), // Light blue button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    "Get Started",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}
