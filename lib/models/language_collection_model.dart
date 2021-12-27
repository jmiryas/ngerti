import '../models/word_model.dart';

class LangauageCollectionModel {
  final String id;
  final String label;
  final List<WordModel> words;
  final String flag;
  final DateTime dateTime;

  LangauageCollectionModel({
    required this.id,
    required this.label,
    required this.words,
    required this.flag,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "label": label,
      "words": words,
      "flag": flag,
      "dateTime": dateTime,
    };
  }

  factory LangauageCollectionModel.fromJson(Map json) {
    return LangauageCollectionModel(
      id: json["id"],
      label: json["label"],
      words: json["words"],
      flag: json["flag"],
      dateTime: json["dateTime"],
    );
  }
}
