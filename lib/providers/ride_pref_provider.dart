import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';
import 'async_value.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  // Private fields
  RidePreference? _currentPreference;
  late AsyncValue<List<RidePreference>> pastPreferences;
  final RidePreferencesRepository repository;

  // Constructor - loads initial preferences
  RidesPreferencesProvider({required this.repository}) {
    fetchPastPreferences();
  }

  // Get current preference (can be null)
  RidePreference? get currentPreference => _currentPreference;

  // // Load initial preferences from repository


  // Set current preference and update history
  void setCurrentPreferrence(RidePreference pref) {
    if (_currentPreference != pref) {
      _currentPreference = pref;
      _addPreference(pref);
      notifyListeners();
    }
  }

  /// Fetches past ride preferences from the repository
  Future<void> fetchPastPreferences() async {
    pastPreferences = AsyncValue.loading(); // Set loading state
    notifyListeners();
    try {
      List<RidePreference> pastPrefs = await repository.getPastPreferences(); // Fetch data from repository
      pastPreferences = AsyncValue.success(pastPrefs); // Store successful data
    } catch (error) {
      pastPreferences = AsyncValue.error(error); // Handle errors
    }
    notifyListeners();
  }
  /// Adds a new ride preference to the repository and updates past preferences
  Future<void> _addPreference(RidePreference preference) async {
    await repository.addPreference(preference);
    fetchPastPreferences(); // Fetch updated list of past preferences (ensuring sync with stored data)
  }
    /// Returns the list of past ride preferences, or an empty list if data isn't available
    List<RidePreference> get preferencesHistory => pastPreferences.data ?? [];

}