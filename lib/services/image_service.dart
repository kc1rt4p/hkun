import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class ImageService {
  final _imagePicker = ImagePicker();

  Future<File?> pickImage(BuildContext context) async {
    final image = await showModalBottomSheet<XFile?>(
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Select image from',
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
              SizedBox(height: 20.0),
              _buildModalButton(
                label: 'Gallery',
                onTap: () async {
                  final permissionStatus = await Permission.storage.request();

                  if (!permissionStatus.isGranted) return;

                  final image =
                      await _imagePicker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, image);
                },
              ),
              Divider(),
              _buildModalButton(
                label: 'Camera',
                onTap: () async {
                  final permissionStatus = await Permission.camera.request();

                  if (!permissionStatus.isGranted) return;
                  final image =
                      await _imagePicker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, image);
                },
              ),
              Divider(),
              _buildModalButton(
                label: 'Cancel',
                color: Colors.red.shade400,
                onTap: () => Navigator.pop(context, null),
              ),
            ],
          ),
        );
      },
    );

    if (image == null) return null;

    final file = File(image.path);

    return file;
  }

  Widget _buildModalButton({
    required String label,
    required Function() onTap,
    Color? color,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Text(
          label,
          style: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w600,
            color: color ?? Colors.black,
          ),
        ),
      ),
    );
  }
}
