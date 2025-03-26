import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/ride_pref_provider.dart';
import '../../../model/ride/ride_filter.dart';
import '../../../model/ride/ride.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../service/rides_service.dart';
import '../../../utils/animations_util.dart';
import '../../theme/theme.dart';
import 'widgets/ride_pref_bar.dart';
import 'widgets/ride_pref_modal.dart';
import 'widgets/rides_tile.dart';

class RidesScreen extends StatelessWidget {
  const RidesScreen({super.key});

  void onBackPressed(BuildContext context) {
    Navigator.of(context).pop();
  }

  void onPreferencePressed(BuildContext context, RidePreference currentPreference) async {
    // Open modal to edit preferences
    final RidePreference? newPreference = await Navigator.of(context).push<RidePreference>(
      AnimationUtils.createTopToBottomRoute(
        RidePrefModal(initialPreference: currentPreference),
      ),
    );

    if (newPreference != null) {
      // Update preference using provider
      context.read<RidesPreferencesProvider>().setCurrentPreferrence(newPreference);
    }
  }

  List<Ride> _getMatchingRides(RidePreference preference, RideFilter filter) {
    return RidesService.instance.getRidesFor(preference, filter);
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to rebuild when preferences change
    final preferencesProvider = context.watch<RidesPreferencesProvider>();
    final currentPreference = preferencesProvider.currentPreference;
    
    // If no preference set, return empty screen or error state
    if (currentPreference == null) {
      return const Center(child: Text('No ride preference selected'));
    }

    // Get matching rides based on current preference
    final matchingRides = _getMatchingRides(currentPreference, RideFilter());

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(
          left: BlaSpacings.m,
          right: BlaSpacings.m,
          top: BlaSpacings.s,
        ),
        child: Column(
          children: [
            // Top search bar
            RidePrefBar(
              ridePreference: currentPreference,
              onBackPressed: () => onBackPressed(context),
              onPreferencePressed: () => onPreferencePressed(context, currentPreference),
              onFilterPressed: () {}, // TODO: Implement filter functionality
            ),

            // Rides list
            Expanded(
              child: ListView.builder(
                itemCount: matchingRides.length,
                itemBuilder: (ctx, index) => RideTile(
                  ride: matchingRides[index],
                  onPressed: () {}, // TODO: Implement ride selection
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
