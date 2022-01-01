import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../screens/word_screen.dart';
import '../constants/constants.dart';
import '../widgets/add_new_language_widget.dart';

class LanguageCollectionScreen extends StatelessWidget {
  const LanguageCollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Koleksi Bahasa"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(kLanguageCollectionTitle)
              .orderBy("dateTime")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.size > 0) {
                return ListView(
                  padding: const EdgeInsets.all(20.0),
                  children: snapshot.data!.docs.map((collection) {
                    return Dismissible(
                      key: Key(collection["id"]),
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
                      onDismissed: (direction) async {
                        // * Hapus koleksi bahasa.

                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        CollectionReference languageCollection =
                            firestore.collection(kLanguageCollectionTitle);

                        await languageCollection.doc(collection.id).delete();

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Koleksi bahasa berhasil dihapus!"),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: SizedBox(
                            width: 30.0,
                            height: double.infinity,
                            child: Center(
                              child: Text(
                                collection["flag"],
                                style: const TextStyle(
                                  fontSize: 25.0,
                                ),
                              ),
                            ),
                          ),
                          title: Text(collection["label"]),
                          subtitle: Text("${collection['words'].length}"),
                          trailing: const Icon(Icons.arrow_forward_ios_rounded),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return WordScreen(
                                    languageCollectionId: collection.id,
                                    flag: collection["flag"],
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  }).toList(),
                );
              } else {
                return const Center(
                  child: Text("Koleksi bahasa masih kosong."),
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
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const AddNewLanguageWidget();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
