import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

sealed class SignupState {}

class SignUpSuccessState extends SignupState {}

class SignUpSubmittingState extends SignupState {}

class SignUpInitialState extends SignupState {}

class SignUpErrorState extends SignupState {
  final Object error;

  SignUpErrorState({required this.error});
}

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignUpInitialState());

  Future<void> signUp(String email, String password) async {
    emit(SignUpSubmittingState());
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      emit(SignUpSuccessState());
    } on FirebaseAuthException catch (e) {
      emit(SignUpErrorState(error: e));
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      }
      print('$e');
    } catch (e) {
      emit(SignUpErrorState(error: e));
      print(e);
    }
  }
}
