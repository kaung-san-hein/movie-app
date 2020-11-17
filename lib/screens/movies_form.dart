import 'package:flutter/material.dart';
import 'package:movie_admin/models/genre_model.dart';
import 'package:movie_admin/models/movie_model.dart';
import 'package:movie_admin/services/movie_service.dart';
import 'package:movie_admin/utils/constants.dart';
import 'package:movie_admin/utils/ui_helper.dart';
import 'package:movie_admin/widgets/form_wrapper.dart';
import 'package:movie_admin/widgets/my_text_form_field.dart';
import 'package:provider/provider.dart';

class MoviesForm extends StatefulWidget {
  final MovieModel movieModel;

  MoviesForm({this.movieModel});

  @override
  _MoviesFormState createState() => _MoviesFormState();
}

class _MoviesFormState extends State<MoviesForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _imageURLController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  List<GenreModel> _genres = [];
  GenreModel _selectedGenre;
  bool _isExist = false;
  MovieModel _movie;

  @override
  void initState() {
    _movie = widget.movieModel;
    _init();
    super.initState();
  }

  void _init() {
    _genres = context.read<List<GenreModel>>();
    if (_movie == null) {
      _selectedGenre = _genres.first;
    } else {
      _titleController.text = _movie.title;
      _imageURLController.text = _movie.imageUrl;
      _keyController.text = _movie.key;
      _selectedGenre =
          _genres.where((genre) => genre.id == _movie.genreId).first;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _imageURLController.dispose();
    _keyController.dispose();
    super.dispose();
  }

  DropdownButton _buildDropdown() {
    List<DropdownMenuItem<GenreModel>> items = [];
    _genres.forEach((genre) {
      DropdownMenuItem<GenreModel> item = DropdownMenuItem<GenreModel>(
        child: Text(genre.name),
        value: genre,
      );
      items.add(item);
    });

    return DropdownButton(
      value: _selectedGenre,
      items: items,
      onChanged: (value) {
        setState(() {
          _selectedGenre = value;
        });
      },
    );
  }

  String _validateTitle(String value) {
    if (value.trim().isEmpty) return 'Title is required!';

    if (_isExist) {
      _isExist = false;
      return "Title is already taken.";
    }

    return null;
  }

  String _validateImageURL(String value) {
    if (value.trim().isEmpty) return 'Image URL is required!';
    return null;
  }

  String _validateKey(String value) {
    if (value.trim().isEmpty) return 'Key is required!';
    return null;
  }

  Future<void> _handleSave() async {
    final title = _titleController.text.trim();
    final imageURL = _imageURLController.text.trim();
    final key = _keyController.text.trim();

    // check already taken
    final result = await MovieService.checkDocumentsByTitle(title);
    setState(() {
      if (result) {
        _isExist = true;
        _formKey.currentState.validate();
      } else {
        _isExist = false;
      }
    });

    if (!result) {
      MovieModel newMovie = MovieModel(
        title: title,
        imageUrl: imageURL,
        key: key,
        genreId: _selectedGenre.id,
        genreName: _selectedGenre.name,
      );

      if (_movie == null) {
        await MovieService.save(newMovie);
      } else {
        await MovieService.update(_movie.id, newMovie);
        Navigator.pop(context);
      }

      UIHelper.showSuccessFlushbar(context, "Movie was saved successfully!");
      _formKey.currentState.reset();
      _titleController.clear();
      _imageURLController.clear();
      _keyController.clear();
    }
  }

  Future<void> _handleDelete() async {
    FocusScope.of(context).requestFocus(FocusNode());
    await MovieService.delete(_movie.id);
    Navigator.pop(context);

    UIHelper.showSuccessFlushbar(context, "Movie was deleted successfully!");
  }

  @override
  Widget build(BuildContext context) {
    final String title = _movie == null ? "Create Movie" : "Edit Movie";
    final String label = _movie == null ? "Save" : "Update";

    return FormWrapper(
      formKey: _formKey,
      appbarTitle: title,
      btnLabel: label,
      model: _movie,
      handleSave: _handleSave,
      handleDelete: _handleDelete,
      formItems: [
        MyTextFormField(
          controller: _titleController,
          autofocus: true,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: "Title *",
          ),
          validator: _validateTitle,
        ),
        _buildDropdown(),
        MyTextFormField(
          controller: _imageURLController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: "Image URL *",
          ),
          validator: _validateImageURL,
        ),
        MyTextFormField(
          controller: _keyController,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: "Key *",
          ),
          validator: _validateKey,
        ),
      ],
    );
  }
}
