// ignore_for_file: public_member_api_docs

enum ChecklistScenario {
  earthquake('地震直後'),
  heavyRain('豪雨・水害'),
  tsunami('津波'),
  fire('火災'),
  powerOut('停電');

  const ChecklistScenario(this.label);

  final String label;
}
