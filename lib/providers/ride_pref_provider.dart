import 'package:flutter/foundation.dart';
import '../model/ride/ride_pref.dart';
import '../repository/ride_preferences_repository.dart';

class RidesPreferencesProvider extends ChangeNotifier {
  // Private fields
  RidePreference? _currentPreference;
  final List<RidePreference> _pastPreferences = [];
  final RidePreferencesRepository repository;

  // Constructor - loads initial preferences
  RidesPreferencesProvider({required this.repository}) {
    _loadInitialPreferences();
  }

  // Get current preference (can be null)
  RidePreference? get currentPreference => _currentPreference;

  // Get past preferences from newest to oldest
  List<RidePreference> get preferencesHistory => 
      List.unmodifiable(_pastPreferences.reversed);

  // // Load initial preferences from repository
  Future<void> _loadInitialPreferences() async {
    final prefs = await repository.loadPreferences();
    _pastPreferences.addAll(prefs);
    notifyListeners();
  }

  // Set current preference and update history
  void setCurrentPreferrence(RidePreference pref) {
    // 1. Process only if different from current
    if (_currentPreference == pref) return;

    // 2. Update current preference
    _currentPreference = pref;

    // 3. Update history (ensure exclusivity)
    _pastPreferences.remove(pref);  // Remove if exists
    _pastPreferences.add(pref);     // Add as newest

    // 4. Notify listeners of changes
    notifyListeners();
  }
}