import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_backend/home/cubit/task_cubit.dart';
import 'package:todo_list_backend/home/cubit/task_state.dart';

class TasksList extends StatelessWidget {
   TasksList({
    super.key,
    required this.loadedState,
  });

  final TaskStateLoaded loadedState;

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filterBy = loadedState.filterBy;

    final theList = loadedState.getViewList();

    final cubit = context.read<TaskCubit>();
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
            cubit.changeFilter(filterBy);
          },
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextField(
            controller: controller,
            decoration: const InputDecoration(
              labelText: 'Write your task here',
              border: OutlineInputBorder(),
            ),
            onSubmitted: (text) {
              cubit.addTask(title: text);
              controller.clear();
            },
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: theList.length,
            itemBuilder: (context, index) {
              final task = theList[index];
              return CheckboxListTile(
                title: Text(task.title),
                value: task.completed,
                onChanged: (checked) {
                  cubit.changeTaskState(
                    id: task.id,
                    completed: checked ?? false,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
