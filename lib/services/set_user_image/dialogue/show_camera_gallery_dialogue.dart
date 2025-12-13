import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<void> showCameraGalleryDialogue(BuildContext context,Function(ImageSource) pickImage) async{
  return showDialog(
      context: context, 
      builder: (context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Take a Photo'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await pickImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
  );
}