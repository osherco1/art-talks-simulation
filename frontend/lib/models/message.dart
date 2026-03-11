class Message {
  final String id;
  final String artworkId;
  final String text;
  final DateTime createdAt;

  Message({
    required this.id,
    required this.artworkId,
    required this.text,
    required this.createdAt,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['_id'] as String,
      artworkId: json['artworkId'] as String,
      text: json['text'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'artworkId': artworkId,
      'text': text,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
