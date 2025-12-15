import 'package:asp_chat/authentications/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../utils/constant/app_colors.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  int currentField = 1;


  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// >>> Registration Successfully Popup Dialogue =============================
  void showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),),
          title: Text("Success 🎉", textAlign: TextAlign.center,style: TextStyle(color: AppColors.primaryColor),),
          content: Text("Registration completed successfully!", textAlign: TextAlign.center,style: TextStyle(color: AppColors.primaryColor)),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false,);
              },
              child: const Text("OK"),
            )
          ],
        );
      },
    );
  }
  /// <<< Registration Successfully Popup Dialogue =============================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Stack(
          children: [
            // >>> Gradient Background =========================================
            Container(decoration: BoxDecoration(gradient: LinearGradient(colors: AppColors.registrationGradient, begin: Alignment.topLeft, end: Alignment.bottomRight,),),),
            // <<< Gradient Background =========================================

            // >>> Wavy Header =================================================
            ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 300,
                decoration: BoxDecoration(gradient: LinearGradient(colors: [AppColors.primaryColor, AppColors.secondaryColor], begin: Alignment.topLeft, end: Alignment.bottomRight,),),
                child: Center(child: Text("Create Account", style: TextStyle(color: Colors.white.withValues(alpha: 0.1), fontSize: 32, fontWeight: FontWeight.bold,),),),
              ),
            ),
            // <<< Wavy Header =================================================

            // >>> Registration Form ===========================================
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // >>> NAME FIELD ======================================
                        if (currentField >= 1)...[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: "Name",
                                  filled: false,
                                  hintStyle: TextStyle(color: Colors.white70),
                                  prefixIcon: Padding(padding: const EdgeInsets.only(left: 15.0), child: Icon(Icons.person, color: Colors.white, size: 20,),),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  counterStyle: TextStyle(color: Colors.white)
                              ),
                              keyboardType: TextInputType.name,
                              maxLength: 30,
                              cursorColor: Colors.white,
                              controller: _nameController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onChanged: (value) {setState(() {currentField = 2;});},
                              validator: (value){
                                if(value == null || value.trim().isEmpty){
                                  return "Field is Empty";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                        // <<< NAME FIELD ======================================

                        // >>> EMAIL FIELD =====================================
                        if (currentField >= 2)...[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: "Email",
                                  filled: false,
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
                              onChanged: (value) {
                                setState(() {
                                  if (RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(value)){
                                    currentField = 3;
                                  }
                                });
                              },
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
                          SizedBox(height: 16),
                        ],
                        // <<< EMAIL FIELD =====================================

                        // >>> PHONE FIELD =====================================
                        if (currentField >= 3)...[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: "Phone",
                                  filled: false,
                                  hintStyle: TextStyle(color: Colors.white70),
                                  prefixIcon: Padding(padding: const EdgeInsets.only(left: 15.0), child: Icon(Icons.phone, color: Colors.white, size: 20,),),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  counterStyle: TextStyle(color: Colors.white)
                              ),
                              keyboardType: TextInputType.phone,
                              maxLength: 50,
                              cursorColor: Colors.white,
                              controller: _phoneController,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onChanged: (value) {
                                setState(() {
                                  if (value.length == 11 && RegExp(r'^(01[3-9])[0-9]{8}$').hasMatch(value)){
                                    currentField = 4;
                                  }
                                });
                              },
                              validator: (value){
                                if(value == null || value.trim().isEmpty){
                                  return "Field is Empty";
                                }
                                if (!RegExp(r'^[0-9]+$').hasMatch(value)){
                                  return "Invalid Number";
                                }
                                value = value.trim().replaceAll('+', '');
                                if (value.length != 11) {
                                  return "Must 11 Digit";
                                }
                                final pattern = RegExp(r'^(01[3-9])[0-9]{8}$');
                                if (!pattern.hasMatch(value)) {
                                  return "Invalid Number";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                        ],
                        // <<< PHONE FIELD =====================================

                        // >>> PASSWORD FIELD ==================================
                        if (currentField >= 4)...[
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
                              onChanged: (value){
                                setState(() {
                                  if (value.length >= 8 && RegExp(r'^(?=.*[A-Z])(?=.*[a-z])(?=.*[0-9])(?=.*[!@#$%^&*{}()\\.+=?/_-]).{8,}$').hasMatch(value)){
                                    currentField = 5;
                                  }
                                });
                              },
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
                        ],
                        // <<< PASSWORD FIELD ==================================

                        // >>> CONFIRM PASSWORD FIELD ==========================
                        if (currentField >= 5)...[
                          Container(
                            margin: EdgeInsets.symmetric(horizontal: 40),
                            child: TextFormField(
                              style: TextStyle(color: Colors.white),
                              decoration: InputDecoration(
                                  hintText: "Confirm Pass",
                                  filled: false,
                                  hintStyle: TextStyle(color: Colors.white70),
                                  prefixIcon: Padding(padding: const EdgeInsets.only(left: 15.0), child: Icon(Icons.lock, color: Colors.white, size: 20,),),
                                  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 15),
                                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white),borderRadius: BorderRadius.circular(35)),
                                  suffixIcon: Padding(padding: const EdgeInsets.only(right: 8.0),child: IconButton(
                                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Colors.white,),
                                    onPressed: () {
                                      setState(() {_obscureConfirmPassword = !_obscureConfirmPassword;});
                                    },
                                  ),),
                                  counterStyle: TextStyle(color: Colors.white)
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              maxLength: 22,
                              cursorColor: Colors.white,
                              controller: _confirmPasswordController,
                              obscureText: _obscureConfirmPassword,
                              autovalidateMode: AutovalidateMode.onUserInteraction,
                              onChanged: (value){
                                setState(() {
                                  if (value == _passwordController.text){
                                    currentField = 6;
                                  }
                                });
                              },
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return "Field is Empty";
                                }
                                if (value != _passwordController.text) {
                                  return "Pass Not match";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                        // <<< CONFIRM PASSWORD FIELD ==========================

                        // >>> Registration Button =============================
                        SizedBox(
                          width: 200,
                          height: 48,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.buttonBgColor, foregroundColor: AppColors.primaryColor, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30),),),
                            onPressed: isLoading || currentField != 6 ? null :() async{
                              FocusScope.of(context).unfocus();
                              if(currentField == 6 &&_formKey.currentState!.validate()){
                                String name = _nameController.text.trim();
                                String email = _emailController.text.trim();
                                String phone = _phoneController.text.trim();
                                String password = _confirmPasswordController.text.trim();
                                try{
                                  setState(() {isLoading = true;});
                                  // >>> Create user
                                  UserCredential userCrendetial = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);
                                  // >>> Update display name
                                  await userCrendetial.user!.updateDisplayName(name);
                                  // >>> Save phone & other info in Firestore
                                  await FirebaseFirestore.instance.collection("users").doc(userCrendetial.user!.uid).set({
                                    "name": name,
                                    "email": email,
                                    "phone": phone,
                                    "status": "Unavailable",
                                    "entertainment": {
                                      "video1" : {
                                        "thumbnail": "",
                                        "title": "",
                                        "url" : ""
                                      }
                                    },
                                    "uid": userCrendetial.user!.uid,
                                    "createdAt": FieldValue.serverTimestamp(),
                                  });

                                  setState(() {isLoading = false;currentField == 1;});
                                  // >>> Clear Fields
                                  _nameController.clear();
                                  _emailController.clear();
                                  _phoneController.clear();
                                  _passwordController.clear();
                                  _confirmPasswordController.clear();
                                  if(!mounted) return;
                                  // >>> Show Popup
                                  showSuccessDialog();
                                }catch(err){
                                  debugPrint("Error $err");
                                }
                              }
                            },
                            child: Text("Register", style: TextStyle(fontSize: 18),),
                          ),
                        ),
                        // <<< Registration Button =============================

                        /// >>> =============== IF Already His / Her Account Exists so Login Here =================
                        SizedBox(height: 25),
                        InkWell(
                          onTap:()=>Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginScreen()), (Route<dynamic> route) => false,),
                          child: Text("Already have an account ? Login",style: TextStyle(color: AppColors.buttonBgColor),),
                        ),
                        /// <<< =============== IF Already His / Her Account Exists so Login Here =================

                      ],
                    ),
                  ),
                ),
              ),
            ),
            // <<< Registration Form ===========================================

            // >>> Show Loader When Update Database ============================
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
            // <<< Show Loader When Update Database ============================

          ],
        ),
      ),
    );
  }
}

// >>> Custom wave clipper =====================================================
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 50);
    var firstControlPoint = Offset(size.width / 4, size.height);
    var firstEndPoint = Offset(size.width / 2, size.height - 50);
    var secondControlPoint = Offset(size.width * 3 / 4, size.height - 100);
    var secondEndPoint = Offset(size.width, size.height - 50);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy, firstEndPoint.dx, firstEndPoint.dy);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy, secondEndPoint.dx, secondEndPoint.dy);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }
  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
// <<< Custom wave clipper =====================================================
