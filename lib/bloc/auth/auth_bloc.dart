import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  AuthBloc() : super(AuthInitial()) {
    // Register both handlers in the same constructor
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
  }

  // --- LOGIN HANDLER ---
  Future<void> _onLoginRequested(
      LoginRequested event,
      Emitter<AuthState> emit,
      ) async {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

    if (!emailRegex.hasMatch(event.email)) {
      return emit(AuthFailure("Enter a valid Gmail address"));
    }
    if (event.password.length < 6) {
      return emit(AuthFailure("Password must be at least 6 characters"));
    }

    emit(AuthLoading());

    try {
      await _auth.signInWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );
      emit(AuthSuccess("Login Success"));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Login Failed"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  // --- REGISTER HANDLER ---
  Future<void> _onRegisterRequested(
      RegisterRequested event,
      Emitter<AuthState> emit,
      ) async {
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');

    if (event.fullName.isEmpty) {
      return emit(AuthFailure("Please enter your full name"));
    }
    if (!emailRegex.hasMatch(event.email)) {
      return emit(AuthFailure("Enter a valid Gmail address"));
    }
    if (event.password.length < 6) {
      return emit(AuthFailure("Password must be at least 6 characters"));
    }

    emit(AuthLoading());

    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: event.email.trim(),
        password: event.password.trim(),
      );

      await userCredential.user!.updateDisplayName(event.fullName.trim());

      emit(AuthSuccess("Registration Success"));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Registration Failed"));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}