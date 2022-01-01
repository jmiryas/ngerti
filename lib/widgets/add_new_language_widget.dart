import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../constants/constants.dart';
import '../widgets/info_widget.dart';
import '../models/language_collection_model.dart';

class AddNewLanguageWidget extends StatelessWidget {
  const AddNewLanguageWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _selectedFlag = flagList[0];
    TextEditingController _languageCollectionController =
        TextEditingController();

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
                        content: "Nama koleksi bahasa tidak boleh kosong!");
                  });
            } else {
              const uuid = Uuid();

              LangauageCollectionModel langauageCollectionModel =
                  LangauageCollectionModel(
                id: uuid.v4(),
                label: _languageCollectionController.text,
                words: [],
                flag: _selectedFlag,
                dateTime: DateTime.now(),
              );

              FirebaseFirestore firestore = FirebaseFirestore.instance;
              CollectionReference languageCollection =
                  firestore.collection(kLanguageCollectionTitle);

              await languageCollection
                  .add(langauageCollectionModel.toMap())
                  .whenComplete(() {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Koleksi bahasa berhasil ditambah!"),
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
  }
}
