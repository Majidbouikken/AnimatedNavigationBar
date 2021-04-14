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
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Animated Navigation Bar"),
      ),
      backgroundColor: Color(0xFFE0E0E0),
      body: AnimatedNavBar(
        padding: 0,
        borderRadius: Radius.circular(0),
        color: Theme.of(context).cardColor,
        shadow: false,
        pages: [
          // first page
          AnimatedNavBarPage(
            title: "Home",
            icon: Icons.home,
            inactiveIcon: Icons.home_outlined,
            pageContent: Container(
              color: Colors.blue[100],
              alignment: Alignment.center,
              child: Text("Home", style: TextStyle(fontSize: 24),),
            ),
          ),
          // second page
          AnimatedNavBarPage(
            title: "Map",
            icon: Icons.map,
            inactiveIcon: Icons.map_outlined,
            pageContent: Container(
              color: Colors.red[100],
              alignment: Alignment.center,
              child: Text("Map", style: TextStyle(fontSize: 24),),
            ),
          ),
          // third page
          AnimatedNavBarPage(
            title: "User",
            icon: Icons.person,
            inactiveIcon: Icons.person_outline,
            pageContent: Container(
              color: Colors.green[100],
              alignment: Alignment.center,
              child: Text("User", style: TextStyle(fontSize: 24),),
            ),
          ),
        ],
      ),
    );
  }
}