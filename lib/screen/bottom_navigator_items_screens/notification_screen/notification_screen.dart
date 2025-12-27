import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../helper/countdown_helper.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  DateTime? _selectedDateTime;
  bool _isLoading = false;
  late CountdownHelper _countdownHelper;


  String get formattedDateTime {
    if(_isLoading) return "";
    if (_selectedDateTime == null) return "No DateTime selected";
    return "${_selectedDateTime!.day.toString().padLeft(2, '0')}/${_selectedDateTime!.month.toString().padLeft(2, '0')}/${_selectedDateTime!.year} ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}:${_selectedDateTime!.second.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    /// >>> Back Counter Timer Initialize ======================================
    _countdownHelper = CountdownHelper(onTick: () {if (mounted) setState(() {});},);
    /// <<< Back Counter Timer Initialize ======================================
    _loadDateTimeFromFirebase();
  }


  /// >>> Load DateTime From Firebase ==========================================
  Future<void> _loadDateTimeFromFirebase() async {
    setState(() {_isLoading = true;});
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('notification').doc('alerm').get();
      if (doc.exists && doc['datetime'] != null) {
        Timestamp ts = doc['datetime'];
        DateTime firebaseDateTime = ts.toDate();
        if(!mounted) return;
        setState(() {_selectedDateTime = firebaseDateTime;});
        // >>> Compare here Timer Counter ======================================
        _countdownHelper.handle(firebaseDateTime);
        // <<< Compare here Timer Counter ======================================
      }else{
        debugPrint("Firebase Date Time is Empty");
      }
    }catch (e) {
      debugPrint("Error fetching datetime: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }
  /// <<< Load DateTime From Firebase ==========================================


  /// >>> Date Time picker =====================================================
  Future<void> _pickDateTime() async{
    // >>> Date Picker
    DateTime? pickedDate = await showDatePicker(context: context, firstDate: DateTime(2000), lastDate: DateTime(2100),helpText: 'Select a date',);
    if (pickedDate == null || !mounted) return;
    // >>> Time Picker
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null ? TimeOfDay.fromDateTime(_selectedDateTime!) : TimeOfDay.now(),
      helpText: 'Select a time',
    );
    if (pickedTime == null || !mounted) return;
    // >>> DateTime combine
    final DateTime newDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute, DateTime.now().second,);
    if(!mounted) return;
    setState(() {_isLoading = true;_selectedDateTime = newDateTime;});
    await _storeDateTimeToFirebase();
    // >>> Compare here Timer Counter ==========================================
    _countdownHelper.handle(newDateTime);
    // <<< Compare here Timer Counter ==========================================
    if(!mounted) return;
    setState(() {_isLoading = false;});
  }
  /// <<< Date Time picker =====================================================


  /// >>> Set Data Firestore ===================================================
  Future<void> _storeDateTimeToFirebase() async {
    if (_selectedDateTime == null) return;
    await FirebaseFirestore.instance.collection('notification').doc('alerm').set({'datetime': Timestamp.fromDate(_selectedDateTime!),}, SetOptions(merge: true),);
  }
  /// <<< Set Data Firestore ===================================================



  @override
  void dispose() {
    _countdownHelper.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final parts = _countdownHelper.countdownParts;

    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Main Content
            _isLoading ? SizedBox.shrink() : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // Date Selector Card
                GestureDetector(
                  onTap: _pickDateTime,
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [Colors.purpleAccent.shade400, Colors.blueAccent.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                      borderRadius: BorderRadius.circular(35),
                      boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), offset: const Offset(0, 8), blurRadius: 20), BoxShadow(color: Colors.purpleAccent.withValues(alpha: 0.5), offset: const Offset(0, 4), blurRadius: 10),],
                    ),
                    child: Text(formattedDateTime, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 0.5, shadows: [Shadow(color: Colors.black38, offset: Offset(1, 1), blurRadius: 2,)],),),
                  ),
                ),

                const SizedBox(height: 30),

                // Countdown Card
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.purple.shade700, Colors.blue.shade700], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), offset: const Offset(0, 8), blurRadius: 20), BoxShadow(color: Colors.purple.withValues(alpha: 0.5), offset: const Offset(0, 4), blurRadius: 10),],
                  ),
                  child: Text(_countdownHelper.formattedCountdown, textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white.withValues(alpha: 0.95), fontWeight: FontWeight.bold, shadows: const [Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 3,)],),),
                ),
              ],
            ),

            // Loader Overlay
            if (_isLoading)
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.purple.shade700, Colors.blue.shade700], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), offset: const Offset(0, 8), blurRadius: 20), BoxShadow(color: Colors.purple.withValues(alpha: 0.5), offset: const Offset(0, 4), blurRadius: 10),],
                ),
                padding: const EdgeInsets.all(25),
                child: SizedBox(width: 36, height: 36, child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 36,),),
              ),
          ],
        ),
      ),
    );

  }
}
