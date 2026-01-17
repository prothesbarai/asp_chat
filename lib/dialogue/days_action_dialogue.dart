import 'package:flutter/material.dart';

void daysActionDialogue(BuildContext context, String title, String subTitle, String actionButtonText, IconData bodyIconData, String bodyIconText, String navigateFlag) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(colors: [Color(0xFF1D2671), Color(0xFFC33764),], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10),),],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Lover Message", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1,),),
                  const SizedBox(height: 10),
                  const Text("Upgrade to Premium Membership\n& Unlock Exclusive Benefits", textAlign: TextAlign.center, style: TextStyle(color: Colors.white70, fontSize: 14,),),
                  const SizedBox(height: 20),
                  _benefitItem("🚚", "Free Delivery on All Orders"),
                  _benefitItem("💸", "Extra Discounts & Cashback"),
                  _benefitItem("⚡", "Priority Support"),
                  _benefitItem("🎁", "Early Access to Offers"),
                  const SizedBox(height: 25),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pop(context);

                      },
                      child: const Text("Send Love", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1,),),
                    ),
                  ),

                  const SizedBox(height: 12),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Maybe Later", style: TextStyle(color: Colors.white70),),
                  ),
                ],
              ),
            ),

            // >>> Premium Icon
            Container(
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(colors: [Colors.amber, Colors.orange],),
                boxShadow: [BoxShadow(color: Colors.amber.withValues(alpha: 0.6), blurRadius: 20,),],
              ),
              child: const Icon(Icons.workspace_premium, size: 40, color: Colors.white,),
            ),
          ],
        ),
      );
    },
  );
}

/// >>> Benefit Items Design Here ==============================================
Widget _benefitItem(String icon, String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white),),),
      ],
    ),
  );
}
/// <<< Benefit Items Design Here ==============================================
