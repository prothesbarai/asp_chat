import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class PremiumPeriodTrackerPage extends StatefulWidget {
  const PremiumPeriodTrackerPage({super.key});

  @override
  State<PremiumPeriodTrackerPage> createState() =>
      _PremiumPeriodTrackerPageState();
}

class _PremiumPeriodTrackerPageState extends State<PremiumPeriodTrackerPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? lastPeriodDate;

  int cycleLength = 28;
  int periodLength = 5;

  List<DateTime> predictedRange = [];

  double painLevel = 2;
  String selectedMood = '😊';
  final moods = ['😊', '😐', '😢', '😡', '🥱'];

  bool isSameMonth(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month;

  List<DateTime> calculatePredictionRange(DateTime lastDate) {
    final base = lastDate.add(Duration(days: cycleLength));
    return List.generate(
      periodLength + 4, // ±2 days
          (i) => base.add(Duration(days: i - 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF4F8),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Period Tracker',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _cycleOverviewCard(),
            const SizedBox(height: 16),
            _calendarCard(),
            const SizedBox(height: 16),
            _periodLengthCard(),
            const SizedBox(height: 16),
            _todayLogCard(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // 🌸 TOP CARD
  Widget _cycleOverviewCard() {
    String subtitle = 'আপনার present Period তারিখ নির্বাচন করুন';

    if (lastPeriodDate != null) {
      final next = lastPeriodDate!.add(Duration(days: cycleLength));
      subtitle =
      'সম্ভাব্য পরবর্তী Period: ${next.day}/${next.month}/${next.year}';
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: const LinearGradient(
          colors: [Color(0xFFFF7AA2), Color(0xFFFFB3C6)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Cycle Overview',
              style: TextStyle(color: Colors.white70)),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // 📅 CALENDAR
  Widget _calendarCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: TableCalendar(
        firstDay: DateTime.utc(2018, 1, 1),
        lastDay: DateTime.now(),
        focusedDay: _focusedDay,

        selectedDayPredicate: (day) =>
        lastPeriodDate != null && isSameDay(day, lastPeriodDate),

        enabledDayPredicate: (day) => !day.isAfter(DateTime.now()),

        onDaySelected: (selectedDay, focusedDay) {
          setState(() {
            lastPeriodDate = selectedDay;
            _focusedDay = focusedDay;
            predictedRange = calculatePredictionRange(selectedDay);
          });
        },

        calendarBuilders: CalendarBuilders(
          defaultBuilder: (context, day, focusedDay) {
            if (predictedRange.any((d) => isSameDay(d, day))) {
              return Container(
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.pink.shade100,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('${day.day}',style: TextStyle(color: Colors.black),),
              );
            }
            return null;
          },
        ),

        calendarStyle: const CalendarStyle(
          todayDecoration: BoxDecoration(
            color: Color(0xFFFF7AA2),
            shape: BoxShape.circle,
          ),
          selectedDecoration: BoxDecoration(
            color: Color(0xFFFF4D6D),
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  // ⏱ PERIOD LENGTH
  Widget _periodLengthCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'এই মাসে কয়দিন Period হয়েছে?',
            style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
          ),
          Slider(
            value: periodLength.toDouble(),
            min: 3,
            max: 7,
            divisions: 4,
            label: '$periodLength দিন',
            activeColor: const Color(0xFFFF4D6D),
            onChanged: (v) {
              setState(() {
                periodLength = v.toInt();
                if (lastPeriodDate != null) {
                  predictedRange =
                      calculatePredictionRange(lastPeriodDate!);
                }
              });
            },
          ),
        ],
      ),
    );
  }

  // 😊 MOOD + PAIN
  Widget _todayLogCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('আজ কেমন অনুভব করছেন?',
              style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
          const SizedBox(height: 10),
          Row(
            children: moods.map((mood) {
              return GestureDetector(
                onTap: () => setState(() => selectedMood = mood),
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selectedMood == mood
                        ? const Color(0xFFFF7AA2)
                        : Colors.grey.shade200,
                  ),
                  child: Text(mood, style: const TextStyle(fontSize: 20)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          const Text('Pain Level'),
          Slider(
            value: painLevel,
            min: 0,
            max: 5,
            divisions: 5,
            activeColor: const Color(0xFFFF4D6D),
            onChanged: (v) => setState(() => painLevel = v),
          ),
        ],
      ),
    );
  }


}
