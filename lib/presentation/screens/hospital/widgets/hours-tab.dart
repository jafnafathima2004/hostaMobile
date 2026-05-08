import 'package:flutter/material.dart';

class HoursTab extends StatelessWidget {
  final Map<String, dynamic> hospital;
  final String Function(String) formatTime;

  const HoursTab({
    super.key,
    required this.hospital,
    required this.formatTime,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final workingHoursClinic = hospital["working_hours_clinic"] as List?;
    final workingHours = hospital["working_hours"] as List?;

    if (workingHoursClinic != null && workingHoursClinic.isNotEmpty) {
      return _buildHoursTabNewFormat(workingHoursClinic, screenWidth, screenHeight);
    } else if (workingHours != null && workingHours.isNotEmpty) {
      return _buildHoursTabOldFormat(workingHours, screenWidth, screenHeight);
    } else {
      return Center(
        child: Text(
          "No working hours available",
          style: TextStyle(fontSize: screenWidth * 0.04),
        ),
      );
    }
  }

  Widget _buildHoursTabNewFormat(List<dynamic> workingHoursClinic, double screenWidth, double screenHeight) {
    return ListView.builder(
      padding: EdgeInsets.all(screenWidth * 0.04),
      itemCount: workingHoursClinic.length,
      itemBuilder: (context, index) {
        final item = workingHoursClinic[index];
        final isHoliday = item["is_holiday"] == true;
        final morningSession = item["morning_session"];
        final eveningSession = item["evening_session"];

        return Card(
          elevation: screenWidth * 0.005,
          margin: EdgeInsets.only(bottom: screenHeight * 0.0125),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.03)),
          child: ListTile(
            title: Text(
              item["day"],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.0375,
                color: isHoliday ? Colors.red : Colors.black,
              ),
            ),
            subtitle: isHoliday
                ? Text(
                    "Holiday",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenWidth * 0.035,
                    ),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (morningSession["open"] != null && morningSession["open"].isNotEmpty)
                        Text(
                          "🌅 Morning: ${formatTime(morningSession["open"])} - ${formatTime(morningSession["close"])}",
                          style: TextStyle(fontSize: screenWidth * 0.0325),
                        ),
                      if (eveningSession["open"] != null && eveningSession["open"].isNotEmpty)
                        Text(
                          "🌇 Evening: ${formatTime(eveningSession["open"])} - ${formatTime(eveningSession["close"])}",
                          style: TextStyle(fontSize: screenWidth * 0.0325),
                        ),
                      if (item["has_break"] == true)
                        Text(
                          "⏸️ Has break time",
                          style: TextStyle(
                            color: Colors.orange,
                            fontSize: screenWidth * 0.0325,
                          ),
                        ),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildHoursTabOldFormat(List<dynamic> workingHours, double screenWidth, double screenHeight) {
    return ListView.builder(
      padding: EdgeInsets.all(screenWidth * 0.04),
      itemCount: workingHours.length,
      itemBuilder: (context, index) {
        final item = workingHours[index];
        final isHoliday = item["is_holiday"] == true;

        return Card(
          elevation: screenWidth * 0.005,
          margin: EdgeInsets.only(bottom: screenHeight * 0.0125),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.03)),
          child: ListTile(
            title: Text(
              item["day"],
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenWidth * 0.0375,
                color: isHoliday ? Colors.red : Colors.black,
              ),
            ),
            subtitle: isHoliday
                ? Text(
                    "Holiday",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: screenWidth * 0.035,
                    ),
                  )
                : Text(
                    "🕒 ${formatTime(item["opening_time"])} - ${formatTime(item["closing_time"])}",
                    style: TextStyle(fontSize: screenWidth * 0.0325),
                  ),
          ),
        );
      },
    );
  }
}