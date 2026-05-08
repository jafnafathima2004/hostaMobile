import 'package:flutter/material.dart';

class LocationSection extends StatelessWidget {
  final String selectedCountry;
  final String selectedState;
  final String selectedDistrict;
  final String selectedPlace;
  final List<String> countries;
  final List<String> states;
  final List<String> districts;
  final List<String> places;
  final List<dynamic> donors;
  final Function(String, String, String, String) onLocationSelected;
  final VoidCallback onClear;

  const LocationSection({
    super.key,
    required this.selectedCountry,
    required this.selectedState,
    required this.selectedDistrict,
    required this.selectedPlace,
    required this.countries,
    required this.states,
    required this.districts,
    required this.places,
    required this.donors,
    required this.onLocationSelected,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.005,
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: () => _openLocationFilter(context),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.0125,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey.shade300,
                    width: screenWidth * 0.0025,
                  ),
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                ),
                child: Text(
                  selectedCountry.isEmpty
                      ? "Select Location"
                      : "$selectedCountry > $selectedState > $selectedDistrict > $selectedPlace",
                  style: TextStyle(
                    fontSize: screenWidth * 0.035,
                    color: Colors.black54,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onClear,
            icon: Icon(
              Icons.clear,
              color: Colors.red,
              size: screenWidth * 0.05,
            ),
            label: Text(
              "Clear",
              style: TextStyle(
                color: Colors.red,
                fontSize: screenWidth * 0.035,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openLocationFilter(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    String tempCountry = selectedCountry;
    String tempState = selectedState;
    String tempDistrict = selectedDistrict;
    String tempPlace = selectedPlace;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(screenWidth * 0.05),
        ),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            // Get filtered locations based on current TEMPORARY selections
            List<String> filteredStates = _getFilteredStates(tempCountry);
            List<String> filteredDistricts = _getFilteredDistricts(
              tempCountry,
              tempState,
            );
            List<String> filteredPlaces = _getFilteredPlaces(
              tempCountry,
              tempState,
              tempDistrict,
            );

            return Padding(
              padding: EdgeInsets.fromLTRB(
                screenWidth * 0.04,
                screenHeight * 0.02,
                screenWidth * 0.04,
                MediaQuery.of(context).viewInsets.bottom + screenHeight * 0.02,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Text(
                        "Select Location",
                        style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Divider(thickness: screenWidth * 0.0025),

                    // Country Dropdown
                    DropdownButtonFormField<String>(
                      value: tempCountry.isEmpty ? null : tempCountry,
                      decoration: InputDecoration(
                        labelText: "Country *",
                        labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.025,
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.015,
                        ),
                      ),
                      items: [
                        DropdownMenuItem(
                          value: '',
                          child: Text(
                            "Select Country",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: screenWidth * 0.035,
                            ),
                          ),
                        ),
                        ...countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(
                              country,
                              style: TextStyle(fontSize: screenWidth * 0.035),
                            ),
                          );
                        }).toList(),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          tempCountry = value ?? '';
                          tempState = '';
                          tempDistrict = '';
                          tempPlace = '';
                        });
                      },
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // State Dropdown
                    if (tempCountry.isNotEmpty) ...[
                      DropdownButtonFormField<String>(
                        value: tempState.isEmpty ? null : tempState,
                        decoration: InputDecoration(
                          labelText: "State *",
                          labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.025,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text(
                              "Select State",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                          ...filteredStates.map((state) {
                            return DropdownMenuItem(
                              value: state,
                              child: Text(
                                state,
                                style: TextStyle(fontSize: screenWidth * 0.035),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setModalState(() {
                            tempState = value ?? '';
                            tempDistrict = '';
                            tempPlace = '';
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],

                    // District Dropdown
                    if (tempCountry.isNotEmpty && tempState.isNotEmpty) ...[
                      DropdownButtonFormField<String>(
                        value: tempDistrict.isEmpty ? null : tempDistrict,
                        decoration: InputDecoration(
                          labelText: "District *",
                          labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.025,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text(
                              "Select District",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                          ...filteredDistricts.map((district) {
                            return DropdownMenuItem(
                              value: district,
                              child: Text(
                                district,
                                style: TextStyle(fontSize: screenWidth * 0.035),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setModalState(() {
                            tempDistrict = value ?? '';
                            tempPlace = '';
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],

                    // Place Dropdown
                    if (tempCountry.isNotEmpty &&
                        tempState.isNotEmpty &&
                        tempDistrict.isNotEmpty) ...[
                      DropdownButtonFormField<String>(
                        isExpanded: true,
                        value: tempPlace.isEmpty ? null : tempPlace,
                        decoration: InputDecoration(
                          labelText: "Place",
                          labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.025,
                            ),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: '',
                            child: Text(
                              "Select Place",
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: screenWidth * 0.035,
                              ),
                            ),
                          ),
                          ...filteredPlaces.map((place) {
                            return DropdownMenuItem(
                              value: place,
                              child: Text(
                                place,
                                style: TextStyle(fontSize: screenWidth * 0.035),
                              ),
                            );
                          }).toList(),
                        ],
                        onChanged: (value) {
                          setModalState(() {
                            tempPlace = value ?? '';
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.02),
                    ],

                    SizedBox(height: screenHeight * 0.03),

                    // Apply Filter Button
                    ElevatedButton(
                      // Apply Filter button il ulla code maattuka:
                      onPressed: () {
                        // Add these debug prints BEFORE calling onLocationSelected
                        // print("📍 Applying filters - Country: '$tempCountry'");
                        // print("📍 Applying filters - State: '$tempState'");
                        // print("📍 Applying filters - District: '$tempDistrict'");
                        // print("📍 Applying filters - Place: '$tempPlace'");

                        // Call the callback with selected values
                        onLocationSelected(
                          tempCountry,
                          tempState,
                          tempDistrict,
                          tempPlace,
                        );
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(
                          vertical: screenHeight * 0.02,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.03,
                          ),
                        ),
                      ),
                      child: Text(
                        "Apply Filter",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: screenWidth * 0.04,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Fixed: These methods now properly use donors list
  List<String> _getFilteredStates(String country) {
    if (country.isEmpty) return [];

    final filteredStates = <String>{};
    for (final donor in donors) {
      final address = donor['address'] ?? {};
      final donorCountry = address['country']?.toString().trim() ?? '';
      final state = address['state']?.toString().trim() ?? '';

      if (donorCountry == country && state.isNotEmpty) {
        filteredStates.add(state);
      }
    }

    final result = filteredStates.toList();
    result.sort();
    return result;
  }

  List<String> _getFilteredDistricts(String country, String state) {
    if (country.isEmpty || state.isEmpty) return [];

    final filteredDistricts = <String>{};
    for (final donor in donors) {
      final address = donor['address'] ?? {};
      final donorCountry = address['country']?.toString().trim() ?? '';
      final donorState = address['state']?.toString().trim() ?? '';
      final district = address['district']?.toString().trim() ?? '';

      if (donorCountry == country &&
          donorState == state &&
          district.isNotEmpty) {
        filteredDistricts.add(district);
      }
    }

    final result = filteredDistricts.toList();
    result.sort();
    return result;
  }

  List<String> _getFilteredPlaces(
    String country,
    String state,
    String district,
  ) {
    if (country.isEmpty || state.isEmpty || district.isEmpty) return [];

    final filteredPlaces = <String>{};
    for (final donor in donors) {
      final address = donor['address'] ?? {};
      final donorCountry = address['country']?.toString().trim() ?? '';
      final donorState = address['state']?.toString().trim() ?? '';
      final donorDistrict = address['district']?.toString().trim() ?? '';
      final place = address['place']?.toString().trim() ?? '';

      if (donorCountry == country &&
          donorState == state &&
          donorDistrict == district &&
          place.isNotEmpty) {
        filteredPlaces.add(place);
      }
    }

    final result = filteredPlaces.toList();
    result.sort();
    return result;
  }
}
