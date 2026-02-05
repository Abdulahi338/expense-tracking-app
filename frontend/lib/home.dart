import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'app_routes.dart';
import 'analysis.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // Pages
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      const HomeContent(),
      const Placeholder(), // Placeholder for center button action if needed
      const AnalysisScreen(),
    ];
  }

  void _onTabTapped(int index) {
    if (index == 1) return; 
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentIndex, 
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add_box, size: 0), label: ""), 
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Analysis"),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.toNamed(AppRoutes.addTransaction),
        backgroundColor: Colors.blue,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  final _storage = const FlutterSecureStorage();
  
  double totalBalance = 0.0;
  double totalIncome = 0.0;
  double totalExpense = 0.0;
  List<dynamic> recentTransactions = [];
  bool isLoading = true;
  String username = "User";

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final storedName = await _storage.read(key: 'username');
      final token = await _storage.read(key: 'token');
      
      if (token == null) {
        // Not logged in, go to login
        Get.offAllNamed(AppRoutes.login);
        return;
      }
      
      if (storedName != null) {
         username = storedName;
      }

      // 1. Fetch Incomes
      // Replace localhost with 10.0.2.2 for Android Emulator if needed
      final incomeRes = await http.get(
        Uri.parse('http://localhost:5000/api/incomes/get-incomes'),
        headers: {'Authorization': 'Bearer $token'},
      );

      // 2. Fetch Expenses
      final expenseRes = await http.get(
        Uri.parse('http://localhost:5000/api/expenses/get-expenses'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (incomeRes.statusCode == 200 && expenseRes.statusCode == 200) {
        final incomes = jsonDecode(incomeRes.body) as List;
        final expenses = jsonDecode(expenseRes.body) as List;

        double tIncome = 0;
        double tExpense = 0;

        // Process Incomes
        List<Map<String, dynamic>> allTrans = [];
        
        for (var item in incomes) {
          tIncome += (item['amount'] as num).toDouble();
          allTrans.add({
            'type': 'Income',
            'title': item['title'],
            'amount': (item['amount'] as num).toDouble(),
            'date': DateTime.parse(item['date']),
            'category': item['category'],
          });
        }

        // Process Expenses
        for (var item in expenses) {
          tExpense += (item['amount'] as num).toDouble();
          allTrans.add({
            'type': 'Expense',
            'title': item['title'],
            'amount': (item['amount'] as num).toDouble(),
            'date': DateTime.parse(item['date']),
            'category': item['category'],
          });
        }

        // Sort by Date Descending
        allTrans.sort((a, b) => b['date'].compareTo(a['date']));

        setState(() {
          totalIncome = tIncome;
          totalExpense = tExpense;
          totalBalance = tIncome - tExpense;
          recentTransactions = allTrans.take(5).toList(); // Show top 5
          isLoading = false;
        });
      } else {
        // Handle error token expired etc
        print("Failed to fetch data");
        setState(() => isLoading = false);
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  Future<void> _logout() async {
    await _storage.delete(key: 'token');
    Get.offAllNamed(AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return isLoading 
          ? const Center(child: CircularProgressIndicator()) 
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.blue.shade100,
                              child: Text(
                                username.length >= 2 
                                  ? username.substring(0, 2).toUpperCase() 
                                  : username.toUpperCase(),
                                style: const TextStyle(
                                  fontSize: 18, 
                                  fontWeight: FontWeight.bold, 
                                  color: Colors.blue
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Hello, $username!", style: const TextStyle(fontSize: 14, color: Colors.black54)),
                                const Text("Track your income and expense", style: TextStyle(fontSize: 12, color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                        IconButton(onPressed: _logout, icon: const Icon(Icons.logout, color: Colors.red)),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Total Balance Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.grey.shade100),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Total Balance", style: TextStyle(color: Colors.grey, fontSize: 14)),
                              const Icon(Icons.more_horiz, color: Colors.blueGrey),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "\$${totalBalance.toStringAsFixed(2)}",
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2C3E50),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Monthly Budget Card (Static UI for now as we don't have budget API)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFBBDEFB), Color(0xFF90CAF9)], // Light Blue Gradient
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Monthly Budget", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 15),
                          Container(
                            height: 10,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: FractionallySizedBox(
                              alignment: Alignment.centerLeft,
                              widthFactor: 0.7, // Static 70%
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent, // Darker blue progress
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("\$${totalExpense.toStringAsFixed(0)} / \$${(totalIncome).toStringAsFixed(0)}", 
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)
                              ), // Showing Expense vs Income as budget proxy
                              const Text("15%", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Recent Transactions
                    const Text("Recent transaction", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 15),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: recentTransactions.length,
                      itemBuilder: (ctx, index) {
                        final tx = recentTransactions[index];
                        final isIncome = tx['type'] == 'Income';
                        return Container(
                          margin: const EdgeInsets.only(bottom: 15),
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(color: Colors.grey.shade100),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5)),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Icon
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: isIncome ? Colors.green.shade50 : Colors.red.shade50,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  isIncome ? Icons.attach_money : Icons.money_off,
                                  color: isIncome ? Colors.green : Colors.red,
                                ),
                              ),
                              const SizedBox(width: 15),
                              // Text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(tx['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                    const SizedBox(height: 5),
                                    Text(
                                      "${tx['date'].day}/${tx['date'].month}/${tx['date'].year}",
                                      style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ),
                              // Amount
                              Text(
                                "${isIncome ? '+' : '-'}\$${tx['amount'].toStringAsFixed(2)}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: isIncome ? Colors.green : Colors.red,
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
          );

  }
}
