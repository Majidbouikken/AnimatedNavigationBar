import 'package:flutter/material.dart';
import 'package:animated_navigation_bar/animated_navigation_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedNavBar(
        padding: 8,
        color: Theme.of(context).backgroundColor,
        pages: [
          // first page
          AnimatedNavBarPage(
            title: "Home",
            icon: Icons.home,
            inactiveIcon: Icons.home_outlined,
            pageContent: Container(
              color: Colors.redAccent,
              alignment: Alignment.center,
              child: Text("Home"),
            ),
          ),
          // second page
          AnimatedNavBarPage(
            title: "Map",
            icon: Icons.map,
            inactiveIcon: Icons.map_outlined,
            pageContent: Container(
              color: Colors.lightBlueAccent,
              alignment: Alignment.center,
              child: Text("Map"),
            ),
          ),
          // third page
          AnimatedNavBarPage(
            title: "User",
            icon: Icons.person,
            inactiveIcon: Icons.person_outline,
            pageContent: Container(
              color: Colors.lightGreenAccent,
              alignment: Alignment.center,
              child: Text("User"),
            ),
          ),
        ],
      ),
    );
  }
}
