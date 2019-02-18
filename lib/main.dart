import 'package:flutter/material.dart';
import 'package:movie_finder/screens/favs.dart';
import 'package:movie_finder/screens/home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme:
          new ThemeData(brightness: Brightness.dark, accentColor: Colors.red),
      // home: MyHomePage(title: 'Movie Finder'),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            title: Text("Movie Finder"),
            bottom: TabBar(
              tabs: <Widget>[
                Tab(
                  icon: Icon(Icons.home),
                  text: "Home",
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: "Favs",
                )
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              MyHomePage(title: "ho"),
              Favs(),
            ],
          ),
        ),
      ),
    );
  }
}
