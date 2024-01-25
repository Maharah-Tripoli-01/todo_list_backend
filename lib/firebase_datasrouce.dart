import 'package:cloud_firestore/cloud_firestore.dart';

abstract class FirebaseDataSource {
  static FirebaseFirestore db = FirebaseFirestore.instance;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getTasks() {
    final Stream<QuerySnapshot<Map<String, dynamic>>> stream =
        db.collection('tasks').snapshots();

    return stream;
  }

  /// task map should not contain the id
  static Future<void> updateTask(
    String taskId,
    Map<String, dynamic> taskMap,
  ) {
    return db.collection('tasks').doc(taskId).update(taskMap);
  }

  static Future<void> addTask(
    String title,
  ) {
    return db.collection('tasks').add({
      'title': title,
      'completed': false,
    });
  }
}
