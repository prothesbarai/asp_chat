import 'package:asp_chat/services/network_connection_check/network_checker_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NetworkCheckerUi extends StatelessWidget {
  final Widget child;
  const NetworkCheckerUi({super.key,required this.child});

  @override
  Widget build(BuildContext context) {
    final isOnline = context.select<NetworkCheckerProvider,bool>((p)=>p.isOnline);
    return Stack(
      children: [
        child,
        if(!isOnline)...[
          Positioned(
              bottom: 50,
              left: 10,
              right: 10,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                color: Colors.red.shade700,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: const [
                          Icon(Icons.wifi_off, color: Colors.white),
                          SizedBox(width: 8),
                          Text('No Internet Connection', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500, decoration: TextDecoration.none,),),
                        ],
                      ),
                      TextButton(
                        onPressed: () {  context.read<NetworkCheckerProvider>().retry(); },
                        style: TextButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8), backgroundColor: Colors.white24, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8),),),
                        child: const Text('Retry', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                      ),
                    ],
                  ),
                ),
              )
          )
        ]
      ],
    );
  }
}
