import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
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
  bool _hasPlayedSound = false;
  bool _userSetDate = false;
  final AudioPlayer _audioPlayer = AudioPlayer();



  String get formattedDateTime {
    if(_isLoading) return "";
    if (_selectedDateTime == null) return "No DateTime selected";
    return "${_selectedDateTime!.day.toString().padLeft(2, '0')}/${_selectedDateTime!.month.toString().padLeft(2, '0')}/${_selectedDateTime!.year} ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}:${_selectedDateTime!.second.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    /// >>> Back Counter Timer Initialize ======================================
    _countdownHelper = CountdownHelper(onTick: () {if (mounted) setState(() {});  /* For Alarm Function*/ _checkCountdownZero();},);
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
  Future<void> _pickDateTime() async {
    _hasPlayedSound = false;
    DateTime? pickedDate = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      helpText: 'Select a date',
      builder: (context, child) {return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Theme.of(context).colorScheme.primary, onPrimary: Theme.of(context).colorScheme.onSurface, onSurface: Theme.of(context).colorScheme.primary,), dialogTheme: DialogThemeData(backgroundColor: Colors.grey[900]),), child: child!,);},
    );
    if (pickedDate == null || !mounted) return;
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedDateTime != null ? TimeOfDay.fromDateTime(_selectedDateTime!) : TimeOfDay.now(),
      builder: (context, child) {return Theme(data: Theme.of(context).copyWith(colorScheme: ColorScheme.light(primary: Theme.of(context).colorScheme.primary, onPrimary: Theme.of(context).colorScheme.onSurface, onSurface: Theme.of(context).colorScheme.primary,), timePickerTheme: TimePickerThemeData(backgroundColor: Colors.grey[900]),), child: child!,);},
    );
    if (pickedTime == null || !mounted) return;
    final newDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute, DateTime.now().second,);
    if (!mounted) return;
    // >>> Only set the countdown if the date is in the future
    if (newDateTime.isAfter(DateTime.now())) {
      _userSetDate = true;
      setState(() {_isLoading = true;_selectedDateTime = newDateTime;});
      await _storeDateTimeToFirebase();
      _countdownHelper.handle(newDateTime);
    } else {
      // >>>  Old date selected
      _userSetDate = false;
      setState(() {_selectedDateTime = newDateTime;});
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }
  /// <<< Date Time picker =====================================================


  /// >>> Set Data Firestore ===================================================
  Future<void> _storeDateTimeToFirebase() async {
    if (_selectedDateTime == null) return;
    await FirebaseFirestore.instance.collection('notification').doc('alerm').set({'datetime': Timestamp.fromDate(_selectedDateTime!),}, SetOptions(merge: true),);
  }
  /// <<< Set Data Firestore ===================================================



  /// >>> Check if countdown ended && Play Sound ===============================
  void _checkCountdownZero() {
    if (_userSetDate && !_countdownHelper.isFuture && !_hasPlayedSound) {
      _hasPlayedSound = true;
      _playAlarmSound();
      _userSetDate = false; // reset so it won't play again automatically
    }
  }
  void _playAlarmSound() async {
    try {
      await _audioPlayer.play(AssetSource('sounds/alarm1.mp3'));
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
    } catch (e) {
      debugPrint("Error playing alarm sound: $e");
    }
  }
  void _stopAlarmSound() async {
    try {
      await _audioPlayer.stop();
      setState(() {_hasPlayedSound = false;});
    } catch (e) {
      debugPrint("Error stopping alarm sound: $e");
    }
  }
  /// <<< Check if countdown ended && Play Sound ===============================



  @override
  void dispose() {
    _audioPlayer.stop();
    _countdownHelper.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    /// >>> Back Counter Timer UI Show Specific Parts ==========================
    final parts = _countdownHelper.countdownInDays;
    final uiShow = _countdownHelper.isFuture;
    /// <<< Back Counter Timer UI Show Specific Parts ==========================

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
                /*Container(
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.purple.shade700, Colors.blue.shade700], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), offset: const Offset(0, 8), blurRadius: 20), BoxShadow(color: Colors.purple.withValues(alpha: 0.5), offset: const Offset(0, 4), blurRadius: 10),],
                  ),
                  child: Text(_countdownHelper.formattedCountdown, textAlign: TextAlign.center, style: TextStyle(fontSize: 22, color: Colors.white.withValues(alpha: 0.95), fontWeight: FontWeight.bold, shadows: const [Shadow(color: Colors.black45, offset: Offset(1, 1), blurRadius: 3,)],),),
                ),*/


                if(uiShow)...[
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildCountdownBlock(parts.days.toString().padLeft(2,'0'), 'Days'),
                      const SizedBox(width: 8),
                      _buildCountdownBlock(parts.hours.toString().padLeft(2,'0'), 'Hours'),
                      const SizedBox(width: 8),
                      _buildCountdownBlock(parts.minutes.toString().padLeft(2,'0'), 'Minutes'),
                      const SizedBox(width: 8),
                      _buildCountdownBlock(parts.seconds.toString().padLeft(2,'0'), 'Seconds'),
                    ],
                  ),
                ],
                if (_hasPlayedSound && !uiShow) ...[
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {_stopAlarmSound();},
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent, padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),),
                    child: const Text("Stop Alarm", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),),
                  ),
                ]
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


  /// >>> Build Count Down Block ===============================================
  Widget _buildCountdownBlock(String value, String label) {
    return Column(
      children: [
        Material(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(8),
          elevation: 6,
          shadowColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16), child: Text(value, style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold,),),),
        ),
        const SizedBox(height: 6),
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 12, fontWeight: FontWeight.bold,),),
      ],
    );
  }
  /// <<< Build Count Down Block ===============================================

}
