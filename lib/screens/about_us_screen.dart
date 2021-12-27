import 'package:flutter/material.dart';

import '../constants/constants.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Tentang Kami"),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height - 100.0,
        margin: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200.0,
                    decoration: const BoxDecoration(
                      color: Colors.amber,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage(wallpaperMenu),
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                Divider(
                  thickness: 1.0,
                  color: Colors.grey.shade300,
                ),
                const Text(
                  "ngerti. Sebuah aplikasi untuk mengingat kembali kosa kata asing yang sudah dipelajari.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const Text(
                  "Dibuat oleh Rizky Ramadhan, @jmiryas (IG) & @dendengcrap (Twitter) dengan menggunakan Flutter.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
