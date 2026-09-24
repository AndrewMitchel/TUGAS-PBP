class CoffeePlace {
  final int id;
  final String name;
  final double rating;
  final double latitude;
  final double longitude;
  final String mapUrl;
  final String? about;
  final String? imageUrl;
  final bool isRecommended;
  final bool isTrending;
  final DateTime createdAt;

  const CoffeePlace({
    required this.id,
    required this.name,
    required this.rating,
    required this.latitude,
    required this.longitude,
    required this.mapUrl,
    required this.about,
    required this.imageUrl,
    required this.isRecommended,
    required this.isTrending,
    required this.createdAt,
  });

  factory CoffeePlace.fromMap(
    Map<String, dynamic> map,
  ) {
    return CoffeePlace(
      id: (map['id'] as num).toInt(),

      name:
          map['name']?.toString() ?? '',

      rating:
          (map['rating'] as num?)
                  ?.toDouble() ??
              0,

      latitude:
          (map['latitude'] as num?)
                  ?.toDouble() ??
              0,

      longitude:
          (map['longitude'] as num?)
                  ?.toDouble() ??
              0,

      mapUrl:
          map['map_url']?.toString() ?? '',

      about:
          map['about']?.toString(),

      imageUrl:
          map['image_url']?.toString(),

      isRecommended:
          map['is_recommended'] == true,

      isTrending:
          map['is_trending'] == true,

      createdAt:
          DateTime.parse(
        map['created_at'].toString(),
      ),
    );
  }
}