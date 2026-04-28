/// パッケージアセットは [rootBundle.load] 用のキー（`packages/...` 形式）。
enum HazardType {
  flood(
    '洪水浸水想定区域',
    'packages/feature_hazard/assets/hazard/flood.pmtiles',
    0x800000FF,
  ),
  landslide(
    '土砂災害警戒区域',
    'packages/feature_hazard/assets/hazard/landslide.pmtiles',
    0x80FF6600,
  ),
  tsunami(
    '津波浸水想定',
    'packages/feature_hazard/assets/hazard/tsunami.pmtiles',
    0x80FF00FF,
  ),
  stormSurge(
    '高潮浸水想定',
    'packages/feature_hazard/assets/hazard/storm_surge.pmtiles',
    0x8000FFFF,
  );

  const HazardType(this.label, this.assetPath, this.color);

  final String label;
  final String assetPath;
  final int color;
}
