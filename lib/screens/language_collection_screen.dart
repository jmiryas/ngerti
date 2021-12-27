import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';
import '../widgets/info_widget.dart';
import '../models/language_collection_model.dart';

class LanguageCollectionScreen extends StatelessWidget {
  const LanguageCollectionScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _selectedFlag = flagList[0];
    TextEditingController _languageCollectionController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Koleksi Bahasa"),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection(kLanguageCollectionTitle)
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
                            title: Text(collection["label"]),
                            subtitle: Text("${collection['words'].length}"),
                            trailing: Text(collection["flag"]),
                          ),
                        ));
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
              return AlertDialog(
                title: const Text(
                  "Tambah Koleksi Bahasa",
                  textAlign: TextAlign.center,
                ),
                content: StatefulBuilder(
                  builder: (context, setState) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            controller: _languageCollectionController,
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              filled: true,
                              isDense: true,
                              fillColor: Colors.grey.shade100,
                              labelText: "Nama Koleksi",
                              hintText: "Contoh: Belanda",
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          Wrap(
                            alignment: WrapAlignment.start,
                            spacing: 10.0,
                            children: flagList.map((flag) {
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedFlag = flag;
                                  });
                                },
                                child: Container(
                                  width: 50.0,
                                  height: 50.0,
                                  decoration: BoxDecoration(
                                    color: _selectedFlag == flag
                                        ? Colors.grey.shade100
                                        : Colors.transparent,
                                  ),
                                  child: Center(
                                    child: Text(
                                      flag,
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                    );
                  },
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Batal"),
                  ),
                  TextButton(
                    onPressed: () async {
                      if (_languageCollectionController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return const InfoWidget(
                                  title: "Error!",
                                  content:
                                      "Nama koleksi bahasa tidak boleh kosong!");
                            });
                      } else {
                        const uuid = Uuid();

                        LangauageCollectionModel langauageCollectionModel =
                            LangauageCollectionModel(
                          id: uuid.v4(),
                          label: _languageCollectionController.text,
                          words: [],
                          flag: _selectedFlag,
                        );

                        FirebaseFirestore firestore =
                            FirebaseFirestore.instance;
                        CollectionReference languageCollection =
                            firestore.collection(kLanguageCollectionTitle);

                        await languageCollection
                            .add(langauageCollectionModel.toMap())
                            .whenComplete(() {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text("Koleksi bahasa berhasil ditambah!"),
                            ),
                          );

                          Navigator.pop(context);

                          _languageCollectionController.clear();
                        });
                      }
                    },
                    child: const Text("Simpan"),
                  )
                ],
              );
            },
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
