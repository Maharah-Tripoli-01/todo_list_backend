import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_backend/domain/task.dart';
import 'package:todo_list_backend/cubit/task_state.dart';
import 'package:http/http.dart' as http;
import 'package:todo_list_backend/firebase_datasrouce.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskStateLoading()) {
    fetchTasks();
  }

  void changeFilter(FilterBy filterBy) {
    if (state is TaskStateLoaded) {
      final loaded = state as TaskStateLoaded;
      emit(loaded.copyWith(filterBy: filterBy));
    }
  }

  Future<void> fetchTasks() async {
    emit(TaskStateLoading());
    try {
      // final response = await http
      //     .get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
      //
      // final List<dynamic> jsonResponse = jsonDecode(response.body);
      //
      // final listOfTasks =
      //     jsonResponse.map((map) => Task.fromJson(map)).toList();

      // final listOfTasks = await FirebaseDataSource.getTasks();
      // emit(TaskStateLoaded(allTasks: listOfTasks));
      FirebaseDataSource.getTasks().listen((event) {

        final listOfTasks = event.docs
            .map(
              (e) => Task.fromJson(e.data()..addAll({'id': e.id})),
            )
            .toList();

        emit(TaskStateLoaded(allTasks: listOfTasks));
      });
    } on Exception catch (e) {
      emit(TaskStateError(error: e));
    }
  }
}
