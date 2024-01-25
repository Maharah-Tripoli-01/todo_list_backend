import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:todo_list_backend/app_router.gr.dart';
import 'package:todo_list_backend/login/login_cubit.dart';

@RoutePage()
class LoginPage extends StatelessWidget {
   LoginPage({super.key, required this.onResult});
   final void Function() onResult ;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(),
      child: Builder(
        builder: (context) {
          final cubit = context.watch<LoginCubit>();
          final state = cubit.state;
          final isSubmitting = state is LoginSubmittingState;

          return BlocListener<LoginCubit,LoginState>(
            listener: (BuildContext context, LoginState state) {

              if (state is LoginSuccessState) {
                onResult();
              }

            },
            child: Scaffold(
              appBar: AppBar(
                title: const Text('Login'),
              ),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                     TextField(
                      controller: emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const Gap(16),
                     TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Password',
                      ),
                    ),
                    const Gap(16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: isSubmitting
                                ? null
                                : () {
                              cubit.login(
                                emailController.text,
                                passwordController.text,
                              );
                            },
                            child: Row(
                              children: [
                                const Text('Login'),
                                if (isSubmitting)
                                  const CircularProgressIndicator(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        context.pushRoute( SignupRoute());
                      },
                      child: const Text('Sign Up'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      ),
    );
  }
}
