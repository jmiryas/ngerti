import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/word_model.dart';
import '../constants/constants.dart';
import '../widgets/info_widget.dart';

class WordScreen extends StatelessWidget {
  final String languageCollectionId;
  const WordScreen({
    Key? key,
    required this.languageCollectionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _foreignWordController = TextEditingController();
    TextEditingController _englishWordController = TextEditingController();
    TextEditingController _indonesianWordController = TextEditingController();
    TextEditingController _pronounceLinkController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Kosa Kata"),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection(kLanguageCollectionTitle)
            .where(FieldPath.documentId, isEqualTo: languageCollectionId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data!.size > 0) {
              return ListView(
                padding: const EdgeInsets.all(20.0),
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: snapshot.data!.docs.map((language) {
                      if (language["words"].length > 0) {
                        return Column(children: [
                          ...language["words"].map((word) {
                            return Card(
                              child: ListTile(
                                title: Text(word["foreignWord"]),
                                subtitle: Text(word["englishWord"]),
                                trailing: word["voice"] != null
                                    ? IconButton(
                                        onPressed: () async {
                                          AudioPlayer audioPlayer =
                                              AudioPlayer();
                                          int result = await audioPlayer
                                              .play(word["voice"]);

                                          print(result);
                                        },
                                        icon: const Icon(Icons.keyboard_voice))
                                    : const SizedBox(),
                              ),
                            );
                          }).toList()
                        ]);
                      } else {
                        return SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 200.0,
                          child: const Center(
                            child: Text("Kosa kata masih kosong!"),
                          ),
                        );
                      }
                    }).toList(),
                  )
                ],
              );
            } else {
              return const Center(
                child: Text("Kosa kata masih kosong."),
              );
            }
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong!"),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
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
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: _indonesianWordController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              isDense: true,
                              fillColor: Colors.grey.shade100,
                              labelText: "Kosa Kata Indonesia",
                              hintText: "Silakan",
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          TextField(
                            controller: _pronounceLinkController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              isDense: true,
                              fillColor: Colors.grey.shade100,
                              labelText: "Pengucapan",
                              hintText: "https://",
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
                            _englishWordController.text.isEmpty ||
                            _indonesianWordController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return const InfoWidget(
                                  title: "Error",
                                  content: "Kosa kata tidak boleh kosong!");
                            },
                          );
                        } else {
                          const uuid = Uuid();

                          FirebaseFirestore firestore =
                              FirebaseFirestore.instance;
                          CollectionReference languageCollection =
                              firestore.collection(kLanguageCollectionTitle);

                          await languageCollection
                              .doc(languageCollectionId)
                              .update({
                            "words": [
                              WordModel(
                                id: uuid.v4(),
                                foreignWord: _foreignWordController.text,
                                englishWord: _englishWordController.text,
                                indonesianWord: _indonesianWordController.text,
                                voice: _pronounceLinkController.text,
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
                              _indonesianWordController.clear();
                              _pronounceLinkController.clear();
                            },
                          );
                        }
                      },
                      child: const Text("Simpan"),
                    ),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
