import 'package:flutter/material.dart';
import 'package:movie_finder/model/model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'apikeys.dart';

final String key =  APIkeys().key;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark(),
      home: MyHomePage(title: 'Movie Finder'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movie> movies = List();
  bool hasLoaded = true;

  final PublishSubject subject = PublishSubject<String>();

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    subject.stream.debounce(Duration(milliseconds: 400)).listen(searchMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (String string) => (subject.add(string)),
            ),
          ),
          Expanded(
              child: Center(
                  child:
                      hasLoaded ? Container() : CircularProgressIndicator())),
          hasLoaded == false
              ? Expanded(
                  child: ListView.builder(
                      padding: EdgeInsets.all(10.0),
                      itemCount: movies.length,
                      itemBuilder: (BuildContext context, int index) {
                        return new Container();
                      }),
                )
              : Container(),
        ],
      ),
    );
  }

  void searchMovies(query) {
    resetMovies();
    if (query.isEmpty) {
      setState(() {
        hasLoaded = true;
      });
      return;
    }
    setState(() => hasLoaded = false);

    http
        .get(
            'https://api.themoviedb.org/3/search/movie?api_key=$key&query=$query')
        .then((res) => (res.body))
        .then(json.decode)
        .then((map) => map["results"])
        .then((movies) => movies.forEach(addMovie))
        .catchError(onError)
        .then((e) {
      setState(() {
        hasLoaded = true;
      });
    });
  }

  void onError(dynamic d) {
    setState(() {
      hasLoaded = true;
    });
  }

  void resetMovies() {
    setState(() => movies.clear());
  }

  void addMovie(item) {
    setState(() {
      movies.add(Movie.fromJson(item));
    });
  }
}
