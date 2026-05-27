class Vehicle {
  final String brand;
  final String name;
  final String image;
  final int price;
  final String type;
  final double mileage;
  final String category;
  final int power;
  final bool isElectric;
  final double rating;
  final String usedTo;
  final String id;

  Vehicle({
    required this.brand,
    required this.name,
    required this.image,
    required this.price,
    required this.type,
    required this.mileage,
    required this.category,
    required this.power,
    required this.isElectric,
    required this.rating,
    required this.usedTo,
    required this.id,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map, String id) {
    return Vehicle(
      brand: map['brand'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',

      price: int.tryParse(map['price'].toString()) ?? 0,
      power: int.tryParse(map['power'].toString()) ?? 0,

      type: map['spec']?['type'] ?? map['type'] ?? '',
      mileage: double.tryParse(map['spec']?['mileage'].toString() ?? '0') ?? 0,

      category: map['category'] ?? '',
      isElectric: map['isElectric'] ?? false,

      rating: (map['rating'] ?? 0).toDouble(),

      usedTo: map['usedto'] ?? '',
      id: id,
    );
  }
}
