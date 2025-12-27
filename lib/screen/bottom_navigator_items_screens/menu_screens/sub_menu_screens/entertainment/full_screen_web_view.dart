import 'package:asp_chat/utils/constant/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class FullScreenWebView extends StatefulWidget {
  final String url;
  final String title;
  const FullScreenWebView({super.key,required this.url, required this.title});

  @override
  State<FullScreenWebView> createState() => _FullScreenWebViewState();
}

class _FullScreenWebViewState extends State<FullScreenWebView> {


  late WebViewController controller;
  bool isLoading = true;
  bool isValidUrl = true;

  @override
  void initState() {
    super.initState();

    String url = widget.url;
    // >>> URL empty check
    if (url.isEmpty) {isValidUrl = false;return;}
    // >>> Missing scheme add
    if (!url.startsWith("http://") && !url.startsWith("https://")) {url = "https://$url";}

    // >>> Uri parse check
    final uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != "http" && uri.scheme != "https")) {isValidUrl = false;return;}

    // >>> if Valid URL controller set
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(onPageFinished: (url) {setState(() {isLoading = false;});},),)
      ..loadRequest(uri);
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text(widget.title,style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),)),),
      body: isValidUrl ? Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),),
        ],
      ) :
      Center(child: Text("Invalid or empty URL", style: TextStyle(fontSize: 16, color: Colors.red),)),
    );
  }
}
