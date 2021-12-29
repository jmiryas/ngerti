class WordModel {
  final String id;
  final String foreignWord;
  final String englishWord;
  final String? voice;
  final DateTime dateTime;

  WordModel({
    required this.id,
    required this.foreignWord,
    required this.englishWord,
    this.voice,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "foreignWord": foreignWord,
      "englishWord": englishWord,
      "voice": voice,
      "dateTime": dateTime,
    };
  }

  factory WordModel.fromJson(Map json) {
    return WordModel(
      id: json["id"],
      foreignWord: json["foreignWord"],
      englishWord: json["englishWord"],
      voice: json["voice"],
      dateTime: json["dateTime"],
    );
  }
}
