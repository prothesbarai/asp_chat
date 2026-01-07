import 'package:asp_chat/utils/constant/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../../../utils/constant/app_string.dart';

class MoodStatusScreen extends StatefulWidget {
  const MoodStatusScreen({super.key});

  @override
  State<MoodStatusScreen> createState() => _MoodStatusScreenState();
}

class _MoodStatusScreenState extends State<MoodStatusScreen> {

  final _noteController = TextEditingController();
  Map<String, String>? selectedMood;
  final uid = FirebaseAuth.instance.currentUser!.uid;

  bool isPremium = false;
  bool isLoading = false;
  String? partnerUid;


  @override
  void initState() {
    super.initState();
    fetchPremiumStatus();
  }


  /// >>> Fetch & Update Function Status =======================================
  void fetchPremiumStatus(){
    setState(() {isLoading = true;});
    final uid = FirebaseAuth.instance.currentUser!.uid;
    FirebaseFirestore.instance.collection("users").doc(uid).snapshots().listen((doc){
      if(!doc.exists) return;
      final data = doc.data();
      if (data == null) return;
      if (!mounted) return;
      setState(() {
        isLoading = false;
        isPremium = data["isPremium"] ?? false;
        partnerUid = data["relationship"]?["partnerUid"];
        final moodData = data['mood'];
        if (moodData != null) {selectedMood = {"emoji": moodData["emoji"] ?? "😐", "title": moodData["currentMood"] ?? "Neutral",};_noteController.text = moodData["note"] ?? "";}
      });
    });
  }
  void updatePremiumStatus(bool value) async{
    final uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection("users").doc(uid).update({"isPremium" : value});
  }
  /// <<< Fetch & Update Function Status =======================================


  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Mood Status"),
          actions: [
            Row(
              children: [
                Text(isPremium ? "Premium" : "Free", style: const TextStyle(fontSize: 14),),
                Switch(value: isPremium, onChanged: (value) {updatePremiumStatus(value);},),
              ],
            ),
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: isLoading ?  Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),) :
              Column(
                children: [
                  _myMoodCard(isPremium),
                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),
                  partnerUid == null ? Text("No partner connected", style: TextStyle(color: Theme.of(context).colorScheme.onSurface),) : Text("_partnerMoodCard(partnerUid)",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),
                ],
              ),
            ),
            if (isLoading)...[
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
            ],
          ],
        )
    );
  }


  /// >>> ================= MY MOOD CARD =======================================
  Widget _myMoodCard(bool isPremium){
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("My Mood", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onSurface),),
            const SizedBox(height: 12),
            // >>> Selected Emoji
            Center(child: Text(selectedMood?["emoji"] ?? "😐", style: TextStyle(fontSize: 64, color: Theme.of(context).colorScheme.onSurface ),),),
            const SizedBox(height: 8),
            Center(child: Text(selectedMood?["title"] ?? "Neutral", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500 , color: Theme.of(context).colorScheme.onSurface ),),),
            const SizedBox(height: 16),
            isPremium ? _premiumDropdown() : _freeMoodGrid(),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              maxLines: 2,
              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
              decoration: InputDecoration(
                hintText: "Why are you feeling this? (optional)",
                border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor)),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: selectedMood == null ? null : _updateMood, child: const Text("Update Mood"),),
            )
          ],
        ),
      ),
    );
  }
  /// <<< ================= MY MOOD CARD =======================================

  /// >>> ================= FREE MOOD GRID =====================================
  Widget _freeMoodGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: AppString.freeMoods.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1,),
      itemBuilder: (context, index) {
        final mood = AppString.freeMoods[index];
        return GestureDetector(
          onTap: () {setState(() => selectedMood = mood);},
          child: Card(
            color: selectedMood == mood ? AppColors.primaryColor : Theme.of(context).colorScheme.onSurface,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(mood["emoji"]!, style: const TextStyle(fontSize: 28)),
                const SizedBox(height: 4),
                Text(mood["title"]!, style: const TextStyle(fontSize: 12)),
              ],
            ),
          ),
        );
      },
    );
  }
  /// <<< ================= FREE MOOD GRID =====================================

  /// >>> ================= PREMIUM DROPDOWN ===================================
  Widget _premiumDropdown() {
    return DropdownButtonFormField(
      items: AppString.premiumMoods.map((mood){return DropdownMenuItem(value: mood,child: Text("${mood["emoji"]} ${mood["title"]}",style: TextStyle(color: Theme.of(context).colorScheme.onSurface),),);}).toList(),
      onChanged: (value) {setState(() {selectedMood = value;});},
    );
  }
  /// <<< ================= PREMIUM DROPDOWN ===================================


  /// >>> ================= UPDATE BUTTON ======================================
  Future<void> _updateMood() async {
    setState(() {isLoading = true;});
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "mood.currentMood": selectedMood!["title"],
      "mood.emoji": selectedMood!["emoji"],
      "mood.note": _noteController.text.trim(),
      "mood.updatedAt": FieldValue.serverTimestamp(),
    });
    if(!mounted) return;
    setState(() {isLoading = false;});
    FocusScope.of(context).unfocus();
    _noteController.clear();
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mood updated successfully")),);
  }
  /// <<< ================= UPDATE BUTTON ======================================

}

