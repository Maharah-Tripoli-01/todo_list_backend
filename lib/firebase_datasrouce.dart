import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list_backend/domain/task.dart';

abstract class FirebaseDataSource {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getTasks() {
    final Stream<QuerySnapshot<Map<String, dynamic>>> stream =
        db.collection('tasks').snapshots();

    return stream;
  }
}
