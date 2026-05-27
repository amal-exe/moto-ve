import 'package:equatable/equatable.dart';

abstract class NavEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class TabChanged extends NavEvent {
  final int index;
  TabChanged(this.index);

  @override
  List<Object> get props => [index];
}