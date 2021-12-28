class WordModel {
  final String id;
  final String foreignWord;
  final String englishWord;
  final String indonesianWord;
  final String? voice;
  final DateTime dateTime;

  WordModel({
    required this.id,
    required this.foreignWord,
    required this.englishWord,
    required this.indonesianWord,
    this.voice,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "foreignWord": foreignWord,
      "englishWord": englishWord,
      "indonesianWord": indonesianWord,
      "voice": voice,
      "dateTime": dateTime,
    };
  }

  factory WordModel.fromJson(Map json) {
    return WordModel(
      id: json["id"],
      foreignWord: json["foreignWord"],
      englishWord: json["englishWord"],
      indonesianWord: json["indonesianWord"],
      voice: json["voice"],
      dateTime: json["dateTime"],
    );
  }
}
