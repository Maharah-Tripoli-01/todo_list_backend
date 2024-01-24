import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_backend/cubit/task_cubit.dart';
import 'package:todo_list_backend/cubit/task_state.dart';
import 'package:todo_list_backend/domain/task.dart';

class TasksList extends StatelessWidget {
  const TasksList({
    super.key,
    required this.loadedState,
  });

  final TaskStateLoaded loadedState;

  @override
  Widget build(BuildContext context) {
    final filterBy = loadedState.filterBy;

    final theList = loadedState.getViewList();

    return Column(
      children: [
        CupertinoSegmentedControl<FilterBy>(
          groupValue: filterBy,
          children: const {
            FilterBy.all: Text('All'),
            FilterBy.completed: Text('Completed'),
            FilterBy.uncompleted: Text('UnCompleted'),
          },
          onValueChanged: (filterBy) {
            context.read<TaskCubit>().changeFilter(filterBy);
          },
        ),
        Expanded(
          child: ListView.builder(
            itemCount: theList.length,
            itemBuilder: (context, index) {
              final task = theList[index];
              return CheckboxListTile(
                title: Text(task.title),
                value: task.completed,
                onChanged: (checked) {},
              );
            },
          ),
        ),
      ],
    );
  }
}
