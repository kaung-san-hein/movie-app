import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_admin/models/movie_model.dart';

class MovieService {
  static CollectionReference _ref =
      FirebaseFirestore.instance.collection('movies');

  static Stream<List<MovieModel>> movieStream() {
    return _ref.orderBy('created', descending: true).snapshots().map((event) =>
        event.docs
            .map((e) => MovieModel.fromQueryDocumentSnapshot(e))
            .toList());
  }

  static Future<bool> checkDocumentsByTitle(String title) async {
    final QuerySnapshot qsn = await _ref.get();
    for (QueryDocumentSnapshot doc in qsn.docs) {
      final data = doc.data();
      String titleField = data[MovieModel.titleField];

      if (titleField.toLowerCase() == title.toLowerCase()) {
        return Future.value(true);
      }
    }

    return Future.value(false);
  }

  static Future<void> save(MovieModel movieModel) async {
    await _ref.add(MovieModel.toMap(movieModel, isNew: true));
  }

  static Future<void> update(String id, MovieModel movieModel) async {
    await _ref.doc(id).update(MovieModel.toMap(movieModel));
  }

  static Future<void> delete(String id) async {
    await _ref.doc(id).delete();
  }
}
