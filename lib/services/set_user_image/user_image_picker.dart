import 'dart:io';
import 'package:asp_chat/services/set_user_image/user_image_provider/user_image_provider.dart';
import 'package:asp_chat/utils/constant/app_colors.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

/// >>> ==============Set Profile Image Pick & Crop & Compressed Function Write Start Here ===================

Future<void> userProfilePickImage(BuildContext context, ImageSource source) async{
  try{
    final imageProvider = Provider.of<UserImageProvider>(context,listen: false);
    final ImagePicker imagePicker = ImagePicker();
    final originalImage = await imagePicker.pickImage(source: source);
    if(originalImage == null) return;

    // Now Print Original Image Size
    final originalImageSize = await File(originalImage.path).length();
    if(kDebugMode){print("Original Image Size : ${originalImageSize / 1024} KB\nOriginal Image Size : ${originalImageSize / (1024*1024)} MB");}


    // Now Crop Image Here
    final cropImage = await ImageCropper().cropImage(
        sourcePath: originalImage.path,
        compressFormat: ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: "Crop Image",
            toolbarColor: AppColors.primaryColor,
            toolbarWidgetColor: Colors.white,
            lockAspectRatio: true,
            hideBottomControls: false,
            initAspectRatio: CropAspectRatioPreset.square,
            cropFrameColor: AppColors.primaryColor,
            cropGridColor: AppColors.primaryColor,
            backgroundColor: AppColors.primaryColor,
            statusBarLight: true,
            /*aspectRatioPresets: [
                  CropAspectRatioPreset.square,       // 1:1
                  CropAspectRatioPreset.original,     // original
                  CropAspectRatioPreset.ratio3x2,     // 3:2
                  CropAspectRatioPreset.ratio4x3,     // 4:3
                  CropAspectRatioPreset.ratio16x9,    // 16:9
                ],*/

          ),
          IOSUiSettings(
            title: "Crop Image",
            aspectRatioLockEnabled: true,
            hidesNavigationBar: false,
            aspectRatioPickerButtonHidden: false,
            minimumAspectRatio: 1.0,

          )
        ]
    );

    if(cropImage == null) return;

    // Now Crop Image Size Print
    final cropImageSize = await File(cropImage.path).length();
    if(kDebugMode){print("Crop Image Size : ${cropImageSize / 1024} KB\nCrop Image Size : ${cropImageSize / (1024*1024)} MB");}


    // >>>  Now Image Compressed Start Here
    final tempDir = await getTemporaryDirectory();
    final tempPath = path.join(tempDir.path,"compressed_${DateTime.now().millisecondsSinceEpoch}.jpg");

    final firstCompressed = await FlutterImageCompress.compressAndGetFile(cropImage.path, tempPath,quality: 70,minHeight: 512,minWidth: 512);
    if(firstCompressed == null) return;

    final firstCompressedImgSize = await firstCompressed.length();

    // Print First Compressed
    if(kDebugMode){print("First Compressed Size : ${firstCompressedImgSize / 1024} KB");}

    // Now Check 300 KB
    if(firstCompressedImgSize > (300 * 1024)){
      final againFinalCompressed = await FlutterImageCompress.compressAndGetFile(cropImage.path, tempPath,quality: 50,minHeight: 512,minWidth: 512);

      if(againFinalCompressed != null){
        // Print Final Compressed Image
        final finalCompressedSize = await againFinalCompressed.length();
        if(kDebugMode){print("Final Compressed Image is : ${finalCompressedSize/1024} KB");}

        final permanentDirectory = await getApplicationDocumentsDirectory();
        final permanentPath = "${permanentDirectory.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg";
        await againFinalCompressed.saveTo(permanentPath);
        final permanentImage = File(permanentPath);
        await imageProvider.saveUserProfileImage(permanentImage);
      }
    }else{
      final permanentDirectory = await getApplicationDocumentsDirectory();
      final permanentPath = "${permanentDirectory.path}/profile_${DateTime.now().millisecondsSinceEpoch}.jpg";
      await firstCompressed.saveTo(permanentPath);
      final permanentImage = File(permanentPath);
      await imageProvider.saveUserProfileImage(permanentImage);
    }

  }catch(e){
    debugPrint("Something Error : $e");
  }
}
/// <<< ==============Set Profile Image Pick & Crop & Compressed Function Write End Here =====================
