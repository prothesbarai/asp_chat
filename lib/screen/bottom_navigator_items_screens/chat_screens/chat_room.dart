import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import '../../../providers/user_info_provider.dart';
import '../../../services/set_user_image/user_image_provider/user_image_provider.dart';
import '../../../utils/constant/app_colors.dart';

class ChatRoom extends StatefulWidget {
  final Map<String, dynamic> userMap;
  final String chatRoomId;
  const ChatRoom({super.key,required this.chatRoomId, required this.userMap});
  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {

  final TextEditingController _message = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;


  /// >>> On send text sms =====================================================
  void onSendMessage() async{
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": _auth.currentUser!.displayName,
        "message": _message.text,
        "type": "text",
        "time": FieldValue.serverTimestamp(),
      };
      _message.clear();
      await _firestore.collection('chatroom').doc(widget.chatRoomId).collection('chats').add(messages);
      await _firestore.collection('chatroom').doc(widget.chatRoomId).update({"lastMessage": _message.text, "updatedAt": FieldValue.serverTimestamp(),});
    }
  }
  /// <<< On send text sms =====================================================



  @override
  void dispose() {
    _message.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<UserImageProvider>(context,listen: false);
    final userProvider = Provider.of<UserInfoProvider>(context,);
    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection("users").doc(widget.userMap['uid']).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(widget.userMap['name'],style: TextStyle(color: snapshot.data!['status'] == "Online" ? Colors.green : Theme.of(context).colorScheme.secondary),),
                  Text(snapshot.data!['status'], style: TextStyle(fontSize: 10,color: snapshot.data!['status'] == "Online" ? Colors.green : Theme.of(context).colorScheme.secondary),),
                ],
              );
            } else {
              return SizedBox.shrink();
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('chatroom').doc(widget.chatRoomId).collection('chats').orderBy("time", descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {return Center(child: CircularProgressIndicator());}
                  return ListView.builder(
                    reverse: true,
                    itemCount: snapshot.data!.docs.length + 1,
                    itemBuilder: (context, index) {
                      if (index == snapshot.data!.docs.length) {
                        return FutureBuilder<Map<String,dynamic>?>(
                          future: userProvider.getUserData(),
                          builder: (context, snapshot) {

                            if(snapshot.connectionState == ConnectionState.waiting) {return  Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),);}
                            if(!snapshot.hasData || snapshot.data == null){return const Center(child: Text("User data not found"),);}

                            final userData = snapshot.data!;
                            final name = userData['name'];
                            final email = userData['email'];
                            final username = email != null ? email.split('@').first : 'prothesbarai';

                            return SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 20),
                                  // >>> PROFILE PHOTO + NAME + USERNAME =============================
                                  Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundColor: (imageProvider.profileImage == null) ? Color(0xff1f2b3b) : null,
                                        backgroundImage: (imageProvider.profileImage != null) ? FileImage(imageProvider.profileImage!) : null,
                                        child: (imageProvider.profileImage == null) ? Icon(Icons.person, size: 34,) : null,
                                      ),
                                      const SizedBox(height: 12),
                                      Text(name ?? "Prothes Barai", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface,),),
                                      const SizedBox(height: 4),
                                      Text("@$username", style: TextStyle(fontSize: 16, color: Theme.of(context).colorScheme.onSurface,),),

                                    ],
                                  ),
                                  // <<< PROFILE PHOTO + NAME + USERNAME =============================


                                ],
                              ),
                            );
                          },
                        );
                      }
                      Map<String, dynamic> map = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                      return messages(MediaQuery.of(context).size, map, context);
                    },
                  );
                },
              ),
            ),
            Padding(
                padding: const EdgeInsets.only(bottom: 8.0,left: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(left: 0,right: 0),
                        child: TextFormField(
                          style: TextStyle(color: AppColors.primaryColor),
                          decoration: InputDecoration(
                            filled: false,
                            hintText: "Write message",
                            hintStyle: TextStyle(color: AppColors.primaryColor.withValues(alpha: 0.6)),
                            prefixIcon: Padding(padding: const EdgeInsets.only(left: 5.0), child: Icon(Icons.message, color: AppColors.primaryColor, size: 20,),),
                            contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor),borderRadius: BorderRadius.circular(10)),
                            border: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor),borderRadius: BorderRadius.circular(10)),
                            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AppColors.primaryColor),borderRadius: BorderRadius.circular(10)),
                          ),
                          keyboardType: TextInputType.text,
                          cursorColor: AppColors.primaryColor,
                          controller: _message,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: onSendMessage,
                      style: ElevatedButton.styleFrom(shape: CircleBorder(), backgroundColor: Colors.white, padding: EdgeInsets.all(10),),
                      child: Icon(Icons.send, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                )
            ),
          ],
        ),
      ),
    );
  }


  Widget messages(Size size, Map<String, dynamic> map, BuildContext context) {
   return Container(
      width: size.width,
      alignment: map['sendby'] == _auth.currentUser!.displayName ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        margin: EdgeInsets.symmetric(vertical: 5, horizontal: 8),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), color: map['sendby'] == _auth.currentUser!.displayName ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary),
        child: Text(map['message'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Theme.of(context).colorScheme.surface,),),
      ),
    );
  }

}

