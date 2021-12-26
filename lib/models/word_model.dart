class WordModel {
  final String id;
  final String foreignWord;
  final String englishWord;
  final String indonesianWord;
  final String? voice;

  WordModel({
    required this.id,
    required this.foreignWord,
    required this.englishWord,
    required this.indonesianWord,
    this.voice,
  });
}
