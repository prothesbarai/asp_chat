import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

void imagePopUpDialogue(BuildContext context, String imgUrl) {
  if(imgUrl.isEmpty ) return;
  showDialog(
    context: context,
    builder: (context) => Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          children: [
            // >>> The Image ===================================================
            CachedNetworkImage(
              imageUrl: imgUrl,
              placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.contain,
            ),
            // <<< The Image ===================================================

            // >>> Close Button ================================================
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.circle,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.close,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
            // <<< Close Button ================================================
          ],
        ),
      ),
    ),
  );
}
