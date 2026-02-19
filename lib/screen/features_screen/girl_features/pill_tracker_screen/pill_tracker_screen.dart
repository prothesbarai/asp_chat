import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../firebase_analytics_service/analytics_service.dart';

class PillTrackerScreen extends StatefulWidget {
  const PillTrackerScreen({super.key});

  @override
  State<PillTrackerScreen> createState() => _PillTrackerScreenState();
}

class _PillTrackerScreenState extends State<PillTrackerScreen> {

  bool isLoading = true;

  // >>>> Store status using STRING date key
  final Map<String, bool> pillStatus = {};


  DateTime get currentDay => DateTime.now();

  // >>> Date key helper
  String _dateKey(DateTime date) => "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

  // >>>  Today status
  bool get isCompletedToday {if (isLoading) return false;return pillStatus[_dateKey(DateTime.now())] == true;}

  /// >>>  Monthly Completed count Here ========================================
  int get completedCount {
    if (isLoading) return 0;
    final now = DateTime.now();
    return pillStatus.entries.where((e) {final parts = e.key.split('-');return e.value == true && int.parse(parts[0]) == now.year && int.parse(parts[1]) == now.month;}).length;
  }
  /// <<<  Monthly Completed count Here ========================================

  /// >>> Monthly missed count Here ============================================
  int get missedCount {
    if (isLoading) return 0;
    final now = DateTime.now();
    return pillStatus.entries.where((e) {
      final parts = e.key.split('-');
      return e.value == false && int.parse(parts[0]) == now.year && int.parse(parts[1]) == now.month;
    }).length;
  }
  /// <<< Monthly missed count Here ============================================

  /// >>> Days in current month Calculation Here ===============================
  int get daysInMonth {
    final firstDay = DateTime(currentDay.year, currentDay.month, 1);
    final nextMonth = DateTime(currentDay.year, currentDay.month + 1, 1);
    return nextMonth.difference(firstDay).inDays;
  }
  /// <<< Days in current month Calculation Here ===============================


  /// >>> Day BG color Calculation Here ========================================
  Color _dayStatusColor(int day) {
    if (isLoading) return Colors.grey.shade300;
    final key = _dateKey(DateTime(currentDay.year, currentDay.month, day),);
    final status = pillStatus[key];
    if (status == true) return Colors.green;
    if (status == false) return Colors.redAccent;
    return Colors.grey.shade300;
  }
  /// <<< Day BG color Calculation Here ========================================


  @override
  void initState() {
    super.initState();
    AnalyticsService.logPageView("pill_tracker_page");
    loadMonthData();
  }

  /// >>> Load month data From Database ========================================
  Future<void> loadMonthData() async {
    setState(() => isLoading = true);
    pillStatus.clear();
    final today = DateTime.now();
    final monthKey = "${today.year}-${today.month.toString().padLeft(2, '0')}";
    final doc = await FirebaseFirestore.instance.collection('pilltracker').doc('pt').collection('months').doc(monthKey).get();
    if (doc.exists) {
      final rawData = doc.data();
      if (rawData != null && rawData['days'] != null) {
        final data = Map<String, dynamic>.from(rawData['days']);
        for (final entry in data.entries) {pillStatus[entry.key] = entry.value as bool;}
      }
    }
    setState(() => isLoading = false);
  }
  /// <<< Load month data From Database ========================================

  /// >>> Database Save Function ===============================================
  Future<void> saveStatus(bool status) async {
    final today = DateTime.now();
    final monthKey = "${today.year}-${today.month.toString().padLeft(2, '0')}";
    final dateKey = _dateKey(today);
    setState(() {pillStatus[dateKey] = status;});
    await FirebaseFirestore.instance.collection('pilltracker').doc('pt').collection('months').doc(monthKey).set({'days': {dateKey: status,}}, SetOptions(merge: true));
  }
  /// <<< Database Save Function ===============================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Pill Tracker")),
      body: Stack(
        children: [

          /// >>> MAIN UI Start Here ===========================================
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                // >>> Today card ==============================================
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), gradient: const LinearGradient(colors: [Color(0xffFFDEE9), Color(0xffB5FFFC)],),),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Today", style: TextStyle(fontWeight: FontWeight.bold,color: isCompletedToday ? Colors.green :Colors.black)),
                      const SizedBox(height: 6),
                      Text(isCompletedToday ? "Routine Completed 🌸" : "Routine Pending", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600,color: isCompletedToday ? Colors.green :Colors.black),),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // <<< Today card ==============================================

                // >>> Complete / Missed Buttons ===============================
                Row(
                  children: [
                    Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.green), onPressed: () => saveStatus(true), child: const Text("Taken"),),),
                    const SizedBox(width: 12),
                    Expanded(child: ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent), onPressed: () => saveStatus(false), child: const Text("Missed"),),),
                  ],
                ),
                const SizedBox(height: 20),
                // <<< Complete / Missed Buttons ===============================

                // >>> Summary Card ============================================
                Row(
                  children: [
                    Expanded(child: _summaryCard(color: Colors.green, title: "Completed", count: completedCount)),
                    const SizedBox(width: 12),
                    Expanded(child: _summaryCard(color: Colors.redAccent, title: "Missed", count: missedCount)),
                  ],
                ),
                const SizedBox(height: 20),
                // <<< Summary Card ============================================

                // >>> Month grid ==============================================
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20),),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(daysInMonth, (index) {
                      final day = index + 1;
                      final color = _dayStatusColor(day);
                      return Container(
                        width: 42,
                        height: 42,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(color: color, shape: BoxShape.circle,),
                        child: Text("$day", style: TextStyle(color: color == Colors.grey.shade300 ? Colors.black54 : Colors.white),),
                      );
                    }),
                  ),
                ),
                SizedBox(height: kBottomNavigationBarHeight,),
                // <<< Month grid ==============================================
              ],
            ),
          ),
          /// <<< MAIN UI End Here =============================================

          /// >>> Loader =======================================================
          if (isLoading)...[
            Center(child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.purple, size: 40,),),
          ]
          /// <<< Loader =======================================================
        ],
      ),
    );
  }

  /// >>>> Complete or Missed Status Card Design Here ==========================
  Widget _summaryCard({required Color color, required String title, required int count}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: color.withValues(alpha: .1), borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          Text("$count", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: color)),
          Text(title, style: TextStyle(color: color)),
        ],
      ),
    );
  }
  /// <<<< Complete or Missed Status Card Design Here ==========================
}
