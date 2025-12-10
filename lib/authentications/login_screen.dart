import 'package:asp_chat/authentications/registration_screen.dart';
import 'package:asp_chat/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';

import '../services/font_theme/font_selector_widget.dart';

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
  bool isChecked = false;


  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.loginGradiant,),),
        child: Center(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [

                    // >>> USER ICON & TITLE ===================================
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: Colors.white70, width: 2),),
                      child: Icon(Icons.person, size: 60, color: Colors.white,),
                    ),
                    SizedBox(height: 20),
                    Text("MEMBER LOGIN", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold,),),
                    SizedBox(height: 30),
                    // <<< USER ICON & TITLE ===================================

                    // >>> EMAIL FIELD =========================================
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
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
                    // <<< EMAIL FIELD =========================================

                    // >>> PASSWORD FIELD ======================================
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: TextFormField(
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: "Password",
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
                    // <<< PASSWORD FIELD ======================================


                    // >>> REMEMBER ME + FORGOT PASSWORD =======================
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (value) {
                                  setState(() {isChecked = value ?? false;});
                                },
                                side: BorderSide(color: Colors.white),
                                checkColor: Colors.green,
                                activeColor: Colors.white,
                              ),
                              Text("Remember me", style: TextStyle(color: Colors.white)),
                            ],
                          ),

                          Expanded(
                            child: TextButton(
                              onPressed: (){

                              },
                              child: Text("Forgot password?",style: TextStyle(color: AppColors.buttonBgColor),),
                            ),
                          ),

                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    // <<< REMEMBER ME + FORGOT PASSWORD =======================


                    // >>> LOGIN BUTTON ========================================
                    SizedBox(
                      width: 200,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonBgColor, foregroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                          onPressed: isLoading? null :() async{
                            FocusScope.of(context).unfocus();
                            if(_formKey.currentState!.validate()){
                              String email = _emailController.text.trim();
                              String password = _passwordController.text.trim();
                              try{
                                setState(() {isLoading = true;});


                                setState(() => isLoading = false);
                              }catch(err){
                                debugPrint("Error $err");
                              }
                            }
                          },
                        child: Text("Login", style: TextStyle(fontSize: 18),),
                      ),
                    ),
                    SizedBox(height: 20),
                    // <<< LOGIN BUTTON ========================================


                    Text("Not a member?", style: TextStyle(color: Colors.white70, fontSize: 14,),),
                    SizedBox(height: 10),

                    // >>> CREATE ACCOUNT BUTTON ===============================
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
                    // <<< CREATE ACCOUNT BUTTON ===============================
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
