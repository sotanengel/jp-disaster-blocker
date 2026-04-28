import 'package:core/core.dart';
import 'package:feature_evacuation/feature_evacuation.dart';
import 'package:feature_evacuation/testing/fake_shelter_repository.dart';
import 'package:flutter_test/flutter_test.dart';

final _tokyoShelters = [
  const Shelter(
    id: 1,
    name: '新宿区立第一避難所',
    latitude: 35.693,
    longitude: 139.703,
    disasterTypes: [DisasterType.earthquake, DisasterType.flood],
  ),
  const Shelter(
    id: 2,
    name: '渋谷区立避難所',
    latitude: 35.658,
    longitude: 139.701,
    disasterTypes: [DisasterType.earthquake],
  ),
  const Shelter(
    id: 3,
    name: '遠方避難所',
    latitude: 36.0,
    longitude: 140.0,
    disasterTypes: [DisasterType.tsunami],
  ),
];

void _contractTests(ShelterRepository Function() factory) {
  late ShelterRepository repo;

  setUp(() async {
    repo = factory();
    await repo.upsertAll(_tokyoShelters);
  });

  test('findNearby returns shelters within radius', () async {
    final result = await repo.findNearby(
      lat: 35.68,
      lng: 139.70,
      radiusKm: 20,
    );
    expect(result.isOk, isTrue);
    final shelters = (result as Ok<List<Shelter>, AppException>).value;
    expect(shelters.length, greaterThanOrEqualTo(2));
  });

  test('findNearby filters by disaster type', () async {
    final result = await repo.findNearby(
      lat: 35.68,
      lng: 139.70,
      radiusKm: 20,
      filterTypes: [DisasterType.flood],
    );
    expect(result.isOk, isTrue);
    final shelters = (result as Ok<List<Shelter>, AppException>).value;
    expect(shelters.every((s) => s.disasterTypes.contains(DisasterType.flood)),
        isTrue);
  });

  test('findById returns correct shelter', () async {
    final result = await repo.findById(1);
    expect(result.isOk, isTrue);
    expect((result as Ok<Shelter, AppException>).value.name, contains('新宿'));
  });

  test('findById returns Err for unknown id', () async {
    final result = await repo.findById(999);
    expect(result.isErr, isTrue);
  });
}

void main() {
  group('FakeShelterRepository contract', () {
    _contractTests(FakeShelterRepository.new);
  });
}
