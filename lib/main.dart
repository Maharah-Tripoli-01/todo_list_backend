import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_backend/cubit/task_cubit.dart';
import 'package:todo_list_backend/cubit/task_state.dart';
import 'package:todo_list_backend/widgets/tasks_list.dart';

void main() {
  runApp(
    BlocProvider<TaskCubit>(
      create: (BuildContext context) => TaskCubit(),
      child: const MainApp(),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskCubit>().state;

    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: switch (state) {
            TaskStateLoaded() => TasksList(loadedState: state),
            TaskStateLoading() => const CircularProgressIndicator(),
            TaskStateError(error: final error) => Text(error.toString()),
          },
        ),
      ),
    );
  }
}
