import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class BikeState extends Equatable {
  /// FILTER OPTIONS
  final List<String> brands;
  final List<String> types;

  /// APPLIED FILTERS
  final String selectedBrand;
  final String selectedType;
  final String selectedCC;
  final String selectedMileage;

  /// TEMP FILTERS (BOTTOM SHEET)
  final String tempBrand;
  final String tempType;
  final String tempCC;
  final String tempMileage;

  /// SEARCH
  final String searchQuery;

  /// VEHICLES
  final List<DocumentSnapshot> allBikes;
  final List<DocumentSnapshot> filteredBikes;

  /// LOADING
  final bool isLoading;

  const BikeState({
    this.brands = const ["All"],
    this.types = const ["All"],

    this.selectedBrand = "All",
    this.selectedType = "All",
    this.selectedCC = "All",
    this.selectedMileage = "All",

    this.tempBrand = "All",
    this.tempType = "All",
    this.tempCC = "All",
    this.tempMileage = "All",

    this.searchQuery = '',

    this.allBikes = const [],
    this.filteredBikes = const [],

    this.isLoading = false,
  });

  BikeState copyWith({
    List<String>? brands,
    List<String>? types,

    String? selectedBrand,
    String? selectedType,
    String? selectedCC,
    String? selectedMileage,

    String? tempBrand,
    String? tempType,
    String? tempCC,
    String? tempMileage,

    String? searchQuery,

    List<DocumentSnapshot>? allBikes,
    List<DocumentSnapshot>? filteredBikes,

    bool? isLoading,
  }) {
    return BikeState(
      brands: brands ?? this.brands,
      types: types ?? this.types,

      selectedBrand:
      selectedBrand ?? this.selectedBrand,

      selectedType:
      selectedType ?? this.selectedType,

      selectedCC:
      selectedCC ?? this.selectedCC,

      selectedMileage:
      selectedMileage ??
          this.selectedMileage,

      tempBrand:
      tempBrand ?? this.tempBrand,

      tempType:
      tempType ?? this.tempType,

      tempCC:
      tempCC ?? this.tempCC,

      tempMileage:
      tempMileage ?? this.tempMileage,

      searchQuery:
      searchQuery ?? this.searchQuery,

      allBikes:
      allBikes ?? this.allBikes,

      filteredBikes:
      filteredBikes ??
          this.filteredBikes,

      isLoading:
      isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [
    /// FILTER OPTIONS
    brands,
    types,

    /// APPLIED FILTERS
    selectedBrand,
    selectedType,
    selectedCC,
    selectedMileage,

    /// TEMP FILTERS
    tempBrand,
    tempType,
    tempCC,
    tempMileage,

    /// SEARCH
    searchQuery,

    /// VEHICLES
    allBikes,
    filteredBikes,

    /// LOADING
    isLoading,
  ];
}


//car


class CarState extends Equatable {
  /// FILTER OPTIONS
  final List<String> brands;
  final List<String> types;

  /// APPLIED FILTERS
  final String selectedBrand;
  final String selectedType;
  final String selectedMileage;

  /// TEMP FILTERS
  final String tempBrand;
  final String tempType;
  final String tempMileage;

  /// SEARCH
  final String searchQuery;

  /// VEHICLES
  final List<DocumentSnapshot> allCars;
  final List<DocumentSnapshot> filteredCars;

  /// LOADING
  final bool isLoading;

  const CarState({
    this.brands = const ["All"],
    this.types = const ["All"],

    this.selectedBrand = "All",
    this.selectedType = "All",
    this.selectedMileage = "All",

    this.tempBrand = "All",
    this.tempType = "All",
    this.tempMileage = "All",

    this.searchQuery = '',

    this.allCars = const [],
    this.filteredCars = const [],

    this.isLoading = false,
  });

  CarState copyWith({
    List<String>? brands,
    List<String>? types,

    String? selectedBrand,
    String? selectedType,
    String? selectedMileage,

    String? tempBrand,
    String? tempType,
    String? tempMileage,

    String? searchQuery,

    List<DocumentSnapshot>? allCars,
    List<DocumentSnapshot>? filteredCars,

    bool? isLoading,
  }) {
    return CarState(
      brands: brands ?? this.brands,
      types: types ?? this.types,

      selectedBrand:
      selectedBrand ?? this.selectedBrand,

      selectedType:
      selectedType ?? this.selectedType,

      selectedMileage:
      selectedMileage ??
          this.selectedMileage,

      tempBrand:
      tempBrand ?? this.tempBrand,

      tempType:
      tempType ?? this.tempType,

      tempMileage:
      tempMileage ?? this.tempMileage,

      searchQuery:
      searchQuery ?? this.searchQuery,

      allCars:
      allCars ?? this.allCars,

      filteredCars:
      filteredCars ??
          this.filteredCars,

      isLoading:
      isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [

    /// FILTER OPTIONS
    brands,
    types,

    /// APPLIED FILTERS
    selectedBrand,
    selectedType,
    selectedMileage,

    /// TEMP FILTERS
    tempBrand,
    tempType,
    tempMileage,

    /// SEARCH
    searchQuery,

    /// VEHICLES
    allCars,
    filteredCars,

    /// LOADING
    isLoading,
  ];
}

//ev

class EvState extends Equatable {

  /// FILTER OPTIONS
  final List<String> brands;
  final List<String> types;

  /// APPLIED FILTERS
  final String selectedBrand;
  final String selectedType;
  final String selectedBattery;
  final String selectedRange;

  /// TEMP FILTERS
  final String tempBrand;
  final String tempType;
  final String tempBattery;
  final String tempRange;

  /// SEARCH
  final String searchQuery;

  /// VEHICLES
  final List<DocumentSnapshot> allEvs;
  final List<DocumentSnapshot> filteredEvs;

  /// LOADING
  final bool isLoading;

  const EvState({
    this.brands = const ["All"],
    this.types = const ["All"],

    this.selectedBrand = "All",
    this.selectedType = "All",
    this.selectedBattery = "All",
    this.selectedRange = "All",

    this.tempBrand = "All",
    this.tempType = "All",
    this.tempBattery = "All",
    this.tempRange = "All",

    this.searchQuery = '',

    this.allEvs = const [],
    this.filteredEvs = const [],

    this.isLoading = false,
  });

  EvState copyWith({
    List<String>? brands,
    List<String>? types,

    String? selectedBrand,
    String? selectedType,
    String? selectedBattery,
    String? selectedRange,

    String? tempBrand,
    String? tempType,
    String? tempBattery,
    String? tempRange,

    String? searchQuery,

    List<DocumentSnapshot>? allEvs,
    List<DocumentSnapshot>? filteredEvs,

    bool? isLoading,
  }) {
    return EvState(
      brands: brands ?? this.brands,
      types: types ?? this.types,

      selectedBrand:
      selectedBrand ?? this.selectedBrand,

      selectedType:
      selectedType ?? this.selectedType,

      selectedBattery:
      selectedBattery ??
          this.selectedBattery,

      selectedRange:
      selectedRange ??
          this.selectedRange,

      tempBrand:
      tempBrand ?? this.tempBrand,

      tempType:
      tempType ?? this.tempType,

      tempBattery:
      tempBattery ?? this.tempBattery,

      tempRange:
      tempRange ?? this.tempRange,

      searchQuery:
      searchQuery ?? this.searchQuery,

      allEvs:
      allEvs ?? this.allEvs,

      filteredEvs:
      filteredEvs ??
          this.filteredEvs,

      isLoading:
      isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [

    /// FILTER OPTIONS
    brands,
    types,

    /// APPLIED FILTERS
    selectedBrand,
    selectedType,
    selectedBattery,
    selectedRange,

    /// TEMP FILTERS
    tempBrand,
    tempType,
    tempBattery,
    tempRange,

    /// SEARCH
    searchQuery,

    /// VEHICLES
    allEvs,
    filteredEvs,

    /// LOADING
    isLoading,
  ];
}
//home

abstract class VehicleState {}

class VehicleInitial extends VehicleState {}

class VehicleLoading extends VehicleState {}

class VehicleLoaded extends VehicleState {
  final List<QueryDocumentSnapshot> bikes;
  final List<QueryDocumentSnapshot> cars;
  final List<QueryDocumentSnapshot> ads;
  final List<Map<String, dynamic>> favoriteItems;
  final String searchText;

  VehicleLoaded({
    required this.bikes,
    required this.cars,
    required this.ads,
    required this.favoriteItems,
    required this.searchText,
  });
}

class VehicleError extends VehicleState {
  final String message;

  VehicleError(this.message);
}

//detail

enum DetailStatus { initial, loading, success, failure }

class DetailState extends Equatable {
  final DetailStatus status;
  final Map<String, dynamic>? vehicleData;
  final List<QueryDocumentSnapshot>? reviews;
  final String? errorMessage;

  const DetailState({
    this.status = DetailStatus.initial,
    this.vehicleData,
    this.reviews,
    this.errorMessage,
  });

  DetailState copyWith({
    DetailStatus? status,
    Map<String, dynamic>? vehicleData,
    List<QueryDocumentSnapshot>? reviews,
    String? errorMessage,
  }) {
    return DetailState(
      status: status ?? this.status,
      vehicleData: vehicleData ?? this.vehicleData,
      reviews: reviews ?? this.reviews,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, vehicleData, reviews, errorMessage];
}

//explore

class ExploreState extends Equatable {
  final List<DocumentSnapshot> allVehicles;
  final List<DocumentSnapshot> filteredVehicles;
  final bool isLoading;
  final String searchQuery;

  const ExploreState({
    this.allVehicles = const [],
    this.filteredVehicles = const [],
    this.isLoading = false,
    this.searchQuery = '',
  });

  ExploreState copyWith({
    List<DocumentSnapshot>? allVehicles,
    List<DocumentSnapshot>? filteredVehicles,
    bool? isLoading,
    String? searchQuery,
  }) {
    return ExploreState(
      allVehicles: allVehicles ?? this.allVehicles,
      filteredVehicles: filteredVehicles ?? this.filteredVehicles,
      isLoading: isLoading ?? this.isLoading,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allVehicles, filteredVehicles, isLoading, searchQuery];
}
