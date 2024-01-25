import 'package:auto_route/auto_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_list_backend/app_router.gr.dart';
import 'package:todo_list_backend/home/cubit/task_cubit.dart';
import 'package:todo_list_backend/home/cubit/task_state.dart';
import 'package:todo_list_backend/home/widgets/tasks_list.dart';

@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<TaskCubit>().state;

    return Scaffold(
      appBar: AppBar(
        title: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) =>
              Text(snapshot.data?.email ?? ''),
        ),
        actions: [

          IconButton(
            onPressed: () {
              context.pushRoute( LoginRoute(onResult: (){}));
            },
            icon: const Icon(Icons.person),
          ),
          IconButton(
            onPressed: () {
           FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: switch (state) {
          TaskStateLoaded() => TasksList(loadedState: state),
          TaskStateLoading() => const CircularProgressIndicator(),
          TaskStateError(error: final error) => Text(error.toString()),
        },
      ),
    );
  }
}
