import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:lottie/lottie.dart';
import 'package:pinput/pinput.dart';

import '../../utils/constant/app_colors.dart';

class AnniversaryScreen extends StatefulWidget {
  const AnniversaryScreen({super.key});

  @override
  State<AnniversaryScreen> createState() => _AnniversaryScreenState();
}

class _AnniversaryScreenState extends State<AnniversaryScreen> {
  bool _showHistory = false;
  String _password = "";
  String _anniversaryMessage = "";
  String _anniversaryYears = "";
  bool isLoading = false;
  final TextEditingController _pinController = TextEditingController();



  @override
  void initState() {
    super.initState();
    _fetchAnniversaryData();
  }

  /// >>> Get Data From Firebase ===============================================
  Future<void> _fetchAnniversaryData() async {
    setState(() {isLoading = true;});
    final doc = await FirebaseFirestore.instance.collection('anniversary').doc('sp').get();
    if (doc.exists) {
      setState(() {
        _password = doc['password'].toString();
        _anniversaryMessage = doc['anniversary_message'] ?? '';
        _anniversaryYears = doc['anniversary_years'] ?? '';
        isLoading = false;
      });
    }
  }
  /// <<< Get Data From Firebase ===============================================


  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          /// >>> Background Gradient ==========================================
          Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.pink.shade400, Colors.purple.shade900], begin: Alignment.topLeft, end: Alignment.bottomRight,),),),
          /// >>> Background Gradient ==========================================
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // >>> Lottie Animation
                  Lottie.asset('assets/lottie/bird.json', width: double.infinity, height: 200,),
                  const SizedBox(height: 20),
                  // >>> Anniversary Date Card
                  _buildAnniversaryDateCard("16 October 2016"),
                  // >>> Title
                  Text('Happy Anniversary', textAlign: TextAlign.center, style: GoogleFonts.pacifico(fontSize: 36, color: Colors.white, fontWeight: FontWeight.bold,),),
                  const SizedBox(height: 10),
                  // >>> Subtitle
                  Text('$_anniversaryYears Years Together ❤️', textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 22, color: Colors.white70,),),
                  const SizedBox(height: 30),

                  SizedBox(
                    child: isLoading ? LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,) :
                    Text(_anniversaryMessage,textAlign: TextAlign.center, style: GoogleFonts.lato(fontSize: 22, color: Colors.white70,),),
                  ),


                  const SizedBox(height: 30),

                  // >>> History Content (shows only if password is correct)
                  if (_showHistory) _buildHistoryContent(),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      // Protected History Section
                      Expanded(
                        flex: 1,
                        child: GestureDetector(
                          onTap: () {_showPasswordDialog();},
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                            decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(30),),
                            alignment: Alignment.center,
                            child: Text('💌 Love Story', style: GoogleFonts.pacifico(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold,),),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      // >>> Send Wishes Button
                      Expanded(
                        flex: 1,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),), backgroundColor: Colors.pinkAccent,),
                          onPressed: () {},
                          child: const Text('Send Wishes', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// >>> Build Anniversary Date Card ==========================================
  Widget _buildAnniversaryDateCard(String dateText) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.25), Colors.white.withValues(alpha: 0.08),], begin: Alignment.topLeft, end: Alignment.bottomRight,),
        border: Border.all(color: Colors.white24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 6),),],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.calendar_month, color: Colors.white, size: 22),
          const SizedBox(width: 10),
          Text(dateText, style: GoogleFonts.lato(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white, letterSpacing: 1,),),
        ],
      ),
    );
  }
  /// <<< Build Anniversary Date Card ==========================================

  /// >>> Memory Card Widget Build =============================================
  Widget _buildMemoryCard({required String title, required String date, required String description, required IconData icon,}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.pink.shade200, Colors.purple.shade400], begin: Alignment.topLeft, end: Alignment.bottomRight,), borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, offset: const Offset(0, 3),)],),
      child: Row(
        children: [
          CircleAvatar(radius: 25, backgroundColor: Colors.white, child: Icon(icon, color: Colors.pinkAccent, size: 28),),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.pacifico(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,)),
                const SizedBox(height: 5),
                Text(date, style: GoogleFonts.lato(fontSize: 16, color: Colors.white70,)),
                const SizedBox(height: 5),
                Text(description, style: GoogleFonts.lato(fontSize: 14, color: Colors.white60,)),
              ],
            ),
          ),
        ],
      ),
    );
  }
  /// <<< Memory Card Widget Build =============================================

  /// >>> Protected Memory Content =============================================
  Widget _buildHistoryContent() {
    return Column(
      children: [
        const SizedBox(height: 20),
        Text('💖 Our Love Story Timeline 💖', style: GoogleFonts.pacifico(fontSize: 20, color: Colors.white),),
        const SizedBox(height: 10),
        _buildMemoryCard(title: 'First Meet', date: 'Shaheed Smriti College, Sashikar', description: 'We first met at college. ❤', icon: Icons.school,),
        _buildMemoryCard(title: 'Relationship Start', date: '16 October 2016', description: 'Our journey together began 💕', icon: Icons.favorite,),
        _buildMemoryCard(title: 'First Kiss', date: '30-31 March 2017', description: 'A magical first kiss 💖', icon: Icons.heart_broken,),
        _buildMemoryCard(title: 'Romantic Day', date: '23 October 2023', description: 'A special romantic day 💌 fact durga puja', icon: Icons.emoji_emotions,),
        _buildMemoryCard(title: 'Two Anniversary', date: '20 November 2023 & 15 May 2017', description: 'Two beautiful anniversaries, countless memories, and endless love ❤️', icon: Icons.star,),
      ],
    );
  }
  /// <<< Protected Memory Content =============================================

  /// >>> Password Dialog ======================================================
  void _showPasswordDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.pink.shade100.withValues(alpha: 0.95),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Enter Password', style: GoogleFonts.pacifico(fontSize: 20, color: Colors.white,),),
                const SizedBox(height: 15),
                Pinput(
                  controller: _pinController,
                  length: 4,
                  obscureText: true,
                  defaultPinTheme: PinTheme(width: 50, height: 50, textStyle: const TextStyle(fontSize: 18, color: Colors.black), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10),),),
                  onCompleted: (pin) {
                    if (pin == _password) {
                      setState(() {_showHistory = true;});
                      Navigator.pop(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Incorrect password!')),);
                      _pinController.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  /// >>> Password Dialog ======================================================
}
