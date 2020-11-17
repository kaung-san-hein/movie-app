import 'package:flutter/material.dart';
import 'package:movie_admin/models/genre_model.dart';
import 'package:movie_admin/services/genre_service.dart';
import 'package:movie_admin/utils/constants.dart';
import 'package:movie_admin/utils/ui_helper.dart';
import 'package:movie_admin/widgets/form_wrapper.dart';
import 'package:movie_admin/widgets/my_text_form_field.dart';

class GenreForm extends StatefulWidget {
  final GenreModel genre;

  GenreForm({this.genre});

  @override
  _GenreFormState createState() => _GenreFormState();
}

class _GenreFormState extends State<GenreForm> {
  GenreModel _genreModel;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  bool _isExist = false;

  void _init() {
    if (_genreModel != null) {
      _nameController.text = _genreModel.name;
    }
  }

  Future<void> _handleSave() async {
    final name = _nameController.text.trim();

    // check already taken
    final result = await GenreService.checkDocumentsByName(name);
    setState(() {
      if (result) {
        _isExist = true;
        _formKey.currentState.validate();
      } else {
        _isExist = false;
      }
    });

    if (!result) {
      GenreModel genre = GenreModel(name: name);

      if (_genreModel == null) {
        await GenreService.save(genre);
      } else {
        await GenreService.update(_genreModel.id, genre);
        Navigator.pop(context);
      }

      UIHelper.showSuccessFlushbar(context, "Genre was saved successfully!");
      _formKey.currentState.reset();
      _nameController.clear();
    }
  }

  Future<void> _handleDelete() async {
    FocusScope.of(context).requestFocus(FocusNode());
    await GenreService.delete(_genreModel.id);
    Navigator.pop(context);

    UIHelper.showSuccessFlushbar(context, "Genre was deleted successfully!");
  }

  String _validateName(String value) {
    if (value.trim().isEmpty) {
      return "Name is required.";
    }
    if (_isExist) {
      _isExist = false;
      return "Name is already taken.";
    }
    return null;
  }

  @override
  void initState() {
    _genreModel = widget.genre;
    _init();
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = _genreModel == null ? "Create Genre" : "Edit Genre";
    final String label = _genreModel == null ? "Save" : "Update";

    return FormWrapper(
      formKey: _formKey,
      appbarTitle: title,
      btnLabel: label,
      model: _genreModel,
      handleDelete: _handleDelete,
      handleSave: _handleSave,
      formItems: [
        MyTextFormField(
          controller: _nameController,
          autofocus: true,
          decoration: kFormFieldInputDecoration.copyWith(
            labelText: 'Name *',
          ),
          validator: _validateName,
        ),
      ],
    );
  }
}
