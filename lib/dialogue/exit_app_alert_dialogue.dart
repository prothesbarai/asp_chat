import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../utils/constant/app_colors.dart';


class ExitAppAlertDialogue extends StatelessWidget {
  const ExitAppAlertDialogue({super.key});

  static Future<bool> willPopScope(BuildContext context) async{
    final shouldExit = await showDialog<bool>(context: context, builder: (context) => const ExitAppAlertDialogue(),);
    return shouldExit??false;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: Colors.white,
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.warning_amber_rounded,color: AppColors.dangerColor,size: 40,),
              SizedBox(height: 10,),
              Text("Exit App",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: AppColors.dangerColor),),
              SizedBox(height: 10,),
              Text("Do you want to exit this app?",style: TextStyle(color: Colors.grey,fontSize: 16),textAlign: TextAlign.center,),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                      onPressed: (){Navigator.of(context).pop(true);SystemNavigator.pop();},
                      label: Text("Yes",style: TextStyle(color: Colors.white),),
                      icon: Icon(Icons.exit_to_app,color: Colors.white,),
                      style: ElevatedButton.styleFrom(backgroundColor: AppColors.dangerColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {Navigator.of(context).pop(false);},
                    label: Text("No", style: TextStyle(color: AppColors.success),),
                    icon: Icon(Icons.cancel, color: AppColors.success),
                    style: OutlinedButton.styleFrom(side: BorderSide(color: AppColors.success, width: 2), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50),),),
                  ),
                ],
              )
            ],
          ),
      ),
    );
  }

}





