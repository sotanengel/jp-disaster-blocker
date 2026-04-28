import 'package:core/core.dart';
import 'package:feature_evacuation/feature_evacuation.dart';
import 'package:feature_hazard/feature_hazard.dart';
import 'package:feature_location/feature_location.dart';
import 'package:feature_routing/feature_routing.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infra_routing_engine/infra_routing_engine.dart';
import 'package:infra_storage/infra_storage.dart';

/// デフォルト表示用（皇居周辺）。位置情報が得られない場合のフォールバック。
const double kDefaultLat = 35.6762;
const double kDefaultLng = 139.6503;

final locationServiceProvider = Provider<LocationService>(
  (ref) => GeolocatorLocationService(),
);

/// 避難所一覧・ルート出発点に使う。権限がない・取得失敗時は [kDefaultLat]/[kDefaultLng]。
final effectiveLocationProvider = FutureProvider<({double lat, double lng})>((
  ref,
) async {
  final loc = ref.watch(locationServiceProvider);
  if (!await loc.isPermissionGranted) {
    return (lat: kDefaultLat, lng: kDefaultLng);
  }
  final r = await loc.getCurrentLocation();
  return switch (r) {
    Ok(:final value) => (lat: value.latitude, lng: value.longitude),
    Err() => (lat: kDefaultLat, lng: kDefaultLng),
  };
});

final appDatabaseProvider = FutureProvider<AppDatabase>((ref) async {
  final db = SqfliteDatabase(dbPath: 'jp_disaster_blocker.db');
  await db.open();
  ref.onDispose(() => db.close());
  return db;
});

final shelterRepositoryProvider = FutureProvider<ShelterRepository>((
  ref,
) async {
  final db = await ref.watch(appDatabaseProvider.future);
  return SqliteShelterRepository(db);
});

/// ハザード PMTiles 重畳（[feature_hazard]）。アプリ層で [MapPage] と合成する。
final hazardLayerControllerProvider =
    ChangeNotifierProvider<PmTilesHazardLayerController>((ref) {
  // ChangeNotifierProvider が破棄時に [dispose] を呼ぶため ref.onDispose は不要。
  return PmTilesHazardLayerController();
});

/// GraphHopper 本番配線前のスタブエンジン。グローバル束は [routingServiceProvider] 経由。
final routingServiceProvider = FutureProvider<RoutingService>((ref) async {
  final engine = GraphHopperEngine();
  final init = await engine.initialize('stub_graph');
  return switch (init) {
    Ok() => EngineRoutingService(engine),
    Err(:final error) => throw StateError(error.message),
  };
});
