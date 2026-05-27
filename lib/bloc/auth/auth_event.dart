import 'package:equatable/equatable.dart';

// Define this ONLY ONCE
abstract class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

// First event inherits from the base class above
class LoginRequested extends AuthEvent {
  final String email;
  final String password;

  LoginRequested(this.email, this.password);

  @override
  List<Object?> get props => [email, password];
}

// Second event also inherits from the SAME base class above
class RegisterRequested extends AuthEvent {
  final String fullName;
  final String email;
  final String password;

  RegisterRequested({
    required this.fullName,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullName, email, password];
}
