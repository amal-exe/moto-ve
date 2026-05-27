import 'package:equatable/equatable.dart';
import '../../data/models/user_preference.dart';

//recommendation


abstract class RecommendationEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchRecommendations extends RecommendationEvent {
  final UserPreference preference;
  FetchRecommendations(this.preference);

  @override
  List<Object?> get props => [preference];
}
abstract class PreferenceEvent {}

class UpdateBudget extends PreferenceEvent {
  final double budget;
  UpdateBudget(this.budget);
}

class UpdateUsage extends PreferenceEvent {
  final String usage;
  UpdateUsage(this.usage);
}

class UpdateVehicleType extends PreferenceEvent {
  final String vehicleType;
  UpdateVehicleType(this.vehicleType);
}

class UpdatePriority extends PreferenceEvent {
  final String priority;
  UpdatePriority(this.priority);
}

class ResetPreferences extends PreferenceEvent {}