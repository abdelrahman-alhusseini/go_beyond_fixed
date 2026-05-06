import 'dart:typed_data';

import 'package:flutter/material.dart';

class FFUploadedFile {
  FFUploadedFile({
    this.name,
    this.bytes,
    this.height,
    this.width,
    this.blurHash,
    this.originalFilename,
  });

  final String? name;
  final Uint8List? bytes;
  final double? height;
  final double? width;
  final String? blurHash;
  final String? originalFilename;
}

Future<List<SelectedFile>?> selectMediaWithSourceBottomSheet({
  required BuildContext context,
  int? imageQuality,
  bool allowPhoto = true,
  Color? backgroundColor,
  Color? textColor,
  String? pickerFontFamily,
}) async {
  return null;
}

bool validateFileFormat(String path, BuildContext context) => true;

void showUploadMessage(
  BuildContext context,
  String message, {
  bool showLoading = false,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message)),
  );
}

class SelectedFile {
  SelectedFile({
    required this.storagePath,
    required this.bytes,
    this.dimensions,
    this.blurHash,
    this.originalFilename,
  });

  final String storagePath;
  final Uint8List bytes;
  final MediaDimensions? dimensions;
  final String? blurHash;
  final String? originalFilename;
}

class MediaDimensions {
  MediaDimensions({
    this.height,
    this.width,
  });

  final double? height;
  final double? width;
}