import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {

  DateTime? _selectedDateTime;
  bool _isLoading = false;

  String get formattedDateTime {
    if(_isLoading) return "";
    if (_selectedDateTime == null) return "No DateTime selected";
    return "${_selectedDateTime!.day.toString().padLeft(2, '0')}/${_selectedDateTime!.month.toString().padLeft(2, '0')}/${_selectedDateTime!.year} ${_selectedDateTime!.hour.toString().padLeft(2, '0')}:${_selectedDateTime!.minute.toString().padLeft(2, '0')}:${_selectedDateTime!.second.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();
    _loadDateTimeFromFirebase();
  }


  /// >>> Load DateTime From Firebase ==========================================
  Future<void> _loadDateTimeFromFirebase() async {
    setState(() {_isLoading = true;});
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance.collection('notification').doc('alerm').get();
      if (doc.exists && doc['datetime'] != null) {
        String storedDateTime = doc['datetime'];
        List<String> parts = storedDateTime.split(' ');
        List<String> dateParts = parts[0].split('/');
        List<String> timeParts = parts[1].split(':');
        setState(() {_selectedDateTime = DateTime(int.parse(dateParts[2]), int.parse(dateParts[1]), int.parse(dateParts[0]), int.parse(timeParts[0]), int.parse(timeParts[1]), int.parse(timeParts[2]),);});
      }
    } catch (e) {
      debugPrint("Error fetching datetime from Firebase: $e");
    }finally{
      setState(() {_isLoading = false;});
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
    setState(() {_isLoading = true;_selectedDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute, DateTime.now().second,);});
    await _storeDateTimeToFirebase();
    if(!mounted) return;
    setState(() {_isLoading = false;});
  }
  /// <<< Date Time picker =====================================================


  /// >>> Set Data Firestore ===================================================
  Future<void> _storeDateTimeToFirebase() async {
    if (_selectedDateTime == null) return;
    String formattedDateTime = "${_selectedDateTime!.day.toString().padLeft(2, '0')}/""${_selectedDateTime!.month.toString().padLeft(2, '0')}/""${_selectedDateTime!.year} ""${_selectedDateTime!.hour.toString().padLeft(2, '0')}:""${_selectedDateTime!.minute.toString().padLeft(2, '0')}:""${_selectedDateTime!.second.toString().padLeft(2, '0')}";
    await FirebaseFirestore.instance.collection('notification').doc('alerm').set({'datetime': formattedDateTime}, SetOptions(merge: true));
  }
  /// <<< Set Data Firestore ===================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Premium Gradient Button
            GestureDetector(
              onTap: _pickDateTime,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 30),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Colors.purple, Colors.blueAccent], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.6), offset: const Offset(0, 6), blurRadius: 12,),
                    BoxShadow(color: Colors.purple.withValues(alpha: 0.6), offset: const Offset(0, 3), blurRadius: 6,),
                  ],
                ),
                child: Text(formattedDateTime, textAlign: TextAlign.center, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 0.5,),),
              ),
            ),

            // Loader overlay
            if (_isLoading)
              Container(
                decoration: BoxDecoration(color: Colors.black38, borderRadius: BorderRadius.circular(30),),
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 30,),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
