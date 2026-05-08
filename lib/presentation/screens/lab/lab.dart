import 'package:flutter/material.dart';

class LabReport extends StatefulWidget {
  const LabReport({super.key});

  @override
  State<LabReport> createState() => _LabReportState();
}

class _LabReportState extends State<LabReport> {
  DateTime? selectedDate;

  // 👉 Date Picker
  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  // 👉 Date compare
  bool isSameDate(DateTime d1, DateTime d2) {
    return d1.day == d2.day && d1.month == d2.month && d1.year == d2.year;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    // 👉 demo report date (Collected on)
    DateTime reportDate = DateTime(2024, 6, 17);

    Widget _cell(String text, {bool isHeader = false, bool isHigh = false}) {
      return Padding(
        padding: EdgeInsets.all(screenWidth * 0.025),
        child: Text(
          text,
          style: TextStyle(
            color: isHeader
                ? Colors.white
                : isHigh
                ? Colors.red
                : Colors.black87,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
            fontSize: screenWidth * 0.035,
          ),
        ),
      );
    }

    TableRow _row(
      String name,
      String result,
      String range,
      String unit, {
      bool isHigh = false,
    }) {
      return TableRow(
        children: [
          _cell(name),
          _cell(result, isHigh: isHigh),
          _cell(range),
          _cell(unit),
        ],
      );
    }

    // 👉 Filter condition
    bool showReport =
        selectedDate == null || isSameDate(selectedDate!, reportDate);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Lab Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: screenWidth * 0.055,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.02),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 👉 FILTER UI
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.03,
                  vertical: screenHeight * 0.0125,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  border: Border.all(color: Colors.grey, width: screenWidth * 0.0025),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.green,
                      size: screenWidth * 0.05,
                    ),
                    SizedBox(width: screenWidth * 0.025),

                    // 📅 Selected Date Text
                    Expanded(
                      child: Text(
                        selectedDate == null
                            ? "Select report date"
                            : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
                        style: TextStyle(
                          fontSize: screenWidth * 0.035,
                          color: selectedDate == null
                              ? Colors.grey
                              : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),

                    // 🔁 Clear Button (optional but nice)
                    if (selectedDate != null)
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedDate = null;
                          });
                        },
                        child: Icon(
                          Icons.close,
                          size: screenWidth * 0.045,
                          color: Colors.grey,
                        ),
                      ),

                    SizedBox(width: screenWidth * 0.02),

                    // 🔍 Filter Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        ),
                      ),
                      onPressed: pickDate,
                      child: Text(
                        "Filter",
                        style: TextStyle(
                          fontSize: screenWidth * 0.0325,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: screenHeight * 0.0125),
              Divider(
                color: Colors.grey,
                thickness: screenWidth * 0.0025,
              ),

              SizedBox(height: screenHeight * 0.0125),

              // 👉 If date match → show report
              if (showReport) ...[
                Center(
                  child: Text(
                    "Dreams's Medical center",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "123 Healthcare Avenue Medical District,City\n Phone +1(564)123-5676 | Email:info@dream.com",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                Divider(
                  indent: screenWidth * 0.075,
                  endIndent: screenWidth * 0.075,
                  color: Colors.grey,
                  thickness: screenWidth * 0.0025,
                ),
                SizedBox(height: screenHeight * 0.0125),
                Center(
                  child: Text(
                    "Pathology Laboratory Report",
                    style: TextStyle(
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Accredited by NABL | ISO 15185:2024 certified",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: screenWidth * 0.035,
                    ),
                  ),
                ),
                SizedBox(height: screenHeight * 0.01875),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Doctor:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Text(
                                "Dr.Jhon",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Type:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Text(
                                "Blood Test",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "LabNo:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Text(
                                " #TE0025",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                "Collected on:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Text(
                                " 17th June",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Reported on:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Text(
                                " 17th June",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "Status:",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                              Text(
                                "Final",
                                style: TextStyle(
                                  color: Colors.blueGrey,
                                  fontSize: screenWidth * 0.035,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                SizedBox(height: screenHeight * 0.01875),

                Container(
                  height: screenHeight * 0.1,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    border: Border.all(
                      color: Colors.green,
                      width: screenWidth * 0.0025,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Patient Information",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: screenWidth * 0.035,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "PatientName",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: screenWidth * 0.03,
                                  ),
                                ),
                                Text(
                                  "James",
                                  style: TextStyle(fontSize: screenWidth * 0.03),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "PatientId",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: screenWidth * 0.03,
                                  ),
                                ),
                                Text(
                                  "PT008",
                                  style: TextStyle(fontSize: screenWidth * 0.03),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "Age/Gender",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: screenWidth * 0.03,
                                  ),
                                ),
                                Text(
                                  "34y/Male",
                                  style: TextStyle(fontSize: screenWidth * 0.03),
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(
                                  "BloodGroup",
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontSize: screenWidth * 0.03,
                                  ),
                                ),
                                Text(
                                  "AB+ve",
                                  style: TextStyle(fontSize: screenWidth * 0.03),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: screenHeight * 0.0125),

                Padding(
                  padding: EdgeInsets.only(left: screenWidth * 0.0125),
                  child: Text(
                    "Test Result",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),

                // 👉 your table same
                Container(
                  margin: EdgeInsets.all(screenWidth * 0.0075),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    border: Border.all(
                      color: Colors.black,
                      width: screenWidth * 0.0025,
                    ),
                  ),
                  child: Table(
                    columnWidths: {
                      0: FlexColumnWidth(2),
                      1: FlexColumnWidth(1),
                      2: FlexColumnWidth(2),
                      3: FlexColumnWidth(1),
                    },
                    border: TableBorder(
                      horizontalInside: BorderSide(
                        color: Colors.grey,
                        width: screenWidth * 0.0025,
                      ),
                    ),
                    children: [
                      TableRow(
                        decoration: BoxDecoration(color: Colors.black),
                        children: [
                          _cell("Investigation", isHeader: true),
                          _cell("Result", isHeader: true),
                          _cell("Reference Range", isHeader: true),
                          _cell("Unit", isHeader: true),
                        ],
                      ),
                      _row("Neutrophils", "75", "50 - 62", "%", isHigh: true),
                      _row("Lymphocytes", "90", "20 - 40", "%", isHigh: true),
                      _row("Eosinophils", "60", "0 - 6", "%", isHigh: true),
                    ],
                  ),
                ),
              ] else ...[
                Center(
                  child: Padding(
                    padding: EdgeInsets.all(screenWidth * 0.05),
                    child: Text(
                      "No reports found for selected date",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                ),
              ],
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(screenWidth * 0.025),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.08,
                    vertical: screenHeight * 0.0125,
                  ),
                ),
                onPressed: (){},
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Download",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                    Icon(
                      Icons.download,
                      color: Colors.white,
                      size: screenWidth * 0.05,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}