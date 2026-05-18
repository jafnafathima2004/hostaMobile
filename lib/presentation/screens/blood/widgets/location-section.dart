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
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(screenWidth * 0.025),
                ),
                child: Text(
                  _getDisplayText(),
                  style: TextStyle(fontSize: screenWidth * 0.035, color: Colors.black54),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: onClear,
            icon: Icon(Icons.clear, color: Colors.red, size: screenWidth * 0.05),
            label: Text("Clear", style: TextStyle(color: Colors.red, fontSize: screenWidth * 0.035)),
          ),
        ],
      ),
    );
  }

  String _getDisplayText() {
    if (selectedCountry.isEmpty && selectedState.isEmpty && selectedDistrict.isEmpty && selectedPlace.isEmpty) {
      return "Select Location";
    }
    final parts = <String>[];
    if (selectedCountry.isNotEmpty) parts.add(selectedCountry);
    if (selectedState.isNotEmpty) parts.add(selectedState);
    if (selectedDistrict.isNotEmpty) parts.add(selectedDistrict);
    if (selectedPlace.isNotEmpty) parts.add(selectedPlace);
    return parts.join(" > ");
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
        borderRadius: BorderRadius.vertical(top: Radius.circular(screenWidth * 0.05)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
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
                        style: TextStyle(fontSize: screenWidth * 0.045, fontWeight: FontWeight.bold),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                    Divider(thickness: screenWidth * 0.0025),

                    // Country Dropdown
                    DropdownButtonFormField<String>(
                      value: tempCountry.isEmpty ? null : tempCountry,
                      decoration: InputDecoration(
                        labelText: "Country",
                        labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.025)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.015),
                      ),
                      items: [
                        const DropdownMenuItem(value: '', child: Text("Any Country")),
                        ...countries.map((country) => DropdownMenuItem(value: country, child: Text(country))),
                      ],
                      onChanged: (value) => setModalState(() => tempCountry = value ?? ''),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // State Dropdown (independent)
                    DropdownButtonFormField<String>(
                      value: tempState.isEmpty ? null : tempState,
                      decoration: InputDecoration(
                        labelText: "State",
                        labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.025)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.015),
                      ),
                      items: [
                        const DropdownMenuItem(value: '', child: Text("Any State")),
                        ...states.map((state) => DropdownMenuItem(value: state, child: Text(state))),
                      ],
                      onChanged: (value) => setModalState(() => tempState = value ?? ''),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // District Dropdown (independent)
                    DropdownButtonFormField<String>(
                      value: tempDistrict.isEmpty ? null : tempDistrict,
                      decoration: InputDecoration(
                        labelText: "District",
                        labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.025)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.015),
                      ),
                      items: [
                        const DropdownMenuItem(value: '', child: Text("Any District")),
                        ...districts.map((district) => DropdownMenuItem(value: district, child: Text(district))),
                      ],
                      onChanged: (value) => setModalState(() => tempDistrict = value ?? ''),
                    ),
                    SizedBox(height: screenHeight * 0.02),

                    // Place Dropdown (independent)
                    DropdownButtonFormField<String>(
                      isExpanded: true,
                      value: tempPlace.isEmpty ? null : tempPlace,
                      decoration: InputDecoration(
                        labelText: "Place",
                        labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.025)),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.015),
                      ),
                      items: [
                        const DropdownMenuItem(value: '', child: Text("Any Place")),
                        ...places.map((place) => DropdownMenuItem(value: place, child: Text(place))),
                      ],
                      onChanged: (value) => setModalState(() => tempPlace = value ?? ''),
                    ),
                    SizedBox(height: screenHeight * 0.03),

                    // Apply Filter Button
                    ElevatedButton(
                      onPressed: () {
                        onLocationSelected(tempCountry, tempState, tempDistrict, tempPlace);
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.03)),
                      ),
                      child: Text("Apply Filter", style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.04)),
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
}