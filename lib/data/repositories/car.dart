import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cars.dart';

class VehicleRepository {
  final FirebaseFirestore firestore;

  VehicleRepository(this.firestore);

  Stream<List<Vehicle>> getVehicles() {
    return firestore.collection('vehicle').snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => Vehicle.fromMap(doc.data(), doc.id))
          .toList();
    });
  }
}