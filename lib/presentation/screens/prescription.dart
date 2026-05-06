// import 'package:flutter/material.dart';

// class PrescriptionDetailsScreen extends StatelessWidget {
//   const PrescriptionDetailsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text('Prescription Details'),
//         actions: [
//           IconButton(onPressed: () {}, icon: const Icon(Icons.print_outlined)),
//           IconButton(onPressed: () {}, icon: const Icon(Icons.download_outlined)),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Medical Center Info
//             Center(
//               child: Column(
//                 children: [
//                   Text(
//                     "Dream's Medical Center",
//                     style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                           color: Colors.blue.shade700,
//                           fontWeight: FontWeight.bold,
//                         ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text("123 Healthcare Avenue, Medical District, City",
//                       style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
//                   Text("Phone: +1 (555) 123-4567 | Email: info@dreamsmedical.com",
//                       style: Theme.of(context).textTheme.bodySmall, textAlign: TextAlign.center),
//                 ],
//               ),
//             ),
//             const Divider(height: 32),

//             Center(
//               child: Text("Medical Prescription",
//                   style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
//             ),
//             const SizedBox(height: 20),

//             // Doctor & Patient Details
//             _buildInfoCard(
//               context,
//               children: [
//                 _buildKeyValue("Prescribing Doctor", "Dr. Sandy Maria"),
//                 _buildKeyValue("Specialization", "General Medicine"),
//                 _buildKeyValue("Registration No", "MED-2024-001"),
//                 const SizedBox(height: 8),
//                 _buildKeyValue("Prescription Date", "4/21/2026"),
//                 _buildKeyValue("Prescription ID", "1"),
//                 _buildKeyValue("Follow-up Date", "5/21/2026"),
//               ],
//             ),
//             const SizedBox(height: 16),

//             Text("Patient Information",
//                 style: Theme.of(context).textTheme.titleSmall?.copyWith(
//                       color: Colors.blue.shade700,
//                       fontWeight: FontWeight.w600,
//                     )),
//             const SizedBox(height: 12),
//             _buildInfoCard(
//               context,
//               children: [
//                 Row(
//                   children: [
//                     Expanded(child: _buildLabelValue("Patient Name", "James Carter")),
//                     Expanded(child: _buildLabelValue("Patient ID", "PT0025")),
//                   ],
//                 ),
//                 const SizedBox(height: 12),
//                 Row(
//                   children: [
//                     Expanded(child: _buildLabelValue("Age / Gender", "34Y / Male")),
//                     Expanded(child: _buildLabelValue("Contact", "+1 (555) 123-4567")),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Medicines Table
//             Text("Medicines Prescribed", style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
//             const SizedBox(height: 12),
//             _buildMedicineTable(),
//             const SizedBox(height: 20),

//             // Doctor's Notes
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: Colors.green.shade50,
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(color: Colors.green.shade100),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text("Doctor's Notes & Instructions",
//                       style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600, fontSize: 15)),
//                   const SizedBox(height: 8),
//                   const Text(
//                     "Take medications as prescribed. Complete the full course even if symptoms improve. "
//                     "Avoid alcohol during treatment. Report any adverse reactions immediately.",
//                     style: TextStyle(fontSize: 13, height: 1.4),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Dietary & Appointment
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Expanded(
//                   child: _buildGreyCard(
//                     title: "Dietary Advice:",
//                     content: "Stay hydrated. Avoid spicy and oily food. Include fruits and vegetables in diet.",
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _buildGreyCard(
//                     title: "Next Appointment:",
//                     content: "Please schedule a follow-up appointment after completing the medication course.",
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),
//             const Divider(),
//             const SizedBox(height: 16),

//             // QR & Signature
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Column(
//                   children: [
//                     Container(
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.grey.shade300),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                  //     child: QrImageView(data: 'PrescriptionID:1|Patient:PT0025', version: QrVersions.auto, size: 80),
//                     ),
//                     const SizedBox(height: 6),
//                     Text("Scan to verify prescription", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Text("Dr. Sandy Maria", style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
//                     Container(width: 140, height: 1, color: Colors.grey.shade400),
//                     const SizedBox(height: 4),
//                     Text("MD General Medicine", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//                     Text("Authorized Signature", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 32),

//             // Footer
//             Center(
//               child: Column(
//                 children: [
//                   Text("This is a computer generated prescription. No signature is required.",
//                       style: TextStyle(fontSize: 11, color: Colors.grey.shade600), textAlign: TextAlign.center),
//                   const SizedBox(height: 4),
//                   Text("** Take medicines only as prescribed by the doctor **",
//                       style: TextStyle(fontSize: 11, color: Colors.grey.shade600, fontWeight: FontWeight.w500),
//                       textAlign: TextAlign.center),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoCard(BuildContext context, {required List<Widget> children}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
//     );
//   }

//   Widget _buildKeyValue(String key, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [Text(key, style: const TextStyle(fontWeight: FontWeight.w500)), Text(value)],
//       ),
//     );
//   }

//   Widget _buildLabelValue(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//         const SizedBox(height: 2),
//         Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
//       ],
//     );
//   }

//   Widget _buildMedicineTable() {
//     final medicines = [
//       {"name": "Metoprolol", "dosage": "25mg", "duration": "30 days", "freq": "1x/day", "time": "Morning"},
//       {"name": "Lisinopril", "dosage": "10mg", "duration": "30 days", "freq": "1x/day", "time": "Evening"},
//     ];

//     return Container(
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey.shade300),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ClipRRect(
//         borderRadius: BorderRadius.circular(12),
//         child: Table(
//           columnWidths: const {
//             0: FlexColumnWidth(2),
//             1: FlexColumnWidth(1.2),
//             2: FlexColumnWidth(1.2),
//             3: FlexColumnWidth(1),
//             4: FlexColumnWidth(1.2),
//           },
//           children: [
//             TableRow(
//               decoration: BoxDecoration(color: Colors.grey.shade800),
//               children: ["Medicine Name", "Dosage", "Duration", "Frequency", "Timing"]
//                   .map((e) => Padding(
//                         padding: const EdgeInsets.all(12),
//                         child: Text(e, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12)),
//                       ))
//                   .toList(),
//             ),
//             ...medicines.map((med) {
//               return TableRow(
//                 decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey.shade200))),
//                 children: [med["name"]!, med["dosage"]!, med["duration"]!, med["freq"]!, med["time"]!]
//                     .map((e) => Padding(padding: const EdgeInsets.all(12), child: Text(e, style: const TextStyle(fontSize: 13))))
//                     .toList(),
//               );
//             }).toList(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildGreyCard({required String title, required String content}) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade50,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
//           const SizedBox(height: 6),
//           Text(content, style: const TextStyle(fontSize: 12, height: 1.4)),
//         ],
//       ),
//     );
//   }
// }





// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:hosta/data/models/prescription_model.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:pdf/widgets.dart' as pw;
// import 'package:printing/printing.dart';
// import 'package:qr_flutter/qr_flutter.dart';

// class PrescriptionDetailsScreen extends StatefulWidget {
//   const PrescriptionDetailsScreen({super.key});

//   @override
//   State<PrescriptionDetailsScreen> createState() => _PrescriptionDetailsScreenState();
// }


// class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {

// DateTime? selectedDate;

// List<Medicine> medicines = [
//   Medicine(
//     name: "Metoprolol",
//     dosage: "25mg",
//     days: "30 days",
//     time: "Morning",
//     freq: "1x/day",
//     isTaken: true,
//     date: DateTime(2026, 4, 21),
//   ),
//   Medicine(
//     name: "Lisinopril",
//     dosage: "10mg",
//     days: "30 days",
//     time: "Evening",
//     freq: "1x/day",
//     isTaken: false,
//     date: DateTime(2026, 5, 1),
//   ),
// ];

// Future<void> _downloadPrescription() async {
//   final pdf = pw.Document();

//   pdf.addPage(
//     pw.Page(
//       build: (context) => pw.Column(
//         crossAxisAlignment: pw.CrossAxisAlignment.start,
//         children: [
//           pw.Text("Medical Prescription", style: pw.TextStyle(fontSize: 20)),
//           pw.SizedBox(height: 10),

//           pw.Text("Doctor: Dr. Sandy Maria"),
//           pw.Text("Patient: James Carter"),
//           pw.Text("Date: Apr 21, 2026"),

//           pw.SizedBox(height: 20),

//           pw.Text("Medicines:", style: pw.TextStyle(fontSize: 16)),

//           ...medicines.map((med) => pw.Text(
//                 "${med.name} - ${med.dosage} (${med.time})",
//               )),
//         ],
//       ),
//     ),
//   );

//   final dir = await getApplicationDocumentsDirectory();
//   final file = File("${dir.path}/prescription.pdf");

//   await file.writeAsBytes(await pdf.save());
//   // Open preview / print dialog
//   // await Printing.layoutPdf(
//   //   onLayout: (format) async => pdf.save(),
//   // );
//   Navigator.push(
//   context,
//   MaterialPageRoute(
//     builder: (context) => Scaffold(
//       appBar: AppBar(
//         title: Text("Prescription Preview"),
//         backgroundColor: Colors.green,
//       ),
//       body: PdfPreview(
//         build: (format) => pdf.save(),
//       ),
//     ),
//   ),
// );

//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(content: Text("Prescription downloaded successfully")),
//   );
// }

// List<Medicine> get filteredMedicines {
//   if (selectedDate == null) return medicines;

//   return medicines.where((med) {
//     return med.date.year == selectedDate!.year &&
//         med.date.month == selectedDate!.month &&
//         med.date.day == selectedDate!.day;
//   }).toList();
// }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF8F9FC),
//       appBar: AppBar(
//         backgroundColor:  Colors.green,
//         foregroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton( icon: const Icon(Icons.arrow_back),
//         onPressed: () => Navigator.pop(context),),
//         title: const Text('Prescription Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
//         actions: [
//           _appBarAction(Icons.print, 'Print'),
//           _appBarAction(Icons.download, 'Download'),
//           const SizedBox(width: 8),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
        
//         child: Column(
//           children: [
//             // 🔥 FILTER SECTION (APPBAR THAZHE)
// _buildCard(
//   child: Row(
//     children: [
//       // Icon(Icons.filter_list, color: Colors.green),
//       // const SizedBox(width: 8),

//       // Expanded(
//       //   child: Text(
//       //     selectedDate == null
//       //         ? "All Dates"
//       //         : "${selectedDate!.day}-${selectedDate!.month}-${selectedDate!.year}",
//       //     style: TextStyle(fontWeight: FontWeight.w600),
//       //   ),
//       // ),
// Align(
//   alignment: Alignment.center,
//     child:TextButton.icon(
//         onPressed: () async {
//           final picked = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(2020),
//             lastDate: DateTime(2030),
//           );

//           if (picked != null) {
//             setState(() {
//               selectedDate = picked;
//             });
//           }
//         },
      
//         icon: Icon(Icons.calendar_today, size: 18),
//         label: Text("filter by date", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
//       ),
// ),

//       if (selectedDate != null)
//         IconButton(
//           onPressed: () {
//             setState(() {
//               selectedDate = null;
//             });
//           },
//           icon: Icon(Icons.close, color: Colors.red),
          
//         )
//     ],
//   ),
// ),
// const SizedBox(height: 16),
//            // Medical Center Card
//             _buildCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.all(10),
//                         decoration: BoxDecoration(
//                           color: const Color(0xFFE8F1FF),
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         child: const Icon(Icons.local_hospital,  color: Colors.green, size: 28),
//                       ),
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text("Dream's Medical Center",
//                                 style: TextStyle(color: Colors.green, fontWeight: FontWeight.w700, fontSize: 16)),
//                             const SizedBox(height: 4),
//                             Text("123 Healthcare Avenue, Medical District, City",
//                                 style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
//                             Text("Phone: +1 (555) 123-4567 | Email: info@dreamsmedical.com",
//                                 style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const Divider(height: 24),
//                   const Center(
//                     child: Text("Medical Prescription",
//                         style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Expanded(
//                         child: _iconInfoTile(
//                           Icons.person_outline,
//                           "Prescribing Doctor",
//                           "Dr. Sandy Maria",
//                           "General Medicine\nRegistration No.\nMED-2024-001",
//                         ),
//                       ),
//                       Container(width: 1, height: 90, color: Colors.grey.shade200),
//                       const SizedBox(width: 16),
//                       Expanded(
//                         child: _iconInfoTile(
//                           Icons.calendar_today_outlined,
//                           "Prescription Date",
//                           "Apr 21, 2026",
//                           "Prescription ID\n1\nFollow-up Date\nMay 21, 2026",
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//            ),
//             const SizedBox(height: 16),

//             // Patient Information
//             _buildCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Row(
//                     children: [
//                       Icon(Icons.person_outline, color: Colors.green, size: 20),
//                       SizedBox(width: 8),
//                       Text("Patient Information",
//                           style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15)),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       _patientInfoItem(Icons.person, "Patient Name", "James Carter"),
//                       _patientInfoItem(Icons.badge_outlined, "Patient ID", "PT0025"),
//                       _patientInfoItem(Icons.male, "Age / Gender", "34Y / Male"),
//                       _patientInfoItem(Icons.phone, "Contact", "+1 (555) 123-4567"),
                      
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Medicines Prescribed
//             _buildCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.medication_outlined, color: Colors.green, size: 20),
//                       const SizedBox(width: 8),
//                       const Text("Medicines Prescribed",                 
//                           style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 15)),
//                       const Spacer(),
// //                       TextButton.icon(
// //   onPressed: () async {
// //     final picked = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2020),
// //       lastDate: DateTime(2030),
// //     );

// //     if (picked != null) {
// //       setState(() {
// //         selectedDate = picked;
// //       });
// //     }
// //   },
// //   icon: Icon(Icons.calendar_today),
// //   label: Text("Filter by Date"),
// // ),
//                       // TextButton.icon(
//                       //   onPressed: () {},
//                       //   icon: const Icon(Icons.notifications_none, size: 18),
//                       //   label: const Text("Set Reminder"),
//                       // ),
//                     ],
//                   ),
//   //                 if (selectedDate != null)
//   // TextButton(
//   //   onPressed: () {
//   //     setState(() {
//   //       selectedDate = null;
//   //     });
//   //   },
//   //   child: Text("Clear Filter"),
//   // ),
//                   const SizedBox(height: 12),
//                   // _medicineCard(
//                   //   color: Colors.green,
//                   //   name: "Metoprolol",
//                   //   dosage: "25mg",
//                   //   days: "30 days",
//                   //   time: "Morning",
//                   //   freq: "1x/day",
//                   // //  takenStatus: "Taken",
//                   //  // isTaken: true,
//                   // ),
//                 //  const SizedBox(height: 12),
//                   // _medicineCard(
//                   //   color: const Color(0xFF4CAF50),
//                   //   name: "Lisinopril",
//                   //   dosage: "10mg",
//                   //   days: "30 days",
//                   //   time: "Evening",
//                   //   freq: "1x/day",
//                   //   //takenStatus: "Mark as taken",
//                   // //  isTaken: false,
//                   // ),
//                   Column(
//   children: filteredMedicines.map((med) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: _medicineCard(
//         color: Colors.green,
//         name: med.name,
//         dosage: med.dosage,
//         days: med.days,
//         time: med.time,
//         freq: med.freq,
//       ),
//     );
//   }).toList(),
// ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Doctor's Notes
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(16),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFE8F5E9),
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     children: [
//                       Icon(Icons.description_outlined, color: Colors.green.shade700, size: 20),
//                       const SizedBox(width: 8),
//                       Text("Doctor's Notes & Instructions",
//                           style: TextStyle(color: Colors.green.shade800, fontWeight: FontWeight.w600)),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   const Text(
//                     "Take medications as prescribed. Complete the full course even if symptoms improve. "
//                     "Avoid alcohol during treatment. Report any adverse reactions immediately.",
//                     style: TextStyle(fontSize: 13, height: 1.4),
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(height: 16),

//             // Dietary & Appointment
//             Row(
//               children: [
//                 Expanded(
//                   child: _smallInfoCard(
//                     icon: Icons.restaurant_menu,
//                     iconColor: Colors.black,
//                     title: "Dietary Advice",
//                     content: "Stay hydrated. Avoid spicy and oily food. Include fruits and vegetables in diet.",
//                   ),
//                 ),
//                 const SizedBox(width: 12),
//                 Expanded(
//                   child: _smallInfoCard(
//                     icon: Icons.calendar_month_outlined,
//                     iconColor: Colors.black,
//                     title: "Next Appointment",
//                     content: "Please schedule a follow-up appointment after completing the medication course.",
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // QR & Signature
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.end,
//               children: [
//                 Column(
//                   children: [
//                    QrImageView(data: 'PrescriptionID:1', version: QrVersions.auto, size: 80),
//                     const SizedBox(height: 6),
//                     Text("Scan to verify prescription", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//                   ],
//                 ),
//                 const Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Text("Sandy Maria",
//                         style: TextStyle(fontSize: 20, fontStyle: FontStyle.italic, fontFamily: 'Cursive')),
//                     Container(width: 120, height: 1, color: Colors.grey.shade400),
//                     const SizedBox(height: 4),
//                     const Text("Dr. Sandy Maria", style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
//                     Text("MD General Medicine", style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//                     const SizedBox(height: 8),
//                     Container(
//                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                       decoration: BoxDecoration(
//                         color: const Color(0xFFE8F1FF),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Text("This is a computer generated prescription.\nNo signature is required.",
//                           textAlign: TextAlign.center,
//                           style: TextStyle(fontSize: 10, color: Colors.green.shade700)),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 24),

//             // Download Button
//             SizedBox(
//               width: double.infinity,
//               height: 50,
//               child: ElevatedButton.icon(
//                 onPressed: _downloadPrescription,
//              //   onPressed: () {},
//                 icon: const Icon(Icons.download),
//                 label: const Text("Download Prescription (PDF)", style: TextStyle(fontWeight: FontWeight.w600)),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green,
//                   foregroundColor: Colors.white,
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//       // bottomNavigationBar: BottomNavigationBar(
//       //   type: BottomNavigationBarType.fixed,
//       //   selectedItemColor:Colors.green,
//       //   items: const [
//       //     BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Overview'),
//       //     BottomNavigationBarItem(icon: Icon(Icons.medication_outlined), label: 'Medications'),
//       //     BottomNavigationBarItem(icon: Icon(Icons.folder_outlined), label: 'Documents'),
//       //     BottomNavigationBarItem(icon: Icon(Icons.more_horiz), label: 'More'),
//       //   ],
//       //   currentIndex: 1,
//       // ),
//     );
//   }

//   Widget _appBarAction(IconData icon, String label) {
//     return Padding(
//       padding: const EdgeInsets.only(right: 4),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [Icon(icon, size: 20), Text(label, style: const TextStyle(fontSize: 11))],
//       ),
//     );
//   }

//   Widget _buildCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2))],
//       ),
//       child: child,
//     );
//   }

//   Widget _iconInfoTile(IconData icon, String title, String main, String sub) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Row(
//           children: [
//             Icon(icon, size: 18, color:Colors.green),
//             const SizedBox(width: 6),
//             Text(title, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
//           ],
//         ),
//         const SizedBox(height: 6),
//         Text(main, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15)),
//         const SizedBox(height: 4),
//         Text(sub, style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.4)),
//       ],
//     );
//   }

//   Widget _patientInfoItem(IconData icon, String label, String value) {
//     return Column(
//       children: [
//         Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(color: const Color(0xFFE8F1FF), borderRadius: BorderRadius.circular(10)),
//           child: Icon(icon, color:Colors.green, size: 18),
//         ),
//         const SizedBox(height: 6),
//         Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
//         const SizedBox(height: 2),
//         Text(value, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
//       ],
//     );
//   }

//   Widget _medicineCard({
//     required Color color,
//     required String name,
//     required String dosage,
//     required String days,
//     required String time,
//     required String freq,
//    // required String takenStatus,
//     //required bool isTaken,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
//                 child: Icon(Icons.medication, color: color, size: 24),
//               ),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(name, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
//                     const SizedBox(height: 6),
//                     Row(
//                       children: [
//                         _chip(dosage, color),
//                         const SizedBox(width: 6),
//                         _chip(days, Colors.grey),
//                       ],
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFE8F5E9),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: const Text("Day 5 of 30", style: TextStyle(color: Colors.green, fontSize: 11, fontWeight: FontWeight.w600)),
//               ),
//             ],
//           ),
//           const SizedBox(height: 12),
//           Row(
//             children: [
//               Icon(time == "Morning" ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined, size: 16, color: Colors.orange),
//               const SizedBox(width: 6),
//               Text(time, style: const TextStyle(fontSize: 13)),
//               const SizedBox(width: 16),
//               const Icon(Icons.refresh, size: 16, color: Colors.blue),
//               const SizedBox(width: 6),
//               Text(freq, style: const TextStyle(fontSize: 13)),
//               const Spacer(),
//              // isTaken
//                   ? Row(
//                       children: [
//                         Icon(Icons.check_box, color: Colors.green.shade600, size: 20),
//                         const SizedBox(width: 4),
//                        // Text(takenStatus, style: TextStyle(color: Colors.green.shade700, fontSize: 13, fontWeight: FontWeight.w600)),
//                       ],
//                     ),
//                    Row(
//                       children: [
//                         Icon(Icons.check_box_outline_blank, color: Colors.grey.shade400, size: 20),
//                         const SizedBox(width: 4),
//                      //   Text(takenStatus, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
//                       ],
//                     ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _chip(String text, Color color) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(6)),
//       child: Text(text, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600)),
//     );
//   }

//   Widget _smallInfoCard({required IconData icon, required Color iconColor, required String title, required String content}) {
//     return Container(
//       padding: const EdgeInsets.all(14),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(14),
//         border: Border.all(color: Colors.grey.shade200),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Icon(icon, color: iconColor, size: 20),
//               const SizedBox(width: 6),
//               Text(title, style: TextStyle(color: iconColor, fontWeight: FontWeight.w600, fontSize: 14)),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Text(content, style: const TextStyle(fontSize: 12, height: 1.4)),
//         ],
//       ),
//     );
//   }
// }

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hosta/data/models/prescription_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:qr_flutter/qr_flutter.dart';

class PrescriptionDetailsScreen extends StatefulWidget {
  const PrescriptionDetailsScreen({super.key});

  @override
  State<PrescriptionDetailsScreen> createState() => _PrescriptionDetailsScreenState();
}

class _PrescriptionDetailsScreenState extends State<PrescriptionDetailsScreen> {
  DateTime? selectedDate;

  List<Medicine> medicines = [
    Medicine(
      name: "Metoprolol",
      dosage: "25mg",
      days: "30 days",
      time: "Morning",
      freq: "1x/day",
      isTaken: true,
      date: DateTime(2026, 4, 21),
    ),
    Medicine(
      name: "Lisinopril",
      dosage: "10mg",
      days: "30 days",
      time: "Evening",
      freq: "1x/day",
      isTaken: false,
      date: DateTime(2026, 5, 1),
    ),
  ];

  Future<void> _downloadPrescription() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Medical Prescription", style: pw.TextStyle(fontSize: 20)),
            pw.SizedBox(height: 10),
            pw.Text("Doctor: Dr. Sandy Maria"),
            pw.Text("Patient: James Carter"),
            pw.Text("Date: Apr 21, 2026"),
            pw.SizedBox(height: 20),
            pw.Text("Medicines:", style: pw.TextStyle(fontSize: 16)),
            ...medicines.map((med) => pw.Text(
                  "${med.name} - ${med.dosage} (${med.time})",
                )),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File("${dir.path}/prescription.pdf");
    await file.writeAsBytes(await pdf.save());
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Prescription Preview"),
            backgroundColor: Colors.green,
          ),
          body: PdfPreview(
            build: (format) => pdf.save(),
          ),
        ),
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Prescription downloaded successfully")),
    );
  }

  List<Medicine> get filteredMedicines {
    if (selectedDate == null) return medicines;
    return medicines.where((med) {
      return med.date.year == selectedDate!.year &&
          med.date.month == selectedDate!.month &&
          med.date.day == selectedDate!.day;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;
    final screenHeight = screenSize.height;
    final isSmallScreen = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;
    
    // Responsive padding
    final horizontalPadding = isDesktop ? 32.0 : (isTablet ? 24.0 : 16.0);
    final verticalPadding = isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0);
    
    // Responsive font sizes
    final titleFontSize = isDesktop ? 22.0 : (isTablet ? 20.0 : 18.0);
    final subtitleFontSize = isDesktop ? 16.0 : (isTablet ? 15.0 : 14.0);
    final bodyFontSize = isDesktop ? 14.0 : (isTablet ? 13.0 : 12.0);
    final smallFontSize = isDesktop ? 12.0 : (isTablet ? 11.0 : 10.0);
    
    // Responsive spacing
    final spacing = isDesktop ? 24.0 : (isTablet ? 20.0 : 16.0);

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FC),
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Prescription Details',
          style: TextStyle(
            fontSize: titleFontSize,
            fontWeight: FontWeight.w600
          ),
        ),
        actions: [
          _appBarAction(Icons.print, 'Print', isSmallScreen),
          _appBarAction(Icons.download, 'Download', isSmallScreen),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding,
          vertical: verticalPadding,
        ),
        child: Column(
          children: [
            // Filter Section
            _buildCard(
              child: Row(
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: TextButton.icon(
                      onPressed: () async {
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) {
                          setState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                      icon: Icon(Icons.calendar_today, size: isSmallScreen ? 18 : 20),
                      label: Text(
                        "Filter by date",
                        style: TextStyle(
                          fontSize: isSmallScreen ? 13 : 15,
                          fontWeight: FontWeight.w600
                        ),
                      ),
                    ),
                  ),
                  if (selectedDate != null)
                    IconButton(
                      onPressed: () {
                        setState(() {
                          selectedDate = null;
                        });
                      },
                      icon: Icon(Icons.close, color: Colors.red),
                    )
                ],
              ),
            ),
            SizedBox(height: spacing),
            
            // Medical Center Card
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F1FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.local_hospital,
                          color: Colors.green,
                          size: isSmallScreen ? 24 : 28,
                        ),
                      ),
                      SizedBox(width: isSmallScreen ? 8 : 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dream's Medical Center",
                              style: TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w700,
                                fontSize: subtitleFontSize,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              "123 Healthcare Avenue, Medical District, City",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: bodyFontSize,
                              ),
                            ),
                            Text(
                              "Phone: +1 (555) 123-4567 | Email: info@dreamsmedical.com",
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: bodyFontSize,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Divider(height: spacing * 1.5),
                  Center(
                    child: Text(
                      "Medical Prescription",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: subtitleFontSize,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing),
                  ResponsiveRow(
                    isSmallScreen: isSmallScreen,
                    children: [
                      Expanded(
                        child: _iconInfoTile(
                          Icons.person_outline,
                          "Prescribing Doctor",
                          "Dr. Sandy Maria",
                          "General Medicine\nRegistration No.\nMED-2024-001",
                          bodyFontSize,
                          smallFontSize,
                        ),
                      ),
                      if (!isSmallScreen) ...[
                        Container(width: 1, height: 90, color: Colors.grey.shade200),
                        SizedBox(width: spacing),
                      ],
                      Expanded(
                        child: _iconInfoTile(
                          Icons.calendar_today_outlined,
                          "Prescription Date",
                          "Apr 21, 2026",
                          "Prescription ID\n1\nFollow-up Date\nMay 21, 2026",
                          bodyFontSize,
                          smallFontSize,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),

            // Patient Information
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Patient Information",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  ResponsiveGrid(
                    isSmallScreen: isSmallScreen,
                    spacing: spacing,
                    children: [
                      _patientInfoItem(
                        Icons.person,
                        "Patient Name",
                        "James Carter",
                        bodyFontSize,
                        smallFontSize,
                      ),
                      _patientInfoItem(
                        Icons.badge_outlined,
                        "Patient ID",
                        "PT0025",
                        bodyFontSize,
                        smallFontSize,
                      ),
                      _patientInfoItem(
                        Icons.male,
                        "Age / Gender",
                        "34Y / Male",
                        bodyFontSize,
                        smallFontSize,
                      ),
                      _patientInfoItem(
                        Icons.phone,
                        "Contact",
                        "+1 (555) 123-4567",
                        bodyFontSize,
                        smallFontSize,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),

            // Medicines Prescribed
            _buildCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.medication_outlined, color: Colors.green, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Medicines Prescribed",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.w600,
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing),
                  Column(
                    children: filteredMedicines.map((med) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: spacing * 0.75),
                        child: _medicineCard(
                          color: Colors.green,
                          name: med.name,
                          dosage: med.dosage,
                          days: med.days,
                          time: med.time,
                          freq: med.freq,
                          bodyFontSize: bodyFontSize,
                          smallFontSize: smallFontSize,
                          isSmallScreen: isSmallScreen,
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),

            // Doctor's Notes
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(spacing),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description_outlined, color: Colors.green.shade700, size: 20),
                      SizedBox(width: 8),
                      Text(
                        "Doctor's Notes & Instructions",
                        style: TextStyle(
                          color: Colors.green.shade800,
                          fontWeight: FontWeight.w600,
                          fontSize: subtitleFontSize,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing * 0.5),
                  Text(
                    "Take medications as prescribed. Complete the full course even if symptoms improve. "
                    "Avoid alcohol during treatment. Report any adverse reactions immediately.",
                    style: TextStyle(
                      fontSize: bodyFontSize,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing),

            // Dietary & Appointment
            ResponsiveRow(
              isSmallScreen: isSmallScreen,
              children: [
                Expanded(
                  child: _smallInfoCard(
                    icon: Icons.restaurant_menu,
                    iconColor: Colors.black,
                    title: "Dietary Advice",
                    content: "Stay hydrated. Avoid spicy and oily food. Include fruits and vegetables in diet.",
                    bodyFontSize: bodyFontSize,
                    smallFontSize: smallFontSize,
                  ),
                ),
                if (!isSmallScreen) SizedBox(width: spacing * 0.75),
                Expanded(
                  child: _smallInfoCard(
                    icon: Icons.calendar_month_outlined,
                    iconColor: Colors.black,
                    title: "Next Appointment",
                    content: "Please schedule a follow-up appointment after completing the medication course.",
                    bodyFontSize: bodyFontSize,
                    smallFontSize: smallFontSize,
                  ),
                ),
              ],
            ),
            SizedBox(height: spacing * 1.5),

            // QR & Signature
            ResponsiveRow(
              isSmallScreen: isSmallScreen,
              children: [
                Column(
                  children: [
                    QrImageView(
                      data: 'PrescriptionID:1',
                      version: QrVersions.auto,
                      size: isSmallScreen ? 60 : 80,
                    ),
                    SizedBox(height: 6),
                    Text(
                      "Scan to verify prescription",
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
                Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "Sandy Maria",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 16 : 20,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Cursive',
                      ),
                    ),
                    Container(
                      width: isSmallScreen ? 100 : 120,
                      height: 1,
                      color: Colors.grey.shade400,
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Dr. Sandy Maria",
                      style: TextStyle(
                        fontSize: isSmallScreen ? 10 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "MD General Medicine",
                      style: TextStyle(
                        fontSize: smallFontSize,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    SizedBox(height: spacing * 0.5),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallScreen ? 8 : 12,
                        vertical: isSmallScreen ? 4 : 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F1FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "This is a computer generated prescription.\nNo signature is required.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: smallFontSize,
                          color: Colors.green.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: spacing * 1.5),

            // Download Button
            SizedBox(
              width: double.infinity,
              height: isSmallScreen ? 45 : 50,
              child: ElevatedButton.icon(
                onPressed: _downloadPrescription,
                icon: Icon(Icons.download, size: isSmallScreen ? 18 : 20),
                label: Text(
                  "Download Prescription (PDF)",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: bodyFontSize,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            SizedBox(height: spacing),
          ],
        ),
      ),
    );
  }

  Widget _appBarAction(IconData icon, String label, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: isSmallScreen ? 18 : 20),
          Text(
            label,
            style: TextStyle(fontSize: isSmallScreen ? 9 : 11),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _iconInfoTile(
    IconData icon,
    String title,
    String main,
    String sub,
    double bodyFontSize,
    double smallFontSize,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: Colors.green),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(fontSize: bodyFontSize, color: Colors.grey.shade600),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          main,
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: bodyFontSize + 1),
        ),
        const SizedBox(height: 4),
        Text(
          sub,
          style: TextStyle(fontSize: smallFontSize, color: Colors.grey.shade700, height: 1.4),
        ),
      ],
    );
  }

  Widget _patientInfoItem(
    IconData icon,
    String label,
    String value,
    double bodyFontSize,
    double smallFontSize,
  ) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F1FF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Colors.green, size: 18),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TextStyle(fontSize: smallFontSize, color: Colors.grey.shade600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: bodyFontSize),
        ),
      ],
    );
  }

  Widget _medicineCard({
    required Color color,
    required String name,
    required String dosage,
    required String days,
    required String time,
    required String freq,
    required double bodyFontSize,
    required double smallFontSize,
    required bool isSmallScreen,
  }) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.medication,
                  color: color,
                  size: isSmallScreen ? 20 : 24,
                ),
              ),
              SizedBox(width: isSmallScreen ? 8 : 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: bodyFontSize + 2,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Wrap(
                      spacing: 6,
                      children: [
                        _chip(dosage, color, smallFontSize),
                        _chip(days, Colors.grey, smallFontSize),
                      ],
                    ),
                  ],
                ),
              ),
              if (!isSmallScreen)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Day 5 of 30",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: smallFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Row(
            children: [
              Icon(
                time == "Morning" ? Icons.wb_sunny_outlined : Icons.nights_stay_outlined,
                size: isSmallScreen ? 14 : 16,
                color: Colors.orange,
              ),
              SizedBox(width: 6),
              Text(time, style: TextStyle(fontSize: bodyFontSize)),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Icon(
                Icons.refresh,
                size: isSmallScreen ? 14 : 16,
                color: Colors.blue,
              ),
              SizedBox(width: 6),
              Text(freq, style: TextStyle(fontSize: bodyFontSize)),
              if (isSmallScreen) Spacer(),
              if (isSmallScreen)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    "Day 5 of 30",
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: smallFontSize - 1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(String text, Color color, double fontSize) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _smallInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
    required double bodyFontSize,
    required double smallFontSize,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: iconColor, size: 20),
              const SizedBox(width: 6),
              Text(
                title,
                style: TextStyle(
                  color: iconColor,
                  fontWeight: FontWeight.w600,
                  fontSize: bodyFontSize,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(fontSize: smallFontSize, height: 1.4),
          ),
        ],
      ),
    );
  }
}

// Helper widget for responsive row
class ResponsiveRow extends StatelessWidget {
  final bool isSmallScreen;
  final List<Widget> children;
  
  const ResponsiveRow({
    super.key,
    required this.isSmallScreen,
    required this.children,
  });
  
  @override
  Widget build(BuildContext context) {
    if (isSmallScreen) {
      return Column(
        children: children.map((child) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: child,
        )).toList(),
      );
    }
    return Row(children: children);
  }
}

// Helper widget for responsive grid
class ResponsiveGrid extends StatelessWidget {
  final bool isSmallScreen;
  final double spacing;
  final List<Widget> children;
  
  const ResponsiveGrid({
    super.key,
    required this.isSmallScreen,
    required this.spacing,
    required this.children,
  });
  
  @override
  Widget build(BuildContext context) {
    if (isSmallScreen) {
      return Wrap(
        spacing: spacing,
        runSpacing: spacing,
        alignment: WrapAlignment.spaceAround,
        children: children,
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: children,
    );
  }
}