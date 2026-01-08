import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  State<TranslatorScreen> createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {setState(() {_isLoading = true;});},
          onPageFinished: (url) {setState(() {_isLoading = false;});},
        ),
      )
      ..loadRequest(Uri.parse('https://translate.google.com/?sl=auto&tl=en&op=translate'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Google Translator"),),
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(controller: _controller),
            // >>> Loader Overlay
            if (_isLoading)
              Center(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.purple.shade700, Colors.blue.shade700], begin: Alignment.topLeft, end: Alignment.bottomRight,),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [BoxShadow(color: Colors.blueAccent.withValues(alpha: 0.5), offset: const Offset(0, 8), blurRadius: 20), BoxShadow(color: Colors.purple.withValues(alpha: 0.5), offset: const Offset(0, 4), blurRadius: 10),],
                  ),
                  padding: const EdgeInsets.all(25),
                  child: SizedBox(width: 36, height: 36, child: LoadingAnimationWidget.staggeredDotsWave(color: Colors.white, size: 36,),),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
