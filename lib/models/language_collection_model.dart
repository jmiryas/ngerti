import '../models/word_model.dart';

class LangauageCollectionModel {
  final String id;
  final String label;
  final List<WordModel> words;
  final String flag;

  LangauageCollectionModel({
    required this.id,
    required this.label,
    required this.words,
    required this.flag,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "label": label,
      "words": words,
      "flag": flag,
    };
  }

  factory LangauageCollectionModel.fromJson(Map json) {
    return LangauageCollectionModel(
      id: json["id"],
      label: json["label"],
      words: json["words"],
      flag: json["flag"],
    );
  }
}
