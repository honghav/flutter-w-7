import 'package:flutter/material.dart';

import '../../../../model/location/locations.dart';
import '../../../../model/ride/ride_pref.dart';
import '../../../theme/theme.dart';
import '../../../../utils/animations_util.dart';
import '../../../../utils/date_time_util.dart';
import '../../../widgets/actions/bla_button.dart';
import '../../../widgets/display/bla_divider.dart';
import '../../../widgets/inputs/bla_location_picker.dart';
import 'ride_pref_input_tile.dart';

///
/// A Ride Preference From is a view to select:
///   - A depcarture location
///   - An arrival location
///   - A date
///   - A number of seats
///
/// The form can be created with an existing RidePref (optional).
///
///
class RidePrefForm extends StatefulWidget {
  const RidePrefForm({
    super.key,
    required this.initialPreference,
    required this.onSubmit,
  });

  final RidePreference? initialPreference;
  final Function(RidePreference preference) onSubmit;

  @override
  State<RidePrefForm> createState() => _RidePrefFormState();
}

class _RidePrefFormState extends State<RidePrefForm> {
  Location? departure;
  Location? arrival;
  late DateTime departureDate;
  late int requestedSeats;

  @override
  void initState() {
    super.initState();
    _initializeFormData();
  }

  @override
  void didUpdateWidget(RidePrefForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    _initializeFormData();
  }

  void _initializeFormData() {
    if (widget.initialPreference != null) {
      RidePreference current = widget.initialPreference!;
      departure = current.departure;
      arrival = current.arrival;
      departureDate = current.departureDate;
      requestedSeats = current.requestedSeats;
    } else {
      departure = null;
      arrival = null;
      departureDate = DateTime.now();
      requestedSeats = 1;
    }
  }

  // ----------------------------------
  // Handle events
  // ----------------------------------

  void onDeparturePressed() async {
    // 1- Select a location
    Location? selectedLocation = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(initLocation: departure),
      ),
    );

    // 2- Update the from if needed
    if (selectedLocation != null) {
      setState(() {
        departure = selectedLocation;
      });
    }
  }

  void onArrivalPressed() async {
    // 1- Select a location
    Location? selectedLocation = await Navigator.of(context).push<Location>(
      AnimationUtils.createBottomToTopRoute(
        BlaLocationPicker(initLocation: arrival),
      ),
    );

    // 2- Update the from if needed
    if (selectedLocation != null) {
      setState(() {
        arrival = selectedLocation;
      });
    }
  }

  void onSubmit() {
    // 1- Check input validity
    bool hasDeparture = departure != null;
    bool hasArrival = arrival != null;
    bool isValid = hasDeparture && hasArrival;

    if (isValid) {
      // 2 - Create a  new preference
      RidePreference newPreference = RidePreference(
        departure: departure!,
        departureDate: departureDate,
        arrival: arrival!,
        requestedSeats: requestedSeats,
      );

      // 3 - Callback withg the new preference
      widget.onSubmit(newPreference);
    }
  }

  void onSwappingLocationPressed() {
    setState(() {
      // We switch only if both departure and arrivate are defined
      if (departure != null && arrival != null) {
        Location temp = departure!;
        departure = Location.copy(arrival!);
        arrival = Location.copy(temp);
      }
    });
  }

  // ----------------------------------
  // Compute the widgets rendering
  // ----------------------------------
  String get departureLabel => departure?.name ?? "Leaving from";
  String get arrivalLabel => arrival?.name ?? "Going to";
  bool get showDeparturePlaceHolder => departure == null;
  bool get showArrivalPlaceHolder => arrival == null;
  String get dateLabel => DateTimeUtils.formatDateTime(departureDate);
  String get numberLabel => requestedSeats.toString();
  bool get switchVisible => arrival != null && departure != null;

  // ----------------------------------
  // Build the widgets
  // ----------------------------------
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: BlaSpacings.m),
          child: Column(
            children: [
              // 1 - Input the ride departure
              RidePrefInputTile(
                isPlaceHolder: showDeparturePlaceHolder,
                title: departureLabel,
                leftIcon: Icons.location_on,
                onPressed: onDeparturePressed,
                rightIcon: switchVisible ? Icons.swap_vert : null,
                onRightIconPressed:
                    switchVisible ? onSwappingLocationPressed : null,
              ),
              const BlaDivider(),

              // 2 - Input the ride arrival
              RidePrefInputTile(
                isPlaceHolder: showArrivalPlaceHolder,
                title: arrivalLabel,
                leftIcon: Icons.location_on,
                onPressed: onArrivalPressed,
              ),
              const BlaDivider(),

              // 3 - Input the ride date
              RidePrefInputTile(
                title: dateLabel,
                leftIcon: Icons.calendar_month,
                onPressed: () {}, // TODO: Implement date selection
              ),
              const BlaDivider(),

              // 4 - Input the requested number of seats
              RidePrefInputTile(
                title: numberLabel,
                leftIcon: Icons.person_2_outlined,
                onPressed: () {}, // TODO: Implement seats selection
              ),
            ],
          ),
        ),

        // 5 - Launch a search
        BlaButton(text: 'Search', onPressed: onSubmit),
      ],
    );
  }
}
