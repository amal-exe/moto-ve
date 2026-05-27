import 'package:flutter_bloc/flutter_bloc.dart';
import 'navigation_event.dart';
import 'navigation_state.dart';


class NavBloc extends Bloc<NavEvent, NavState> {
  NavBloc() : super(const NavState(0)) {
    on<TabChanged>((event, emit) {
      emit(NavState(event.index));
    });
  }
}