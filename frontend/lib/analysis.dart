import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AnalysisScreen extends StatefulWidget {
  const AnalysisScreen({super.key});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  String selectedPeriod = "Month";
  final List<String> periods = ["Daily", "Month", "Year"];

  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  String username = "User";
  
  bool isLoading = true;
  double totalIncome = 0;
  double totalExpense = 0;
  List<dynamic> topCategories = [];
  List<FlSpot> chartSpots = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadUsername();
    await _fetchAnalysis();
  }

  Future<void> _loadUsername() async {
    try {
      final storedName = await _storage.read(key: 'username');
      if (storedName != null && storedName.trim().isNotEmpty) {
        setState(() {
          username = storedName.trim();
        });
      }
    } catch (_) {
      setState(() {
        username = "User";
      });
    }
  }

  Future<void> _fetchAnalysis() async {
    setState(() => isLoading = true);
    try {
      final token = await _storage.read(key: 'token');
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/reports/analysis?period=$selectedPeriod'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        
        // Process Chart Data
        List<dynamic> rawChart = data['chartData'];
        List<FlSpot> spots = [];
        for (int i = 0; i < rawChart.length; i++) {
          // Simplified: using index as X, amount as Y
          // In a better version, X would be day of month or similar
          spots.add(FlSpot(i.toDouble() + 1, (rawChart[i]['amount'] as num).toDouble()));
        }

        // If no data, add dummy spot to prevent crash
        if (spots.isEmpty) spots.add(const FlSpot(0, 0));

        setState(() {
          totalIncome = (data['totalIncome'] as num).toDouble();
          totalExpense = (data['totalExpense'] as num).toDouble();
          topCategories = data['topCategories'];
          chartSpots = spots;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching analysis: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final initials = username.length >= 2
        ? username.substring(0, 2).toUpperCase()
        : username.toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _fetchAnalysis,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 25,
                          backgroundColor: Colors.blue.shade100,
                          child: Text(
                            initials,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Hello, $username!",
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black54,
                              ),
                            ),
                            const Text(
                              "Track your income and expense",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    // Period Selector
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: periods.map((p) {
                          final isSelected = p == selectedPeriod;
                          return Expanded(
                            child: GestureDetector(
                              onTap: () {
                                setState(() => selectedPeriod = p);
                                _fetchAnalysis();
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? Colors.blue.shade400
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Text(
                                  p,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color:
                                        isSelected ? Colors.white : Colors.black54,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Chart Container
                    SizedBox(
                      height: 200,
                      child: LineChart(
                        LineChartData(
                          gridData: const FlGridData(show: false),
                          titlesData: FlTitlesData(
                            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      value.toInt().toString(),
                                      style: const TextStyle(color: Colors.blue, fontSize: 10),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: chartSpots,
                              isCurved: true,
                              color: Colors.blue.shade300,
                              barWidth: 3,
                              dotData: const FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.blue.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    // Top Categories Header
                    const Text(
                      "Top Categories",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Categories List
                    if (topCategories.isEmpty)
                       const Center(child: Text("No data for this period", style: TextStyle(color: Colors.grey)))
                    else
                      ...topCategories.map((cat) {
                         return _buildCategoryItem(
                          cat['name'],
                          "${(cat['percentage'] * 100).toStringAsFixed(1)}% of Total",
                          _getCategoryColor(cat['name']),
                          _getCategoryIcon(cat['name']),
                          (cat['percentage'] as num).toDouble(),
                          (cat['amount'] as num).toDouble(),
                        );
                      }).toList(),
                  ],
                ),
              ),
            ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Colors.orange;
      case 'transport': return Colors.blue;
      case 'salary': return Colors.green;
      case 'rent': return Colors.purple;
      case 'shopping': return Colors.pink;
      case 'entertainment': return Colors.red;
      case 'health': return Colors.teal;
      default: return Colors.blueGrey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'food': return Icons.restaurant;
      case 'transport': return Icons.directions_bus;
      case 'salary': return Icons.attach_money;
      case 'rent': return Icons.home;
      case 'shopping': return Icons.shopping_bag;
      case 'entertainment': return Icons.movie;
      case 'health': return Icons.medical_services;
      default: return Icons.category;
    }
  }

  Widget _buildCategoryItem(
    String title,
    String subtitle,
    Color color,
    IconData icon,
    double progress,
    double amount,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withOpacity(0.3)),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
             crossAxisAlignment: CrossAxisAlignment.end,
             children: [
                Text("\$${amount.toStringAsFixed(2)}", style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                SizedBox(
                  width: 40,
                  height: 4,
                  child: LinearProgressIndicator(
                    value: progress,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
             ],
          ),
        ],
      ),
    );
  }
}
