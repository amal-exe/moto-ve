import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moto_ve/bloc/recommendation/recommendation_event.dart';
import 'package:moto_ve/bloc/recommendation/recommendation_state.dart';
import '../../data/models/cars.dart';
import '../../data/models/user_preference.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//recommendation

class RecommendationBloc extends Bloc<RecommendationEvent, RecommendationState> {
  RecommendationBloc() : super( RecommendationState()) {
    on<FetchRecommendations>(_onFetchRecommendations);
  }

  Future<void> _onFetchRecommendations(
      FetchRecommendations event, Emitter<RecommendationState> emit) async {
    emit(state.copyWith(status: RecommendationStatus.loading));

    try {
      final snapshot = await FirebaseFirestore.instance.collection("vehicle").get();
      List<Vehicle> allVehicles = snapshot.docs
          .map((doc) => Vehicle.fromMap(doc.data(), doc.id))
          .toList();

      // Filtering logic
      final prefType = event.preference.type.toLowerCase();
      List<Vehicle> filtered = allVehicles.where((v) {
        if (prefType == "bike") return v.category.toLowerCase() == "bike";
        if (prefType == "ev") return v.isElectric == true;
        return v.category.toLowerCase() == "car";
      }).toList();

      if (filtered.isEmpty) filtered = allVehicles;

      // Scoring and Sorting
      Map<String, int> percentages = {};
      for (var v in filtered) {
        double score = _calculateScore(v, event.preference);
        percentages[v.id] = score.clamp(0, 100).round();
      }

      filtered.sort((a, b) => (percentages[b.id] ?? 0).compareTo(percentages[a.id] ?? 0));

      emit(state.copyWith(
        status: RecommendationStatus.success,
        vehicles: filtered,
        matchPercentages: percentages,
      ));
    } catch (e) {
      emit(state.copyWith(status: RecommendationStatus.failure));
    }
  }

  double _calculateScore(Vehicle v, UserPreference u) {
    double score = 0;
    if (v.price <= u.budget) score += 40;
    if (v.category.toLowerCase() == u.type.toLowerCase()) score += 25;
    if (v.usedTo.toLowerCase() == u.usage.toLowerCase()) score += 20;

    switch (u.priority) {
      case "Power": score += (v.power / 10); break;
      case "Mileage": score += v.isElectric ? 25 : v.mileage / 2; break;
      case "Features": score += v.rating * 10; break;
      case "Low Maintenance": score += v.isElectric ? 20 : 10; break;
    }
    return score;
  }
}


class PreferenceBloc extends Bloc<PreferenceEvent, PreferenceState> {
  PreferenceBloc() : super(PreferenceState()) {

    // Step 1: Budget
    on<UpdateBudget>((event, emit) {
      emit(state.copyWith(budget: event.budget));
    });

    // Step 2: Usage
    on<UpdateUsage>((event, emit) {
      emit(state.copyWith(usage: event.usage));
    });

    // Step 3: Vehicle Type
    on<UpdateVehicleType>((event, emit) {
      emit(state.copyWith(vehicleType: event.vehicleType));
    });

    // Step 4: Priority
    on<UpdatePriority>((event, emit) {
      emit(state.copyWith(priority: event.priority));
    });

    // Optional: Reset the form
    on<ResetPreferences>((event, emit) {
      emit(PreferenceState());
    });
  }
}