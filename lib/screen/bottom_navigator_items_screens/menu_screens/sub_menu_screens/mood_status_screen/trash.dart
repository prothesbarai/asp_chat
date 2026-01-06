/*
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../../helper/date_time_helper.dart';

class MoodStatusPage extends StatefulWidget {
  const MoodStatusPage({super.key});

  @override
  State<MoodStatusPage> createState() => _MoodStatusPageState();
}

class _MoodStatusPageState extends State<MoodStatusPage> {
  final _noteController = TextEditingController();

  Map<String, String>? selectedMood;

  final freeMoods = [
    {"emoji": "😊", "title": "Happy"},
    {"emoji": "😔", "title": "Sad"},
    {"emoji": "😡", "title": "Angry"},
    {"emoji": "😴", "title": "Tired"},
    {"emoji": "😍", "title": "Loved"},
  ];

  final premiumMoods = [
    {"emoji": "🥰", "title": "Affectionate"},
    {"emoji": "😤", "title": "Frustrated"},
    {"emoji": "🤯", "title": "Overwhelmed"},
    {"emoji": "😌", "title": "Peaceful"},
    {"emoji": "🥺", "title": "Need Attention"},
    {"emoji": "🤍", "title": "Missing You"},
  ];

  final uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(uid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()),);
        }

        final userData = snapshot.data!;
        final bool isPremium = userData["isPremium"] ?? false;
        final String? partnerUid = userData["relationship"]?["partnerUid"];

        return Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _myMoodCard(isPremium),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                partnerUid == null ? const Text("No partner connected", style: TextStyle(color: Colors.grey),) : _partnerMoodCard(partnerUid),
              ],
            ),
          ),
        );
      },
    );
  }

  // ================= MY MOOD CARD =================

  Widget _myMoodCard(bool isPremium) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("My Mood", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),),
            const SizedBox(height: 12),
            // Selected Emoji
            Center(child: Text(selectedMood?["emoji"] ?? "😐", style: const TextStyle(fontSize: 64),),),
            const SizedBox(height: 8),
            Center(child: Text(selectedMood?["title"] ?? "Neutral", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),),
            const SizedBox(height: 16),
            isPremium ? _premiumDropdown() : _freeMoodGrid(),
            const SizedBox(height: 16),
            TextField(
              controller: _noteController,
              maxLines: 2,
              decoration: const InputDecoration(hintText: "Why are you feeling this? (optional)", border: OutlineInputBorder(),),
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

  // ================= FREE MOOD GRID =================

  Widget _freeMoodGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: freeMoods.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, childAspectRatio: 1,),
      itemBuilder: (context, index) {
        final mood = freeMoods[index];
        return GestureDetector(
          onTap: () {setState(() => selectedMood = mood);},
          child: Card(
            color: selectedMood == mood ? Colors.blue.shade100 : Colors.white,
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

  // ================= PREMIUM DROPDOWN =================

  Widget _premiumDropdown() {
    return DropdownButtonFormField<Map<String, String>>(
      decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Select Mood",),
      items: premiumMoods.map((mood) {
        return DropdownMenuItem(value: mood, child: Text("${mood["emoji"]} ${mood["title"]}"),);
      }).toList(),
      onChanged: (value) {
        setState(() => selectedMood = value);
      },
    );
  }

  // ================= UPDATE MOOD =================

  Future<void> _updateMood() async {
    await FirebaseFirestore.instance.collection("users").doc(uid).update({
      "mood.currentMood": selectedMood!["title"],
      "mood.emoji": selectedMood!["emoji"],
      "mood.note": _noteController.text.trim(),
      "mood.updatedAt": FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Mood updated successfully")),);
  }

  // ================= PARTNER MOOD CARD =================

  Widget _partnerMoodCard(String partnerUid) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance.collection("users").doc(partnerUid).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!;

        // Check if document exists
        if (!data.exists) {
          return const Text(
            "Partner data not found",
            style: TextStyle(color: Colors.grey),
          );
        }

        final mood = data["mood"];
        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text(data["name"] ?? "Partner",
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text(mood?["emoji"] ?? "😐", style: const TextStyle(fontSize: 64)),
                const SizedBox(height: 8),
                Text(mood?["currentMood"] ?? "Neutral",
                    style: const TextStyle(fontSize: 16)),
                if ((mood?["note"] ?? "").toString().isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(mood["note"],
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.grey)),
                ],
                const SizedBox(height: 8),
                Text(
                  _formatTime(mood?["updatedAt"]),
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _formatTime(Timestamp? time) {
    if (time == null) return "";
    return "Updated ${DateTimeHelper.formatTimeOnly(time.toDate())}";
  }

}
*/
