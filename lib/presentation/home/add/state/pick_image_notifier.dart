import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class PickImageNotifier extends StateNotifier<XFile?> {
  PickImageNotifier() : super(null);

  Future<bool> reqPermCameraGall(ImageSource source) async {
    if (source == ImageSource.camera) {
      final status = await Permission.camera.status;

      if (status.isGranted) return true;

      final result = await Permission.camera.request();

      if (result.isGranted) return true;

      if (result.isPermanentlyDenied) {
        return openAppSettings();
      }

      return false;
    } else {
      if (Platform.isAndroid) {
        final status = await Permission.storage.status;

        if (status.isGranted) return true;

        final result = await Permission.storage.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) {
          return openAppSettings();
        }

        return false;
      } else {
        final status = await Permission.photos.status;

        if (status.isGranted) return true;

        final result = await Permission.photos.request();

        if (result.isGranted) return true;

        if (result.isPermanentlyDenied) {
          return openAppSettings();
        }

        return false;
      }
    }
  }

  Future<void> onPickImage(ImageSource source) async {
    if (await reqPermCameraGall(source) == true) {
      final picked = await ImagePicker().pickImage(source: source);

      if (picked == null) return;

      final cropped = await ImageCropper().cropImage(
          sourcePath: picked.path,
          compressFormat: ImageCompressFormat.jpg,
          compressQuality: 90,
          maxHeight: 800,
          maxWidth: 800,
          uiSettings: [
            IOSUiSettings(title: 'Crop Image'),
            AndroidUiSettings(
                toolbarTitle: 'Crop Image',
                toolbarColor: Colors.black,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.square,
                lockAspectRatio: false)
          ]);

      if (cropped == null) return;

      state = XFile(cropped.path);
    }
  }
}
