import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:video_player/video_player.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';


class EntertainmentScreen extends StatefulWidget {
  const EntertainmentScreen({super.key});

  @override
  State<EntertainmentScreen> createState() => _EntertainmentScreenState();
}

class _EntertainmentScreenState extends State<EntertainmentScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  List<Map<String, dynamic>> videos = [];
  bool loading = true;

  final String defaultThumbnail = 'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRW1WFWLAdUk4Uf4vzvwezXvAFnh6eCjY5oHw&s';

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    setState(() {loading = true;});
    try {
      final doc = await firestore.collection("users").doc("qSRgDkA5JeYbziW4k8apXssN1dC2").get();
      if (!doc.exists) {return;}
      final data = doc.data();
      final entertainment = data?['entertainment'];
      if (entertainment == null || entertainment is! Map) {return;}

      List<Map<String, dynamic>> tempVideos = [];

      entertainment.forEach((key, value) {
        if (value is Map<String, dynamic>) {
          tempVideos.add(value);
        }
      });

      setState(() {videos = tempVideos;});
    } catch (e) {
      debugPrint("Data fetch error: $e");
    } finally {
      setState(() => loading = false);
    }
  }


  bool isYoutubeUrl(String url) => YoutubePlayer.convertUrlToId(url) != null;
  bool isDirectVideoUrl(String url) => url.endsWith(".mp4") || url.endsWith(".m3u8");
  void openMedia(String url) {
    if (isYoutubeUrl(url) || isDirectVideoUrl(url)) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => FullscreenVideoPlayer(url: url),),);
    } else {
      Navigator.push(context, MaterialPageRoute(builder: (_) => FullscreenWebView(url: url),),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Smart Video Player")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : videos.isEmpty
          ? Center(child: Text("No videos found" ,style: TextStyle(color: Colors.black45),))
          : GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 8, mainAxisSpacing: 8, childAspectRatio: 16 / 9,),
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          final thumbnail = video['thumbnail'] != null && video['thumbnail'] != "" ? video['thumbnail'] : defaultThumbnail;
          return GestureDetector(
            onTap: () => openMedia(video['url']),
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.network(
                    thumbnail,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.network(defaultThumbnail),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: Colors.black54,
                    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 6),
                    child: Text(
                      video['title'] ?? "No Title",
                      style: const TextStyle(color: Colors.white, fontSize: 14),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// Fullscreen video player for YouTube and direct video links
class FullscreenVideoPlayer extends StatefulWidget {
  final String url;
  const FullscreenVideoPlayer({required this.url, super.key});

  @override
  State<FullscreenVideoPlayer> createState() => _FullscreenVideoPlayerState();
}

class _FullscreenVideoPlayerState extends State<FullscreenVideoPlayer> {
  YoutubePlayerController? ytController;
  VideoPlayerController? videoController;

  bool get isYoutube => YoutubePlayer.convertUrlToId(widget.url) != null;
  bool get isDirectVideo =>
      widget.url.endsWith(".mp4") || widget.url.endsWith(".m3u8");

  @override
  void initState() {
    super.initState();

    /// 🔒 শুরুতেই Portrait রাখছি
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (isYoutube) {
      final videoId = YoutubePlayer.convertUrlToId(widget.url)!;
      ytController = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: true,
          enableCaption: true,
        ),
      );
    } else if (isDirectVideo) {
      videoController =
      VideoPlayerController.networkUrl(Uri.parse(widget.url))
        ..initialize().then((_) {
          videoController!.play();
          setState(() {});
        });
    }
  }

  @override
  void dispose() {
    /// 🔓 Back করলে সব আগের মতো
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    ytController?.dispose();
    videoController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    /// 🌈 Landscape হলে Fullscreen
    if (isLandscape) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    } else {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    }

    return Scaffold(
      appBar: isLandscape
          ? null
          : AppBar(
        title: Text(isYoutube ? "YouTube Video" : "Video Player"),
      ),
      body: Center(
        child: isYoutube && ytController != null
            ? YoutubePlayer(
          controller: ytController!,
          showVideoProgressIndicator: true,
        )
            : isDirectVideo &&
            videoController != null &&
            videoController!.value.isInitialized
            ? AspectRatio(
          aspectRatio: videoController!.value.aspectRatio,
          child: VideoPlayer(videoController!),
        )
            : const CircularProgressIndicator(),
      ),
    );
  }
}


// Fullscreen WebView for websites
class FullscreenWebView extends StatelessWidget {
  final String url;
  const FullscreenWebView({required this.url, super.key});

  @override
  Widget build(BuildContext context) {
    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(url));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Website"),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context),),
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}
