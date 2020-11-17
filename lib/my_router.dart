import 'package:flutter/material.dart';
import 'package:movie_admin/screens/genres_screen.dart';
import 'package:movie_admin/screens/movies_screen.dart';

class MyRouter {
  static const String GENRES_SCREEN = 'genres_screen';
  static const String MOVIES_SCREEN = 'movies_screen';

  static Future buildMaterialRoute(BuildContext context,
      {Widget child, bool isFullScreen = true}) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => child,
        fullscreenDialog: isFullScreen,
      ),
    );
  }

  static PageRouteBuilder<dynamic> _pageRouteBuilder(Widget widget) {
    return PageRouteBuilder(pageBuilder: (context, _, __) => widget);
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case GENRES_SCREEN:
        return _pageRouteBuilder(GenresScreen());
      case MOVIES_SCREEN:
        return _pageRouteBuilder(MoviesScreen());
      default:
        return _pageRouteBuilder(
          Scaffold(
            body: Center(
              child: Text("No route defines for ${settings.name}"),
            ),
          ),
        );
    }
  }
}
