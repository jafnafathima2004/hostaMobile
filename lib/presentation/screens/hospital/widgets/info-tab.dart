import 'package:flutter/material.dart';

class InfoTab extends StatelessWidget {
  final Map<String, dynamic> hospital;
  final Function(String) makePhoneCall;

  const InfoTab({
    super.key,
    required this.hospital,
    required this.makePhoneCall,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    return ListView(
      padding: EdgeInsets.all(screenWidth * 0.04),
      children: [
        _infoRow(Icons.location_on, hospital["address"] ?? "No address provided", screenWidth, screenHeight),
        _infoRow(Icons.phone, hospital["phone"] ?? "No phone number", screenWidth, screenHeight, onTap: () {
          if (hospital["phone"] != null) {
            makePhoneCall(hospital["phone"]);
          }
        }),
        _infoRow(Icons.email, hospital["email"] ?? "No email provided", screenWidth, screenHeight),
        _infoRow(Icons.medical_services, hospital["type"] ?? "Unknown type", screenWidth, screenHeight),
        if (hospital["about"] != null && hospital["about"].isNotEmpty)
          _infoRow(Icons.info, hospital["about"], screenWidth, screenHeight),
        if (hospital["emergencyContact"] != null && hospital["emergencyContact"] != "00000000")
          _infoRow(Icons.emergency, "Emergency: ${hospital["emergencyContact"]}", screenWidth, screenHeight, onTap: () {
            makePhoneCall(hospital["emergencyContact"]);
          }),
      ],
    );
  }

  Widget _infoRow(IconData icon, String text, double screenWidth, double screenHeight, {VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.green, size: screenWidth * 0.055),
            SizedBox(width: screenWidth * 0.025),
            Expanded(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: screenWidth * 0.0375,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}