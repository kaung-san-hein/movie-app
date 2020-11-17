import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:movie_admin/models/genre_model.dart';
import 'package:movie_admin/models/movie_model.dart';
import 'package:movie_admin/my_router.dart';
import 'package:movie_admin/services/genre_service.dart';
import 'package:movie_admin/services/movie_service.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<List<GenreModel>>.value(
          initialData: <GenreModel>[],
          value: GenreService.genreStream(),
        ),
        StreamProvider<List<MovieModel>>.value(
          initialData: <MovieModel>[],
          value: MovieService.movieStream(),
        ),
      ],
      child: MaterialApp(
        title: 'Movie Admin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: MyRouter.GENRES_SCREEN,
        onGenerateRoute: MyRouter.onGenerateRoute,
      ),
    );
  }
}
