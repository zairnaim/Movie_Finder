import 'package:flutter/material.dart';
import 'package:movie_finder/model/model.dart';
import 'package:movie_finder/database/database.dart';
import 'package:rxdart/rxdart.dart';

class Favs extends StatefulWidget {
  @override
  FavsState createState() => FavsState();
}

class FavsState extends State<Favs> {
  List<Movie> filteredMovies = List();
  List<Movie> movieCache = List();

  final PublishSubject subject = PublishSubject<String>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filteredMovies = [];
    movieCache = [];
    subject.stream.listen(searchDataList);
    setupList();
  }

  void setupList() async {
    MovieDatabase db = MovieDatabase();
    filteredMovies = await db.getMovies();
    setState(() {
      movieCache = filteredMovies;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    subject.close();
    super.dispose();
  }

  void onPressedDelete(int index) {
    setState(() {
      filteredMovies.remove(filteredMovies[index]);
    });
  }

  void searchDataList(query) {}

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          TextField(
            onChanged: (String string) => (subject.add(string)),
            keyboardType: TextInputType.url,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(8.0),
              itemCount: filteredMovies.length,
              itemBuilder: (BuildContext context, int index) {
                return new ExpansionTile(
                  initiallyExpanded: filteredMovies[index].isexpanded ?? false,
                  onExpansionChanged: (b) =>
                      filteredMovies[index].isexpanded = b,
                  children: <Widget>[],
                  leading: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      onPressedDelete(index);
                    },
                  ),
                  title: Container(
                    height: 200.0,
                    padding: EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        filteredMovies[index].posterPath != null
                            ? Hero(
                                child: Image.network(
                                    "https://image.tmdb.org/t/p/w92${filteredMovies[index].posterPath}"),
                                tag: filteredMovies[index].title,
                              )
                            : Container(),
                        Expanded(
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                filteredMovies[index].title,
                                maxLines: 10,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
