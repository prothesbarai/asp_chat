/*
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PillTrackerPage extends StatefulWidget {
  const PillTrackerPage({super.key});

  @override
  State<PillTrackerPage> createState() => _PillTrackerPageState();
}

class _PillTrackerPageState extends State<PillTrackerPage> {
  final DateTime _focusedDay = DateTime.now();


  /// true = taken, false = missed
  final Map<DateTime, bool> pillStatus = {};

  bool get isTakenToday =>
      pillStatus[_normalize(DateTime.now())] == true;

  DateTime _normalize(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  int get takenCount {
    return pillStatus.entries
        .where((e) =>
    e.value == true &&
        e.key.month == _focusedDay.month &&
        e.key.year == _focusedDay.year)
        .length;
  }

  int get missedCount {
    return pillStatus.entries
        .where((e) =>
    e.value == false &&
        e.key.month == _focusedDay.month &&
        e.key.year == _focusedDay.year)
        .length;
  }

  int get daysInMonth {
    final firstDay = DateTime(_focusedDay.year, _focusedDay.month, 1);
    final nextMonth = DateTime(_focusedDay.year, _focusedDay.month + 1, 1);
    return nextMonth.difference(firstDay).inDays;
  }

  Color _dayStatusColor(int day) {
    final date = DateTime(_focusedDay.year, _focusedDay.month, day);
    final status = pillStatus[_normalize(date)];

    if (status == true) return Colors.green;
    if (status == false) return Colors.redAccent;
    return Colors.grey.shade300;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF7F6FB),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Daily Routine Tracker",
          style: GoogleFonts.poppins(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// Today Status Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  colors: [Color(0xffFFDEE9), Color(0xffB5FFFC)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Today",
                      style: GoogleFonts.poppins(
                          fontSize: 14, color: Colors.black54)),
                  const SizedBox(height: 6),
                  Text(
                    isTakenToday
                        ? "Routine Completed 🌸"
                        : "Routine Pending",
                    style: GoogleFonts.poppins(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// Taken / Missed Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      setState(() {
                        pillStatus[_normalize(DateTime.now())] = true;
                      });
                    },
                    child: const Text("Taken"),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    onPressed: () {
                      setState(() {
                        pillStatus[_normalize(DateTime.now())] = false;
                      });
                    },
                    child: const Text("Missed"),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// Monthly Summary
            Row(
              children: [
                Expanded(
                  child: _summaryCard(
                    color: Colors.green,
                    title: "Taken",
                    count: takenCount,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _summaryCard(
                    color: Colors.redAccent,
                    title: "Missed",
                    count: missedCount,
                  ),
                ),
              ],
            ),



            const SizedBox(height: 20),


            const SizedBox(height: 24),

            /// Monthly Day Tracker
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "This Month Overview",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: List.generate(daysInMonth, (index) {
                  final dayNumber = index + 1;
                  final color = _dayStatusColor(dayNumber);

                  return Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      "$dayNumber",
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: color == Colors.grey.shade300
                            ? Colors.black54
                            : Colors.white,
                      ),
                    ),
                  );
                }),
              ),
            ),


            Text(
              "This feature is only for reminder & tracking purpose.",
              style: GoogleFonts.poppins(
                  fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _summaryCard({
    required Color color,
    required String title,
    required int count,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            "$count",
            style: GoogleFonts.poppins(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: color),
          ),
          Text(title,
              style: GoogleFonts.poppins(color: color)),
        ],
      ),
    );
  }

  Widget _dayCircle(int day, Color color) {
    return Container(
      margin: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Text(
        "$day",
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.w600),
      ),
    );
  }
}
*/
