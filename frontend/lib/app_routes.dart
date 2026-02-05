import 'package:get/get.dart';
import 'welcome.dart';
import 'login.dart';
import 'signup.dart';
import 'forgot_password.dart';
import 'otp_verification.dart';
import 'reset_password.dart';
import 'home.dart';
import 'analysis.dart';
import 'add_transaction.dart';
import 'add_income.dart';

class AppRoutes {
  static const welcome = '/welcome';
  static const login = '/login';
  static const signup = '/signup';
  static const forgotPassword = '/forgot-password';
  static const otpVerification = '/otp-verification';
  static const resetPassword = '/reset-password';
  static const home = '/home';
  static const analysis = '/analysis';
  static const addTransaction = '/add-transaction';
  static const addIncome = '/add-income';

  static final routes = [
    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: signup, page: () => const RegisterScreen()),
    GetPage(name: forgotPassword, page: () => const ForgotPasswordScreen()),
    GetPage(
      name: otpVerification, 
      page: () => OTPVerificationScreen(emailOrPhone: Get.arguments ?? ''),
    ),
    GetPage(
      name: resetPassword, 
      page: () => ResetPasswordScreen(
        email: Get.arguments['email'] ?? '', 
        code: Get.arguments['code'] ?? '',
      ),
    ),
    GetPage(name: home, page: () => const HomeScreen()),
    GetPage(name: analysis, page: () => const AnalysisScreen()),
    GetPage(name: addTransaction, page: () => const AddTransactionScreen()),
    GetPage(name: addIncome, page: () => const AddIncomeScreen()),
  ];
}
