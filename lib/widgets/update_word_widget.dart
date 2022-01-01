import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/word_model.dart';
import '../widgets/info_widget.dart';
import '../constants/constants.dart';

class UpdateWordWidget extends StatelessWidget {
  final String languageCollectionId;
  final Map<String, dynamic> word;
  final String flag;
  const UpdateWordWidget({
    Key? key,
    required this.languageCollectionId,
    required this.word,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    TextEditingController _pronunciationLinkController =
        TextEditingController();

    return AlertDialog(
      title: const Text(
        "Update Kosa Kata",
        textAlign: TextAlign.center,
      ),
      content: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: isLoading == true
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : Column(
                  children: [
                    TextField(
                      readOnly: true,
                      enabled: false,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        isDense: true,
                        fillColor: Colors.grey.shade100,
                        labelText: word["foreignWord"],
                        hintText: word["foreignWord"],
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextField(
                      readOnly: true,
                      enabled: false,
                      controller: _pronunciationLinkController,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        filled: true,
                        isDense: true,
                        fillColor: Colors.grey.shade100,
                        labelText: "Pronunciation Link",
                        hintText: "Pronunciation Link",
                      ),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45.0),
                      ),
                      onPressed: () async {
                        setState(() {
                          isLoading = !isLoading;
                        });

                        final url =
                            Uri.parse("$kBabLaApi$flag/${word['foreignWord']}");

                        final response = await http.get(url).whenComplete(() {
                          setState(() {
                            isLoading = !isLoading;
                          });
                        });

                        final responseBody = jsonDecode(response.body);

                        if (responseBody["status"]) {
                          _pronunciationLinkController.text =
                              responseBody["link"];

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Link berhasil didapatkan!"),
                            ),
                          );
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return const InfoWidget(
                                    title: "Error!",
                                    content: "Link tidak ditemukan!");
                              });
                        }
                      },
                      child: const Text("Cari Pengucapan"),
                    ),
                  ],
                ),
        );
      }),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Batal"),
        ),
        TextButton(
          onPressed: () async {
            if (_pronunciationLinkController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const InfoWidget(
                        title: "Error!", content: "Link tidak boleh kosong!");
                  });
            } else {
              final currentLanguageCollection = await FirebaseFirestore.instance
                  .collection(kLanguageCollectionTitle)
                  .where(FieldPath.documentId, isEqualTo: languageCollectionId)
                  .get();

              List<dynamic> currentWords = currentLanguageCollection.docs
                  .map((item) => item["words"])
                  .toList()[0];

              List<dynamic> updatedWords = [];

              for (var item in currentWords) {
                if (item["id"] != word["id"]) {
                  updatedWords.add(item);
                } else {
                  updatedWords.add(
                    WordModel(
                      id: word["id"],
                      foreignWord: word["foreignWord"],
                      englishWord: word["englishWord"],
                      dateTime: word["dateTime"].toDate(),
                      voice: _pronunciationLinkController.text,
                    ).toMap(),
                  );
                }
              }

              FirebaseFirestore firestore = FirebaseFirestore.instance;
              CollectionReference languageCollection =
                  firestore.collection(kLanguageCollectionTitle);

              await languageCollection.doc(languageCollectionId).update({
                "words": [
                  ...updatedWords,
                ],
              }).whenComplete(() {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Kosa kata berhasil diupdate!"),
                  ),
                );

                _pronunciationLinkController.clear();
              });
            }
          },
          child: const Text("Simpan"),
        )
      ],
    );
  }
}
