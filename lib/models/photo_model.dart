import 'dart:convert';
class Photo {
  final String id;
  final String thumbnailUrl;
  final String originalUrl;

  Photo({required this.id, required this.thumbnailUrl, required this.originalUrl});

  factory Photo.fromJson(Map<String, dynamic> json) {
    return Photo(
      id: json['id'].toString(),
      thumbnailUrl: json['src']['medium'],
      originalUrl: json['src']['original'],
    );
  }
}