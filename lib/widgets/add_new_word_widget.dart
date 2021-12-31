import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/word_model.dart';
import '../widgets/info_widget.dart';
import '../constants/constants.dart';

class AddNewWordWidget extends StatelessWidget {
  final String languageCollectionId;
  const AddNewWordWidget({
    Key? key,
    required this.languageCollectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _foreignWordController = TextEditingController();
    TextEditingController _englishWordController = TextEditingController();

    return AlertDialog(
      title: const Text(
        "Tambah kosa kata",
        textAlign: TextAlign.center,
      ),
      content: StatefulBuilder(builder: (context, setState) {
        return SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _foreignWordController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  isDense: true,
                  fillColor: Colors.grey.shade100,
                  labelText: "Kosa Kata Asing",
                  hintText: "Alsjeblieft",
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                controller: _englishWordController,
                textCapitalization: TextCapitalization.sentences,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  filled: true,
                  isDense: true,
                  fillColor: Colors.grey.shade100,
                  labelText: "Kosa Kata Inggris",
                  hintText: "Please",
                ),
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
            if (_foreignWordController.text.isEmpty ||
                _englishWordController.text.isEmpty) {
              showDialog(
                context: context,
                builder: (context) {
                  return const InfoWidget(
                      title: "Error", content: "Kosa kata tidak boleh kosong!");
                },
              );
            } else {
              final currentLanguageCollection = await FirebaseFirestore.instance
                  .collection(kLanguageCollectionTitle)
                  .where(FieldPath.documentId, isEqualTo: languageCollectionId)
                  .get();

              List<dynamic> currentWords = currentLanguageCollection.docs
                  .map((item) => item["words"])
                  .toList()[0];

              const uuid = Uuid();

              FirebaseFirestore firestore = FirebaseFirestore.instance;
              CollectionReference languageCollection =
                  firestore.collection(kLanguageCollectionTitle);

              await languageCollection.doc(languageCollectionId).update({
                "words": [
                  ...currentWords,
                  WordModel(
                    id: uuid.v4(),
                    foreignWord: _foreignWordController.text,
                    englishWord: _englishWordController.text,
                    dateTime: DateTime.now(),
                  ).toMap(),
                ],
              }).whenComplete(
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Kosa kata berhasil ditambah!"),
                    ),
                  );

                  Navigator.pop(context);

                  _foreignWordController.clear();
                  _englishWordController.clear();
                },
              );
            }
          },
          child: const Text("Simpan"),
        ),
      ],
    );
  }
}
