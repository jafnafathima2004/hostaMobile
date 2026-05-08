// import 'package:alarm/alarm.dart';
// import 'package:flutter/material.dart';

// // ─────────────────────────────────────────────
// //  ENTRY WIDGET
// // ─────────────────────────────────────────────
// class PillReminder extends StatelessWidget {
//   const PillReminder({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Pill Reminder',
//       theme: ThemeData(primarySwatch: Colors.green),
//       home: const ReminderScreen(),
//     );
//   }
// }

// // ─────────────────────────────────────────────
// //  ALARM SERVICE
// //  Uses the `alarm` package which bypasses
// //  silent mode and plays a looping sound,
// //  just like a real alarm clock.
// // ─────────────────────────────────────────────
// class AlarmService {
//   /// Call once from main() before runApp()
//   static Future<void> init() async {
//     await Alarm.init();
//   }

//   /// Schedule a one-shot alarm that fires at [hour]:[minute].
//   /// If that time has already passed today it is pushed to tomorrow.
//   static Future<void> scheduleAlarm({
//     required int id,
//     required String medicineName,
//     required int hour,
//     required int minute,
//   }) async {
//     final now = DateTime.now();
//     var alarmTime = DateTime(now.year, now.month, now.day, hour, minute);

//     if (alarmTime.isBefore(now)) {
//       alarmTime = alarmTime.add(const Duration(days: 1));
//     }
// final settings = AlarmSettings(
//   id: id,
//   dateTime: alarmTime,
//   assetAudioPath: 'assets/alarm.mp3',

//   loopAudio: true,
//   vibrate: true,
//   warningNotificationOnKill: true,
//   androidFullScreenIntent: true,

//   // ✅ REQUIRED (THIS FIXES YOUR ERROR)
//   volumeSettings: VolumeSettings.fade(
//     volume: 0.8,
//     fadeDuration: const Duration(seconds: 3),
//     volumeEnforced: true,
//   ),

//   notificationSettings: NotificationSettings(
//     title: 'Medicine Reminder 💊',
//     body: 'Time to take $medicineName',
//     stopButton: 'Dismiss',
//     icon: 'notification_icon',
//   ),
// );

//     await Alarm.set(alarmSettings: settings);
//   }

//   static Future<void> cancelAlarm(int id) async {
//     await Alarm.stop(id);
//   }
// }

// // ─────────────────────────────────────────────
// //  UI SCREEN
// // ─────────────────────────────────────────────
// class ReminderScreen extends StatefulWidget {
//   const ReminderScreen({super.key});

//   @override
//   State<ReminderScreen> createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends State<ReminderScreen> {
//   TimeOfDay? selectedTime;
//   List<TimeOfDay> selectedTimes = [];

//   final TextEditingController medicineController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();

//   DateTime? startDate;
//   DateTime? endDate;

//   List<int> selectedDays = [];
//   final List<String> weekDays = [
//     'Sun',
//     'Mon',
//     'Tue',
//     'Wed',
//     'Thu',
//     'Fri',
//     'Sat',
    
//   ];

//   @override
//   void dispose() {
//     medicineController.dispose();
//     notesController.dispose();
//     super.dispose();
//   }

//   // ── TIME PICKER ──────────────────────────────
//   Future<void> pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) {
//         return Theme(
//           data: Theme.of(context).copyWith(
//             colorScheme: const ColorScheme.light(primary: Colors.green),
//           ),
//           child: child!,
//         );
//       },
//     );

//     if (picked != null) setState(() => selectedTime = picked);
//   }

//   void addTime() {
//     if (selectedTime == null) return;

//     final alreadyExists = selectedTimes.any(
//       (t) => t.hour == selectedTime!.hour && t.minute == selectedTime!.minute,
//     );

//     if (!alreadyExists) {
//       setState(() => selectedTimes.add(selectedTime!));
//     }
//   }

//   void removeTime(TimeOfDay time) {
//     setState(() => selectedTimes.remove(time));
//   }

//   String formatTime(TimeOfDay time) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     return TimeOfDay.fromDateTime(dt).format(context);
//   }

//   // ── DATE PICKERS ─────────────────────────────
//   Future<void> pickStartDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) setState(() => startDate = picked);
//   }

//   Future<void> pickEndDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: startDate ?? DateTime.now(),
//       firstDate: startDate ?? DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) setState(() => endDate = picked);
//   }

//   // ── SET REMINDER ─────────────────────────────
//   Future<void> setReminder() async {
//     if (selectedTimes.isEmpty || medicineController.text.trim().isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Add medicine name & at least one time')),
//       );
//       return;
//     }

//     for (int i = 0; i < selectedTimes.length; i++) {
//       final t = selectedTimes[i];
//       await AlarmService.scheduleAlarm(
//         id: i,
//         medicineName: medicineController.text.trim(),
//         hour: t.hour,
//         minute: t.minute,
//       );
//     }

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(content: Text('Reminders set successfully ✅')),
//     );

//     Future.delayed(const Duration(milliseconds: 500), () {
//       if (mounted) Navigator.pop(context);
//     });
//   }

//   // ── BUILD ─────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text('Registering medications'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Medicine name ──
//               _buildInput(
//                 controller: medicineController,
//                 hint: 'Medicine name',
//                 icon: Icons.medication,
//               ),
//               const SizedBox(height: 10),

//               // ── Notes ──
//               _buildInput(
//                 controller: notesController,
//                 hint: 'Add notes',
//                 icon: Icons.notes,
//               ),
//               const SizedBox(height: 20),

//               // ── Time picker ──
//               const Text(
//                 'Reminder Time',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: pickTime,
//                 child: _card(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         selectedTime == null
//                             ? 'Select time'
//                             : formatTime(selectedTime!),
//                       ),
//                       const Icon(Icons.access_time, color: Colors.green),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: addTime,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade100,
//                   foregroundColor: Colors.green,
//                 ),
//                 child: const Text('+ Add Time'),
//               ),
//               const SizedBox(height: 8),

//               // ── Added times ──
//               Wrap(
//                 spacing: 8,
//                 children: selectedTimes.map((time) {
//                   return Chip(
//                     label: Text(formatTime(time)),
//                     deleteIcon: const Icon(Icons.close),
//                     onDeleted: () => removeTime(time),
//                     backgroundColor: Colors.green,
//                     labelStyle: const TextStyle(color: Colors.white),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),

//               // ── Days of week ──
//               _card(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text('Days of Week'),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: List.generate(7, (index) {
//                         final isSelected = selectedDays.contains(index);
//                         return GestureDetector(
//                           onTap: () {
//                             setState(() {
//                               isSelected
//                                   ? selectedDays.remove(index)
//                                   : selectedDays.add(index);
//                             });
//                           },
//                           child: CircleAvatar(
//                             backgroundColor: isSelected
//                                 ? Colors.green
//                                 : Colors.grey.shade200,
//                             child: Text(
//                               weekDays[index][0],
//                               style: TextStyle(
//                                 color:
//                                     isSelected ? Colors.white : Colors.black,
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // ── Start / End date ──
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: pickStartDate,
//                       child: _card(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('Start Date'),
//                             const SizedBox(height: 5),
//                             Text(
//                               startDate == null
//                                   ? 'Select'
//                                   : '${startDate!.day}/${startDate!.month}/${startDate!.year}',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: pickEndDate,
//                       child: _card(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text('End Date'),
//                             const SizedBox(height: 5),
//                             Text(
//                               endDate == null
//                                   ? 'None'
//                                   : '${endDate!.day}/${endDate!.month}/${endDate!.year}',
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),

//               // ── Set Reminder button ──
//               // SizedBox(
//               //   width: double.infinity,
//               //   child: ElevatedButton(
//               //     onPressed: setReminder,
//               //     style: ElevatedButton.styleFrom(
//               //       backgroundColor: Colors.green,
//               //       padding: const EdgeInsets.all(16),
//               //     ),
//               //     child: const Text(
//               //       'Set Reminder',
//               //       style: TextStyle(color: Colors.white),
//               //     ),
//               //   ),
//               // ),
//               SizedBox(
//   width: double.infinity,
//   child: ElevatedButton(
//     onPressed: () {
//       print("🔥 BUTTON PRESSED");
//       setReminder();
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.green,
//       padding: const EdgeInsets.all(16),
//     ),
//     child: const Text(
//       'Set Reminder',
//       style: TextStyle(color: Colors.white),
//     ),
//   ),
// ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── HELPERS ───────────────────────────────────
//   Widget _card({required Widget child}) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//       ),
//       child: child,
//     );
//   }

//   Widget _buildInput({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//   }) {
//     return _card(
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.grey),
//           hintText: hint,
//           border: InputBorder.none,
//         ),
//       ),
//     );
//   }
// }












// import 'package:alarm/alarm.dart';
// import 'package:flutter/material.dart';

// // ─────────────────────────────────────────────
// //  ALARM SERVICE
// // ─────────────────────────────────────────────
// class AlarmService {
//   /// Call once from main() before runApp()
//   static Future<void> init() async {
//     await Alarm.init();
//   }

//   /// Schedule a one-shot alarm at [hour]:[minute].
//   /// Automatically pushed to tomorrow if time already passed today.
//   static Future<void> scheduleAlarm({
//     required int id,
//     required String medicineName,
//     required int hour,
//     required int minute,
//   }) async {
//     final now = DateTime.now();
//     var alarmTime = DateTime(now.year, now.month, now.day, hour, minute);

//     if (alarmTime.isBefore(now)) {
//       alarmTime = alarmTime.add(const Duration(days: 1));
//     }

//     final settings = AlarmSettings(
//       id: id,
//       dateTime: alarmTime,
//       assetAudioPath: 'assets/alarm.mp3',
//       loopAudio: true,
//       vibrate: true,
//       warningNotificationOnKill: true,
//       androidFullScreenIntent: true,
//       volumeSettings: VolumeSettings.fade(
//         volume: 0.8,
//         fadeDuration: const Duration(seconds: 3),
//         volumeEnforced: true,
//       ),
//       notificationSettings: NotificationSettings(
//         title: 'Medicine Reminder 💊',
//         body: 'Time to take $medicineName',
//         stopButton: 'Dismiss',
//         icon: 'notification_icon',
//       ),
//     );

//     await Alarm.set(alarmSettings: settings);
//   }

//   static Future<void> cancelAlarm(int id) async {
//     await Alarm.stop(id);
//   }
// }

// // ─────────────────────────────────────────────
// //  REMINDER SCREEN
// // ─────────────────────────────────────────────
// class ReminderScreen extends StatefulWidget {
//   const ReminderScreen({super.key});

//   @override
//   State<ReminderScreen> createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends State<ReminderScreen> {
//   TimeOfDay? selectedTime;
//   List<TimeOfDay> selectedTimes = [];

//   final TextEditingController medicineController = TextEditingController();
//   final TextEditingController notesController = TextEditingController();

//   DateTime? startDate;
//   DateTime? endDate;

//   List<int> selectedDays = [];
//   final List<String> weekDays = [
//     'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat',
//   ];

//   @override
//   void dispose() {
//     medicineController.dispose();
//     notesController.dispose();
//     super.dispose();
//   }

//   // ── BACK ──────────────────────────────────────
//   /// Instant pop — works because this screen is always
//   /// pushed on top of your home page, never the root route.
//   void _goBack() => Navigator.of(context).pop();

//   // ── TIME PICKER ──────────────────────────────
//   Future<void> pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: const ColorScheme.light(primary: Colors.green),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) setState(() => selectedTime = picked);
//   }

//   void addTime() {
//     if (selectedTime == null) return;
//     final exists = selectedTimes.any(
//       (t) => t.hour == selectedTime!.hour && t.minute == selectedTime!.minute,
//     );
//     if (!exists) setState(() => selectedTimes.add(selectedTime!));
//   }

//   void removeTime(TimeOfDay time) =>
//       setState(() => selectedTimes.remove(time));

//   String formatTime(TimeOfDay time) {
//     final now = DateTime.now();
//     return TimeOfDay.fromDateTime(
//       DateTime(now.year, now.month, now.day, time.hour, time.minute),
//     ).format(context);
//   }

//   // ── DATE PICKERS ─────────────────────────────
//   Future<void> pickStartDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) setState(() => startDate = picked);
//   }

//   Future<void> pickEndDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: startDate ?? DateTime.now(),
//       firstDate: startDate ?? DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) setState(() => endDate = picked);
//   }

//   // ── SET REMINDER ─────────────────────────────
//   Future<void> setReminder() async {
//   print("🔥 BUTTON PRESSED");

//   if (medicineController.text.trim().isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Please enter a medicine name'),
//         backgroundColor: Colors.red,
//       ),
//     );
//     return;
//   }

//   if (selectedTimes.isEmpty) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('Please add at least one reminder time'),
//         backgroundColor: Colors.red,
//       ),
//     );
//     return;
//   }

//   try {
//     for (int i = 0; i < selectedTimes.length; i++) {

//       // ✅ FIXED ID (IMPORTANT)
//       final alarmId =
//           (DateTime.now().millisecondsSinceEpoch ~/ 1000) % 2147483647 + i;

//       await AlarmService.scheduleAlarm(
//         id: alarmId,
//         medicineName: medicineController.text.trim(),
//         hour: selectedTimes[i].hour,
//         minute: selectedTimes[i].minute,
//       );
//     }

//     print("✅ ALARM SET SUCCESS");

//     if (!mounted) return;

//     ScaffoldMessenger.of(context).showSnackBar(
//       const SnackBar(
//         content: Text('✅ Reminders set successfully!'),
//         backgroundColor: Colors.green,
//       ),
//     );

//     Navigator.of(context).pop();

//   } catch (e) {
//     print("❌ ERROR: $e");
//   }
// }
//   // ── BUILD ─────────────────────────────────────
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text('Registering medications'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//         // ✅ FIX: Instant back — no lag, no canPop check needed
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: _goBack,
//         ),
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Medicine name ──
//               _buildInput(
//                 controller: medicineController,
//                 hint: 'Medicine name',
//                 icon: Icons.medication,
//               ),
//               const SizedBox(height: 10),

//               // ── Notes ──
//               _buildInput(
//                 controller: notesController,
//                 hint: 'Add notes',
//                 icon: Icons.notes,
//     ),
//               const SizedBox(height: 20),

//               // ── Time picker ──
//               const Text(
//                 'Reminder Time',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: pickTime,
//                 child: _card(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         selectedTime == null
//                             ? 'Select time'
//                             : formatTime(selectedTime!),
//                         style: TextStyle(
//                           color: selectedTime == null
//                               ? Colors.grey
//                               : Colors.black,
//                         ),
//                       ),
//                       const Icon(Icons.access_time, color: Colors.green),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: addTime,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade100,
//                   foregroundColor: Colors.green,
//                   elevation: 0,
//                 ),
//                 child: const Text('+ Add Time'),
//               ),
//               const SizedBox(height: 8),

//               // ── Added times list ──
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 4,
//                 children: selectedTimes.map((time) {
//                   return Chip(
//                     label: Text(formatTime(time)),
//                     deleteIcon: const Icon(Icons.close, size: 16),
//                     onDeleted: () => removeTime(time),
//                     backgroundColor: Colors.green,
//                     labelStyle: const TextStyle(color: Colors.white),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),

//               // ── Days of week ──
//               _card(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Days of Week',
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: List.generate(7, (index) {
//                         final isSelected = selectedDays.contains(index);
//                         return GestureDetector(
//                           onTap: () => setState(() {
//                             isSelected
//                                 ? selectedDays.remove(index)
//                                 : selectedDays.add(index);
//                           }),
//                           child: CircleAvatar(
//                             radius: 20,
//                             backgroundColor: isSelected
//                                 ? Colors.green
//                                 : Colors.grey.shade200,
//                             child: Text(
//                               weekDays[index][0],
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                                 color: isSelected
//                                     ? Colors.white
//                                     : Colors.black54,
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // ── Start / End date ──
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: pickStartDate,
//                       child: _card(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Start Date',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               startDate == null
//                                   ? 'Select'
//                                   : '${startDate!.day}/${startDate!.month}/${startDate!.year}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: pickEndDate,
//                       child: _card(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'End Date',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               endDate == null
//                                   ? 'None'
//                                   : '${endDate!.day}/${endDate!.month}/${endDate!.year}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),

//               // ── Set Reminder button ──
//               // ✅ FIX: Calls setReminder() which schedules alarms
//               SizedBox(
//   width: double.infinity,
//   child: ElevatedButton(
//     onPressed: () async {
//       await setReminder();
//     },
//     style: ElevatedButton.styleFrom(
//       backgroundColor: Colors.green,
//       padding: const EdgeInsets.all(16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//       ),
//       elevation: 2,
//     ),
//     child: const Text(
//       'Next',
//       style: TextStyle(
//         color: Colors.white,
//         fontSize: 16,
//         fontWeight: FontWeight.w600,
//       ),
//     ),
//   ),
// ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── HELPERS ───────────────────────────────────
//   Widget _card({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _buildInput({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//   }) {
//     return _card(
//       child: TextField(
//         controller: controller,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.grey),
//           hintText: hint,
//           border: InputBorder.none,
//           contentPadding: EdgeInsets.zero,
//         ),
//       ),
//     );
//   } 
// }







// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:hosta/alarm.service.dart';
// import 'package:hosta/providers/reminder_provider.dart';


// class ReminderScreen extends ConsumerStatefulWidget {
//   const ReminderScreen({super.key});

//   @override
//   ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
// }

// class _ReminderScreenState extends ConsumerState<ReminderScreen> {
//   void _goBack() => Navigator.of(context).pop();

//   Future<void> pickTime() async {
//     final picked = await showTimePicker(
//       context: context,
//       initialTime: TimeOfDay.now(),
//       builder: (context, child) => Theme(
//         data: Theme.of(context).copyWith(
//           colorScheme: const ColorScheme.light(primary: Colors.green),
//         ),
//         child: child!,
//       ),
//     );
//     if (picked != null) {
//       ref.read(reminderStateProvider.notifier).setSelectedTime(picked);
//     }
//   }

//   void addTime() {
//     ref.read(reminderStateProvider.notifier).addTime();
//   }

//   void removeTime(TimeOfDay time) {
//     ref.read(reminderStateProvider.notifier).removeTime(time);
//   }

//   String formatTime(TimeOfDay time) {
//     final now = DateTime.now();
//     return TimeOfDay.fromDateTime(
//       DateTime(now.year, now.month, now.day, time.hour, time.minute),
//     ).format(context);
//   }

//   Future<void> pickStartDate() async {
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       ref.read(reminderStateProvider.notifier).setStartDate(picked);
//     }
//   }

//   Future<void> pickEndDate() async {
//     final startDate = ref.read(reminderStateProvider).startDate;
//     final picked = await showDatePicker(
//       context: context,
//       initialDate: startDate ?? DateTime.now(),
//       firstDate: startDate ?? DateTime.now(),
//       lastDate: DateTime(2100),
//     );
//     if (picked != null) {
//       ref.read(reminderStateProvider.notifier).setEndDate(picked);
//     }
//   }

//   Future<void> setReminder() async {
//     print("🔥 BUTTON PRESSED");
    
//     final state = ref.read(reminderStateProvider);
//     final medicineName = state.medicineController.text.trim();
//     final selectedTimes = state.selectedTimes;
    
//     if (medicineName.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please enter a medicine name'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     if (selectedTimes.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('Please add at least one reminder time'),
//           backgroundColor: Colors.red,
//         ),
//       );
//       return;
//     }

//     try {
//       for (int i = 0; i < selectedTimes.length; i++) {
//         final alarmId =
//             (DateTime.now().millisecondsSinceEpoch ~/ 1000) % 2147483647 + i;

//         await AlarmService.scheduleAlarm(
//           id: alarmId,
//           medicineName: medicineName,
//           hour: selectedTimes[i].hour,
//           minute: selectedTimes[i].minute,
//         );
//       }

//       print("✅ ALARM SET SUCCESS");

//       if (!mounted) return;

//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text('✅ Reminders set successfully!'),
//           backgroundColor: Colors.green,
//         ),
//       );

//       // Clear form after successful submission
//       ref.read(reminderStateProvider.notifier).clearForm();
//       Navigator.of(context).pop();

//     } catch (e) {
//       print("❌ ERROR: $e");
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text('Error setting reminder: $e'),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final state = ref.watch(reminderStateProvider);
//     final weekDays = ref.watch(weekDaysProvider);
    
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F5F5),
//       appBar: AppBar(
//         title: const Text('Registering medications'),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         foregroundColor: Colors.black,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: _goBack,
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: SingleChildScrollView(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // ── Medicine name ──
//               _buildInput(
//                 controller: state.medicineController,
//                 hint: 'Medicine name',
//                 icon: Icons.medication, 
//                 onChanged: (value) {
//                   ref.read(reminderStateProvider.notifier).updateMedicineName(value);
//                 },
//               ),
//               const SizedBox(height: 12),

//               // ── Notes ──
//               _buildInput(
//                 controller: state.notesController,
//                 hint: 'Add notes',
//                 icon: Icons.notes, 
//                 onChanged: (value) {
//                   ref.read(reminderStateProvider.notifier).updateNotes(value);
//                 },
//               ),
//               const SizedBox(height: 20),

//               // ── Time picker ──
//               const Text(
//                 'Reminder Time',
//                 style: TextStyle(fontWeight: FontWeight.bold),
//               ),
//               const SizedBox(height: 10),
//               GestureDetector(
//                 onTap: pickTime,
//                 child: _card(
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         state.selectedTime == null
//                             ? 'Select time'
//                             : formatTime(state.selectedTime!),
//                         style: TextStyle(
//                           color: state.selectedTime == null
//                               ? Colors.grey
//                               : Colors.black,
//                         ),
//                       ),
//                       const Icon(Icons.access_time, color: Colors.green),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 10),
//               ElevatedButton(
//                 onPressed: addTime,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.green.shade100,
//                   foregroundColor: Colors.green,
//                   elevation: 0,
//                 ),
//                 child: const Text('+ Add Time'),
//               ),
//               const SizedBox(height: 8),

//               // ── Added times list ──
//               Wrap(
//                 spacing: 8,
//                 runSpacing: 4,
//                 children: state.selectedTimes.map((time) {
//                   return Chip(
//                     label: Text(formatTime(time)),
//                     deleteIcon: const Icon(Icons.close, size: 16),
//                     onDeleted: () => removeTime(time),
//                     backgroundColor: Colors.green,
//                     labelStyle: const TextStyle(color: Colors.white),
//                   );
//                 }).toList(),
//               ),
//               const SizedBox(height: 20),

//               // ── Days of week ──
//               _card(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Days of Week',
//                       style: TextStyle(fontWeight: FontWeight.w500),
//                     ),
//                     const SizedBox(height: 12),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: List.generate(7, (index) {
//                         final isSelected = state.selectedDays.contains(index);
//                         return GestureDetector(
//                           onTap: () {
//                             ref.read(reminderStateProvider.notifier).toggleDay(index);
//                           },
//                           child: CircleAvatar(
//                             radius: 20,
//                             backgroundColor: isSelected
//                                 ? Colors.green
//                                 : Colors.grey.shade200,
//                             child: Text(
//                               weekDays[index][0],
//                               style: TextStyle(
//                                 fontSize: 13,
//                                 fontWeight: FontWeight.w600,
//                                 color: isSelected
//                                     ? Colors.white
//                                     : Colors.black54,
//                               ),
//                             ),
//                           ),
//                         );
//                       }),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 20),

//               // ── Start / End date ──
//               Row(
//                 children: [
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: pickStartDate,
//                       child: _card(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Start Date',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               state.startDate == null
//                                   ? 'Select'
//                                   : '${state.startDate!.day}/${state.startDate!.month}/${state.startDate!.year}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(width: 10),
//                   Expanded(
//                     child: GestureDetector(
//                       onTap: pickEndDate,
//                       child: _card(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'End Date',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.grey,
//                               ),
//                             ),
//                             const SizedBox(height: 5),
//                             Text(
//                               state.endDate == null
//                                   ? 'None'
//                                   : '${state.endDate!.day}/${state.endDate!.month}/${state.endDate!.year}',
//                               style: const TextStyle(
//                                 fontWeight: FontWeight.w500,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 30),

//               // ── Set Reminder button ──
//               SizedBox(
//                 width: double.infinity,
//                 child: ElevatedButton(
//                   onPressed: setReminder,
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: Colors.green,
//                     padding: const EdgeInsets.all(16),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     elevation: 2,
//                   ),
//                   child: const Text(
//                     'Next',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // ── HELPERS ───────────────────────────────────
//   Widget _card({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(16),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(15),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(0.04),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _buildInput({
//     required TextEditingController controller,
//     required String hint,
//     required IconData icon,
//     required Function(String) onChanged,
//   }) {
//      return Container(
//     height: 55, // medium height
//     padding: const EdgeInsets.symmetric(horizontal: 14),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(15),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(0.04),
//           blurRadius: 6,
//           offset: const Offset(0, 2),
//         ),
//       ],
//     ),
//     child: TextField(
//       controller: controller,
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         prefixIcon: Icon(
//           icon,
//           color: Colors.grey,
//           size: 20,
//         ),
//         hintText: hint,
//         border: InputBorder.none,
//         contentPadding: const EdgeInsets.symmetric(
//           vertical: 14,
//         ),
//       ),
//     ),
//   );
// }}






import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hosta/alarm.service.dart';
import 'package:hosta/providers/reminder_provider.dart';

class ReminderScreen extends ConsumerStatefulWidget {
  const ReminderScreen({super.key});

  @override
  ConsumerState<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends ConsumerState<ReminderScreen> {
  void _goBack() => Navigator.of(context).pop();

  Future<void> pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Colors.green),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      ref.read(reminderStateProvider.notifier).setSelectedTime(picked);
    }
  }

  void addTime() {
    ref.read(reminderStateProvider.notifier).addTime();
  }

  void removeTime(TimeOfDay time) {
    ref.read(reminderStateProvider.notifier).removeTime(time);
  }

  String formatTime(TimeOfDay time) {
    final now = DateTime.now();
    return TimeOfDay.fromDateTime(
      DateTime(now.year, now.month, now.day, time.hour, time.minute),
    ).format(context);
  }

  Future<void> pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ref.read(reminderStateProvider.notifier).setStartDate(picked);
    }
  }

  Future<void> pickEndDate() async {
    final startDate = ref.read(reminderStateProvider).startDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: startDate ?? DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      ref.read(reminderStateProvider.notifier).setEndDate(picked);
    }
  }

  Future<void> setReminder() async {
    print("🔥 BUTTON PRESSED");
    
    final state = ref.read(reminderStateProvider);
    final medicineName = state.medicineController.text.trim();
    final selectedTimes = state.selectedTimes;
    
    if (medicineName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a medicine name'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (selectedTimes.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add at least one reminder time'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      for (int i = 0; i < selectedTimes.length; i++) {
        final alarmId =
            (DateTime.now().millisecondsSinceEpoch ~/ 1000) % 2147483647 + i;

        await AlarmService.scheduleAlarm(
          id: alarmId,
          medicineName: medicineName,
          hour: selectedTimes[i].hour,
          minute: selectedTimes[i].minute,
        );
      }

      print("✅ ALARM SET SUCCESS");

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Reminders set successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Clear form after successful submission
      ref.read(reminderStateProvider.notifier).clearForm();
      Navigator.of(context).pop();

    } catch (e) {
      print("❌ ERROR: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error setting reminder: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(reminderStateProvider);
    final weekDays = ref.watch(weekDaysProvider);
    
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    
    // Responsive values
    final horizontalPadding = screenWidth * 0.04; // 4% of screen width
    final verticalPadding = screenHeight * 0.02; // 2% of screen height
    final inputHeight = screenHeight * 0.07; // 7% of screen height (min 50, max 65)
    final avatarRadius = screenWidth * 0.045; // Responsive avatar size
    final cardPadding = screenWidth * 0.04;
    final spacingSmall = screenHeight * 0.015;
    final spacingMedium = screenHeight * 0.025;
    final spacingLarge = screenHeight * 0.035;
    final buttonPadding = screenHeight * 0.02;
    final fontSizeTitle = screenWidth * 0.045;
    final fontSizeBody = screenWidth * 0.04;
    final fontSizeSmall = screenWidth * 0.035;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: screenWidth * 0.05,
          ),
        ),
        title: Text(
          "Registering medications",
          style: TextStyle(
            color: Colors.white,
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(horizontalPadding),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Medicine name ──
              _buildInput(
                controller: state.medicineController,
                hint: 'Medicine name',
                icon: Icons.medication, 
                height: inputHeight,
                fontSize: fontSizeBody,
                onChanged: (value) {
                  ref.read(reminderStateProvider.notifier).updateMedicineName(value);
                },
              ),
              SizedBox(height: spacingSmall),

              // ── Notes ──
              _buildInput(
                controller: state.notesController,
                hint: 'Add notes',
                icon: Icons.notes, 
                height: inputHeight,
                fontSize: fontSizeBody,
                onChanged: (value) {
                  ref.read(reminderStateProvider.notifier).updateNotes(value);
                },
              ),
              SizedBox(height: spacingMedium),

              // ── Time picker ──
              Text(
                'Reminder Time',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSizeBody,
                ),
              ),
              SizedBox(height: spacingSmall),
              GestureDetector(
                onTap: pickTime,
                child: _card(
                  padding: cardPadding,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        state.selectedTime == null
                            ? 'Select time'
                            : formatTime(state.selectedTime!),
                        style: TextStyle(
                          color: state.selectedTime == null
                              ? Colors.grey
                              : Colors.black,
                          fontSize: fontSizeBody,
                        ),
                      ),
                      const Icon(Icons.access_time, color: Colors.green),
                    ],
                  ),
                ),
              ),
              SizedBox(height: spacingSmall),
              ElevatedButton(
                onPressed: addTime,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade100,
                  foregroundColor: Colors.green,
                  elevation: 0,
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.012,
                  ),
                ),
                child: Text(
                  '+ Add Time',
                  style: TextStyle(fontSize: fontSizeBody),
                ),
              ),
              SizedBox(height: spacingSmall),

              // ── Added times list ──
              Wrap(
                spacing: screenWidth * 0.02,
                runSpacing: screenHeight * 0.01,
                children: state.selectedTimes.map((time) {
                  return Chip(
                    label: Text(
                      formatTime(time),
                      style: TextStyle(fontSize: fontSizeSmall),
                    ),
                    deleteIcon: Icon(Icons.close, size: fontSizeBody * 1.2),
                    onDeleted: () => removeTime(time),
                    backgroundColor: Colors.green,
                    labelStyle: const TextStyle(color: Colors.white),
                  );
                }).toList(),
              ),
              SizedBox(height: spacingMedium),

              // ── Days of week ──
              _card(
                padding: cardPadding,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Days of Week',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: fontSizeBody,
                      ),
                    ),
                    SizedBox(height: spacingSmall),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(7, (index) {
                        final isSelected = state.selectedDays.contains(index);
                        return GestureDetector(
                          onTap: () {
                            ref.read(reminderStateProvider.notifier).toggleDay(index);
                          },
                          child: CircleAvatar(
                            radius: avatarRadius,
                            backgroundColor: isSelected
                                ? Colors.green
                                : Colors.grey.shade200,
                            child: Text(
                              weekDays[index][0],
                              style: TextStyle(
                                fontSize: avatarRadius * 0.8,
                                fontWeight: FontWeight.w600,
                                color: isSelected
                                    ? Colors.white
                                    : Colors.black54,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
              SizedBox(height: spacingMedium),

              // ── Start / End date ──
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: pickStartDate,
                      child: _card(
                        padding: cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Start Date',
                              style: TextStyle(
                                fontSize: fontSizeSmall,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              state.startDate == null
                                  ? 'Select'
                                  : '${state.startDate!.day}/${state.startDate!.month}/${state.startDate!.year}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: fontSizeBody,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: screenWidth * 0.025),
                  Expanded(
                    child: GestureDetector(
                      onTap: pickEndDate,
                      child: _card(
                        padding: cardPadding,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'End Date',
                              style: TextStyle(
                                fontSize: fontSizeSmall,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              state.endDate == null
                                  ? 'None'
                                  : '${state.endDate!.day}/${state.endDate!.month}/${state.endDate!.year}',
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: fontSizeBody,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: spacingLarge),

              // ── Set Reminder button ──
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: setReminder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.all(buttonPadding),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: fontSizeBody * 1.1,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: spacingLarge),
            ],
          ),
        ),
      ),
    );
  }

  // ── HELPERS ───────────────────────────────────
  Widget _card({required Widget child, required double padding}) {
    final screenWidth = MediaQuery.of(context).size.width;
    
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildInput({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    required double height,
    required double fontSize,
    required Function(String) onChanged,
  }) {
    return Container(
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.grey,
            size: fontSize * 1.2,
          ),
          hintText: hint,
          hintStyle: TextStyle(fontSize: fontSize),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
        ),
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}

