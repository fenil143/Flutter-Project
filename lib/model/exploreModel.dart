class ExploreModel {
  String name;
  String networkImage;
  String likes;
  String entryFee;
  String openingTime;
  String closingTime;
  String facilities;
  String description;
  String address;
  ExploreModel(
      {required this.name,
      required this.networkImage,
      required this.likes,
      required this.entryFee,
      required this.openingTime,
      required this.closingTime,
      required this.facilities,
      required this.description,
      required this.address});

  ExploreModel copyWith(
      {String? name,
      String? networkImage,
      String? likes,
      String? entryFee,
      String? openingTime,
      String? closingTime,
      String? facilities,
      String? description,
      String? address}) {
    return ExploreModel(
      name: name ?? this.name,
      networkImage: networkImage ?? this.networkImage,
      likes: likes ?? this.likes,
      entryFee: entryFee ?? this.entryFee,
      openingTime: openingTime ?? this.openingTime,
      closingTime: closingTime ?? this.closingTime,
      facilities: facilities ?? this.facilities,
      description: description ?? this.description,
      address: address ?? this.address,
    );
  }

  @override
  String toString() =>
      'ExploreModel(name: $name, networkImage: $networkImage,likes: $likes, entryFee: $entryFee,openingTime: $openingTime,closingTime: $closingTime,facilities: $facilities,description: $description,address: $address)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ExploreModel &&
        other.name == name &&
        other.networkImage == networkImage &&
        other.likes == likes &&
        other.entryFee == entryFee &&
        other.openingTime == openingTime &&
        other.closingTime == closingTime &&
        other.facilities == facilities &&
        other.description == description;
  }

  @override
  int get hashCode => name.hashCode ^ networkImage.hashCode;
}
