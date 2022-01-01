import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';
import '../widgets/update_word_widget.dart';
import '../widgets/add_new_word_widget.dart';

class WordScreen extends StatelessWidget {
  final String languageCollectionId;
  final String flag;
  const WordScreen({
    Key? key,
    required this.languageCollectionId,
    required this.flag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                            return Dismissible(
                              key: Key(word["id"]),
                              background: Container(
                                color: Colors.red.shade300,
                                child: const Center(
                                  child: Text(
                                    "Hapus?",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              child: Card(
                                child: ListTile(
                                  title: Text(word["foreignWord"]),
                                  subtitle: Text(word["englishWord"]),
                                  trailing: word["voice"] != null &&
                                          !word["voice"].isEmpty
                                      ? IconButton(
                                          onPressed: () async {
                                            final player = AudioPlayer();
                                            await player.setUrl(word["voice"]);

                                            player.play();
                                          },
                                          icon:
                                              const Icon(Icons.keyboard_voice))
                                      : const SizedBox(),
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return UpdateWordWidget(
                                          languageCollectionId:
                                              languageCollectionId,
                                          word: word,
                                          flag: flag,
                                        );
                                      },
                                    );
                                  },
                                ),
                              ),
                              onDismissed: (direction) async {
                                final currentLanguageCollection =
                                    await FirebaseFirestore.instance
                                        .collection(kLanguageCollectionTitle)
                                        .where(FieldPath.documentId,
                                            isEqualTo: languageCollectionId)
                                        .get();

                                List<dynamic> currentWords =
                                    currentLanguageCollection.docs
                                        .map((item) => item["words"])
                                        .toList()[0];

                                List<dynamic> updatedWords = [];

                                for (var item in currentWords) {
                                  if (item["id"] != word["id"]) {
                                    updatedWords.add(item);
                                  }
                                }

                                FirebaseFirestore firestore =
                                    FirebaseFirestore.instance;
                                CollectionReference languageCollection =
                                    firestore
                                        .collection(kLanguageCollectionTitle);

                                await languageCollection
                                    .doc(languageCollectionId)
                                    .update({
                                  "words": [
                                    ...updatedWords,
                                  ],
                                }).whenComplete(() {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content:
                                          Text("Kosa kata berhasil dihapus!"),
                                    ),
                                  );
                                });
                              },
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
                return AddNewWordWidget(
                    languageCollectionId: languageCollectionId);
              });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
