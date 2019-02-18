import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movie_finder/apikeys.dart';
import 'package:movie_finder/model/model.dart';
import 'package:movie_finder/screens/movieView.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Movie> movies = List();
  bool hasLoaded = true;
  // MovieDatabase db;
  final String key = APIkeys().key;

  final PublishSubject subject = PublishSubject<String>();

  @override
  void dispose() {
    subject.close();
    // db.closeDb();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    // db = MovieDatabase();
    // print("initializing db from main.dart");
    // db.initDB();

    subject.stream.debounce(Duration(milliseconds: 400)).listen(searchMovies);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextField(
            onChanged: (String string) => (subject.add(string)),
          ),
        ),
        hasLoaded
            ? Container()
            : Expanded(child: Center(child: CircularProgressIndicator())),
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return new MovieView(movies[index]);
              }),
        )
      ],
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
    print('${movies.map((m) => m.title)}');
  }
}
