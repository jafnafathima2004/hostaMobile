// import 'package:flutter/material.dart';

// class DoctorDetailScreen extends StatefulWidget {
//   const DoctorDetailScreen({super.key});

//   @override
//   State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
// }

// class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
//   int appointmentCount = 124;
//   double rating = 4.5;
//   int reviewCount = 38;

//   String consultationType = "clinic";
//   String hospitalName = "City Hospital";
//   String hospitalAddress = "Calicut, Kerala";
//   String clinicAddress = "Kozhikode Town Clinic";
//   double fees = 300;

//   List<Map<String, dynamic>> reviews = [
//     {"name": "Rahul", "stars": 5, "comment": "Very friendly doctor"},
//     {"name": "Anjali", "stars": 4, "comment": "Good experience"},
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFECFDF5),

//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: const Text(
//           "Doctor Details",
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         centerTitle: true,
//           leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
//         ),
//       ),

//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// 🔹 HEADER
//             _doctorHeader(),

//             const SizedBox(height: 20),

//             /// 🔹 HOSPITAL
//             _infoCard(
//               icon: Icons.local_hospital,
//               title: hospitalName,
//               subtitle: hospitalAddress,
//             ),

//             const SizedBox(height: 12),

//             /// 🔹 CONSULTATION TYPE
//             _consultationInfo(),

//             const SizedBox(height: 12),

//             /// 🔹 FEES
//             _feesCard(),

//             const SizedBox(height: 20),

//             /// 🔹 TIMINGS
//             const Text(
//               "Available Timings",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 10),

//             _timingTile("Monday", "9:00 AM - 1:00 PM"),
//             _timingTile("Wednesday", "10:00 AM - 2:00 PM"),

//             const SizedBox(height: 20),

//             /// 🔹 ABOUT
//             const Text(
//               "About Doctor",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 8),

//             const Text(
//               "Experienced doctor with excellent patient care.",
//               style: TextStyle(color: Colors.grey),
//             ),

//             const SizedBox(height: 20),

//             /// 🔹 REVIEWS
//             const Text(
//               "Patient Reviews",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//             ),

//             const SizedBox(height: 10),

//             ...reviews.map(
//               (r) => _reviewTile(r["name"], r["stars"], r["comment"]),
//             ),

//             const SizedBox(height: 10),

//             /// 🔹 ADD REVIEW BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: OutlinedButton(
//                 onPressed: _showReviewDialog,
//                 child: const Text("Write a Review"),
//               ),
//             ),

//             const SizedBox(height: 30),

//             /// 🔹 BOOK BUTTON
//             SizedBox(
//               width: double.infinity,
//               child: ElevatedButton(
//                 onPressed: () {},
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   padding: const EdgeInsets.symmetric(vertical: 16),
//                 ),
//                 child: const Text(
//                   "BOOK APPOINTMENT",
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   /// 🔹 HEADER
//   Widget _doctorHeader() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         children: [
//            CircleAvatar(
//               radius: 40,
//               backgroundImage: AssetImage("assets/doctor.jpg",),
//             ),
          
//           const SizedBox(width: 16),

//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Dr. John Mathew",
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),

//               const Text("Cardiologist", style: TextStyle(color: Colors.green)),

//               const SizedBox(height: 6),

//               Row(
//                 children: [
//                   const Icon(Icons.star, size: 16, color: Colors.amber),
//                   Text("$rating"),
//                   Text(" ($reviewCount)"),
//                 ],
//               ),

//               const SizedBox(height: 4),

//               Text(
//                 "$appointmentCount+ Appointments",
//                 style: const TextStyle(color: Colors.grey),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   /// 🔹 CONSULTATION
//   Widget _consultationInfo() {
//     String text = consultationType == "hospital"
//         ? hospitalAddress
//         : consultationType == "clinic"
//         ? clinicAddress
//         : "Home Visit Available";

//     return _infoCard(
//       icon: Icons.location_on,
//       title: consultationType.toUpperCase(),
//       subtitle: text,
//     );
//   }

//   /// 🔹 FEES
//   Widget _feesCard() {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.green[50],
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.currency_rupee, color: Colors.green),
//           const SizedBox(width: 10),
//           const Text(
//             "Consultation Fee",
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           const Spacer(),
//           Text(
//             "₹$fees",
//             style: const TextStyle(
//               color: Colors.green,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   /// 🔹 INFO CARD
//   Widget _infoCard({
//     required IconData icon,
//     required String title,
//     required String subtitle,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.green[50],
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: Row(
//         children: [
//           Icon(icon, color: Colors.green),
//           const SizedBox(width: 12),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
//               Text(subtitle, style: const TextStyle(color: Colors.grey)),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   /// 🔹 TIMINGS
//   Widget _timingTile(String day, String time) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Row(
//         children: [
//           const Icon(Icons.calendar_today, size: 18, color: Colors.green),
//           const SizedBox(width: 10),
//           Text(day),
//           const Spacer(),
//           Text(time, style: const TextStyle(color: Colors.green)),
//         ],
//       ),
//     );
//   }

//   /// 🔹 REVIEW TILE
//   Widget _reviewTile(String name, int stars, String comment) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
//               const Spacer(),
//               Row(
//                 children: List.generate(
//                   stars,
//                   (index) =>
//                       const Icon(Icons.star, size: 14, color: Colors.amber),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 6),
//           Text(comment, style: const TextStyle(color: Colors.grey)),
//         ],
//       ),
//     );
//   }

//   void _showReviewDialog() {
//     final controller = TextEditingController();
//     int stars = 5;

//     showDialog(
//       context: context,
//       builder: (context) {
//         return StatefulBuilder(
//           builder: (context, setStateDialog) {
//             return AlertDialog(
//               title: const Text("Add Review"),
//               content: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   /// ⭐ STAR RATING UI
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(5, (index) {
//                       return GestureDetector(
//                         onTap: () {
//                           setStateDialog(() {
//                             stars = index + 1;
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 4),
//                           child: Icon(
//                             Icons.star,
//                             size: 28, // control size here
//                             color: index < stars
//                                 ? Colors.amber
//                                 : Colors.grey[300],
//                           ),
//                         ),
//                       );
//                     }),
//                   ),

//                   const SizedBox(height: 10),

//                   /// ✍️ REVIEW TEXT
//                   TextField(
//                     controller: controller,
//                     decoration: const InputDecoration(
//                       hintText: "Write your review",
//                       border: OutlineInputBorder(),
//                     ),
//                     maxLines: 3,
//                   ),
//                 ],
//               ),

//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.pop(context),
//                   child: const Text("Cancel"),
//                 ),

//                 ElevatedButton(
//                   onPressed: () {
//                     if (controller.text.trim().isEmpty) return;

//                     setState(() {
//                       reviews.add({
//                         "name": "You",
//                         "stars": stars,
//                         "comment": controller.text,
//                       });
//                       reviewCount++;
//                     });

//                     Navigator.pop(context);
//                   },
//                   child: const Text("Submit"),
//                 ),
//               ],
//             );
//           },
//         );
//       },
//     );
//   }
// }



import 'package:flutter/material.dart';
import 'package:hosta/data/models/doctor_model.dart';

class DoctorDetailScreen extends StatefulWidget {
  const DoctorDetailScreen({super.key, required Doctor doctor});

  @override
  State<DoctorDetailScreen> createState() => _DoctorDetailScreenState();
}

class _DoctorDetailScreenState extends State<DoctorDetailScreen> {
  int appointmentCount = 124;
  double rating = 4.5;
  int reviewCount = 38;

  String consultationType = "clinic";
  String hospitalName = "City Hospital";
  String hospitalAddress = "Calicut, Kerala";
  String clinicAddress = "Kozhikode Town Clinic";
  double fees = 300;

  List<Map<String, dynamic>> reviews = [
    {"name": "Rahul", "stars": 5, "comment": "Very friendly doctor"},
    {"name": "Anjali", "stars": 4, "comment": "Good experience"},
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenWidth < 600;
    final isLandscape = screenSize.width > screenSize.height;

    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        toolbarHeight: isSmallScreen ? 56 : 70,
        title: Text(
          "Doctor Details",
          style: TextStyle(
            color: Colors.white, 
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 18 : 22,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(
          isSmallScreen ? 12.0 : screenWidth * 0.02,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔹 HEADER
            _doctorHeader(screenWidth, isLandscape),

            SizedBox(height: screenHeight * 0.025),

            /// 🔹 HOSPITAL
            _infoCard(
              icon: Icons.local_hospital,
              title: hospitalName,
              subtitle: hospitalAddress,
              screenWidth: screenWidth,
            ),

            SizedBox(height: screenHeight * 0.015),

            /// 🔹 CONSULTATION TYPE
            _consultationInfo(screenWidth),

            SizedBox(height: screenHeight * 0.015),

            /// 🔹 FEES
            _feesCard(screenWidth),

            SizedBox(height: screenHeight * 0.025),

            /// 🔹 TIMINGS
            Text(
              "Available Timings",
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.012),

            _timingTile("Monday", "9:00 AM - 1:00 PM", screenWidth),
            _timingTile("Wednesday", "10:00 AM - 2:00 PM", screenWidth),

            SizedBox(height: screenHeight * 0.025),

            /// 🔹 ABOUT
            Text(
              "About Doctor",
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.01),

            Text(
              "Experienced doctor with excellent patient care.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: isSmallScreen ? 13 : 15,
              ),
            ),

            SizedBox(height: screenHeight * 0.025),

            /// 🔹 REVIEWS
            Text(
              "Patient Reviews",
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            SizedBox(height: screenHeight * 0.012),

            ...reviews.map(
              (r) => _reviewTile(r["name"], r["stars"], r["comment"], screenWidth),
            ),

            SizedBox(height: screenHeight * 0.012),

            /// 🔹 ADD REVIEW BUTTON
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => _showReviewDialog(),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                ),
                child: const Text("Write a Review"),
              ),
            ),

            SizedBox(height: screenHeight * 0.03),

            /// 🔹 BOOK BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                ),
                child: Text(
                  "BOOK APPOINTMENT",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 HEADER
  Widget _doctorHeader(double screenWidth, bool isLandscape) {
    final isSmallScreen = screenWidth < 600;
    final avatarSize = isLandscape ? 50.0 : (isSmallScreen ? 60.0 : 80.0);
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: isLandscape
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _doctorHeaderContent(avatarSize, isSmallScreen),
              ],
            )
          : Column(
              children: [
                _doctorHeaderContent(avatarSize, isSmallScreen),
              ],
            ),
    );
  }

  Widget _doctorHeaderContent(double avatarSize, bool isSmallScreen) {
    return Row(
      children: [
        CircleAvatar(
          radius: avatarSize / 2,
          backgroundImage: const AssetImage("assets/doctor.jpg"),
        ),
        SizedBox(width: isSmallScreen ? 12.0 : 20.0),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Dr. John Mathew",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 16 : 20,
                ),
              ),
              Text(
                "Cardiologist",
                style: TextStyle(
                  color: Colors.green,
                  fontSize: isSmallScreen ? 12 : 14,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.star, size: isSmallScreen ? 14 : 16, color: Colors.amber),
                  Text("$rating", style: TextStyle(fontSize: isSmallScreen ? 12 : 14)),
                  Text(
                    " ($reviewCount)",
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "$appointmentCount+ Appointments",
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: isSmallScreen ? 11 : 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// 🔹 CONSULTATION
  Widget _consultationInfo(double screenWidth) {
    String text = consultationType == "hospital"
        ? hospitalAddress
        : consultationType == "clinic"
        ? clinicAddress
        : "Home Visit Available";

    return _infoCard(
      icon: Icons.location_on,
      title: consultationType.toUpperCase(),
      subtitle: text,
      screenWidth: screenWidth,
    );
  }

  /// 🔹 FEES
  Widget _feesCard(double screenWidth) {
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(Icons.currency_rupee, color: Colors.green, size: isSmallScreen ? 20 : 24),
          const SizedBox(width: 10),
          Text(
            "Consultation Fee",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 14 : 16,
            ),
          ),
          const Spacer(),
          Text(
            "₹$fees",
            style: TextStyle(
              color: Colors.green,
              fontWeight: FontWeight.bold,
              fontSize: isSmallScreen ? 16 : 20,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 INFO CARD
  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required double screenWidth,
  }) {
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12.0 : 16.0),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: isSmallScreen ? 20 : 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 16,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: isSmallScreen ? 12 : 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 TIMINGS
  Widget _timingTile(String day, String time, double screenWidth) {
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today, size: isSmallScreen ? 16 : 18, color: Colors.green),
          const SizedBox(width: 10),
          Text(
            day,
            style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
          ),
          const Spacer(),
          Text(
            time,
            style: TextStyle(
              color: Colors.green,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  /// 🔹 REVIEW TILE
  Widget _reviewTile(String name, int stars, String comment, double screenWidth) {
    final isSmallScreen = screenWidth < 600;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(isSmallScreen ? 10.0 : 12.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: isSmallScreen ? 14 : 16,
                ),
              ),
              const Spacer(),
              Row(
                children: List.generate(
                  stars,
                  (index) => Icon(
                    Icons.star,
                    size: isSmallScreen ? 12 : 14,
                    color: Colors.amber,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            comment,
            style: TextStyle(
              color: Colors.grey,
              fontSize: isSmallScreen ? 12 : 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showReviewDialog() {
    final controller = TextEditingController();
    int stars = 5;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text("Add Review"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ⭐ STAR RATING UI
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return GestureDetector(
                        onTap: () {
                          setStateDialog(() {
                            stars = index + 1;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Icon(
                            Icons.star,
                            size: 28,
                            color: index < stars
                                ? Colors.amber
                                : Colors.grey[300],
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Write your review",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (controller.text.trim().isEmpty) return;

                    setState(() {
                      reviews.add({
                        "name": "You",
                        "stars": stars,
                        "comment": controller.text,
                      });
                      reviewCount++;
                    });

                    Navigator.pop(context);
                  },
                  child: const Text("Submit"),
                ),
              ],
            );
          },
        );
      },
    );
  }
}