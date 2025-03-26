import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/ride_pref_provider.dart';
import 'repository/mock/mock_locations_repository.dart';
import 'repository/mock/mock_rides_repository.dart';
import 'repository/mock/mock_ride_preferences_repository.dart';
import 'service/locations_service.dart';
import 'service/rides_service.dart';
import 'ui/screens/ride_pref/ride_pref_screen.dart';
import 'ui/theme/theme.dart';

void main() {
  // 1 - Initialize the services
  LocationsService.initialize(MockLocationsRepository());
  RidesService.initialize(MockRidesRepository());

  // 2- Create repositories instances
  final ridePrefsRepository = MockRidePreferencesRepository();

  // 3- Run the UI with providers
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => RidesPreferencesProvider(
            repository: ridePrefsRepository,
          ),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      home: const Scaffold(body: RidePrefScreen()),
    );
  }
}
