import 'package:flutter/material.dart';

class LabReport extends StatefulWidget {
  const LabReport({super.key});

  @override
  State<LabReport> createState() => _LabReportState();
}

class _LabReportState extends State<LabReport> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(
          "Lab Details",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.keyboard_arrow_left, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 10),
              Divider(),
              Center(
                child: Text(
                  "Dreams's Medical center",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "123 Healthcare Avenue Medical District,City\n Phone +1(564)123-5676 | Email:info@dream.com",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              Divider(indent: 30, endIndent: 30),
              SizedBox(height: 10),
              Center(
                child: Text(
                  "Pathology Laboratory Report",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Center(
                child: Text(
                  "Accredited by NABL | ISO 15185:2024 certified",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              SizedBox(height: 10,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Referring Doctor: Dr. John"),
                        Text("Test Type: Blood Test"),
                        Text("Lab Number: #TE0025"),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text("Collected on: 17th June 2024"),
                        Text("Reported on: 17th June 2024, 2:00 PM"),
                        Text("Status: Final"),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
