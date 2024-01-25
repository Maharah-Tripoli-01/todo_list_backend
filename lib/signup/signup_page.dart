import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:todo_list_backend/signup/signup_cubit.dart';

@RoutePage()
class SignupPage extends StatelessWidget {
  SignupPage({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SignupCubit(),
      child: Builder(builder: (context) {
        final cubit = context.watch<SignupCubit>();
        final state = cubit.state;
        final isSubmitting = state is SignUpSubmittingState;
        return BlocListener<SignupCubit, SignupState>(
          listener: (BuildContext context, SignupState state) {
            print('$state');

            if (state is SignUpSuccessState) {
              context.router.popUntilRoot();
            }
          },
          child: Scaffold(
            appBar: AppBar(
              title: const Text('SignUp'),
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
                    obscureText: true,
                    controller: passwordController,
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
                                  cubit.signUp(
                                    emailController.text,
                                    passwordController.text,
                                  );
                                },
                          child: Row(
                            children: [
                              const Text('Sign Up'),
                              if (isSubmitting)
                                const CircularProgressIndicator(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
