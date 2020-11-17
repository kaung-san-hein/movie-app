import 'package:cloud_firestore/cloud_firestore.dart';

class GenreModel {
  final String name;
  final String id;

  GenreModel({this.name, this.id});

  factory GenreModel.fromQueryDocumentSnapshot(
      QueryDocumentSnapshot queryDocumentSnapshot) {
    final data = queryDocumentSnapshot.data();
    return GenreModel(
      name: data['name'],
      id: queryDocumentSnapshot.id,
    );
  }

  static Map<String, dynamic> toMap(GenreModel genreModel,
      {bool isNew = false}) {
    Map<String, dynamic> data = {
      'name': genreModel.name,
    };

    if (isNew) {
      data['created'] = FieldValue.serverTimestamp();
    }

    return data;
  }
}
