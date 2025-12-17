import 'package:asp_chat/authentications/registration_screen.dart';
import 'package:asp_chat/screen/home_screen/home_screen.dart';
import 'package:asp_chat/utils/constant/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';

import '../providers/user_info_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscurePassword = true;
  bool isChecked = true;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  /// >>> Navigate Home Page ===================================================
  void _navigateHomePage(){
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeScreen()), (Route<dynamic> route) => false,);
  }
  /// <<< Navigate Home Page ===================================================


  /// >>> Login Successfully Popup Dialogue ====================================
  void showSuccessDialog(String message, bool flag) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          title: Text(flag ? "Success 🎉" : "Failed", textAlign: TextAlign.center,style: TextStyle(color: AppColors.primaryColor),),
          content: Text(message, textAlign: TextAlign.center,style: TextStyle(color: AppColors.primaryColor)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [ElevatedButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))],
        );
      },
    );
  }
  /// <<< Login Successfully Popup Dialogue ====================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // >>> Gradient Background =========================================
            Container(decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.loginGradiant,),),),
            // <<< Gradient Background =========================================

            // >>> Login Info ==================================================
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 60),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [

                        // >>> USER ICON & TITLE ===============================
                        Container(
                          padding: EdgeInsets.all(20),
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white70, width: 2),),
                          child: Icon(Icons.person, size: 60, color: Colors.white,),
                        ),
                        SizedBox(height: 20),
                        Text("USER LOGIN", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,),),
                        SizedBox(height: 30),
                        // <<< USER ICON & TITLE ===============================

                        // >>> EMAIL FIELD =====================================
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                filled: false,
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Padding(padding: const EdgeInsets.only(left: 15.0), child: Icon(Icons.email_outlined, color: Colors.white, size: 20,),),
                                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                counterStyle: TextStyle(color: Colors.white)
                            ),
                            keyboardType: TextInputType.emailAddress,
                            maxLength: 50,
                            cursorColor: Colors.white,
                            controller: _emailController,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value){
                              if(value == null || value.trim().isEmpty){
                                return "Field is Empty";
                              }
                              if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
                                return "Invalid Email";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // <<< EMAIL FIELD =====================================

                        // >>> PASSWORD FIELD ==================================
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: TextFormField(
                            style: TextStyle(color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Password",
                                filled: false,
                                hintStyle: TextStyle(color: Colors.white70),
                                prefixIcon: Padding(padding: const EdgeInsets.only(left: 15.0), child: Icon(Icons.lock, color: Colors.white, size: 20,),),
                                contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                suffixIcon: Padding(padding: const EdgeInsets.only(right: 8.0),child: IconButton(
                                  icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white,),
                                  onPressed: () {
                                    setState(() {_obscurePassword = !_obscurePassword;});
                                  },
                                ),),
                                counterStyle: TextStyle(color: Colors.white)
                            ),
                            keyboardType: TextInputType.visiblePassword,
                            maxLength: 22,
                            cursorColor: Colors.white,
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return "Field is Empty";
                              }
                              if (!RegExp(r'[A-Z]').hasMatch(value)) {
                                return "Must one uppercase (A-Z)";
                              }
                              if (!RegExp(r'[a-z]').hasMatch(value)) {
                                return "Must one lowercase (a-z)";
                              }
                              if (!RegExp(r'[0-9]').hasMatch(value)) {
                                return "Must one number (0-9)";
                              }
                              if (!RegExp(r'[!@#$%^&*{}()\\.+=?/_-]').hasMatch(value)) {
                                return "Must one Symbol";
                              }
                              if (value.length < 8) {
                                return "Password must 8 length";
                              }
                              return null;
                            },
                          ),
                        ),
                        SizedBox(height: 20),
                        // <<< PASSWORD FIELD ==================================


                        // >>> REMEMBER ME + FORGOT PASSWORD ===================
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: isChecked,
                                    onChanged: (value) {setState(() {isChecked = value ?? false;});},
                                    side: BorderSide(color: Colors.white),
                                    checkColor: Colors.green,
                                    activeColor: Colors.white,
                                  ),
                                  Text("Remember me", style: TextStyle(color: Colors.white,fontSize: 13)),
                                ],
                              ),

                              Expanded(
                                child: TextButton(
                                  onPressed: (){

                                  },
                                  child: Text("Forgot password?",style: TextStyle(color: AppColors.buttonBgColor,fontSize: 13),),
                                ),
                              ),

                            ],
                          ),
                        ),
                        SizedBox(height: 20),
                        // <<< REMEMBER ME + FORGOT PASSWORD ===================


                        // >>> LOGIN BUTTON ====================================
                        SizedBox(
                          width: 200,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonBgColor, foregroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            onPressed: isLoading? null :() async{
                              FocusScope.of(context).unfocus();
                              if(_formKey.currentState!.validate()){
                                final userData = Provider.of<UserInfoProvider>(context,listen: false);
                                String email = _emailController.text.trim();
                                String password = _passwordController.text.trim();
                                setState(() {isLoading = true;});
                                try{

                                  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
                                  final uid = userCredential.user!.uid;
                                  final getUserData = await FirebaseFirestore.instance.collection("users").doc(uid).get();
                                  if (getUserData.exists) {
                                    final data = getUserData.data()!;
                                    String name = data["name"] ?? "";
                                    String phone = data["phone"] ?? "";
                                    String emailFromDB = data["email"] ?? email;
                                    if(isChecked){
                                      await userData.storeHive({"uid" : uid, "name" : name, "phone" : phone, "email" : emailFromDB,});
                                    }
                                  }
                                  if(!mounted) return;
                                  _navigateHomePage();
                                  showSuccessDialog("Successfully Login", true);

                                }on FirebaseAuthException catch(err){
                                  String message = err.message ?? "Login failed!";
                                  if (err.code == 'user-not-found') {
                                    message = "Email not registered!";
                                  } else if (err.code == 'wrong-password' || err.code == 'invalid-credential') {
                                    message = "Incorrect Email or Password!";
                                  }
                                  showSuccessDialog(message, false);
                                }finally{
                                  if (mounted) setState(() { isLoading = false;});
                                }
                              }
                            },
                            child: Text("Login", style: TextStyle(fontSize: 18),),
                          ),
                        ),
                        SizedBox(height: 20),
                        // <<< LOGIN BUTTON ====================================


                        Text("Not a member?", style: TextStyle(color: Colors.white70, fontSize: 14,),),
                        SizedBox(height: 10),

                        // >>> CREATE ACCOUNT BUTTON ===========================
                        SizedBox(
                          width: 200,
                          height: 48,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(side: BorderSide(color: Colors.white), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            onPressed: () => Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => RegistrationScreen()), (Route<dynamic> route) => false,),
                            child: Text("Create account", style: TextStyle(color: Colors.white),),
                          ),
                        ),
                        SizedBox(height: 30),
                        // <<< CREATE ACCOUNT BUTTON ===========================
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // <<< Login Info ==================================================

            // >>> Show Loader When Authentication =============================
            if (isLoading) ...[
              Positioned.fill(
                child: Stack(
                  children: [
                    // Dark transparent background
                    Container(color: Colors.black.withValues(alpha: 0.35),),

                    // Center loading card
                    Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20,),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, 6),),],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),
                            SizedBox(height: 10),
                            Text("Please wait...", style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 1)),),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]
            // <<< Show Loader When Authentication =============================
          ],
        ),
      ),
    );
  }
}
