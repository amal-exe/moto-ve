import 'package:cloud_firestore/cloud_firestore.dart';

class FilterService {
  static Stream<List<String>> getBrands() {
    return FirebaseFirestore.instance
        .collection('vehicles')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => doc['brand'].toString())
          .toSet()
          .toList();
    });
  }
}