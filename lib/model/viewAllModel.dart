import 'dart:convert';

class ViewAllModel {
  final String id;
  final String name;
  final String address;
  ViewAllModel({
    required this.id,
    required this.name,
    required this.address,
  });

  ViewAllModel copyWith({
    String? id,
    String? name,
    String? address,
  }) {
    return ViewAllModel(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
    };
  }

  factory ViewAllModel.fromMap(Map<String, dynamic> map) {
    return ViewAllModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      address: map['address'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory ViewAllModel.fromJson(String source) =>
      ViewAllModel.fromMap(json.decode(source));

  @override
  String toString() => 'ViewAllModel(name: $name, address: $address)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ViewAllModel &&
        other.name == name &&
        other.address == address;
  }

  @override
  int get hashCode => name.hashCode ^ address.hashCode;
}
