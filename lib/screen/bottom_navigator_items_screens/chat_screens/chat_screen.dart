import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import '../../../utils/constant/app_colors.dart';
import 'chat_room.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver{ // >>> User Online / Offline State Check

  Map<String, dynamic>? userMap;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailSearchController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    /// >>> Catch User Online/Offline and set state ============================
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
    /// <<< Catch User Online/Offline and set state ============================
  }



  /// >>> Set Status & Catch User Online/Offline ===============================
  void setStatus(String status) async {
    await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).update({"status": status,});
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setStatus("Online");
    }else {
      setStatus("Offline");
    }
    super.didChangeAppLifecycleState(state);
  }
  /// <<< Set Status & Catch User Online/Offline ===============================



  /// >>> Search Button Logic and Create And Set DB Chat Room ID ===============
  // >>> Create Chat Room ID Based On User name 1st letter ASCII value
  String chatRoomID(String user1, String user2){
    if(user1[0].toLowerCase().codeUnits[0] > user2.toLowerCase().codeUnits[0]){
      return "$user1$user2";
    }else{
      return "$user2$user1";
    }
  }
  // >>> Show Message
  void showMessage(String message){ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)),);}
  // >>> Search Functions
  void onSearch() async{
    if(!mounted) return;
    setState(() {isLoading = true;});
    var result = await _firebaseFirestore.collection('users').where("email", isEqualTo: _emailSearchController.text).get();
    if(result.docs.isEmpty){
      if(!mounted) return;
      setState(() {isLoading = false; userMap = null;});
      showMessage("User not found");
      return;
    }
    var searchedUser = result.docs.first.data();

    // >>> PREVENT SELF CHAT
    if(searchedUser['uid'] == _auth.currentUser!.uid){
      if(!mounted) return;
      setState(() {isLoading = false;userMap = null;});
      showMessage("You can't chat with yourself");
      return;
    }

    if(!mounted) return;
    setState(() {userMap = searchedUser;isLoading = false;});
  }
  /// <<< Search Button Logic and Create And Set DB Chat Room ID ===============



  /// >>> Navigate ChatRoom ====================================================
  void navigateChatRoom({required String chatRoomId, required Map<String, dynamic> userMapData}){
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatRoom(chatRoomId: chatRoomId, userMap: userMapData,),),);
  }
  /// <<< Navigate ChatRoom ====================================================


  @override
  void dispose() {
    _emailSearchController.dispose();
    /// >>> Catch User Online/Offline ==========================================
    WidgetsBinding.instance.removeObserver(this);
    /// <<< Catch User Online/Offline ==========================================
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: isLoading ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),):
          GestureDetector(
            onTap: ()=>FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: Column(
              children: [
                /// >>> Search Box & Button ====================================
                SizedBox(height: size.height * 0.03,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Form(
                    key: _formKey,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.only(left: 10,right: 5),
                              child: TextFormField(
                                style: TextStyle(color: AppColors.primaryColor),
                                decoration: InputDecoration(
                                    filled: false,
                                    hintText: "Search by email",
                                    hintStyle: TextStyle(color: AppColors.primaryColor.withValues(alpha: 0.6)),
                                    prefixIcon: Padding(padding: const EdgeInsets.only(left: 15.0), child: Icon(Icons.email_outlined, color: AppColors.primaryColor, size: 20,),),
                                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor),borderRadius: BorderRadius.circular(35)),
                                    border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor),borderRadius: BorderRadius.circular(35)),
                                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor),borderRadius: BorderRadius.circular(35)),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                cursorColor: AppColors.primaryColor,
                                controller: _emailSearchController,
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
                          ),
                          ElevatedButton(
                            onPressed: () {if (_formKey.currentState!.validate()) {onSearch();}},
                            style: ElevatedButton.styleFrom(shape: CircleBorder(), backgroundColor: Colors.white, padding: EdgeInsets.all(10),),
                            child: Icon(Icons.search, color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      )
                  ),
                ),
                /// <<< Search Box & Button ====================================


                /// >>> Search Result Show Here ================================
                SizedBox(height: size.height * 0.03,),
                userMap != null ?
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text("Searching Result" ,style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black,),textAlign: TextAlign.start,),
                        SizedBox(height: 5,),
                        _buildChatItems(
                            title: userMap!['name'],
                            subTitle: userMap!['email'],
                            onTap: () async{
                              String roomId = chatRoomID(_auth.currentUser!.displayName!, userMap!['name']);
                              await _firebaseFirestore.collection("chatroom").doc(roomId).set({
                                "users" : [_auth.currentUser!.uid,userMap!['uid']],
                                "lastMessage": "",
                                "updatedAt": FieldValue.serverTimestamp(),
                              },SetOptions(merge: true));
                              if(!mounted) return;
                              navigateChatRoom(chatRoomId: roomId, userMapData: userMap!);
                            }
                        ),
                      ],
                    )
                    :SizedBox.shrink(),
                Divider(),
                /// <<< Search Result Show Here ================================


                /// >>> Show Existing Chat =====================================
                SizedBox(height: size.height * 0.03,),
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance.collection("chatroom").where("users", arrayContains: _auth.currentUser!.uid).orderBy("updatedAt", descending: true).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {return Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),);}
                      var docs = snapshot.data!.docs;
                      return ListView.builder(
                        itemCount: docs.length + 1,
                        itemBuilder: (context, index) {
                          if(index == 0){return Padding(
                            padding: const EdgeInsets.only(left: 12.0,bottom: 8.0),
                            child: Text("Old Friend's",style: TextStyle(color: Theme.of(context).colorScheme.primary,fontWeight: FontWeight.bold,fontSize: 20),),
                          );}
                          var room = docs[index - 1];
                          List users = room['users'];
                          String? otherUserId = users.firstWhere((u) => u != _auth.currentUser!.uid, orElse: () => null,);
                          if (otherUserId == null) return const SizedBox(); // skip invalid room
                          return FutureBuilder<DocumentSnapshot>(
                            future: FirebaseFirestore.instance.collection("users").doc(otherUserId).get(),
                            builder: (context, userSnap) {
                              if (!userSnap.hasData) return SizedBox();
                              var user = userSnap.data!;
                              return _buildChatItems(
                                title: user['name'],
                                subTitle: user['email'],
                                onTap: () {navigateChatRoom(chatRoomId: room.id, userMapData: user.data() as Map<String, dynamic>);},
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ),

                /// <<< Show Existing Chat =====================================
              ],
            ),
          )

    );
  }



  /// >>> Chat Item Design Start Here ==========================================
  Widget _buildChatItems({required String title, required String subTitle, required onTap}){
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: AppColors.primaryColor),),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Icon(Icons.person,color: Theme.of(context).colorScheme.surface,),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 15, fontWeight: FontWeight.w500,),),
                    Text(subTitle, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 11, fontWeight: FontWeight.normal,),),
                  ],
                ),
                Spacer(),
                Icon(Icons.chat, color: Theme.of(context).colorScheme.primary),
              ],
            ),
          ),
        ),
      ),
    );
  }
  /// <<< Chat Item Design Start Here ==========================================
}




