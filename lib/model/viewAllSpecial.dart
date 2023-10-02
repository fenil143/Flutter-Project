import 'dart:convert';

class ViewAllSpecialModel {
  final String id;
  final String name;
  final String likes;
  final String networkImage;
  ViewAllSpecialModel({
    required this.id,
    required this.name,
    required this.networkImage,
    required this.likes,
  });

  ViewAllSpecialModel copyWith({
    String? id,
    String? name,
    String? networkImage,
    String? likes,
  }) {
    return ViewAllSpecialModel(
      id: id ?? this.id,
      name: name ?? this.name,
      networkImage: networkImage ?? this.networkImage,
      likes: likes ?? this.likes,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'networkImage': networkImage,
      'likes' : likes
    };
  }

  factory ViewAllSpecialModel.fromMap(Map<String, dynamic> map) {
    return ViewAllSpecialModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      networkImage: map['networkImage'] ?? '',
      likes: map['likes'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ViewAllSpecialModel.fromJson(String source) =>
      ViewAllSpecialModel.fromMap(json.decode(source));

  @override
  String toString() => 'ViewAllSpecialModel(name: $name, networkImage: $networkImage, likes: $likes)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ViewAllSpecialModel &&
        other.name == name &&
        other.networkImage == networkImage && other.likes == likes;
  }

  @override
  int get hashCode => name.hashCode ^ networkImage.hashCode;
}
