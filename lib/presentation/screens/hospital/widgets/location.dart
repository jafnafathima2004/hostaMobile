import 'package:flutter/material.dart';
import 'package:hosta/presentation/screens/hospital/widgets/loaction-mappreview.dart';

class LocationTab extends StatelessWidget {
  final Map<String, dynamic> hospital;
  final VoidCallback onOpenMaps;

  const LocationTab({
    super.key,
    required this.hospital,
    required this.onOpenMaps,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final lat = hospital["latitude"]?.toString() ?? "0";
    final lng = hospital["longitude"]?.toString() ?? "0";
    
    // Check if coordinates are valid
    if (lat == "0" && lng == "0") {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off,
              size: screenWidth * 0.16,
              color: Colors.grey,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Location not available",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        // Map Preview
        Expanded(
          child: LocationMapPreview(
            latitude: double.tryParse(lat) ?? 0,
            longitude: double.tryParse(lng) ?? 0,
            hospitalName: hospital["name"] ?? "Hospital",
            address: hospital["address"] ?? "",
          ),
        ),
        
        // Open in Maps Button
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: ElevatedButton.icon(
            onPressed: onOpenMaps,
            icon: Icon(
              Icons.open_in_new,
              color: Colors.white,
              size: screenWidth * 0.05,
            ),
            label: Text(
              "Open in Google Maps",
              style: TextStyle(
                color: Colors.white,
                fontSize: screenWidth * 0.04,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
            ),
          ),
        ),
      ],
    );
  }
}