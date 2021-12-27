import 'package:flutter/material.dart';

import '../constants/constants.dart';
import '../widgets/info_widget.dart';

class DrawerNavigationWidget extends StatelessWidget {
  const DrawerNavigationWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
              decoration: BoxDecoration(
                color: colorTheme,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(wallpaperMenu),
                ),
              ),
              child: SizedBox()),
          Container(
            color: colorTheme,
            height: 50.0,
            child: const Center(
              child: Text(
                "ngerti",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26.0,
                  letterSpacing: 5.0,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 5.0,
          ),
          ListTile(
            title: Row(
              children: const [
                Icon(
                  Icons.info,
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  "Tentang Kami",
                )
              ],
            ),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return const InfoWidget(
                      title: "Tentang Kami",
                      content:
                          "ngerti. Dibuat oleh Rizky Ramadhan, @jmiryas (IG) & @dendengcrap (Twitter) dengan menggunakan Flutter.",
                    );
                  });
            },
          )
        ],
      ),
    );
  }
}
