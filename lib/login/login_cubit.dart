import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class LoginState {}

class LoginSuccessState extends LoginState {}

class LoginSubmittingState extends LoginState {}

class LoginInitialState extends LoginState {}

class LoginErrorState extends LoginState {
  final Object error;

  LoginErrorState({required this.error});
}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  Future<void> login(String email, String password) async {
    emit(LoginSubmittingState());
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(LoginSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(LoginErrorState(error: e));
      /// handle firebase auth exceptions based on the documentation
      print('$e');
    } catch (e) {
      emit(LoginErrorState(error: e));
      print(e);
    }
  }
}
