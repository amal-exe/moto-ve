import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moto_ve/bloc/vehicle/vehicle_event.dart';
import 'package:moto_ve/bloc/vehicle/vehicle_state.dart';

class BikeBloc extends Bloc<BikeEvent, BikeState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  BikeBloc() : super(const BikeState()) {
    on<LoadFilters>(_onLoadFilters);

    on<TempFilterChanged>(_onTempFilterChanged);

    on<FilterChanged>(_onFilterChanged);

    on<ResetFilters>(_onResetFilters);

    on<BikeSearchChanged>(_onSearchChanged);
  }

  /// LOAD INITIAL FILTERS + VEHICLES
  Future<void> _onLoadFilters(
    LoadFilters event,
    Emitter<BikeState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final snapshot = await _firestore
          .collection('vehicle')
          .where('category', isEqualTo: 'bike')
          .where('isElectric', isEqualTo: false)
          .get();

      final brands = snapshot.docs
          .map((doc) => doc['brand'].toString())
          .toSet()
          .toList();

      final types = snapshot.docs
          .map((doc) => doc['type'].toString())
          .toSet()
          .toList();

      emit(
        state.copyWith(
          brands: ["All", ...brands],

          types: ["All", ...types],

          allBikes: snapshot.docs,

          filteredBikes: snapshot.docs,

          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  /// TEMP FILTERS
  void _onTempFilterChanged(TempFilterChanged event, Emitter<BikeState> emit) {
    emit(
      state.copyWith(
        tempBrand: event.brand ?? state.tempBrand,

        tempType: event.type ?? state.tempType,

        tempCC: event.cc ?? state.tempCC,

        tempMileage: event.mileage ?? state.tempMileage,
      ),
    );
  }

  /// APPLY FILTERS
  Future<void> _onFilterChanged(
    FilterChanged event,
    Emitter<BikeState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,

        selectedBrand: event.brand,

        selectedType: event.type,

        selectedCC: event.cc,

        selectedMileage: event.mileage,
      ),
    );

    Query query = _firestore
        .collection('vehicle')
        .where('category', isEqualTo: 'bike')
        .where('isElectric', isEqualTo: false);

    /// BRAND FILTER
    if (event.brand != "All") {
      query = query.where('brand', isEqualTo: event.brand);
    }

    /// TYPE FILTER
    if (event.type != "All") {
      query = query.where('type', isEqualTo: event.type);
    }

    final snapshot = await query.get();

    List<DocumentSnapshot> docs = snapshot.docs;

    /// CC FILTER
    if (event.cc != "All") {
      final parts = event.cc.split('-');

      double min = double.tryParse(parts[0]) ?? 0;

      double max = double.tryParse(parts[1]) ?? 9999;

      docs = docs.where((doc) {
        double cc =
            double.tryParse(doc['spec']?['enginecc']?.toString() ?? '0') ?? 0;

        return cc >= min && cc <= max;
      }).toList();
    }

    /// MILEAGE FILTER
    if (event.mileage != "All") {
      final parts = event.mileage.split('-');

      double min = double.tryParse(parts[0]) ?? 0;

      double max = double.tryParse(parts[1]) ?? 999;

      docs = docs.where((doc) {
        double mileage =
            double.tryParse(doc['spec']?['mileage']?.toString() ?? '0') ?? 0;

        return mileage >= min && mileage <= max;
      }).toList();
    }

    /// SEARCH FILTER
    if (state.searchQuery.isNotEmpty) {
      docs = docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;

        final name = (data['name'] ?? '').toString().toLowerCase();

        final brand = (data['brand'] ?? '').toString().toLowerCase();

        return name.contains(state.searchQuery) ||
            brand.contains(state.searchQuery);
      }).toList();
    }

    emit(state.copyWith(filteredBikes: docs, isLoading: false));
  }

  /// RESET FILTERS
  void _onResetFilters(ResetFilters event, Emitter<BikeState> emit) {
    emit(
      state.copyWith(
        selectedBrand: "All",
        selectedType: "All",
        selectedCC: "All",
        selectedMileage: "All",

        tempBrand: "All",
        tempType: "All",
        tempCC: "All",
        tempMileage: "All",

        filteredBikes: state.allBikes,
      ),
    );
  }

  /// SEARCH
  void _onSearchChanged(BikeSearchChanged event, Emitter<BikeState> emit) {
    final query = event.query.toLowerCase();

    final filtered = state.allBikes.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final name = (data['name'] ?? '').toString().toLowerCase();

      final brand = (data['brand'] ?? '').toString().toLowerCase();

      return name.contains(query) || brand.contains(query);
    }).toList();

    emit(state.copyWith(searchQuery: query, filteredBikes: filtered));
  }
}

//car

class CarBloc extends Bloc<CarEvent, CarState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CarBloc() : super(const CarState()) {
    on<LoadCarFilters>(_onLoadFilters);

    on<TempCarFilterChanged>(_onTempFilterChanged);

    on<CarFilterChanged>(_onFilterChanged);

    on<ResetCarFilters>(_onResetFilters);

    on<CarSearchChanged>(_onSearchChanged);
  }

  /// LOAD INITIAL FILTERS + VEHICLES
  Future<void> _onLoadFilters(
    LoadCarFilters event,
    Emitter<CarState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final snapshot = await _firestore
          .collection('vehicle')
          .where('category', isEqualTo: 'car')
          .where('isElectric', isEqualTo: false)
          .get();

      final brands = snapshot.docs
          .map((doc) => doc['brand'].toString())
          .toSet()
          .toList();

      final types = snapshot.docs
          .map((doc) => doc['type'].toString())
          .toSet()
          .toList();

      emit(
        state.copyWith(
          brands: ["All", ...brands],

          types: ["All", ...types],

          allCars: snapshot.docs,

          filteredCars: snapshot.docs,

          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  /// TEMP FILTERS
  void _onTempFilterChanged(
    TempCarFilterChanged event,
    Emitter<CarState> emit,
  ) {
    emit(
      state.copyWith(
        tempBrand: event.brand ?? state.tempBrand,

        tempType: event.type ?? state.tempType,

        tempMileage: event.mileage ?? state.tempMileage,
      ),
    );
  }

  /// APPLY FILTERS
  Future<void> _onFilterChanged(
    CarFilterChanged event,
    Emitter<CarState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,

        selectedBrand: event.brand,

        selectedType: event.type,

        selectedMileage: event.mileage,
      ),
    );

    Query query = _firestore
        .collection('vehicle')
        .where('category', isEqualTo: 'car')
        .where('isElectric', isEqualTo: false);

    /// BRAND FILTER
    if (event.brand != "All") {
      query = query.where('brand', isEqualTo: event.brand);
    }

    /// TYPE FILTER
    if (event.type != "All") {
      query = query.where('type', isEqualTo: event.type);
    }

    final snapshot = await query.get();

    List<DocumentSnapshot> docs = snapshot.docs;

    /// MILEAGE FILTER
    if (event.mileage != "All") {
      final parts = event.mileage.split('-');

      double min = double.tryParse(parts[0]) ?? 0;

      double max = double.tryParse(parts[1]) ?? 999;

      docs = docs.where((doc) {
        double mileage =
            double.tryParse(doc['spec']?['mileage']?.toString() ?? '0') ?? 0;

        return mileage >= min && mileage <= max;
      }).toList();
    }

    /// SEARCH FILTER
    if (state.searchQuery.isNotEmpty) {
      docs = docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;

        final name = (data['name'] ?? '').toString().toLowerCase();

        final brand = (data['brand'] ?? '').toString().toLowerCase();

        return name.contains(state.searchQuery) ||
            brand.contains(state.searchQuery);
      }).toList();
    }

    emit(state.copyWith(filteredCars: docs, isLoading: false));
  }

  /// RESET FILTERS
  void _onResetFilters(ResetCarFilters event, Emitter<CarState> emit) {
    emit(
      state.copyWith(
        selectedBrand: "All",
        selectedType: "All",
        selectedMileage: "All",

        tempBrand: "All",
        tempType: "All",
        tempMileage: "All",

        filteredCars: state.allCars,
      ),
    );
  }

  /// SEARCH
  void _onSearchChanged(CarSearchChanged event, Emitter<CarState> emit) {
    final query = event.query.toLowerCase();

    final filtered = state.allCars.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final name = (data['name'] ?? '').toString().toLowerCase();

      final brand = (data['brand'] ?? '').toString().toLowerCase();

      return name.contains(query) || brand.contains(query);
    }).toList();

    emit(state.copyWith(searchQuery: query, filteredCars: filtered));
  }
}

//ev

class EvBloc extends Bloc<EvEvent, EvState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  EvBloc() : super(const EvState()) {
    on<LoadEvFilters>(_onLoadFilters);

    on<TempEvFilterChanged>(_onTempFilterChanged);

    on<EvFilterChanged>(_onFilterChanged);

    on<ResetEvFilters>(_onResetFilters);

    on<EvSearchChanged>(_onSearchChanged);
  }

  /// LOAD INITIAL FILTERS + VEHICLES
  Future<void> _onLoadFilters(
    LoadEvFilters event,
    Emitter<EvState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final snapshot = await _firestore
          .collection('vehicle')
          .where('isElectric', isEqualTo: true)
          .get();

      final brands = snapshot.docs
          .map((doc) => doc['brand'].toString())
          .toSet()
          .toList();

      final types = snapshot.docs
          .map((doc) => doc['type'].toString())
          .toSet()
          .toList();

      emit(
        state.copyWith(
          brands: ["All", ...brands],

          types: ["All", ...types],

          allEvs: snapshot.docs,

          filteredEvs: snapshot.docs,

          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  /// TEMP FILTERS
  void _onTempFilterChanged(TempEvFilterChanged event, Emitter<EvState> emit) {
    emit(
      state.copyWith(
        tempBrand: event.brand ?? state.tempBrand,

        tempType: event.type ?? state.tempType,

        tempBattery: event.battery ?? state.tempBattery,

        tempRange: event.range ?? state.tempRange,
      ),
    );
  }

  /// APPLY FILTERS
  Future<void> _onFilterChanged(
    EvFilterChanged event,
    Emitter<EvState> emit,
  ) async {
    emit(
      state.copyWith(
        isLoading: true,

        selectedBrand: event.brand,

        selectedType: event.type,

        selectedBattery: event.battery,

        selectedRange: event.range,
      ),
    );

    Query query = _firestore
        .collection('vehicle')
        .where('isElectric', isEqualTo: true);

    /// BRAND FILTER
    if (event.brand != "All") {
      query = query.where('brand', isEqualTo: event.brand);
    }

    /// TYPE FILTER
    if (event.type != "All") {
      query = query.where('type', isEqualTo: event.type);
    }

    final snapshot = await query.get();

    List<DocumentSnapshot> docs = snapshot.docs;

    /// BATTERY FILTER
    if (event.battery != "All") {
      final parts = event.battery.split('-');

      double min = double.tryParse(parts[0]) ?? 0;

      double max = double.tryParse(parts[1]) ?? 999;

      docs = docs.where((doc) {
        final val = doc['spec']?['battery'] ?? doc['spec']?['batteryCapacity'];

        double battery = double.tryParse(val?.toString() ?? '0') ?? 0;

        return battery >= min && battery <= max;
      }).toList();
    }

    /// RANGE FILTER
    if (event.range != "All") {
      final parts = event.range.split('-');

      double min = double.tryParse(parts[0]) ?? 0;

      double max = double.tryParse(parts[1]) ?? 9999;

      docs = docs.where((doc) {
        double range =
            double.tryParse(doc['spec']?['range']?.toString() ?? '0') ?? 0;

        return range >= min && range <= max;
      }).toList();
    }

    /// SEARCH FILTER
    if (state.searchQuery.isNotEmpty) {
      docs = docs.where((doc) {
        final data = doc.data() as Map<String, dynamic>;

        final name = (data['name'] ?? '').toString().toLowerCase();

        final brand = (data['brand'] ?? '').toString().toLowerCase();

        return name.contains(state.searchQuery) ||
            brand.contains(state.searchQuery);
      }).toList();
    }

    emit(state.copyWith(filteredEvs: docs, isLoading: false));
  }

  /// RESET FILTERS
  void _onResetFilters(ResetEvFilters event, Emitter<EvState> emit) {
    emit(
      state.copyWith(
        selectedBrand: "All",
        selectedType: "All",
        selectedBattery: "All",
        selectedRange: "All",

        tempBrand: "All",
        tempType: "All",
        tempBattery: "All",
        tempRange: "All",

        filteredEvs: state.allEvs,
      ),
    );
  }

  /// SEARCH
  void _onSearchChanged(EvSearchChanged event, Emitter<EvState> emit) {
    final query = event.query.toLowerCase();

    final filtered = state.allEvs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final name = (data['name'] ?? '').toString().toLowerCase();

      final brand = (data['brand'] ?? '').toString().toLowerCase();

      return name.contains(query) || brand.contains(query);
    }).toList();

    emit(state.copyWith(searchQuery: query, filteredEvs: filtered));
  }
}

//home

class VehicleBloc extends Bloc<VehicleEvent, VehicleState> {
  VehicleBloc() : super(VehicleInitial()) {
    on<LoadTrendingBikes>(_loadTrendingBikes);
    on<LoadTrendingCars>(_loadTrendingCars);
    on<LoadAds>(_loadAds);
    on<ToggleFavorite>(_toggleFavorite);
    on<SearchVehicle>(_searchVehicle);
  }

  List<QueryDocumentSnapshot> bikes = [];
  List<QueryDocumentSnapshot> cars = [];
  List<QueryDocumentSnapshot> ads = [];

  List<Map<String, dynamic>> favoriteItems = [];

  String searchText = '';

  Future<void> _loadTrendingBikes(
    LoadTrendingBikes event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('vehicle')
          .where('category', isEqualTo: 'bike')
          .where('isElectric', isEqualTo: false)
          .get();

      bikes = snapshot.docs;

      emit(
        VehicleLoaded(
          bikes: bikes,
          cars: cars,
          ads: ads,
          favoriteItems: favoriteItems,
          searchText: searchText,
        ),
      );
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _loadTrendingCars(
    LoadTrendingCars event,
    Emitter<VehicleState> emit,
  ) async {
    emit(VehicleLoading());

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('vehicle')
          .where('category', isEqualTo: 'car')
          .where('isElectric', isEqualTo: false)
          .get();

      cars = snapshot.docs;

      emit(
        VehicleLoaded(
          bikes: bikes,
          cars: cars,
          ads: ads,
          favoriteItems: favoriteItems,
          searchText: searchText,
        ),
      );
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  Future<void> _loadAds(LoadAds event, Emitter<VehicleState> emit) async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('ads').get();

      ads = snapshot.docs;

      emit(
        VehicleLoaded(
          bikes: bikes,
          cars: cars,
          ads: ads,
          favoriteItems: favoriteItems,
          searchText: searchText,
        ),
      );
    } catch (e) {
      emit(VehicleError(e.toString()));
    }
  }

  void _toggleFavorite(ToggleFavorite event, Emitter<VehicleState> emit) {
    final alreadyExists = favoriteItems.any(
      (fav) => fav['name'] == event.item['name'],
    );

    if (alreadyExists) {
      favoriteItems.removeWhere((fav) => fav['name'] == event.item['name']);
    } else {
      favoriteItems.add(event.item);
    }

    emit(
      VehicleLoaded(
        bikes: bikes,
        cars: cars,
        ads: ads,
        favoriteItems: favoriteItems,
        searchText: searchText,
      ),
    );
  }

  void _searchVehicle(SearchVehicle event, Emitter<VehicleState> emit) {
    searchText = event.value;

    emit(
      VehicleLoaded(
        bikes: bikes,
        cars: cars,
        ads: ads,
        favoriteItems: favoriteItems,
        searchText: searchText,
      ),
    );
  }
}

//detail

class DetailBloc extends Bloc<DetailEvent, DetailState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DetailBloc() : super(const DetailState()) {
    on<LoadVehicleDetails>(_onLoadVehicleDetails);
  }

  Future<void> _onLoadVehicleDetails(
    LoadVehicleDetails event,
    Emitter<DetailState> emit,
  ) async {
    emit(state.copyWith(status: DetailStatus.loading));

    try {
      // 1. Fetch Vehicle Main Data
      final doc = await _firestore
          .collection("vehicle")
          .doc(event.vehicleId)
          .get();

      if (!doc.exists) {
        emit(
          state.copyWith(
            status: DetailStatus.failure,
            errorMessage: "Vehicle not found",
          ),
        );
        return;
      }

      // 2. Fetch Reviews Sub-collection
      final reviewsSnapshot = await _firestore
          .collection("vehicle")
          .doc(event.vehicleId)
          .collection("reviews")
          .get();

      emit(
        state.copyWith(
          status: DetailStatus.success,
          vehicleData: doc.data() as Map<String, dynamic>,
          reviews: reviewsSnapshot.docs,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: DetailStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

//explore

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ExploreBloc() : super(const ExploreState()) {
    on<LoadVehicles>(_onLoadVehicles);
    on<SearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onLoadVehicles(
    LoadVehicles event,
    Emitter<ExploreState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('vehicle')
          .get();

      List<DocumentSnapshot> filtered = snapshot.docs;

      final query = state.searchQuery.toLowerCase().trim();

      /// APPLY SEARCH AGAIN AFTER LOAD

      if (query.isNotEmpty) {
        filtered = snapshot.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;

          final name = (data['name'] ?? '').toString().toLowerCase();

          final brand = (data['brand'] ?? '').toString().toLowerCase();

          final category = (data['category'] ?? '').toString().toLowerCase();

          final isElectric = data['isElectric'] == true;

          if (query == 'car' || query == 'cars') {
            return category == 'car' && !isElectric;
          }

          if (query == 'bike' || query == 'bikes') {
            return category == 'bike' && !isElectric;
          }

          if (query == 'ev' || query == 'electric') {
            return isElectric;
          }

          return name.contains(query) || brand.contains(query);
        }).toList();
      }

      emit(
        state.copyWith(
          allVehicles: snapshot.docs,
          filteredVehicles: filtered,
          isLoading: false,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onSearchQueryChanged(
    SearchQueryChanged event,
    Emitter<ExploreState> emit,
  ) {
    final query = event.query.toLowerCase().trim();

    final filtered = state.allVehicles.where((doc) {
      final data = doc.data() as Map<String, dynamic>;

      final name = (data['name'] ?? '').toString().toLowerCase();

      final brand = (data['brand'] ?? '').toString().toLowerCase();

      final category = (data['category'] ?? '').toString().toLowerCase();

      final isElectric = data['isElectric'] == true;

      if (query == 'car') {
        return category == 'car';
      }

      if (query == 'bike') {
        return category == 'bike';
      }

      if (query == 'ev') {
        return isElectric;
      }

      return name.contains(query) || brand.contains(query);
    }).toList();

    emit(state.copyWith(filteredVehicles: filtered, searchQuery: query));
  }
}
