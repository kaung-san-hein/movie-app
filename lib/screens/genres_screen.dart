import 'package:flutter/material.dart';
import 'package:movie_admin/models/genre_model.dart';
import 'package:movie_admin/my_router.dart';
import 'package:movie_admin/screens/genre_form.dart';
import 'package:movie_admin/utils/constants.dart';
import 'package:movie_admin/widgets/master_view.dart';
import 'package:movie_admin/widgets/my_text_form_field.dart';
import 'package:provider/provider.dart';

class GenresScreen extends StatefulWidget {
  @override
  _GenresScreenState createState() => _GenresScreenState();
}

class _GenresScreenState extends State<GenresScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<GenreModel> _filterGenres = [];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    setState(() {
      _filterGenres = [];
      _searchController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final genres = Provider.of<List<GenreModel>>(context);
    final results = _filterGenres.length == 0 ? genres : _filterGenres;

    return MasterView(
      title: "Genres",
      onPressed: () async {
        await MyRouter.buildMaterialRoute(context, child: GenreForm());
        _clearSearch();
      },
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(10.0),
            child: MyTextFormField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              decoration: kSearchInputDecoration.copyWith(
                hintText: "Search Genre",
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          _clearSearch();
                        },
                      )
                    : null,
              ),
              onChanged: (value) {
                setState(() {});
              },
              onFieldSubmitted: (String value) {
                if (value.trim().isNotEmpty) {
                  _filterGenres = genres
                      .where((genre) => genre.name
                          .toLowerCase()
                          .contains(value.toLowerCase()))
                      .toList();
                } else {
                  _filterGenres = genres;
                }
                setState(() {});
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              separatorBuilder: (context, index) => Divider(),
              itemCount: results.length,
              itemBuilder: (context, index) {
                final genre = results[index];
                return ListTile(
                  title: Text(genre.name),
                  trailing: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () async {
                      await MyRouter.buildMaterialRoute(context,
                          child: GenreForm(genre: genre));
                      _clearSearch();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
