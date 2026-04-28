enum DisasterType {
  flood('洪水'),
  landslide('崖崩れ・土石流・地滑り'),
  stormSurge('高潮'),
  earthquake('地震'),
  tsunami('津波'),
  largeFire('大規模な火事'),
  inlandFlood('内水氾濫'),
  volcano('火山現象');

  const DisasterType(this.label);

  final String label;
}
