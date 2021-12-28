import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/language_collection_provider.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Quiz"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20.0),
        children: [
          Consumer<LangaugeCollectionProvider>(
              builder: (context, languageCollection, child) {
            if (languageCollection.selectedLanguage.isEmpty) {
              return const Center(
                child: Text("Koleksi bahasa masih kosong."),
              );
            } else {
              return Card(
                child: ListTile(
                  title: Text(languageCollection.selectedLanguage),
                  trailing: SizedBox(
                    width: 100.0,
                    height: 50.0,
                    child: Center(
                      child: Text(
                        languageCollection.selectedFlag,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 30.0,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }
          })
        ],
      ),
    );
  }
}
