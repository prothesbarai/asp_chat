import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'ChatRoom.dart';


class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> with WidgetsBindingObserver{ // >>> User Online / Offline
  Map<String,dynamic>? userMap;
  bool isLoading = false;
  final TextEditingController textEditingController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;


  @override
  void initState() {
    super.initState();
    /// >>> Catch User Online/Offline ==========================================
    WidgetsBinding.instance.addObserver(this);
    setStatus("Online");
  }


  /// >>> Set Status Online/Offline ============================================
  void setStatus(String status) async {
    await _firebaseFirestore.collection('users').doc(_auth.currentUser!.uid).update({"status": status,});
  }
  /// <<< Set Status Online/Offline ============================================



  /// >>> Catch User Online/Offline ============================================
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if(state == AppLifecycleState.resumed){
      setStatus("Online");
    }else {
      setStatus("Offline");
    }
    super.didChangeAppLifecycleState(state);
  }
  /// <<< Catch User Online/Offline ============================================





  String chatRoomId(String user1, String user2) {
    if (user1[0].toLowerCase().codeUnits[0] >
        user2.toLowerCase().codeUnits[0]) {
      return "$user1$user2";
    } else {
      return "$user2$user1";
    }
  }

  void onSearch() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    setState(() {
      isLoading = true;
    });

    await firestore
        .collection('users')
        .where("email", isEqualTo: textEditingController.text)
        .get()
        .then((value) {
      setState(() {
        userMap = value.docs[0].data();
        isLoading = false;
      });
    });
  }







  @override
  void dispose() {
    textEditingController.dispose();
    /// >>> Catch User Online/Offline ==========================================
    WidgetsBinding.instance.removeObserver(this);
    /// <<< Catch User Online/Offline ==========================================
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: (){},
        child: Icon(Icons.group),
      ),
      /*body: isLoading ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),):
          Column()*/

      body: isLoading
          ? Center(
        child: SizedBox(
          height: size.height / 20,
          width: size.height / 20,
          child: CircularProgressIndicator(),
        ),
      )
          : Column(
        children: [
          SizedBox(
            height: size.height / 20,
          ),
          Container(
            height: size.height / 14,
            width: size.width,
            alignment: Alignment.center,
            child: SizedBox(
              height: size.height / 14,
              width: size.width / 1.15,
              child: TextField(
                controller: textEditingController,
                decoration: InputDecoration(
                  hintText: "Search",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height / 50,
          ),
          ElevatedButton(
            onPressed: onSearch,
            child: Text("Search"),
          ),
          SizedBox(height: size.height / 30,),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('chatroom')
                  .where("users", arrayContains: _auth.currentUser!.uid)
                  .orderBy("updatedAt", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var room = snapshot.data!.docs[index];
                    List users = room['users'];
                    String otherUserId =
                    users.firstWhere((u) => u != _auth.currentUser!.uid);

                    return FutureBuilder<DocumentSnapshot>(
                      future: FirebaseFirestore.instance
                          .collection("users")
                          .doc(otherUserId)
                          .get(),
                      builder: (context, userSnap) {
                        if (!userSnap.hasData) return SizedBox();

                        var user = userSnap.data!;
                        return ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text(user['name']),
                          subtitle: Text(user['email']),
                          trailing: Icon(Icons.chat),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatRoom(
                                  chatRoomId: room.id,
                                  userMap: user.data() as Map<String, dynamic>,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),


          SizedBox(height: size.height / 30,),
          userMap != null
              ? ListTile(
            onTap: () async {
              String roomId = chatRoomId(_auth.currentUser!.displayName!, userMap!['name']);

              // 🔹 CREATE / UPDATE CHATROOM
              await _firebaseFirestore
                  .collection('chatroom')
                  .doc(roomId)
                  .set({
                "users": [
                  _auth.currentUser!.uid,
                  userMap!['uid'],
                ],
                "lastMessage": "",
                "updatedAt": FieldValue.serverTimestamp(),
              }, SetOptions(merge: true));
              if(!mounted) return;
              Navigator.of(context).push(MaterialPageRoute(builder: (_) => ChatRoom(chatRoomId: roomId, userMap: userMap!,),),);
            },
            leading: Icon(Icons.account_box, color: Colors.black),
            title: Text(
              userMap!['name'],
              style: TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Text(userMap!['email']),
            trailing: Icon(Icons.chat, color: Colors.black),
          )
              : Container(),
        ],
      ),
    );
  }
}