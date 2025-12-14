import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:video_player/video_player.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../../utils/constant/app_colors.dart';

class FullScreenVideoPlayer extends StatefulWidget {
  final String url;
  final String title;
  const FullScreenVideoPlayer({super.key,required this.url, required this.title});

  @override
  State<FullScreenVideoPlayer> createState() => _FullScreenVideoPlayerState();
}

class _FullScreenVideoPlayerState extends State<FullScreenVideoPlayer> {

  /// >>> Some Initialization And Check Url ====================================
  YoutubePlayerController? _youtubePlayerController;
  VideoPlayerController? _videoPlayerController;
  bool get isYoutube => YoutubePlayer.convertUrlToId(widget.url) != null;
  bool get isDirectVideo => widget.url.endsWith(".mp4") || widget.url.endsWith(".m3u8");
  /// <<< Some Initialization And Check Url ====================================


  @override
  void initState() {
    super.initState();
    // >>> First Time Portrait Mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    if(isYoutube){
      final videoId = YoutubePlayer.convertUrlToId(widget.url)!;
      _youtubePlayerController = YoutubePlayerController(initialVideoId: videoId,flags: YoutubePlayerFlags(autoPlay: true,mute: false));
    }else if(isDirectVideo){
      _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(widget.url))..initialize().then((_){_videoPlayerController!.play();setState(() {});});
    }
  }


  @override
  void dispose() {
    // >>> If User Back Then Device is Clear And Default Previous mode
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    _youtubePlayerController?.dispose();
    _videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    // >>> Check landscape mode
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    // >>> When Landscape then Full-Screen
    if(isLandscape){
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    }else{
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    return Scaffold(
      appBar: isLandscape ? null : AppBar(title: Text(widget.title,style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),)),),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: AppColors.videoPageGradient,),),
        child: isLandscape ?
        Center(
          child: isYoutube && _youtubePlayerController != null ? YoutubePlayer(controller: _youtubePlayerController!, showVideoProgressIndicator: true,) :
          isDirectVideo && _videoPlayerController != null && _videoPlayerController!.value.isInitialized ? AspectRatio(aspectRatio: _videoPlayerController!.value.aspectRatio, child: VideoPlayer(_videoPlayerController!),) : LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),
        ):
        Column(
          children: [
            SizedBox(height: 200,),
            isYoutube && _youtubePlayerController != null ? YoutubePlayer(controller: _youtubePlayerController!, showVideoProgressIndicator: true,) :
            isDirectVideo && _videoPlayerController != null && _videoPlayerController!.value.isInitialized ? AspectRatio(aspectRatio: _videoPlayerController!.value.aspectRatio, child: VideoPlayer(_videoPlayerController!),) : LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),
          ],
        )
      ),

    );
  }
}
