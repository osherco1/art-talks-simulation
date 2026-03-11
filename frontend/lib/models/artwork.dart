class Artwork {
  final String id;
  final String pictureName;
  final String artist;
  final String description;
  final String imageUrl;

  Artwork({
    required this.id,
    required this.pictureName,
    required this.artist,
    required this.description,
    required this.imageUrl,
  });

  factory Artwork.fromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['_id'] as String,
      pictureName: json['pictureName'] as String,
      artist: json['artist'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'pictureName': pictureName,
      'artist': artist,
      'description': description,
      'imageUrl': imageUrl,
    };
  }
}
