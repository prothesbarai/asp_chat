import 'package:flutter/material.dart';
import 'app_colors.dart';

class NetworkStatusWidgets{
  /// >>> =========================== Static Loader Start Here ============================
  static Widget loader(BuildContext context, String url) {
    return Image.asset("assets/images/placeholder.png", fit: BoxFit.cover, width: double.infinity,);
  }
  /// <<< =========================== Static Loader End Here ==============================


  /// >>> =========================== Static Error Start Here ============================
  static Widget error(BuildContext context, String url, dynamic error) {
    return Image.asset("assets/images/placeholder.png", fit: BoxFit.cover, width: double.infinity,);
  }
  /// <<< =========================== Static Error End Here ==============================



  /// >>> =========================== Static Success Start Here ==========================
  static Widget success(BuildContext context, String url) {
    return const Center(child: Icon(Icons.check_circle, color: AppColors.success),);
  }
/// <<< =========================== Static Success End Here ============================
}
