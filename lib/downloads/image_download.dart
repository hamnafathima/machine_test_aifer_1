import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

Future<void> _downloadPhoto(String url, BuildContext context) async {
  final dio = Dio();
  final directory = await getApplicationDocumentsDirectory();
  final filePath = '${directory.path}/image.jpg';

  await dio.download(url, filePath);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('Image saved to $filePath')),
  );
}