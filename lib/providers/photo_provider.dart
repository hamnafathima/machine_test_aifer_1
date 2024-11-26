import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:machine_test/models/photo_model.dart';
import 'dart:convert';


class PhotoProvider with ChangeNotifier {
  final String _apiKey = 'API_KEY';
  List<Photo> _photos = [];
  int _page = 1;
  bool _isLoading = false;

  List<Photo> get photos => _photos;

  Future<void> fetchPhotos() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    final url = Uri.parse('https://api.pexels.com/v1/curated?page=$_page&per_page=20');
    final response = await http.get(url, headers: {'Authorization': _apiKey});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<Photo> loadedPhotos = (data['photos'] as List)
          .map((item) => Photo.fromJson(item))
          .toList();

      _photos.addAll(loadedPhotos);
      _page++;
      _isLoading = false;
      notifyListeners();
    } else {
      _isLoading = false;
      throw Exception('Failed to load photos');
    }
  }
}