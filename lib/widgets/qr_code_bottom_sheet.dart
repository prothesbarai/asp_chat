import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import '../features/set_user_image/user_image_provider/user_image_provider.dart';


class QrCodeBottomSheet extends StatefulWidget {
  final String qrData;
  final String userName;
  final String userHandle;
  const QrCodeBottomSheet({super.key, required this.qrData, required this.userName, required this.userHandle});

  @override
  State<QrCodeBottomSheet> createState() => _QrCodeBottomSheetState();
}

class _QrCodeBottomSheetState extends State<QrCodeBottomSheet> {

  final ScreenshotController screenshotController = ScreenshotController();

  // >>> Generate vCard string =================================================
  String get vCardData => "BEGIN:VCARD\nVERSION:3.0\nN:${widget.userName};;;\nFN:${widget.userName}\nUID:${widget.userHandle}\nEMAIL:${widget.qrData}\nEND:VCARD";
  // <<< Generate vCard string =================================================


  /// >>> Share screenshot image ===============================================
  Future<void> _shareQrCode() async {
    try {
      final Uint8List? imageBytes = await screenshotController.capture();
      if (imageBytes == null) return;
      final tempDir = await getTemporaryDirectory();
      final file = await File('${tempDir.path}/contact_qr.png').writeAsBytes(imageBytes);
      _safeShare(files: [XFile(file.path)], text: "Contact QR");
    } catch (e) {
      debugPrint("Error sharing QR code: $e");
    }
  }
  /// <<< Share screenshot image ===============================================



  /// >>> Share Function =======================================================
  void _safeShare({dynamic files,String? subject,required String text}) async {
    try {
      await SharePlus.instance.share(ShareParams(files : files, subject: subject, text: text));
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }
  /// <<< Share Function =======================================================

  @override
  Widget build(BuildContext context) {

    final imageProvider = Provider.of<UserImageProvider>(context);

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),),
      child: SafeArea(
        child: Column(
          children: [
            // >>> Header with Close Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context),),
                  const Spacer(),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // >>> Avatar + Name + Handle With Screenshot ======================
            Screenshot(
              controller: screenshotController,
              child: Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 28,
                          backgroundColor: (imageProvider.profileImage == null) ? Color(0xff1f2b3b) : null,
                          backgroundImage: (imageProvider.profileImage != null) ? FileImage(imageProvider.profileImage!) : null,
                          child: (imageProvider.profileImage == null) ? Icon(Icons.person, size: 28,) : null,
                        ),

                        const SizedBox(height: 8),
                        Text(widget.userName, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6)),),
                        Text(widget.userHandle, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),),),
                      ],
                    ),
                    const SizedBox(height: 24),
                    QrImageView(data: vCardData, size: 220, backgroundColor: Colors.white,),
                  ],
                ),
              ),
            ),
            // <<< Avatar + Name + Handle With Screenshot ======================

            const Spacer(),

            // >>> Share Button ================================================
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(icon: const Icon(Icons.share), label: const Text("Share QR Code"), onPressed: _shareQrCode,),
              ),
            ),
            // <<< Share Button ================================================
          ],
        ),
      ),
    );
  }
}
