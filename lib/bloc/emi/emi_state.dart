class EmiState {
  final double downPayment;
  final int years;
  final double emiResult;

  EmiState({
    required this.downPayment,
    this.years = 5,
    this.emiResult = 0,
  });

  EmiState copyWith({
    double? downPayment,
    int? years,
    double? emiResult,
  }) {
    return EmiState(
      downPayment: downPayment ?? this.downPayment,
      years: years ?? this.years,
      emiResult: emiResult ?? this.emiResult,
    );
  }
}