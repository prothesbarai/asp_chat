import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../helper/date_time_helper.dart';
import '../../../../utils/constant/app_colors.dart';

class CoupleDailyLove extends StatefulWidget {
  const CoupleDailyLove({super.key});

  @override
  State<CoupleDailyLove> createState() => _CoupleDailyLoveState();
}

class _CoupleDailyLoveState extends State<CoupleDailyLove> {

  String _topMainTitle = "";
  String _topMainSubtitle = "";
  String _messageBoxTitle = "";
  String _shreyasiImgUrl = "";
  String _prothesImgUrl = "";
  // String _messageBoxDate = "";
  String _messageBoxMessage = "";
  String _imgTitleShreyasi = "";
  String _imgTitleProthes = "";
  String _dailyTipsQuoteTitle = "";
  String _dailyTipsOne = "";
  String _dailyTipsTwo = "";
  String _dailyTipsThree = "";
  String _dailyTipsFour = "";
  String _footerText = "";
  bool isLoading = false;


  @override
  void initState() {
    super.initState();
    _fetchAnniversaryData();
  }

  /// >>> Get Data From Firebase ===============================================
  Future<void> _fetchAnniversaryData() async {
    setState(() {isLoading = true;});
    final doc = await FirebaseFirestore.instance.collection('coupledailylove').doc('sp').get();
    if (doc.exists) {
      setState(() {
        _topMainTitle = doc['top_main_title'] ?? '';
        _topMainSubtitle = doc['top_main_subtitle'] ?? '';
        _messageBoxTitle = doc['message_box_title'] ?? '';
        _shreyasiImgUrl = doc['shreyasi_img_url'] ?? '';
        _prothesImgUrl = doc['prothes_img_url'] ?? '';
        // _messageBoxDate = doc['message_box_date'] ?? '';
        _messageBoxMessage = doc['message_box_message'] ?? '';
        _imgTitleShreyasi = doc['img_title_shreyasi'] ?? '';
        _imgTitleProthes = doc['img_title_prothes'] ?? '';
        _dailyTipsQuoteTitle = doc['daily_tips_quote_title'] ?? '';
        _footerText = doc['footer_text'] ?? '';
        _dailyTipsOne = doc['daily_tips_one'] ?? '';
        _dailyTipsTwo = doc['daily_tips_two'] ?? '';
        _dailyTipsThree = doc['daily_tips_three'] ?? '';
        _dailyTipsFour = doc['daily_tips_four'] ?? '';
        isLoading = false;
      });
    }
  }
  /// <<< Get Data From Firebase ===============================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // >>> Gradient Background
          Container(decoration: BoxDecoration(gradient: LinearGradient(colors: [Colors.pink.shade400, Colors.deepPurple.shade600], begin: Alignment.topLeft, end: Alignment.bottomRight,),),),
          // >>> Light blur overlay for dreamy effect
          BackdropFilter(filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12), child: Container(color: Colors.black.withValues(alpha: 0.2),),),
          // >>> Main content scrollable
          isLoading? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 60,)):
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // >>> Title
                  Text(_topMainTitle, style: GoogleFonts.pacifico(fontSize: 36, color: Colors.white, shadows: [Shadow(color: Colors.black45, offset: Offset(2, 2), blurRadius: 5,),],), textAlign: TextAlign.center,),
                  SizedBox(height: 10),
                  Text(_topMainSubtitle, style: GoogleFonts.lato(fontSize: 18, color: Colors.white70, fontStyle: FontStyle.italic,), textAlign: TextAlign.center,),
                  SizedBox(height: 40),

                  // >>> Love Message Card
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(30), border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5,), boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10),),],),
                    child: Column(
                      children: [
                        Text(_messageBoxTitle, style: GoogleFonts.pacifico(fontSize: 28, color: Colors.white,),),
                        SizedBox(height: 15),
                        Text(_messageBoxMessage, style: GoogleFonts.lato(fontSize: 20, color: Colors.white70,), textAlign: TextAlign.center,),
                        SizedBox(height: 20),
                        Text(DateTimeHelper.formatDateOnly(DateTime.now()), style: GoogleFonts.lato(fontSize: 16, color: Colors.white54, fontStyle: FontStyle.italic,),),
                        SizedBox(height: 20),
                        Icon(Icons.favorite, color: Colors.redAccent.shade100, size: 50,),
                      ],
                    ),
                  ),

                  SizedBox(height: 40),

                  // >>> Couple Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _coupleProfile(_imgTitleShreyasi, _shreyasiImgUrl),
                      _coupleProfile(_imgTitleProthes, _prothesImgUrl),
                    ],
                  ),

                  SizedBox(height: 40),

                  // >>> Daily Tips or Quotes
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20),),
                    child: Column(
                      children: [
                        Text(_dailyTipsQuoteTitle, style: GoogleFonts.pacifico(fontSize: 24, color: Colors.white,),),
                        SizedBox(height: 15),
                        Text("$_dailyTipsOne\n$_dailyTipsTwo\n$_dailyTipsThree\n$_dailyTipsFour", style: GoogleFonts.lato(fontSize: 18, color: Colors.white70,), textAlign: TextAlign.center,),
                      ],
                    ),
                  ),

                  SizedBox(height: 60),
                  // >>> Footer
                  Text(_footerText, style: GoogleFonts.lato(fontSize: 16, color: Colors.white54, fontStyle: FontStyle.italic,),),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// >>> Couple Profile Image =================================================
  Widget _coupleProfile(String name, String path) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          child: ClipOval(
            child: CachedNetworkImage(
              imageUrl: path,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 40,),),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),

        SizedBox(height: 10),
        Text(name, style: GoogleFonts.lato(fontSize: 18, color: Colors.white,),),
      ],
    );
  }
}
