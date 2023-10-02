import 'dart:convert';

// import 'package:flutter/foundation.dart';

class PlaceModel {
  final String title;
  final String description;
  final int like;
  final String bannerUrl;
  PlaceModel({
    required this.title,
    required this.description,
    required this.like,
    required this.bannerUrl,
  });

  PlaceModel copyWith({
    String? title,
    String? description,
    int? like,
    String? bannerUrl,
  }) {
    return PlaceModel(
      title: title ?? this.title,
      description: description ?? this.description,
      like: like ?? this.like,
      bannerUrl: bannerUrl ?? this.bannerUrl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'like': like,
      'bannerUrl': bannerUrl,
    };
  }

  factory PlaceModel.fromMap(Map<String, dynamic> map) {
    return PlaceModel(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      like: map['like']?.toInt() ?? 0,
      bannerUrl: map['bannerUrl'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory PlaceModel.fromJson(String source) =>
      PlaceModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PlaceModel(title: $title, description: $description, like: $like, bannerUrl: $bannerUrl,)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PlaceModel &&
        other.title == title &&
        other.description == description &&
        other.like == like &&
        other.bannerUrl == bannerUrl;
  }
}
