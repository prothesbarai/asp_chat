import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../features/set_user_image/user_image_provider/user_image_provider.dart';

class ProfileCard extends StatelessWidget {
  final String name;
  const ProfileCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<UserImageProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [

              // >>> Background Gradient Blobs Style Here ======================
              Positioned(left: -40, top: 80, child: _blob(Colors.orange),),
              Positioned(right: -40, bottom: 60, child: _blob(Colors.redAccent),),
              // <<< Background Gradient Blobs Style Here ======================

              // >>> Glass Card Start Here =====================================
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                  child: Container(
                    width: 280,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), color: Colors.white.withValues(alpha: 0.15), border: Border.all(color: Colors.white.withValues(alpha: 0.3),),),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text("Profile Card", style: TextStyle(color: Colors.white70, fontSize: 14,),),
                        const SizedBox(height: 16),
                        // >>> Profile Image
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.red, width: 2),),
                          child: CircleAvatar(
                            radius: 40,
                            backgroundColor: (imageProvider.profileImage == null) ? Color(0xff1f2b3b) : null,
                            backgroundImage: (imageProvider.profileImage != null) ? FileImage(imageProvider.profileImage!) : null,
                            child: (imageProvider.profileImage == null) ? Icon(Icons.person, size: 34,) : null,
                          )
                        ),
                        const SizedBox(height: 12),

                        // >>> Name
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(name, style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold,),),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified, color: Colors.orange, size: 16),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // >>> Stats
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _statItem(title: "posts", value: "89"),
                            _statItem(title: "followers", value: "4561"),
                            _statItem(title: "following", value: "1589"),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // >>> Follow Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14),),),
                            onPressed: () {},
                            child: const Text("Follow"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // <<< Glass Card Start Here =====================================
            ],
          ),
        )
      ),
    );
  }


  /// >>> Background Gradiant Blob =============================================
  Widget _blob(Color color){return Container(width: 160, height: 160, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color.withValues(alpha: 0.8), color.withValues(alpha: 0.1),],),),);}
  /// <<< Background Gradiant Blob =============================================


  /// >>> Widget StatItem Start Here ===========================================
  Widget _statItem({required String title, required String value}){
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16,),),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.white70, fontSize: 12),),
      ],
    );
  }
  /// <<< Widget StatItem Start Here ===========================================

}
