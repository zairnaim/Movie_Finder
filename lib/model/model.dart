import 'package:meta/meta.dart';

class Movie {
  String title, posterPath, id, overview;
  bool favored;

  Movie({
    @required this.title,
    @required this.posterPath,
    @required this.id,
    @required this.overview,
    this.favored,
  });

  Movie.fromJson(Map json)
      : title = json["title"],
        posterPath = json["poster_path"],
        id = json["id"].toString(),
        overview = json["overview"],
        favored = false;
}
