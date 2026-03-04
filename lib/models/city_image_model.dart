class CityImageModel {
  final String id;
  final String regularUrl;
  final String smallUrl;
  final String thumbUrl;
  final String photographerName;
  final String photographerUrl;
  final String blurHash;
  final int width;
  final int height;

  CityImageModel({
    required this.id,
    required this.regularUrl,
    required this.smallUrl,
    required this.thumbUrl,
    required this.photographerName,
    required this.photographerUrl,
    required this.blurHash,
    required this.width,
    required this.height,
  });

  factory CityImageModel.fromJson(Map<String, dynamic> json) {
    return CityImageModel(
      id: json['id'] ?? '',
      regularUrl: json['urls']?['regular'] ?? '',
      smallUrl: json['urls']?['small'] ?? '',
      thumbUrl: json['urls']?['thumb'] ?? '',
      photographerName: json['user']?['name'] ?? 'Unknown',
      photographerUrl: json['user']?['links']?['html'] ?? '',
      blurHash: json['blur_hash'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
    );
  }
}
