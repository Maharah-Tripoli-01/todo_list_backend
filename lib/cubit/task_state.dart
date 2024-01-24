import 'package:todo_list_backend/domain/task.dart';

sealed class TaskState {}

enum FilterBy {
  completed,
  uncompleted,
  all,
}

class TaskStateLoaded extends TaskState {
  final List<Task> allTasks;
  late final List<Task> completed;
  late final List<Task> uncompleted;
  final FilterBy filterBy;

  TaskStateLoaded({required this.allTasks, this.filterBy = FilterBy.all}) {
    completed = allTasks.where((task) => task.completed).toList();
    uncompleted = allTasks.where((task) => !task.completed).toList();
  }

  List<Task> getViewList() => switch (filterBy) {
        FilterBy.completed => completed,
        FilterBy.uncompleted => uncompleted,
        FilterBy.all => allTasks,
      };

  TaskStateLoaded copyWith({
    List<Task>? allTasks,
    FilterBy? filterBy,
  }) {
    return TaskStateLoaded(
      allTasks: allTasks ?? this.allTasks,
      filterBy: filterBy ?? this.filterBy,
    );
  }
}

class TaskStateLoading extends TaskState {}

class TaskStateError extends TaskState {
  final Object error;

  TaskStateError({required this.error});
}
