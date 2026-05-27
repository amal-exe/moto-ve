import '../../data/models/cars.dart';
import 'package:equatable/equatable.dart';


//recommendation

enum RecommendationStatus { initial, loading, success, failure }

class RecommendationState extends Equatable {
  final RecommendationStatus status;
  final List<Vehicle> vehicles;
  final Map<String, int> matchPercentages; // Pre-calculated for the UI

  const RecommendationState({
    this.status = RecommendationStatus.initial,
    this.vehicles = const [],
    this.matchPercentages = const {},
  });

  RecommendationState copyWith({
    RecommendationStatus? status,
    List<Vehicle>? vehicles,
    Map<String, int>? matchPercentages,
  }) {
    return RecommendationState(
      status: status ?? this.status,
      vehicles: vehicles ?? this.vehicles,
      matchPercentages: matchPercentages ?? this.matchPercentages,
    );
  }

  @override
  List<Object?> get props => [status, vehicles, matchPercentages];
}

class PreferenceState {
  final double budget;
  final String usage;
  final String vehicleType; // New field
  final String priority;

  PreferenceState({
    this.budget = 1000000,
    this.usage = 'City Driving',
    this.vehicleType = 'SUV', // Default value
    this.priority = 'Mileage',
  });

  PreferenceState copyWith({
    double? budget,
    String? usage,
    String? vehicleType,
    String? priority,
  }) {
    return PreferenceState(
      budget: budget ?? this.budget,
      usage: usage ?? this.usage,
      vehicleType: vehicleType ?? this.vehicleType,
      priority: priority ?? this.priority,
    );
  }
}