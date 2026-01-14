import 'package:asp_chat/helper/date_time_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:table_calendar/table_calendar.dart';

class PeriodTrackerScreen extends StatefulWidget {
  const PeriodTrackerScreen({super.key});

  @override
  State<PeriodTrackerScreen> createState() => _PeriodTrackerScreenState();
}

class _PeriodTrackerScreenState extends State<PeriodTrackerScreen> {

  bool isLoading = true;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _currentDay = DateTime.now();


  DateTime? afterDate;
  DateTime? currentDate;
  DateTime? previousDate;

  String moods = '';
  int cycleLength = 0;
  int periodLength = 0;
  int painLevel = 0;
  String rules1 = '';
  String rules2 = '';
  String rules3 = '';
  String rules4 = '';
  String rules5 = '';
  String rules6 = '';
  String rules7 = '';
  String rules8 = '';
  String rules9 = '';



  @override
  void initState() {
    super.initState();
    fetchPeriodData();
  }


  /// >>>> Fetch Data And Set Initialization ===================================
  Future<void> fetchPeriodData() async {
    try{
      final doc = await FirebaseFirestore.instance.collection('periodtracker').doc('pt').get();
      if (doc.exists) {
        final data = doc.data()!;
        final periodInfo = data['periodinfo'] as Map<String, dynamic>?;
        setState(() {
          afterDate = (data['afterdate'] as Timestamp?)?.toDate();
          currentDate = (data['currentdate'] as Timestamp?)?.toDate();
          previousDate = (data['previousdate'] as Timestamp?)?.toDate();
          moods = data['moods'] ?? '';
          cycleLength = data['cyclelength'] ?? 0;
          periodLength = data['periodlength'] ?? 0;
          painLevel = data['painlevel'] ?? 0;
          rules1 = periodInfo?['rules_1'] ?? '';
          rules2 = periodInfo?['rules_2'] ?? '';
          rules3 = periodInfo?['rules_3'] ?? '';
          rules4 = periodInfo?['rules_4'] ?? '';
          rules5 = periodInfo?['rules_5'] ?? '';
          rules6 = periodInfo?['rules_6'] ?? '';
          rules7 = periodInfo?['rules_7'] ?? '';
          rules8 = periodInfo?['rules_8'] ?? '';
          rules9 = periodInfo?['rules_9'] ?? '';
          isLoading = false;
        });
      }
    }catch(e){
      debugPrint(e.toString());
      isLoading = false;
    }
  }
  /// <<<< Fetch Data And Set Initialization ===================================


  /// >>>> Update Button Logic Here ============================================
  Future<void> updateInformation() async {
    try {
      setState(() {
        isLoading = true;
      });

      // >>> First get the previous information from Firebase
      final docRef = FirebaseFirestore.instance.collection('periodtracker').doc('pt');
      final doc = await docRef.get();
      if (!doc.exists) return;

      final data = doc.data()!;
      final Timestamp? fbCurrentDate = data['currentdate'] as Timestamp?;
      final int fbCycleLength = data['cyclelength'] ?? 30;

      // >>> Convert DateTime
      final DateTime currentFbDate = fbCurrentDate?.toDate() ?? DateTime.now();
      // >>> New Current Date
      final DateTime newCurrentDate = _currentDay;


      // >>> Check if current month is already updated
      if (currentFbDate.year == newCurrentDate.year && currentFbDate.month == newCurrentDate.month) {
        if(!mounted) return;
        setState(() {isLoading = false;});
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Already Date Update for this month, So Skip Date Update")),);
        return;
      }
      // >>> Update Previous Date
      final DateTime newPreviousDate = currentFbDate;
      // >>> Calculate After Date
      final DateTime newAfterDate = newCurrentDate.add(Duration(days: fbCycleLength));
      // >>> Update Firebase
      await docRef.update({
        'previousdate': Timestamp.fromDate(newPreviousDate),
        'currentdate': Timestamp.fromDate(newCurrentDate),
        'afterdate': Timestamp.fromDate(newAfterDate),
      });
      // >>> Local state update
      setState(() {
        previousDate = newPreviousDate;
        currentDate = newCurrentDate;
        afterDate = newAfterDate;
        isLoading = false;
      });
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Dates updated successfully")),);
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      debugPrint(e.toString());
    }
  }
  /// <<<< Update Button Logic Here ============================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Period Tracker")),
      body: Stack(
        children: [
          /// >>> UI Data Here =================================================
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            physics: BouncingScrollPhysics(),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _cycleOverviewCard(),
                  const SizedBox(height: 16),
                  _calendarCard(),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: (){
                        showDialog(
                          context: context, 
                          builder: (context) => AlertDialog(
                            title: Text("Alert!",style: TextStyle(color:Theme.of(context).colorScheme.onSurface),),
                            content: Text("Are you sure update date ?",style: TextStyle(color:Theme.of(context).colorScheme.onSurface),),
                            actions: [
                              ElevatedButton(onPressed: (){Navigator.pop(context);updateInformation();}, child: Text("OK"))
                            ],
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(),
                      child: Text("Update All")
                    ),
                  )
                ],
              ),
            ),
          ),
          /// <<< UI Data Here =================================================


          /// >>> Set Loader  ==================================================
          if(isLoading)...[
            Center(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.purple.shade700, Colors.blue.shade700], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), offset: const Offset(0, 8), blurRadius: 20), BoxShadow(color: Colors.purple.withValues(alpha: 0.5), offset: const Offset(0, 4), blurRadius: 10),],
                ),
                padding: const EdgeInsets.all(25),
                child: SizedBox(width: 36, height: 36, child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 36,),),
              ),
            ),
          ]
          /// <<< Set Loader  ==================================================
        ],
      ),
    );
  }

  /// >>> TOP CARD DESIGN HERE =================================================
  Widget _cycleOverviewCard() {
    if (previousDate == null || currentDate == null || afterDate == null) {return const SizedBox();}
    return Container(
      width: MediaQuery.of(context).size.width * 1,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), gradient: const LinearGradient(colors: [Color(0xFFFF7AA2), Color(0xFFFFB3C6)],),),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Period Cycle Overview', style: TextStyle(color: Colors.white54,fontSize: 20, fontWeight: FontWeight.bold,)),
          const SizedBox(height: 16),
          Text("Last Month Date : ${DateTimeHelper.formatDateOnly(previousDate!)}", style: const TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500),),
          const SizedBox(height: 8),
          Text("Current Month Date : ${DateTimeHelper.formatDateOnly(currentDate!)}", style: const TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500),),
          const SizedBox(height: 8),
          Text("After Month Date : ${DateTimeHelper.formatDateOnly(afterDate!)}", style: const TextStyle(color: Colors.white70,fontSize: 15,fontWeight: FontWeight.w500),),
        ],
      ),
    );
  }
  /// <<< TOP CARD DESIGN HERE =================================================


  /// >>> CALENDAR DESIGN AND SELECT DATE HERE =================================
  Widget _calendarCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Theme.of(context).colorScheme.surface, borderRadius: BorderRadius.circular(24),),
      child: TableCalendar(
        firstDay: DateTime.utc(2010, 1, 23),
        lastDay: DateTime.utc(2130, 1, 23),
        focusedDay: _currentDay,
        // >>> Month / Week header style
        headerStyle: HeaderStyle(
          titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600,),
          formatButtonTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w500,),
          leftChevronIcon: Icon(Icons.chevron_left, color: Theme.of(context).colorScheme.onSurface),
          rightChevronIcon: Icon(Icons.chevron_right, color: Theme.of(context).colorScheme.onSurface),
        ),
        // >>>  Sun, Mon, Tue text color
        daysOfWeekStyle: DaysOfWeekStyle(
          weekdayStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          weekendStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
        ),
        // >>> Calendar date numbers
        calendarStyle: CalendarStyle(
          defaultTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          weekendTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface),
          outsideTextStyle: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.20)),
          selectedTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          todayTextStyle: TextStyle(color: Theme.of(context).secondaryHeaderColor),
          selectedDecoration: BoxDecoration(color: Colors.purple, shape: BoxShape.circle,),
          todayDecoration: BoxDecoration(color: Theme.of(context).primaryColor, shape: BoxShape.circle,),
        ),
        calendarFormat: _calendarFormat,
        onFormatChanged: (format) {setState(() {_calendarFormat = format;});},
        selectedDayPredicate: (day) {return isSameDay(_currentDay, day);},
        onDaySelected: (selectedDay, focusedDay) {setState(() {_currentDay = selectedDay;});},
      ),
    );

  }
  /// <<< CALENDAR DESIGN AND SELECT DATE HERE =================================
}
