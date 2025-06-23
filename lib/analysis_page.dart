import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalysisPage extends StatelessWidget {
  final String? userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE5F1E8),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: Colors.black),
        title: Text("Personal Performance", style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('tasks')
            .where('userId', isEqualTo: userId)
            .get(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final tasks = snapshot.data!.docs;
          final total = tasks.length;
          final completed = tasks.where((t) => t['isCompleted'] == true).length;
          final pending = total - completed;
          final completionRate = total > 0 ? ((completed / total) * 100).round() : 0;

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                if (total > 0) ...[
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        centerSpaceRadius: 40,
                        sectionsSpace: 4,
                        sections: [
                          PieChartSectionData(
                            value: completed.toDouble(),
                            color: Colors.green,
                            title: '$completed\nDone',
                            titleStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          PieChartSectionData(
                            value: pending.toDouble(),
                            color: const Color.fromARGB(255, 105, 103, 103),
                            title: '$pending\nPending',
                            titleStyle: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                ],
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    children: [
                      _statCard(Icons.check_circle, 'Completed', completed),
                      _statCard(Icons.access_time, 'Pending', pending),
                      _statCard(Icons.pie_chart, 'Completion', '$completionRate%'),
                      _statCard(Icons.list_alt, 'Total Tasks', total),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _statCard(IconData icon, String label, dynamic value) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 36, color: Colors.blueGrey),
          SizedBox(height: 12),
          Text('$value', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Text(label, style: TextStyle(fontSize: 14, color: Colors.black54)),
        ],
      ),
    );
  }
}
