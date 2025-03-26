import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import '../../../model/ride/ride_pref.dart';
import '../../../providers/ride_pref_provider.dart';
// import '../../../service/ride_prefs_service.dart';
import '../../theme/theme.dart';
import '../../../utils/animations_util.dart';
import '../rides/rides_screen.dart';
import 'widgets/ride_pref_form.dart';
import 'widgets/ride_pref_history_tile.dart';

const String blablaHomeImagePath = 'assets/images/blabla_home.png';

///
/// This screen allows user to:
/// - Enter his/her ride preference and launch a search on it
/// - Or select a last entered ride preferences and launch a search on it
///
class RidePrefScreen extends StatelessWidget {
  const RidePrefScreen({super.key});

  void onRidePrefSelected(BuildContext context, RidePreference newPreference) async {
    // Read the provider (don't listen)
    context.read<RidesPreferencesProvider>().setCurrentPreferrence(newPreference);

    // Navigate to the rides screen
    await Navigator.of(context)
        .push(AnimationUtils.createBottomToTopRoute(const RidesScreen()));
  }

  @override
  Widget build(BuildContext context) {
    // Watch the provider to rebuild when preferences change
    final preferencesProvider = context.watch<RidesPreferencesProvider>();
    final currentRidePreference = preferencesProvider.currentPreference;
    final pastPreferences = preferencesProvider.preferencesHistory;

    return Stack(
      children: [
        const BlaBackground(),
        Column(
          children: [
            const SizedBox(height: BlaSpacings.m),
            Text(
              "Your pick of rides at low price",
              style: BlaTextStyles.heading.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 100),
            Container(
              margin: EdgeInsets.symmetric(horizontal: BlaSpacings.xxl),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  RidePrefForm(
                    initialPreference: currentRidePreference,
                    onSubmit: (pref) => onRidePrefSelected(context, pref),
                  ),
                  const SizedBox(height: BlaSpacings.m),
                  SizedBox(
                    height: 200,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: pastPreferences.length,
                      itemBuilder: (ctx, index) => RidePrefHistoryTile(
                        ridePref: pastPreferences[index],
                        onPressed: () => onRidePrefSelected(
                            context, pastPreferences[index]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BlaBackground extends StatelessWidget {
  const BlaBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 340,
      child: Image.asset(
        blablaHomeImagePath,
        fit: BoxFit.cover, // Adjust image fit to cover the container
      ),
    );
  }
}
