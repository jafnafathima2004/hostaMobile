import 'package:flutter/material.dart';

class SpecialtiesTab extends StatelessWidget {
  final Map<String, dynamic> hospital;
  final Function(String) onSpecialtyTap;

  const SpecialtiesTab({
    super.key,
    required this.hospital,
    required this.onSpecialtyTap,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final specialties = hospital["specialties"] as List? ?? [];
    
    if (specialties.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.medical_services_outlined,
              size: screenWidth * 0.16,
              color: Colors.grey,
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "No specialties available",
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(screenWidth * 0.04),
      itemCount: specialties.length,
      itemBuilder: (context, index) {
        final specialty = specialties[index];
        final specialtyName = specialty["name"] ?? "Unnamed Specialty";
        final doctorsCount = (specialty["doctors"] as List? ?? []).length;
        
        return Card(
          elevation: screenWidth * 0.0075,
          margin: EdgeInsets.only(bottom: screenHeight * 0.015),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.03)),
          child: InkWell(
            onTap: () => onSpecialtyTap(specialtyName),
            borderRadius: BorderRadius.circular(screenWidth * 0.03),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          specialtyName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold, 
                            fontSize: screenWidth * 0.04,
                            color: const Color.fromARGB(255, 12, 94, 15),
                          ),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: screenWidth * 0.04,
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  
                  if (specialty["description"] != null && specialty["description"].isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.01),
                      child: Text(
                        specialty["description"],
                        style: TextStyle(fontSize: screenWidth * 0.035),
                      ),
                    ),
                  
                  if (specialty["department_info"] != null && specialty["department_info"].isNotEmpty)
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.005),
                      child: Text(
                        "Department: ${specialty["department_info"]}",
                        style: TextStyle(
                          color: Colors.blueGrey,
                          fontSize: screenWidth * 0.03,
                        ),
                      ),
                    ),
                  
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    child: Row(
                      children: [
                        Icon(
                          Icons.medical_services,
                          size: screenWidth * 0.035,
                          color: Colors.green,
                        ),
                        SizedBox(width: screenWidth * 0.01),
                        Text(
                          "$doctorsCount doctors available",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w500,
                            fontSize: screenWidth * 0.03,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.02,
                            vertical: screenHeight * 0.0025,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green[50],
                            borderRadius: BorderRadius.circular(screenWidth * 0.03),
                          ),
                          child: Text(
                            "View Doctors",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: screenWidth * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}