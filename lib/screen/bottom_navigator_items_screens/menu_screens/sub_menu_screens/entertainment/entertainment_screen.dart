import 'package:asp_chat/screen/bottom_navigator_items_screens/menu_screens/sub_menu_screens/entertainment/full_screen_video_player.dart';
import 'package:asp_chat/screen/bottom_navigator_items_screens/menu_screens/sub_menu_screens/entertainment/full_screen_web_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../../providers/user_info_provider.dart';
import '../../../../../utils/constant/app_colors.dart';
import '../../../../../utils/constant/network_status_widgets.dart';

class EntertainmentScreen extends StatefulWidget {
  const EntertainmentScreen({super.key});

  @override
  State<EntertainmentScreen> createState() => _EntertainmentScreenState();
}

class _EntertainmentScreenState extends State<EntertainmentScreen> {

  /// >>> Initially Some Variable and Firebase Cloud Declaration ===============
  final FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  List<Map<String,dynamic>> videos = [];
  bool isLoading = false;
  String defaultPlaceholder = "https://prothesbarai.github.io/collect/placeholder.png";
  /// <<< Initially Some Variable and Firebase Cloud Declaration ===============


  @override
  void initState() {
    super.initState();
    _fetchVideo();
  }


  /// >>> Fetch Entertainment Video List Based On Specific User Id =============
  Future<void> _fetchVideo() async{
    setState(() {isLoading = true;});
    try{
      final userData = Provider.of<UserInfoProvider>(context,listen: false);
      if(userData.userInfo?["uid"] == null || userData.userInfo?["uid"].isEmpty) {
        final user = FirebaseAuth.instance.currentUser;
        if(user == null) return;
        final uid = user.uid;
        final document = await firebaseFirestore.collection("users").doc(uid).get();
        if(!document.exists) return;
        final data = document.data();
        final entertainment = data?['entertainment'];
        if(entertainment == null && entertainment is! Map) return;
        List<Map<String,dynamic>> tempVideos = [];
        entertainment.forEach((key,value){
          if(value is Map<String, dynamic>){
            tempVideos.add(value);
          }
        });
        setState(() {videos = tempVideos;});
      }else{
        final uid = userData.userInfo?["uid"];
        final document = await firebaseFirestore.collection("users").doc(uid).get();
        if(!document.exists) return;
        final data = document.data();
        final entertainment = data?['entertainment'];
        if(entertainment == null && entertainment is! Map) return;
        List<Map<String,dynamic>> tempVideos = [];
        entertainment.forEach((key,value){
          if(value is Map<String, dynamic>){
            tempVideos.add(value);
          }
        });
        setState(() {videos = tempVideos;});
      }
    }catch(e){
      debugPrint("Data fetch error: $e");
    }finally{
      setState(() {isLoading = false;});
    }
  }
  /// <<< Fetch Entertainment Video List Based On Specific User Id =============


  /// >>> Check Url Based Navigate =============================================
  bool isYoutubeUrl(String url) => YoutubePlayer.convertUrlToId(url) != null;
  bool isDirectVideoUrl(String url) => url.endsWith(".mp4") || url.endsWith(".m3u8");
  void openMedia(String url, String title){
    if(isYoutubeUrl(url) || isDirectVideoUrl(url)){
      Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenVideoPlayer(url: url,title: title,),));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => FullScreenWebView(url: url,title: title,),));
    }
  }
  /// <<< Check Url Based Navigate =============================================


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Entertainment",style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),)),
        body: isLoading ? Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),) : videos.isEmpty ? Center(child: Text("No videos found"),) :
        SafeArea(
          child: GridView.builder(
            padding: EdgeInsets.symmetric(vertical:  10,horizontal: 10),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 8,mainAxisSpacing: 8,childAspectRatio: 16/9),
            itemCount: videos.length,
            itemBuilder: (context, index) {
              final video = videos[index];
              final thumbnail = video['thumbnail'] != null && video['thumbnail'] != "" ? video['thumbnail'] : defaultPlaceholder;
              return GestureDetector(
                onTap: ()=> openMedia(video['url'],video['title']),
                child: Stack(
                  children: [
                    Positioned.fill(
                        child: CachedNetworkImage(
                          imageUrl: thumbnail,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(child: NetworkStatusWidgets.loader(context, url),),
                          errorWidget: (context, url, error) => NetworkStatusWidgets.error(context, url, error),
                        )
                    ),
                    Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          color: Colors.black54,
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                          child: Text(video['title'],style: TextStyle(color: Colors.white, fontSize: 14),maxLines: 2, overflow: TextOverflow.ellipsis,),
                        )
                    ),
                  ],
                ),
              );
            },
          ),
        )
    );
  }
}
