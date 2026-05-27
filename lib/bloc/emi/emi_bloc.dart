import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'emi_event.dart';
import 'emi_state.dart';

class EmiBloc extends Bloc<EmiEvent, EmiState> {
  final double vehiclePrice;

  EmiBloc({required this.vehiclePrice})
      : super(EmiState(downPayment: (vehiclePrice * 100000) * 0.10)) {

    on<UpdateDownPayment>((event, emit) {
      emit(state.copyWith(downPayment: event.amount));
    });

    on<UpdateTenure>((event, emit) {
      emit(state.copyWith(years: event.years));
    });

    on<CalculateEmiResult>((event, emit) {
      final double price = vehiclePrice * 100000;
      final double principal = price - state.downPayment;
      final int months = state.years * 12;
      final double r = event.interestRate / 12 / 100;

      if (principal <= 0 || r <= 0) {
        emit(state.copyWith(emiResult: 0));
        return;
      }

      final double emiValue = (principal * r * pow(1 + r, months)) /
          (pow(1 + r, months) - 1);

      emit(state.copyWith(emiResult: emiValue));
    });
  }
}