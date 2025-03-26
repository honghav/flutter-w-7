import '../model/ride/ride_pref.dart';

abstract class RidePreferencesRepository {
  List<RidePreference> getPastPreferences();

  void addPreference(RidePreference preference);

  loadPreferences() {}

  savePreferences(List<RidePreference> pastPreferences) {}
}
