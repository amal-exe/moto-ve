abstract class EmiEvent {}

class UpdateDownPayment extends EmiEvent {
  final double amount;
  UpdateDownPayment(this.amount);
}

class UpdateTenure extends EmiEvent {
  final int years;
  UpdateTenure(this.years);
}

class CalculateEmiResult extends EmiEvent {
  final double interestRate;
  CalculateEmiResult(this.interestRate);
}