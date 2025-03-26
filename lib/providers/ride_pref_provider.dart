import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  // Private fields
  RidePreference? _currentPreference;
  List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  // Constructor - loads initial preferences
  RidesPreferencesProvider({required this.repository}) {
    _pastPreferences = repository.getPastPreferences();
  }

  // Get current preference (can be null)
  RidePreference? get currentPreference => _currentPreference;

  // Get past preferences from newest to oldest
  List<RidePreference> get preferencesHistory =>
      _pastPreferences.reversed.toList();

  // // Load initial preferences from repository


  // Set current preference and update history
  void setCurrentPreferrence(RidePreference pref) {
    // 1. Process only if different from current
    if (_currentPreference == pref) return;

    // 2. Update current preference
    _currentPreference = pref;

    // 3. Update history (ensure exclusivity)
    _addPreference(pref);

    // 4. Notify listeners of changes
    notifyListeners();



  }


  void _addPreference(RidePreference preference) {
    if (!_pastPreferences.contains(preference)) {
      _pastPreferences.add(preference);
      repository.addPreference(preference); // Persist to repository
    }
  }
}