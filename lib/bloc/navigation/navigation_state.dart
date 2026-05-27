import 'package:equatable/equatable.dart';

class NavState extends Equatable {
  final int index;
  const NavState(this.index);

  @override
  List<Object> get props => [index];
}