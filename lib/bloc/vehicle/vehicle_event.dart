import 'package:equatable/equatable.dart';

abstract class BikeEvent extends Equatable {
  const BikeEvent();

  @override
  List<Object?> get props => [];
}

/// LOAD INITIAL DATA
class LoadFilters extends BikeEvent {}

/// APPLY FILTERS
class FilterChanged extends BikeEvent {
  final String brand;
  final String type;
  final String cc;
  final String mileage;

  const FilterChanged({
    required this.brand,
    required this.type,
    required this.cc,
    required this.mileage,
  });

  @override
  List<Object?> get props => [
    brand,
    type,
    cc,
    mileage,
  ];
}

/// TEMP FILTER CHANGES
/// (USED INSIDE BOTTOM SHEET)
class TempFilterChanged extends BikeEvent {
  final String? brand;
  final String? type;
  final String? cc;
  final String? mileage;

  const TempFilterChanged({
    this.brand,
    this.type,
    this.cc,
    this.mileage,
  });

  @override
  List<Object?> get props => [
    brand,
    type,
    cc,
    mileage,
  ];
}

/// RESET FILTERS
class ResetFilters extends BikeEvent {}

/// SEARCH
class BikeSearchChanged extends BikeEvent {
  final String query;

  const BikeSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}


//car


abstract class CarEvent extends Equatable {
  const CarEvent();

  @override
  List<Object?> get props => [];
}

/// LOAD INITIAL DATA
class LoadCarFilters extends CarEvent {}

/// APPLY FILTERS
class CarFilterChanged extends CarEvent {
  final String brand;
  final String type;
  final String mileage;

  const CarFilterChanged({
    required this.brand,
    required this.type,
    required this.mileage,
  });

  @override
  List<Object?> get props => [
    brand,
    type,
    mileage,
  ];
}

/// TEMP FILTER CHANGES
class TempCarFilterChanged extends CarEvent {
  final String? brand;
  final String? type;
  final String? mileage;

  const TempCarFilterChanged({
    this.brand,
    this.type,
    this.mileage,
  });

  @override
  List<Object?> get props => [
    brand,
    type,
    mileage,
  ];
}

/// RESET FILTERS
class ResetCarFilters extends CarEvent {}

/// SEARCH
class CarSearchChanged extends CarEvent {
  final String query;

  const CarSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}

//ev


abstract class EvEvent extends Equatable {
  const EvEvent();

  @override
  List<Object?> get props => [];
}

/// LOAD INITIAL DATA
class LoadEvFilters extends EvEvent {}

/// APPLY FILTERS
class EvFilterChanged extends EvEvent {
  final String brand;
  final String type;
  final String battery;
  final String range;

  const EvFilterChanged({
    required this.brand,
    required this.type,
    required this.battery,
    required this.range,
  });

  @override
  List<Object?> get props => [
    brand,
    type,
    battery,
    range,
  ];
}

/// TEMP FILTER CHANGES
class TempEvFilterChanged extends EvEvent {
  final String? brand;
  final String? type;
  final String? battery;
  final String? range;

  const TempEvFilterChanged({
    this.brand,
    this.type,
    this.battery,
    this.range,
  });

  @override
  List<Object?> get props => [
    brand,
    type,
    battery,
    range,
  ];
}

/// RESET FILTERS
class ResetEvFilters extends EvEvent {}

/// SEARCH
class EvSearchChanged extends EvEvent {
  final String query;

  const EvSearchChanged(this.query);

  @override
  List<Object?> get props => [query];
}


//home


abstract class VehicleEvent {}

class LoadTrendingBikes extends VehicleEvent {}

class LoadTrendingCars extends VehicleEvent {}

class LoadAds extends VehicleEvent {}

class ToggleFavorite extends VehicleEvent {
  final Map<String, dynamic> item;

  ToggleFavorite(this.item);
}

class SearchVehicle extends VehicleEvent {
  final String value;

  SearchVehicle(this.value);
}


//detail
abstract class DetailEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadVehicleDetails extends DetailEvent {
  final String vehicleId;
  LoadVehicleDetails(this.vehicleId);

  @override
  List<Object?> get props => [vehicleId];
}
//explore

abstract class ExploreEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadVehicles extends ExploreEvent {}

class SearchQueryChanged extends ExploreEvent {
  final String query;
  SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
