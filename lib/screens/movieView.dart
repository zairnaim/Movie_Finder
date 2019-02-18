import 'package:flutter/material.dart';
import 'package:movie_finder/model/model.dart';
import 'package:movie_finder/database/database.dart';

class MovieView extends StatefulWidget {
  MovieView(this.movie);
  final Movie movie;

  @override
  MovieViewState createState() => MovieViewState();
}

class MovieViewState extends State<MovieView> {
  Movie currentmovieState;

  @override
  void initState() {
    super.initState();
    currentmovieState = widget.movie;
    // db = widget.database;
    // db.initDB();
  }

  void onPressedFavs() {
    MovieDatabase db = MovieDatabase();
    setState(() {
      currentmovieState.favored = !currentmovieState.favored;
      currentmovieState.favored
          ? db.addMovie(currentmovieState)
          : db.deleteMovie(currentmovieState);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Colors.black54,
        child: ExpansionTile(
          onExpansionChanged: (b) => currentmovieState.isexpanded = b,
          initiallyExpanded: currentmovieState.isexpanded ?? false,
          children: <Widget>[
            Container(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: RichText(
                  text: TextSpan(
                    text: currentmovieState.overview,
                    style:
                        TextStyle(fontSize: 14.0, fontWeight: FontWeight.w300),
                  ),
                ),
              ),
            )
          ],
          leading: IconButton(
            icon: currentmovieState.favored
                ? Icon(Icons.star)
                : Icon(Icons.star_border),
            color: Colors.white,
            onPressed: () {
              onPressedFavs();
            },
          ),
          title: Container(
            height: 200.0,
            padding: EdgeInsets.all(10.0),
            child: Row(children: [
              currentmovieState.posterPath != null
                  ? Hero(
                      child: Image.network(
                          "https://image.tmdb.org/t/p/w92${currentmovieState.posterPath}"),
                      tag: currentmovieState.title,
                    )
                  : Container(),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      currentmovieState.title,
                      maxLines: 10,
                    ),
                  ),
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
