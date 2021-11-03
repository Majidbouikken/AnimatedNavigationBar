import 'package:flutter/material.dart';
import 'package:animated_navigation_bar/animated_navigation_bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData.dark(),
        locale: Locale('ar', 'DZ'),
        home: MyHomePage(),
        debugShowCheckedModeBanner: false);
  }
}

class MyHomePage extends StatelessWidget {
  static Map<int, GlobalKey<NavigatorState>> navigatorKeys = {
    0: GlobalKey<NavigatorState>(),
    1: GlobalKey<NavigatorState>(),
    2: GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    print('${Directionality.of(context)}');
    return Scaffold(
        backgroundColor: Colors.redAccent,
        body: SafeArea(
          child: AnimatedNavBar(
              padding: 6,
              borderRadius: Radius.circular(12),
              color: Theme.of(context).cardColor,
              inactiveColor: Colors.black45,
              shadow: false,
              pages: [
                // first page
                AnimatedNavBarPage(
                    title: "Home",
                    icon: Icons.home,
                    inactiveIcon: Icons.home_outlined,
                    navigationKey: navigatorKeys[0],
                    pageContent: Center(
                        child: TextButton(
                            child: Text('Go to My second page'),
                            onPressed: () => navigatorKeys[0].currentState.push(
                                MaterialPageRoute(
                                    builder: (_) => MySecondPage()))))),
                // second page
                AnimatedNavBarPage(
                    title: "Map",
                    icon: Icons.map,
                    inactiveIcon: Icons.map_outlined,
                    navigationKey: navigatorKeys[1],
                    pageContent: Container(
                        color: Colors.red[100],
                        alignment: Alignment.center,
                        child: Text("Map", style: TextStyle(fontSize: 24)))),
                // third page
                AnimatedNavBarPage(
                    title: "User",
                    icon: Icons.person,
                    inactiveIcon: Icons.person_outline,
                    navigationKey: navigatorKeys[2],
                    pageContent: Container(
                        color: Colors.green[100],
                        alignment: Alignment.center,
                        child: Text("User", style: TextStyle(fontSize: 24))))
              ]),
        ));
  }
}

class MySecondPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: Center(child: Text('My second page')));
}
