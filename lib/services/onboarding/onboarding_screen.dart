import 'package:asp_chat/screen/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../../utils/constant/app_colors.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}


class _OnboardingScreenState extends State<OnboardingScreen> {
  final controller = PageController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  void navigateHomeScreen(){
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      body: Stack(
        children: [
          /// >>> Page Design ==================================================
          PageView(
            controller: controller,
            children: [
              buildOnBoardingPage(title: "Welcome ASPChat", description: "Plan smarter, work faster.\nStay organized with a clean workflow.", icon: Icons.task_alt_rounded,),
              buildOnBoardingPage(title: "Smoothly Chatting", description: "Smooth chat, set reminders,\nand complete work on time—every day.", icon: Icons.bolt_rounded,),
              buildOnBoardingPage(title: "Secure & Reliable", description: "Your tasks and data stay protected\nwith strong cloud security.", icon: Icons.security_rounded,),
            ],
          ),
          /// <<< Page Design ==================================================


          /// >>> Page Indicator Positioned ====================================
          Positioned(
              bottom: 80,
              left: 0,
              right: 0,
              child: SafeArea(child: Center(child: SmoothPageIndicator(controller: controller, count: 3,effect: ExpandingDotsEffect(activeDotColor: AppColors.primaryColor,dotColor: AppColors.secondaryColor),),))
          ),
          /// <<< Page Indicator Positioned ====================================


          /// >>> Get Start Button =============================================
          Positioned(
              bottom: 20,
              left: 40,
              right: 40,
              child: SafeArea(
                child: ElevatedButton(
                  onPressed: () async{
                    await Hive.box("onBoardingPage").put("onboarding_seen", true);
                    if(!mounted) return;
                    navigateHomeScreen();
                  },
                  child: const Text("Get Started"),
                ),
              )
          )
          /// <<< Get Start Button =============================================
        ],
      ),
    );
  }



  /// >>>  Onboarding Page Build Here ==========================================
  Widget buildOnBoardingPage({required String title,required String description, required IconData icon}){
    return Container(
      decoration: BoxDecoration(gradient: LinearGradient(colors: [Color(0xFFEEF2FF), Color(0xFFE0E7FF),], begin: Alignment.topCenter, end: Alignment.bottomCenter,),),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 26),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Colors.white.withValues(alpha: 0.7), Colors.white.withValues(alpha: 0.3),], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 25, offset: const Offset(0, 10),),],
                border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1.5,),
              ),
              child: Icon(icon, size: 115, color: AppColors.primaryColor,),
            ),
            const SizedBox(height: 45),

            // Title
            Text(title, style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w700, letterSpacing: 0.8, color: AppColors.primaryColor,), textAlign: TextAlign.center,),
            const SizedBox(height: 18),
            // Description
            Text(description, style: TextStyle(fontSize: 17, height: 1.6, color: Colors.grey.shade700,), textAlign: TextAlign.center,),
          ],
        ),
      ),
    );
  }
  /// <<<  Onboarding Page Build Here ==========================================
}
