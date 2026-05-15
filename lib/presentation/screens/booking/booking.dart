// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hosta/providers/booking_provider.dart';
// import 'package:intl/intl.dart';
// import '../../../common/top_snackbar.dart';

// class BookingScreen extends ConsumerStatefulWidget {
//   const BookingScreen({super.key});

//   @override
//   ConsumerState<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends ConsumerState<BookingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Initialize data when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(bookingStateProvider.notifier).initializeData();
//     });
//   }

//   @override
//   void dispose() {
//     // Cleanup is handled by the provider
//     super.dispose();
//   }

//   Future<void> _selectDate() async {
//     final now = DateTime.now();
//      final selectedDate = ref.read(bookingStateProvider).selectedDate;
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: ref.read(bookingStateProvider).selectedDate ?? now,
//       firstDate: DateTime(now.year - 1),
//       lastDate: DateTime(now.year + 1),
//     );
//     if (picked != null && mounted) {
//       ref.read(bookingStateProvider.notifier).updateSelectedDate(picked);
//     }
//   }

//   Future<void> _cancelBooking(Map<String, dynamic> booking) async {
//     try {
//       await ref.read(bookingStateProvider.notifier).cancelBooking(booking);
//       if (mounted) {
//         showTopSnackBar(context, "Booking cancelled successfully");
//       }
//     } catch (e) {
//       if (mounted) {
//         showTopSnackBar(context, "Failed to cancel booking", isError: true);
//       }
//     }
//   }

//   String _formatTime(dynamic time) {
//     try {
//       if (time == null || time == "N/A") return "N/A";

//       String timeStr = time.toString().trim();

//       if (timeStr.contains(':') && timeStr.length <= 5) {
//         return timeStr;
//       }

//       if (timeStr.contains('T')) {
//         DateTime dateTime = DateTime.parse(timeStr);
//         return DateFormat('HH:mm').format(dateTime);
//       }

//       return timeStr;
//     } catch (e) {
//       return time?.toString() ?? "N/A";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bookingState = ref.watch(bookingStateProvider);
//     final filteredBookings = ref.watch(filteredBookingsProvider);
//     final userId = bookingState.userId;
//     final isLoading = bookingState.isLoading;
//     final isSocketConnected = bookingState.isSocketConnected;
//     final selectedFilter = bookingState.selectedFilter;
//     final selectedDate = bookingState.selectedDate;
//     final searchController = bookingState.searchController;

//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isSmallScreen = screenWidth < 600;

//     // Show message if no user ID
//     if (userId == null || userId.isEmpty) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFECFDF5),
//         appBar: AppBar(
//           backgroundColor: Colors.green,
//           title: Text(
//             "My Bookings",
//             style: TextStyle(
//               fontWeight: FontWeight.bold, 
//               color: Colors.white,
//               fontSize: screenWidth * 0.05,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.person_off, size: screenWidth * 0.15, color: Colors.grey),
//               SizedBox(height: screenHeight * 0.02),
//               Text(
//                 "Please login to view your bookings",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: screenWidth * 0.04,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFECFDF5),
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(
//           "My Bookings",
//           style: TextStyle(
//             fontWeight: FontWeight.bold, 
//             color: Colors.white,
//             fontSize: screenWidth * 0.05,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           // Socket connection indicator
//          if (!isSocketConnected)
//             // Padding(
//             //   padding: EdgeInsets.only(right: screenWidth * 0.02),
//             //   child: Icon(Icons.wifi_off, color: Colors.white, size: screenWidth * 0.05),
//             // ),
//           IconButton(
//             icon: Icon(Icons.refresh, color: Colors.white, size: screenWidth * 0.06),
//             onPressed: () {
//               ref.read(bookingStateProvider.notifier).refreshBookings();
//             },
//             tooltip: "Refresh bookings",
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : Padding(
//               padding: EdgeInsets.all(screenWidth * 0.04),
//               child: Column(
//                 children: [
//                   // Search Bar
//                   TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       hintText: "Search by hospital or doctor",
//                       prefixIcon: Icon(Icons.search, size: screenWidth * 0.06),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.03),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.04,
//                         vertical: screenHeight * 0.015,
//                       ),
//                     ),
//                     onChanged: (value) {
//                       ref.read(bookingStateProvider.notifier).updateSearchQuery(value);
//                     },
//                   ),
//                   SizedBox(height: screenHeight * 0.015),

//                   // Date Filter
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         selectedDate == null
//                             ? "Filter by date"
//                             : "Date: ${DateFormat('dd MMM yyyy').format(selectedDate!)}",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: screenWidth * 0.035,
//                         ),
//                       ),
//                       TextButton.icon(
//                         onPressed: _selectDate,
//                         icon: Icon(Icons.calendar_today, size: screenWidth * 0.045),
//                         label: Text(
//                           "Select Date",
//                           style: TextStyle(fontSize: screenWidth * 0.035),
//                         ),
//                       ),
//                       if (selectedDate != null)
//                         IconButton(
//                           icon: Icon(Icons.clear, size: screenWidth * 0.045),
//                           onPressed: () {
//                             ref.read(bookingStateProvider.notifier).clearSelectedDate();
//                           },
//                         ),
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.01),
//                   // Status Filter Chips
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: ["All", "Pending", "Accepted", "Declined", "Cancelled"]
//                           .map(
//                             (f) => Padding(
//                               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
//                               child: ChoiceChip(
//                                 label: Text(
//                                   f,
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                   ),
//                                 ),
//                                 selected: selectedFilter == f,
//                                 onSelected: (_) {
//                                   ref.read(bookingStateProvider.notifier).updateSelectedFilter(f);
//                                 },
//                                 selectedColor: Colors.green,
//                                 labelStyle: TextStyle(
//                                   color: selectedFilter == f ? Colors.white : Colors.black,
//                                   fontSize: screenWidth * 0.035,
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.02),

//                   // Booking List
//                   Expanded(
//                     child: filteredBookings.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.event_busy, size: screenWidth * 0.12, color: Colors.grey),
//                                 SizedBox(height: screenHeight * 0.02),
//                                 Text(
//                                   "No bookings found",
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.04,
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.01),
//                                 Text(
//                                   "Try adjusting your search or filter criteria",
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                     color: Colors.grey[400],
//                                   ),
                                  
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             itemCount: filteredBookings.length,
//                             itemBuilder: (context, index) {
//                               final b = filteredBookings[index];
//                               return Card(
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(screenWidth * 0.03)),
//                                 margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//                                 elevation: isSmallScreen ? 2 : 3,
//                                 child: Padding(
//                                   padding: EdgeInsets.all(screenWidth * 0.03),
//                                   child: Column(
//                                     crossAxisAlignment: CrossAxisAlignment.start,
//                                     children: [
//                                       Row(
//                                         children: [
//                                           Icon(Icons.local_hospital,
//                                               color: Colors.green, size: screenWidth * 0.06),
//                                           SizedBox(width: screenWidth * 0.02),
//                                           Expanded(
//                                             child: Text(
//                                               b["hospital"],
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(
//                                                   fontWeight: FontWeight.bold,
//                                                   fontSize: screenWidth * 0.04),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: screenHeight * 0.0075),
//                                       Row(
//                                         children: [
//                                           Icon(Icons.person,
//                                               color: Colors.blueAccent, size: screenWidth * 0.05),
//                                           SizedBox(width: screenWidth * 0.02),
//                                           Expanded(
//                                             child: Text(
//                                               "Doctor: ${b["doctor"]}",
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(fontSize: screenWidth * 0.035),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: screenHeight * 0.005),
//                                       Row(
//                                         children: [
//                                           Icon(Icons.medical_services,
//                                               color: Colors.orange, size: screenWidth * 0.05),
//                                           SizedBox(width: screenWidth * 0.02),
//                                           Expanded(
//                                             child: Text(
//                                               "Type: ${b["type"]}",
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(fontSize: screenWidth * 0.035),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: screenHeight * 0.005),
//                                       Row(
//                                         children: [
//                                           Icon(Icons.health_and_safety,
//                                               color: Colors.purple, size: screenWidth * 0.05),
//                                           SizedBox(width: screenWidth * 0.02),
//                                           Expanded(
//                                             child: Text(
//                                               "Specialty: ${b["specialty"]}",
//                                               overflow: TextOverflow.ellipsis,
//                                               style: TextStyle(fontSize: screenWidth * 0.035),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: screenHeight * 0.005),
//                                       Row(
//                                         children: [
//                                           Icon(Icons.calendar_today, color: Colors.green, size: screenWidth * 0.05),
//                                           SizedBox(width: screenWidth * 0.02),
//                                           Text(
//                                             "Date: ${b["date"]}",
//                                             style: TextStyle(fontSize: screenWidth * 0.035),
//                                           ),
//                                         ],
//                                       ),
//                                       SizedBox(height: screenHeight * 0.005),
//                                       Row(
//                                         children: [
//                                           Icon(Icons.access_time, color: Colors.green, size: screenWidth * 0.05),
//                                           SizedBox(width: screenWidth * 0.02),
//                                           Text(
//                                             "Time: ${_formatTime(b["time"])}",
//                                             style: TextStyle(fontSize: screenWidth * 0.035),
//                                           ),
//                                         ],
//                                       ),
//                                       if (b["patient_name"]?.isNotEmpty == true) ...[
//                                         SizedBox(height: screenHeight * 0.005),
//                                         Row(
//                                           children: [
//                                             Icon(Icons.person_outline, color: Colors.green, size: screenWidth * 0.05),
//                                             SizedBox(width: screenWidth * 0.02),
//                                             Expanded(
//                                               child: Text(
//                                                 "Patient: ${b["patient_name"]}",
//                                                 overflow: TextOverflow.ellipsis,
//                                                 style: TextStyle(fontSize: screenWidth * 0.035),
//                                               ),
//                                             ),
//                                           ],
//                                         ),
//                                       ],
//                                       Divider(height: screenHeight * 0.025),
//                                       Row(
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           // Status badge
//                                           Container(
//                                             padding: EdgeInsets.symmetric(
//                                               horizontal: screenWidth * 0.03, 
                                               
//                                               vertical: screenHeight * 0.005,
//                                             ),
//                                             decoration: BoxDecoration(
//                                               color: b["status"] == "accepted"
//                                                   ? Colors.green
//                                                   : b["status"] == "declined"
//                                                   ? Colors.orange
//                                                   : b["status"] == "cancelled" || b["status"] == "cancel"
//                                                   ? Colors.red
//                                                   : b["status"] == "pending"
//                                                   ? Colors.blue
//                                                   : Colors.grey,
//                                               borderRadius: BorderRadius.circular(screenWidth * 0.03),
//                                             ),
//                                             child: Text(
//                                               b["status"].toString().toUpperCase(),
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                                 fontSize: screenWidth * 0.03,
//                                                 fontWeight: FontWeight.bold,
//                                               ),
//                                             ),
//                                           ),
//                                           // Cancel button only for pending bookings
//                                           if (b["status"] == "pending")
//                                             ElevatedButton(
//                                               onPressed: () => _cancelBooking(b),
//                                               style: ElevatedButton.styleFrom(
//                                                 backgroundColor: Colors.red,
//                                                 foregroundColor: Colors.white,
//                                                 padding: EdgeInsets.symmetric(
//                                                   horizontal: screenWidth * 0.04,
//                                                   vertical: screenHeight * 0.01,
//                                                 ),
//                                                 shape: RoundedRectangleBorder(
//                                                   borderRadius: BorderRadius.circular(screenWidth * 0.02),
//                                                 ),
//                                               ),
//                                               child: Text(
//                                                 "Cancel",
//                                                 style: TextStyle(fontSize: screenWidth * 0.035),
//                                               ),
//                                             ),
//                                         ],
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hosta/providers/booking_provider.dart';
// import 'package:intl/intl.dart';
// import '../../../common/top_snackbar.dart';

// class BookingScreen extends ConsumerStatefulWidget {
//   const BookingScreen({super.key});

//   @override
//   ConsumerState<BookingScreen> createState() => _BookingScreenState();
// }

// class _BookingScreenState extends ConsumerState<BookingScreen> {
//   @override
//   void initState() {
//     super.initState();
//     // Initialize data when screen loads
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       ref.read(bookingStateProvider.notifier).initializeData();
//     });
//   }

//   @override
//   void dispose() {
//     // Cleanup is handled by the provider
//     super.dispose();
//   }

//   Future<void> _selectDate() async {
//     final now = DateTime.now();
//     final selectedDate = ref.read(bookingStateProvider).selectedDate;
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: selectedDate ?? now,
//       firstDate: DateTime(now.year - 1),
//       lastDate: DateTime(now.year + 1),
//     );
//     if (picked != null && mounted) {
//       ref.read(bookingStateProvider.notifier).updateSelectedDate(picked);
//     }
//   }

//   Future<void> _cancelBooking(Map<String, dynamic> booking) async {
//      showDialog(
//     context: context,
//     barrierDismissible: false,
//     builder: (context) => const Center(child: CircularProgressIndicator()),
//   );
//     try {
//       await ref.read(bookingStateProvider.notifier).cancelBooking(booking);
//       if (mounted) {
//          Navigator.pop(context);
//         showTopSnackBar(context, "Booking cancelled successfully");
//       }
//     } catch (e) {
//       if (mounted) {
//          Navigator.pop(context);
//         showTopSnackBar(context, "Failed to cancel booking", isError: true);
//       }
//     }
//   }

//   String _formatTime(dynamic time) {
//     try {
//       if (time == null || time == "N/A") return "N/A";
      
//       // If time contains 'T' (ISO format), extract time part
//       if (time.toString().contains('T')) {
//         final dateTime = DateTime.parse(time.toString());
//         return DateFormat('hh:mm a').format(dateTime);
//       }
      
//       // If time is already formatted
//       if (time.toString().contains(':')) {
//         return time.toString();
//       }
      
//       return time.toString();
//     } catch (e) {
//       return time?.toString() ?? "N/A";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final bookingState = ref.watch(bookingStateProvider);
//     final filteredBookings = ref.watch(filteredBookingsProvider);
    
//     final userId = bookingState.userId;
//     final isLoading = bookingState.isLoading;
//     final isSocketConnected = bookingState.isSocketConnected;
//     final selectedFilter = bookingState.selectedFilter;
//     final selectedDate = bookingState.selectedDate;
//     final searchController = bookingState.searchController;

//     final screenWidth = MediaQuery.of(context).size.width;
//     final screenHeight = MediaQuery.of(context).size.height;
//     final isSmallScreen = screenWidth < 600;

//     // Show message if no user ID
//     if (userId == null || userId.isEmpty) {
//       return Scaffold(
//         backgroundColor: const Color(0xFFECFDF5),
//         appBar: AppBar(
//           backgroundColor: Colors.green,
//           title: Text(
//             "My Bookings",
//             style: TextStyle(
//               fontWeight: FontWeight.bold, 
//               color: Colors.white,
//               fontSize: screenWidth * 0.05,
//             ),
//           ),
//           centerTitle: true,
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(Icons.person_off, size: screenWidth * 0.15, color: Colors.grey),
//               SizedBox(height: screenHeight * 0.02),
//               Text(
//                 "Please login to view your bookings",
//                 style: TextStyle(
//                   color: Colors.grey,
//                   fontSize: screenWidth * 0.04,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//             ],
//           ),
//         ),
//       );
//     }

//     return Scaffold(
//       backgroundColor: const Color(0xFFECFDF5),
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         title: Text(
//           "My Bookings",
//           style: TextStyle(
//             fontWeight: FontWeight.bold, 
//             color: Colors.white,
//             fontSize: screenWidth * 0.05,
//           ),
//         ),
//         centerTitle: true,
//         actions: [
//           // Socket connection indicator
//           if (!isSocketConnected)
//             Padding(
//               padding: EdgeInsets.only(right: screenWidth * 0.02),
//               child: Icon(Icons.wifi_off, color: Colors.white, size: screenWidth * 0.05),
//             ),
//           IconButton(
//             icon: Icon(Icons.refresh, color: Colors.white, size: screenWidth * 0.06),
//             onPressed: () {
//               ref.read(bookingStateProvider.notifier).refreshBookings();
//             },
//             tooltip: "Refresh bookings",
//           ),
//         ],
//       ),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator(color: Colors.green))
//           : Padding(
//               padding: EdgeInsets.all(screenWidth * 0.04),
//               child: Column(
//                 children: [
//                   // Search Bar
//                   TextField(
//                     controller: searchController,
//                     decoration: InputDecoration(
//                       hintText: "Search by hospital or doctor",
//                       prefixIcon: Icon(Icons.search, size: screenWidth * 0.06),
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.03),
//                       ),
//                       filled: true,
//                       fillColor: Colors.white,
//                       contentPadding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.04,
//                         vertical: screenHeight * 0.015,
//                       ),
//                     ),
//                     onChanged: (value) {
//                       ref.read(bookingStateProvider.notifier).updateSearchQuery(value);
//                     },
//                   ),
//                   SizedBox(height: screenHeight * 0.015),

//                   // Date Filter Row
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         selectedDate == null
//                             ? "Filter by date"
//                             : "Date: ${DateFormat('dd MMM yyyy').format(selectedDate!)}",
//                         style: TextStyle(
//                           fontWeight: FontWeight.w500,
//                           fontSize: screenWidth * 0.035,
//                         ),
//                       ),
//                       TextButton.icon(
//                         onPressed: _selectDate,
//                         icon: Icon(Icons.calendar_today, size: screenWidth * 0.045),
//                         label: Text(
//                           "Select Date",
//                           style: TextStyle(fontSize: screenWidth * 0.035),
//                         ),
//                       ),
//                       if (selectedDate != null)
//                         IconButton(
//                           icon: Icon(Icons.clear, size: screenWidth * 0.045),
//                           onPressed: () {
//                             ref.read(bookingStateProvider.notifier).clearSelectedDate();
//                           },
//                         ),
//                     ],
//                   ),
//                   SizedBox(height: screenHeight * 0.01),

//                   // Status Filter Chips
//                   SingleChildScrollView(
//                     scrollDirection: Axis.horizontal,
//                     child: Row(
//                       children: ["All", "Pending", "Accepted", "Declined", "Cancelled"]
//                           .map(
//                             (f) => Padding(
//                               padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
//                               child: ChoiceChip(
//                                 label: Text(
//                                   f,
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                   ),
//                                 ),
//                                 selected: selectedFilter == f,
//                                 onSelected: (_) {
//                                   ref.read(bookingStateProvider.notifier).updateSelectedFilter(f);
//                                 },
//                                 selectedColor: Colors.green,
//                                 labelStyle: TextStyle(
//                                   color: selectedFilter == f ? Colors.white : Colors.black,
//                                   fontSize: screenWidth * 0.035,
//                                 ),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                     ),
//                   ),
//                   SizedBox(height: screenHeight * 0.02),

//                   // Booking List
//                   Expanded(
//                     child: filteredBookings.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.event_busy, size: screenWidth * 0.12, color: Colors.grey),
//                                 SizedBox(height: screenHeight * 0.02),
//                                 Text(
//                                   "No bookings found",
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.04,
//                                     color: Colors.grey,
//                                     fontWeight: FontWeight.w600,
//                                   ),
//                                 ),
//                                 SizedBox(height: screenHeight * 0.01),
//                                 Text(
//                                   "Try changing your filters",
//                                   style: TextStyle(
//                                     fontSize: screenWidth * 0.035,
//                                     color: Colors.grey[400],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : ListView.builder(
//                             itemCount: filteredBookings.length,
//                             itemBuilder: (context, index) {
//                               final b = filteredBookings[index];
//                               return _buildBookingCard(b, screenWidth, screenHeight);
//                             },
//                           ),
//                   ),
//                 ],
//               ),
//             ),
//     );
//   }

//   Widget _buildBookingCard(Map<String, dynamic> booking, double screenWidth, double screenHeight) {
//     final status = booking["status"].toString().toLowerCase();
    
//     Color getStatusColor() {
//       switch (status) {
//         case "accepted": return Colors.green;
//         case "declined": return Colors.orange;
//         case "cancelled": 
//         case "cancel": return Colors.red;
//         case "pending": return Colors.blue;
//         default: return Colors.grey;
//       }
//     }

//     String getStatusText() {
//       switch (status) {
//         case "accepted": return "ACCEPTED";
//         case "declined": return "DECLINED";
//         case "cancelled": 
//         case "cancel": return "CANCELLED";
//         case "pending": return "PENDING";
//         default: return status.toUpperCase();
//       }
//     }

//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(screenWidth * 0.03)
//       ),
//       margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
//       elevation: 3,
//       child: Padding(
//         padding: EdgeInsets.all(screenWidth * 0.04),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Hospital Name
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(screenWidth * 0.02),
//                   decoration: BoxDecoration(
//                     color: Colors.green.withOpacity(0.1),
//                     borderRadius: BorderRadius.circular(screenWidth * 0.02),
//                   ),
//                   child: Icon(Icons.local_hospital, color: Colors.green, size: screenWidth * 0.06),
//                 ),
//                 SizedBox(width: screenWidth * 0.03),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         booking["hospital"] ?? "Unknown Hospital",
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           fontSize: screenWidth * 0.04,
//                         ),
//                         overflow: TextOverflow.ellipsis,
//                       ),
//                       if (booking["type"] != null && booking["type"] != "General")
//                         Text(
//                           booking["type"],
//                           style: TextStyle(
//                             fontSize: screenWidth * 0.03,
//                             color: Colors.grey[600],
//                           ),
//                         ),
//                     ],
//                   ),
//                 ),
//                 // Status Badge
//                 Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: screenWidth * 0.03,
//                     vertical: screenHeight * 0.005,
//                   ),
//                   decoration: BoxDecoration(
//                     color: getStatusColor(),
//                     borderRadius: BorderRadius.circular(screenWidth * 0.03),
//                   ),
//                   child: Text(
//                     getStatusText(),
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: screenWidth * 0.03,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
            
//             SizedBox(height: screenHeight * 0.015),
            
//             // Doctor Name
//             _buildInfoRow(
//               Icons.person,
//               "Doctor",
//               booking["doctor"] ?? "Not specified",
//               screenWidth,
//             ),
            
//             SizedBox(height: screenHeight * 0.008),
            
//             // Specialty
//             _buildInfoRow(
//               Icons.medical_services,
//               "Specialty",
//               booking["specialty"] ?? "General",
//               screenWidth,
//             ),
            
//             SizedBox(height: screenHeight * 0.008),
            
//             // Date
//             _buildInfoRow(
//               Icons.calendar_today,
//               "Date",
//               booking["date"] ?? "N/A",
//               screenWidth,
//             ),
            
//             SizedBox(height: screenHeight * 0.008),
            
//             // Time
//             _buildInfoRow(
//               Icons.access_time,
//               "Time",
//               _formatTime(booking["time"]),
//               screenWidth,
//             ),
            
//             // Patient Name (if available)
//             if (booking["patient_name"] != null && booking["patient_name"].toString().isNotEmpty) ...[
//               SizedBox(height: screenHeight * 0.008),
//               _buildInfoRow(
//                 Icons.person_outline,
//                 "Patient",
//                 booking["patient_name"],
//                 screenWidth,
//               ),
//             ],
            
//             SizedBox(height: screenHeight * 0.015),
            
//             const Divider(),
            
//             SizedBox(height: screenHeight * 0.01),
            
//             // Cancel Button (only for pending bookings)
//             if (status == "pending")
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   ElevatedButton.icon(
//                     onPressed: () => _cancelBooking(booking),
//                     icon: Icon(Icons.cancel, size: screenWidth * 0.045),
//                     label: Text(
//                       "Cancel Booking",
//                       style: TextStyle(fontSize: screenWidth * 0.035),
//                     ),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.red,
//                       foregroundColor: Colors.white,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: screenWidth * 0.04,
//                         vertical: screenHeight * 0.01,
//                       ),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(screenWidth * 0.02),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildInfoRow(IconData icon, String label, String value, double screenWidth) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.green, size: screenWidth * 0.045),
//         SizedBox(width: screenWidth * 0.03),
//         SizedBox(
//           width: screenWidth * 0.2,
//           child: Text(
//             label,
//             style: TextStyle(
//               color: Colors.grey[600],
//               fontSize: screenWidth * 0.035,
//             ),
//           ),
//         ),
//         Expanded(
//           child: Text(
//             value,
//             style: TextStyle(
//               fontSize: screenWidth * 0.035,
//               fontWeight: FontWeight.w500,
//             ),
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//       ],
//     );
//   }
// }







import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hosta/providers/booking_provider.dart';
import 'package:intl/intl.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../common/top_snackbar.dart';

class BookingScreen extends ConsumerStatefulWidget {
  const BookingScreen({super.key});

  @override
  ConsumerState<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends ConsumerState<BookingScreen> {
  
  // Controllers for new booking form
  final _patientNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _dobController = TextEditingController();
  final _placeController = TextEditingController();
  final _appointmentDateController = TextEditingController();
  
  String _selectedHospitalId = '5';
  String _selectedDoctorId = '1';
  String _selectedTime = '10:30 AM';
  bool _isBooking = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingStateProvider.notifier).initializeData();
    });
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _placeController.dispose();
    _appointmentDateController.dispose();
    super.dispose();
  }

  // New Booking Function
  Future<void> _confirmBooking() async {
    if (_patientNameController.text.isEmpty ||
        _phoneController.text.isEmpty ||
        _dobController.text.isEmpty ||
        _appointmentDateController.text.isEmpty) {
      showTopSnackBar(context, "Please fill all fields", isError: true);
      return;
    }
    
    setState(() => _isBooking = true);
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final userId = prefs.getInt('userId');
      
      if (token == null || userId == null) {
        showTopSnackBar(context, "Please login again", isError: true);
        setState(() => _isBooking = false);
        return;
      }
      
      final bookingData = {
  "userId": userId,  // ✅ ADD THIS LINE
  "patient_name": _patientNameController.text,
  "patient_phone": _phoneController.text,
  "patient_dob": _dobController.text,
  "patient_place": _placeController.text,
  "hospitalId": _selectedHospitalId,
  "doctorId": _selectedDoctorId,
  "booking_date": _appointmentDateController.text,
  "consulting_time": _selectedTime,
};
      
      print('📝 Booking Data: $bookingData');
      
      final dio = Dio(BaseOptions(baseUrl: 'https://zorrowtek.in'));
      
      final response = await dio.post(
        '/api/booking/$userId',
        data: bookingData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        showTopSnackBar(context, "Booking successful!");
        // Clear form
        _patientNameController.clear();
        _phoneController.clear();
        _dobController.clear();
        _placeController.clear();
        _appointmentDateController.clear();
        // Refresh bookings list
        ref.read(bookingStateProvider.notifier).refreshBookings();
      } else {
        showTopSnackBar(context, "Booking failed", isError: true);
      }
    } catch (e) {
      print('❌ Booking error: $e');
      showTopSnackBar(context, "Booking failed: ${e.toString()}", isError: true);
    } finally {
      setState(() => _isBooking = false);
    }
  }

  // Existing functions (selectDate, cancelBooking, formatTime etc.)
  Future<void> _selectDate() async {
    final now = DateTime.now();
    final selectedDate = ref.read(bookingStateProvider).selectedDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 1),
    );
    if (picked != null && mounted) {
      ref.read(bookingStateProvider.notifier).updateSelectedDate(picked);
    }
  }

  Future<void> _cancelBooking(Map<String, dynamic> booking) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await ref.read(bookingStateProvider.notifier).cancelBooking(booking);
      if (mounted) {
        Navigator.pop(context);
        showTopSnackBar(context, "Booking cancelled successfully");
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        showTopSnackBar(context, "Failed to cancel booking", isError: true);
      }
    }
  }

  String _formatTime(dynamic time) {
    try {
      if (time == null || time == "N/A") return "N/A";
      if (time.toString().contains('T')) {
        final dateTime = DateTime.parse(time.toString());
        return DateFormat('hh:mm a').format(dateTime);
      }
      if (time.toString().contains(':')) {
        return time.toString();
      }
      return time.toString();
    } catch (e) {
      return time?.toString() ?? "N/A";
    }
  }

  @override
  Widget build(BuildContext context) {
    final bookingState = ref.watch(bookingStateProvider);
    final filteredBookings = ref.watch(filteredBookingsProvider);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: const Color(0xFFECFDF5),
        appBar: AppBar(
          backgroundColor: Colors.green,
          title: Text(
            "Bookings",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: screenWidth * 0.05,
            ),
          ),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: "My Bookings"),
              Tab(text: "New Booking"),
            ],
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            indicatorColor: Colors.white,
          ),
          actions: [
            if (!bookingState.isSocketConnected)
              Padding(
                padding: EdgeInsets.only(right: screenWidth * 0.02),
                child: Icon(Icons.wifi_off, color: Colors.white, size: screenWidth * 0.05),
              ),
            IconButton(
              icon: Icon(Icons.refresh, color: Colors.white, size: screenWidth * 0.06),
              onPressed: () {
                ref.read(bookingStateProvider.notifier).refreshBookings();
              },
              tooltip: "Refresh bookings",
            ),
          ],
        ),
        body: TabBarView(
          children: [
            // Tab 1: My Bookings List (Your existing code)
            _buildMyBookingsTab(bookingState, filteredBookings, screenWidth, screenHeight),
            
            // Tab 2: New Booking Form
            _buildNewBookingTab(screenWidth, screenHeight),
          ],
        ),
      ),
    );
  }

  // My Bookings Tab Widget
  Widget _buildMyBookingsTab(BookingState bookingState, List<Map<String, dynamic>> filteredBookings, double screenWidth, double screenHeight) {
    final userId = bookingState.userId;
    final isLoading = bookingState.isLoading;
    final selectedFilter = bookingState.selectedFilter;
    final selectedDate = bookingState.selectedDate;
    final searchController = bookingState.searchController;

    if (userId == null || userId.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.person_off, size: screenWidth * 0.15, color: Colors.grey),
            SizedBox(height: screenHeight * 0.02),
            Text(
              "Please login to view your bookings",
              style: TextStyle(
                color: Colors.grey,
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.green));
    }

    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        children: [
          // Search Bar
          TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: "Search by hospital or doctor",
              prefixIcon: Icon(Icons.search, size: screenWidth * 0.06),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.03),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            onChanged: (value) {
              ref.read(bookingStateProvider.notifier).updateSearchQuery(value);
            },
          ),
          SizedBox(height: screenHeight * 0.015),
          
          // Date Filter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                selectedDate == null
                    ? "Filter by date"
                    : "Date: ${DateFormat('dd MMM yyyy').format(selectedDate!)}",
                style: TextStyle(fontSize: screenWidth * 0.035),
              ),
              TextButton.icon(
                onPressed: _selectDate,
                icon: Icon(Icons.calendar_today, size: screenWidth * 0.045),
                label: Text("Select Date", style: TextStyle(fontSize: screenWidth * 0.035)),
              ),
              if (selectedDate != null)
                IconButton(
                  icon: Icon(Icons.clear, size: screenWidth * 0.045),
                  onPressed: () {
                    ref.read(bookingStateProvider.notifier).clearSelectedDate();
                  },
                ),
            ],
          ),
          
          // Status Filter Chips
          SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: ["All", "Pending", "Accepted", "Declined", "Cancelled"].map((f) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.01),
                  child: ChoiceChip(
                    label: Text(f, style: TextStyle(fontSize: screenWidth * 0.035)),
                    selected: selectedFilter == f,
                    onSelected: (_) {
                      ref.read(bookingStateProvider.notifier).updateSelectedFilter(f);
                    },
                    selectedColor: Colors.green,
                    labelStyle: TextStyle(
                      color: selectedFilter == f ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          
          SizedBox(height: screenHeight * 0.02),
          
          // Booking List
          Expanded(
            child: filteredBookings.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.event_busy, size: screenWidth * 0.12, color: Colors.grey),
                        SizedBox(height: screenHeight * 0.02),
                        Text("No bookings found", style: TextStyle(fontSize: screenWidth * 0.04)),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: filteredBookings.length,
                    itemBuilder: (context, index) {
                      return _buildBookingCard(filteredBookings[index], screenWidth, screenHeight);
                    },
                  ),
          ),
        ],
      ),
    );
  }

  // New Booking Tab Widget
  Widget _buildNewBookingTab(double screenWidth, double screenHeight) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Book an Appointment",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          
          TextFormField(
            controller: _patientNameController,
            decoration: InputDecoration(
              labelText: "Patient Name",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
              prefixIcon: Icon(Icons.person),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: "Phone Number",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
          ),
          SizedBox(height: screenHeight * 0.015),
          
          TextFormField(
            controller: _dobController,
            decoration: InputDecoration(
              labelText: "Date of Birth (YYYY-MM-DD)",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
              prefixIcon: Icon(Icons.cake),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          
          TextFormField(
            controller: _placeController,
            decoration: InputDecoration(
              labelText: "Place",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
              prefixIcon: Icon(Icons.location_on),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          
          TextFormField(
            controller: _appointmentDateController,
            decoration: InputDecoration(
              labelText: "Appointment Date (YYYY-MM-DD)",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
              prefixIcon: Icon(Icons.calendar_today),
            ),
          ),
          SizedBox(height: screenHeight * 0.015),
          
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedHospitalId,
                  decoration: InputDecoration(
                    labelText: "Hospital",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
                  ),
                  items: [
                    DropdownMenuItem(value: '5', child: Text('Zorrow Hospital')),
                  ],
                  onChanged: (value) => setState(() => _selectedHospitalId = value!),
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: _selectedDoctorId,
                  decoration: InputDecoration(
                    labelText: "Doctor",
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
                  ),
                  items: [
                    DropdownMenuItem(value: '1', child: Text('Dr. Safvan')),
                  ],
                  onChanged: (value) => setState(() => _selectedDoctorId = value!),
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.015),
          
          DropdownButtonFormField<String>(
            value: _selectedTime,
            decoration: InputDecoration(
              labelText: "Consulting Time",
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(screenWidth * 0.02)),
              prefixIcon: Icon(Icons.access_time),
            ),
            items: ['10:30 AM', '11:00 AM', '11:30 AM', '12:00 PM', '12:30 PM', '01:00 PM']
                .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                .toList(),
            onChanged: (value) => setState(() => _selectedTime = value!),
          ),
          SizedBox(height: screenHeight * 0.025),
          
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isBooking ? null : _confirmBooking,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: screenHeight * 0.018),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(screenWidth * 0.02),
                ),
              ),
              child: _isBooking
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Confirm Booking",
                      style: TextStyle(fontSize: screenWidth * 0.04, fontWeight: FontWeight.bold),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  // Booking Card Widget (Your existing code)
  Widget _buildBookingCard(Map<String, dynamic> booking, double screenWidth, double screenHeight) {
    final status = booking["status"].toString().toLowerCase();
    
    Color getStatusColor() {
      switch (status) {
        case "accepted": return Colors.green;
        case "declined": return Colors.orange;
        case "cancelled": 
        case "cancel": return Colors.red;
        case "pending": return Colors.blue;
        default: return Colors.grey;
      }
    }

    String getStatusText() {
      switch (status) {
        case "accepted": return "ACCEPTED";
        case "declined": return "DECLINED";
        case "cancelled": 
        case "cancel": return "CANCELLED";
        case "pending": return "PENDING";
        default: return status.toUpperCase();
      }
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(screenWidth * 0.03)),
      child: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(screenWidth * 0.02),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(screenWidth * 0.02),
                  ),
                  child: Icon(Icons.local_hospital, color: Colors.green, size: screenWidth * 0.06),
                ),
                SizedBox(width: screenWidth * 0.03),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking["hospital"] ?? "Unknown Hospital",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: screenWidth * 0.04),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03, vertical: screenHeight * 0.005),
                  decoration: BoxDecoration(
                    color: getStatusColor(),
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Text(
                    getStatusText(),
                    style: TextStyle(color: Colors.white, fontSize: screenWidth * 0.03, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            SizedBox(height: screenHeight * 0.015),
            _buildInfoRow(Icons.person, "Doctor", booking["doctor"] ?? "Not specified", screenWidth),
            SizedBox(height: screenHeight * 0.008),
            _buildInfoRow(Icons.medical_services, "Specialty", booking["specialty"] ?? "General", screenWidth),
            SizedBox(height: screenHeight * 0.008),
            _buildInfoRow(Icons.calendar_today, "Date", booking["date"] ?? "N/A", screenWidth),
            SizedBox(height: screenHeight * 0.008),
            _buildInfoRow(Icons.access_time, "Time", _formatTime(booking["time"]), screenWidth),
            if (status == "pending") ...[
              SizedBox(height: screenHeight * 0.015),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _cancelBooking(booking),
                    icon: Icon(Icons.cancel, size: screenWidth * 0.045),
                    label: Text("Cancel Booking"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value, double screenWidth) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: screenWidth * 0.045),
        SizedBox(width: screenWidth * 0.03),
        SizedBox(width: screenWidth * 0.2, child: Text(label, style: TextStyle(color: Colors.grey[600]))),
        Expanded(child: Text(value, style: TextStyle(fontWeight: FontWeight.w500))),
      ],
    );
  }
}