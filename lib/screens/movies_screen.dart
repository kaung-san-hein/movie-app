import 'package:flutter/material.dart';
import 'package:movie_admin/models/movie_model.dart';
import 'package:movie_admin/my_router.dart';
import 'package:movie_admin/screens/movies_form.dart';
import 'package:movie_admin/widgets/master_view.dart';
import 'package:movie_admin/widgets/image_tile.dart';
import 'package:provider/provider.dart';

class MoviesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movies = Provider.of<List<MovieModel>>(context);

    return MasterView(
      title: "Movies",
      onPressed: () async {
        await MyRouter.buildMaterialRoute(context, child: MoviesForm());
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              separatorBuilder: (_, __) => Divider(),
              itemCount: movies.length,
              itemBuilder: (BuildContext context, int index) {
                return ImageTile(
                  title: movies[index].title,
                  subTitle: movies[index].genreName,
                  imageURL: movies[index].imageUrl,
                  onEdit: () async {
                    await MyRouter.buildMaterialRoute(context,
                        child: MoviesForm(movieModel: movies[index]));
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
