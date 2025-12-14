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

  @override
  void initState() {
    super.initState();
    controller = WebViewController()..setJavaScriptMode(JavaScriptMode.unrestricted)..setNavigationDelegate(NavigationDelegate(onPageFinished: (url) {
      setState(() {isLoading = false;});
    },))..loadRequest(Uri.parse(widget.url));
  }


  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(title: Text(widget.title,style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),)),),
      body: Stack(
        children: [
          WebViewWidget(controller: controller),
          if (isLoading)
            Center(child: LoadingAnimationWidget.staggeredDotsWave(color: AppColors.primaryColor, size: 50,),),
        ],
      )
    );
  }
}
