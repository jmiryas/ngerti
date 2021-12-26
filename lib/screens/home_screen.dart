import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';
import '../widgets/info_widget.dart';
import '../widgets/drawer_navigation_widget.dart';
import '../models/language_collection_model.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _languageCollectionController =
        TextEditingController();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Home"),
      ),
      drawer: const DrawerNavigationWidget(),
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
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextField(
                        controller: _languageCollectionController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: InputDecoration(
                            filled: true,
                            isDense: true,
                            fillColor: Colors.grey.shade200,
                            labelText: "Nama Koleksi Bahasa",
                            hintText: "Masukkan nama koleksi bahasa ..."),
                      )
                    ],
                  ),
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
