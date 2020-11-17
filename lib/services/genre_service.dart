import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_admin/models/genre_model.dart';

class GenreService {
  static final CollectionReference _ref =
      FirebaseFirestore.instance.collection('genres');

  static Stream<List<GenreModel>> genreStream() {
    return _ref.orderBy('created', descending: true).snapshots().map((event) =>
        event.docs
            .map((e) => GenreModel.fromQueryDocumentSnapshot(e))
            .toList());
  }

  static Future<bool> checkDocumentsByName(String name) async {
    final QuerySnapshot qsn = await _ref.get();
    for (QueryDocumentSnapshot doc in qsn.docs) {
      final data = doc.data();
      String nameField = data['name'];

      if (nameField.toLowerCase() == name.toLowerCase()) {
        return Future.value(true);
      }
    }

    return Future.value(false);
  }

  static Future<void> save(GenreModel genreModel) async {
    await _ref.add(GenreModel.toMap(genreModel, isNew: true));
  }

  static Future<void> update(String id, GenreModel genreModel) async {
    await _ref.doc(id).update(GenreModel.toMap(genreModel));
  }

  static Future<void> delete(String id) async {
    await _ref.doc(id).delete();
  }
}
