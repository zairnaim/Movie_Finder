import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';
import 'dart:io';
import 'package:movie_finder/model/model.dart';

class MovieDatabase {
  static final MovieDatabase _instance = MovieDatabase._internal();
  static Database _db;

  factory MovieDatabase() => _instance;
  MovieDatabase._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  Future<Database> initDB() async {
    Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, "main.db");
    print("opening database");
    var theDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return theDb;
  }

  FutureOr<void> _onCreate(Database db, int version) async {
    print("creating database in oncreate");
    await db.execute('''CREATE TABLE Movies(id STRING PRIMARY KEY, 
        title TEXT, poster_path TEXT, 
        overview TEXT, 
        favored BIT)''');
    print("Database was created!");
  }

  Future<int> addMovie(Movie movie) async {
    var dbClient = await db;
    try {
      int res = await dbClient.insert("Movies", movie.toMap());
      print("movie added $res: " + movie.title);
      return res;
    } catch (e) {
      int res = await updateMovie(movie);
      return res;
    }
  }

  Future<int> updateMovie(Movie movie) async {
    var dbClient = await db;
    int res = await dbClient.update("Movies", movie.toMap(),
        where: "id = ?", whereArgs: [movie.id]);
    print("Movie updated $res");
    return res;
  }

  Future<int> deleteMovie(Movie movie) async {
    var dbClient = await db;
    int res =
        await dbClient.delete("Movies", where: "id = ?", whereArgs: [movie.id]);
    print("Movie deleted");
    return res;
  }

  Future closeDb() async {
    var dbClient = await db;
    dbClient.close();
  }


}
