import 'disaster_type.dart';

class Shelter {
  const Shelter({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.disasterTypes = const [],
    this.capacity,
    this.distanceKm,
  });

  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final List<DisasterType> disasterTypes;
  final int? capacity;
  final double? distanceKm;

  factory Shelter.fromMap(Map<String, Object?> map) {
    final types = (map['disaster_types'] as String? ?? '')
        .split(',')
        .where((s) => s.isNotEmpty)
        .map((s) => DisasterType.values.firstWhere(
              (t) => t.name == s,
              orElse: () => DisasterType.earthquake,
            ))
        .toList();

    return Shelter(
      id: map['id'] as int,
      name: map['name'] as String,
      latitude: map['lat'] as double,
      longitude: map['lng'] as double,
      address: map['address'] as String?,
      disasterTypes: types,
      capacity: map['capacity'] as int?,
    );
  }
}
