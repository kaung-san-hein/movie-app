import 'package:cloud_firestore/cloud_firestore.dart';

class MovieModel {
  MovieModel({
    this.id,
    this.title,
    this.imageUrl,
    this.key,
    this.genreId,
    this.genreName,
  });

  final String id;
  final String title;
  final String imageUrl;
  final String key;
  final String genreId;
  final String genreName;

  static const String titleField = 'title';
  static const String imageUrlField = 'imageUrl';
  static const String keyField = 'key';
  static const String genreIdField = 'genreId';
  static const String genreNameField = 'genreName';
  static const String createdField = 'created';

  factory MovieModel.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot queryDocumentSnapshot) {
    final data = queryDocumentSnapshot.data();
    return MovieModel(
      id: queryDocumentSnapshot.id,
      title: data[titleField],
      imageUrl: data[imageUrlField],
      key: data[keyField],
      genreId: data[genreIdField],
      genreName: data[genreNameField],
    );
  }

  static Map<String, dynamic> toMap(MovieModel movieModel,
      {bool isNew = false}) {
    Map<String, dynamic> data = {
      titleField: movieModel.title,
      imageUrlField: movieModel.imageUrl,
      keyField: movieModel.key,
      genreIdField: movieModel.genreId,
      genreNameField: movieModel.genreName,
    };

    if (isNew) {
      data[createdField] = FieldValue.serverTimestamp();
    }

    return data;
  }
}
