import 'package:flutter/material.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';

import '../constants/constants.dart';
import '../screens/language_collection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  PageController? _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            const LanguageCollectionScreen(),
            Container(
              color: Colors.blueGrey,
            ),
            Container(
              color: Colors.amber,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
          selectedIndex: _currentIndex,
          showElevation: true,
          itemCornerRadius: 24,
          curve: Curves.easeIn,
          items: [
            BottomNavyBarItem(
              icon: const Icon(Icons.home),
              title: const Text("Home"),
              activeColor: colorTheme,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.language),
              title: const Text("Quiz"),
              activeColor: colorTheme,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: const Icon(Icons.info),
              title: const Text("About Us"),
              activeColor: colorTheme,
              textAlign: TextAlign.center,
            ),
          ],
          onItemSelected: (index) {
            setState(() {
              _currentIndex = index;
            });
            _pageController!.jumpToPage(index);
          }),
    );
  }
}
