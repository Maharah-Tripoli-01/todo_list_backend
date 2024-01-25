import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_backend/firebase_datasrouce.dart';
import 'package:todo_list_backend/home/cubit/task_state.dart';
import 'package:todo_list_backend/home/domain/task.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskStateLoading()) {
    fetchTasks();
  }

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _tasksSub;

  void changeFilter(FilterBy filterBy) {
    if (state is TaskStateLoaded) {
      final loaded = state as TaskStateLoaded;
      emit(loaded.copyWith(filterBy: filterBy));
    }
  }

  @override
  Future<void> close() async {
    super.close();
    _tasksSub?.cancel();
  }

  Future<void> changeTaskState({
    required String id,
    required bool completed,
  }) {
    return FirebaseDataSource.updateTask(
      id,
      {
        'completed': completed,
      },
    );
  }

  Future<void> addTask({
    required String title,
  }) {
    return FirebaseDataSource.addTask(title);
  }

  Future<void> fetchTasks() async {
    emit(TaskStateLoading());
    try {
      _tasksSub = FirebaseDataSource.getTasks().listen((event) {
        final listOfTasks = event.docs.map(
          (doc) {
            final taskMap = doc.data();
            final taskMapWithId = {
              ...taskMap,
              'id': doc.id,
            };
            return Task.fromJson(taskMapWithId);
          },
        ).toList();

        emit(TaskStateLoaded(allTasks: listOfTasks));
      });
    } on Exception catch (e) {
      emit(TaskStateError(error: e));
    }
  }
}
