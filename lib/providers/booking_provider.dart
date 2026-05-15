import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../../../services/api_service.dart';

// ─────────────────────────────────────────────
//  STATE CLASSES
// ─────────────────────────────────────────────

class BookingState {
  final String selectedFilter;
  final String searchQuery;
  final DateTime? selectedDate;
  final bool isLoading;
  final String? userId;
  final bool isSocketConnected;
  final List<Map<String, dynamic>> bookings;
  final TextEditingController searchController;
   final String? errorMessage;

  BookingState({
    this.selectedFilter = "All",
    this.searchQuery = "",
    this.selectedDate,
    this.isLoading = true,
    this.userId,
    this.isSocketConnected = false,
    this.bookings = const [],
    required this.searchController,
    this.errorMessage,
  });

  BookingState copyWith({
    String? selectedFilter,
    String? searchQuery,
    DateTime? selectedDate,
    bool? isLoading,
    String? userId,
    bool? isSocketConnected,
    List<Map<String, dynamic>>? bookings,
    TextEditingController? searchController,
    String? errorMessage,
  }) {
    return BookingState(
      selectedFilter: selectedFilter ?? this.selectedFilter,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
      userId: userId ?? this.userId,
      isSocketConnected: isSocketConnected ?? this.isSocketConnected,
      bookings: bookings ?? this.bookings,
      searchController: searchController ?? this.searchController,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

// ─────────────────────────────────────────────
//  PROVIDERS
// ─────────────────────────────────────────────

final bookingStateProvider = StateNotifierProvider<BookingNotifier, BookingState>((ref) {
  return BookingNotifier();
});

class BookingNotifier extends StateNotifier<BookingState> {
  IO.Socket? _socket;
  final ApiService _apiService = ApiService();

  BookingNotifier() : super(
    BookingState(
      searchController: TextEditingController(),
    ),
  );

    bool canCancelBooking(Map<String, dynamic> booking) {
    final status = booking["status"].toString().toLowerCase();
    // Only pending bookings can be cancelled
    return status == "pending";
  }

 void clearError() {
    state = state.copyWith(errorMessage: null);
  }
  void updateSelectedFilter(String filter) {
    state = state.copyWith(
      selectedFilter: filter,
      // selectedDate: filter == "All" ? null : state.selectedDate,
      // searchQuery: filter == "All" ? "" : state.searchQuery,
    );
    if (filter == "All") {
      state.searchController.clear();
    }
  }

  void updateSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void updateSelectedDate(DateTime? date) {
    state = state.copyWith(selectedDate: date);
  }

  void clearSelectedDate() {
    state = state.copyWith(selectedDate: null);
  }

  void setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  void setUserId(String? userId) {
    state = state.copyWith(userId: userId);
  }

  void setSocketConnected(bool connected) {
    state = state.copyWith(isSocketConnected: connected);
  }

  void setBookings(List<Map<String, dynamic>> bookings) {
    state = state.copyWith(bookings: bookings);
  }

  void updateBookingStatus(String bookingId, String newStatus) {
    final updatedBookings = state.bookings.map((booking) {
      if (booking["id"] == bookingId) {
        return {...booking, "status": newStatus};
      }
      return booking;
    }).toList();
    state = state.copyWith(bookings: updatedBookings);
  }

  Future<void> initializeData() async {
    await loadUserIdAndFetchBookings();
    setupSocketListener();
  }

  Future<void> loadUserIdAndFetchBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final storedUserId = prefs.getString('userId');

      setUserId(storedUserId);
      print("📱 Loaded user ID for bookings: $storedUserId");

      if (storedUserId != null && storedUserId.isNotEmpty) {
        await fetchBookings();
      } else {
        setLoading(false);
        print("❌ No user ID found for bookings");
      }
    } catch (e) {
      print("❌ Error loading user ID: $e");
      setLoading(false);
    }
  }

  // Future<void> fetchBookings() async {
  //   final userId = state.userId;
  //   if (userId == null || userId.isEmpty) {
  //     setLoading(false);
  //     return;
  //   }

  //   setLoading(true);
  //   try {
  //     final response = await _apiService.getAllBookings(userId);
  //     print("📋 Bookings API Response: ${response.data}");
  //     print("📋 Bookings API Response Data: ${response.data}");
  //     // Handle different response structures
  //     dynamic bookingsData;
  //     if (response.data is Map && response.data.containsKey('data')) {
  //       bookingsData = response.data['data'];
  //     } else if (response.data is List) {
  //       bookingsData = response.data;
  //     } else {
  //       bookingsData = [];
  //     }

  //     List<Map<String, dynamic>> parsedBookings = [];
  //     if (bookingsData is List) {
  //       parsedBookings = List<Map<String, dynamic>>.from(
  //         bookingsData.map((b) {
  //           // Extract hospital data correctly
  //           final hospitalData = b["hospitalId"] is Map ? b["hospitalId"] : {};
  //           final hospitalName = hospitalData["name"] ?? "Unknown Hospital";
  //           final hospitalType = hospitalData["type"] ?? "General";
  //           final hospitalId = hospitalData["_id"] ?? b["hospitalId"] ?? "";

  //           return {
  //             "id": b["bookingId"] ?? b["_id"] ?? "",
  //             "hospital_id": hospitalId,
  //             "hospital": hospitalName,
  //             "type": hospitalType,
  //             "doctor": b["doctor_name"] ?? "Not specified",
  //             "specialty": b["specialty"] ?? "General",
  //             "date": _parseDate(b["booking_date"]),
  //             "status": (b["status"] ?? "pending").toString().toLowerCase(),             
  //             "time": b["booking_time"] ?? "N/A",
  //             "patient_name": b["patient_name"] ?? "",
  //             "patient_phone": b["patient_phone"] ?? "",
  //             "patient_place": b["patient_place"] ?? "",
  //           };
  //         }),
  //       );
  //     }

  //     setBookings(parsedBookings);
  //     print("✅ Loaded ${parsedBookings.length} bookings");
  //   } catch (e) {
  //     print("❌ Error fetching bookings: $e");
  //     setBookings([]);
  //   } finally {
  //     setLoading(false);
  //   }
  // }
  Future<void> fetchBookings() async {
  final userId = state.userId;
  if (userId == null || userId.isEmpty) {
    setLoading(false);
    return;
  }

  setLoading(true);
  try {
    final response = await _apiService.getAllBookings(userId);
 //   print("📋 Bookings API Response Status: ${response.statusCode}");
    print("📋 Bookings API Response Data: ${response.data}");

    // Handle different response structures
    dynamic bookingsData;
    if (response.data is Map && response.data.containsKey('data')) {
      bookingsData = response.data['data'];
    } else if (response.data is List) {
      bookingsData = response.data;
    } else {
      bookingsData = [];
    }

    List<Map<String, dynamic>> parsedBookings = [];
    if (bookingsData is List) {
      parsedBookings = List<Map<String, dynamic>>.from(
        bookingsData.map((b) {
          // Extract hospital data correctly
          final hospitalData = b["hospitalId"] is Map ? b["hospitalId"] : {};
          final hospitalName = hospitalData["name"] ?? b["hospital_name"] ?? "Unknown Hospital";
          final hospitalType = hospitalData["type"] ?? b["hospital_type"] ?? "General";
          final hospitalId = hospitalData["_id"] ?? b["hospitalId"] ?? b["hospital_id"] ?? "";

          return {
            "id": b["bookingId"] ?? b["_id"] ?? b["id"] ?? "",
            "hospital_id": hospitalId,
            "hospital": hospitalName,
            "type": hospitalType,
            "doctor": b["doctor_name"] ?? b["doctor"] ?? "Not specified",
            "specialty": b["specialty"] ?? "General",
            "date": _parseDate(b["booking_date"] ?? b["date"]),
            "status": (b["status"] ?? "pending").toString().toLowerCase(),
            "time": _formatTime(b["booking_time"] ?? b["time"]),
            "patient_name": b["patient_name"] ?? b["patientName"] ?? "",
            "patient_phone": b["patient_phone"] ?? b["patientPhone"] ?? "",
            "patient_place": b["patient_place"] ?? b["patientPlace"] ?? "",
          };
        }),
      );
    }

    setBookings(parsedBookings);
    print("✅ Loaded ${parsedBookings.length} bookings");
      clearError();
  } catch (e) {
    print("❌ Error fetching bookings: $e");
    
      state = state.copyWith(
      errorMessage: "Failed to load bookings. Please check your connection.",
      isLoading: false,
    );
    
    setBookings([]);
  } finally {
    setLoading(false);
  }
}

// Add time formatting helper
String _formatTime(dynamic time) {
  try {
    if (time == null || time == "N/A") return "N/A";
    
    // If it's a DateTime object or ISO string
    if (time.toString().contains('T')) {
      final dateTime = DateTime.parse(time.toString());
      return DateFormat('hh:mm a').format(dateTime);
    }
    
    // If it's already formatted
    if (time.toString().contains(':')) {
      return time.toString();
    }
    
    return time.toString();
  } catch (e) {
    return time?.toString() ?? "N/A";
  }
}

  String _parseDate(dynamic date) {
    try {
      if (date == null) return "N/A";
      return DateFormat('yyyy-MM-dd').format(DateTime.parse(date.toString()));
    } catch (e) {
      return "Invalid date";
    }
  }

  void setupSocketListener() {
  try {
    const String serverUrl = 'https://www.zorrowtek.in';
    final userId = state.userId;

    if (userId == null || userId.isEmpty) {
      print("⚠️ Cannot setup socket: No user ID");
      return;
    }

    // Clean up existing socket
    _disposeSocket();

    Map<String, dynamic> socketOptions = {
      'transports': ['websocket', 'polling'],
      'autoConnect': true,
      'forceNew': true,
      'reconnection': true,
      'reconnectionAttempts': 10,
      'reconnectionDelay': 1000,
      'reconnectionDelayMax': 5000,
      'timeout': 20000,
    };

    _socket = IO.io(serverUrl, socketOptions);

    _socket!.onConnect((_) {
      print("✅ Connected to server via Socket.IO");
      setSocketConnected(true);
      _joinUserRoom();
    });

    _socket!.onDisconnect((_) {
      print("🔌 Disconnected from server");
      setSocketConnected(false);
    });

    _socket!.onReconnect((attempt) {
      print("🔄 Reconnected to server after $attempt attempts");
      setSocketConnected(true);
      _joinUserRoom();
    });

    _socket!.onReconnectAttempt((attempt) {
      print("🔄 Reconnection attempt #$attempt");
    });

    _socket!.onReconnectError((error) {
      print('⚠️ Reconnection error: $error');
    });

    _socket!.onError((error) {
      print('⚠️ Socket error: $error');
      setSocketConnected(false);
    });

    // Listen for specific events
    _socket!.on('bookingCreated', _handleBookingCreated);
    _socket!.on('bookingUpdate', _handleBookingUpdate);
    _socket!.on('bookingStatusChanged', _handleBookingStatusChanged);
    _socket!.on('bookingCancelled', _handleBookingCancelled);

    _socket!.connect();
    print('🔌 Socket.IO connection initiated for user: $userId');
  } catch (e) {
    print('❌ Error setting up socket: $e');
    setSocketConnected(false);
  }
}

// Separate event handlers for better maintainability
void _handleBookingCreated(dynamic data) {
  print('📡 New booking notification received: $data');
  _handleSocketNotification(data, 'bookingCreated');
}

void _handleBookingUpdate(dynamic data) {
  print('📡 Booking update notification received: $data');
  _handleSocketNotification(data, 'bookingUpdate');
}

void _handleBookingStatusChanged(dynamic data) {
  print('📡 Booking status change notification: $data');
  _handleSocketNotification(data, 'bookingStatusChanged');
}

void _handleBookingCancelled(dynamic data) {
  print('📡 Booking cancelled notification: $data');
  _handleSocketNotification(data, 'bookingCancelled');
}

  void _joinUserRoom() {
    final userId = state.userId;
    if (_socket != null && _socket!.connected && userId != null && userId.isNotEmpty) {
      _socket!.emit('joinUserRoom', {'userId': userId});

      for (var booking in state.bookings) {
        if (booking['id'] != null && booking['id'].toString().isNotEmpty) {
          _socket!.emit('joinBookingRoom', {'bookingId': booking['id']});
        }
      }
    }
  }

  void _handleSocketNotification(dynamic data, String eventType) {
    try {
      final notificationUserId = data['userId']?.toString();
      final userId = state.userId;

      print('📱 Processing $eventType for user: $notificationUserId');

      if (notificationUserId == userId) {
        print('🔄 Refreshing bookings due to socket notification');
        fetchBookings().then((_) {
          if (_socket != null && _socket!.connected) {
            _joinUserRoom();
          }
        });
      } else {
        print('🚫 This socket notification is for another user');
      }
    } catch (e) {
      print('❌ Error handling socket notification: $e');
    }
  }

  Future<void> cancelBooking(Map<String, dynamic> booking) async {
    final bookingId = booking["id"].toString();
    final hospitalId = booking["hospital_id"].toString();

    if (bookingId.isEmpty || hospitalId.isEmpty) {
      throw Exception("Invalid booking data");
    }
      if (hospitalId == null || hospitalId.isEmpty) {
    throw Exception("Hospital ID not found");
  }
    if (!canCancelBooking(booking)) {
    throw Exception("Only pending bookings can be cancelled");
  }
    try {
      state = state.copyWith(isLoading: true);

      await _apiService.updateBooking(bookingId, hospitalId, {
        "status": "cancel",
      });
      
      updateBookingStatus(bookingId, "cancel");
      await fetchBookings(); 
      
       state = state.copyWith(isLoading: false);

    } catch (e) {
       state = state.copyWith(isLoading: false);
      print("❌ Error cancelling booking: $e");
      rethrow;
    }
  }

  void refreshBookings() {
    fetchBookings();
    if (!state.isSocketConnected) {
      setupSocketListener();
    }
  }

  void _disposeSocket() {
    _socket?.off('bookingCreated');
    _socket?.off('bookingUpdate');
    _socket?.off('bookingStatusChanged');
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  @override
  void dispose() {
    _disposeSocket();
    state.searchController.dispose();
    super.dispose();
  }
}

// ─────────────────────────────────────────────
//  HELPER PROVIDERS
// ─────────────────────────────────────────────

// final filteredBookingsProvider = Provider<List<Map<String, dynamic>>>((ref) {
//   final state = ref.watch(bookingStateProvider);
//   final bookings = state.bookings;
//   final selectedFilter = state.selectedFilter;
//   final searchQuery = state.searchQuery;
//   final selectedDate = state.selectedDate;

//   return bookings.where((b) {
//     final matchesFilter = selectedFilter == "All" ||
//         b["status"] == selectedFilter.toLowerCase();
//     final matchesSearch = b["hospital"].toString().toLowerCase().contains(
//           searchQuery.toLowerCase(),
//         ) ||
//         b["doctor"].toString().toLowerCase().contains(
//           searchQuery.toLowerCase(),
//         );
//     final matchesDate = selectedDate == null ||
//         b["date"] == DateFormat('yyyy-MM-dd').format(selectedDate);
//     return matchesFilter && matchesSearch && matchesDate;
//   }).toList();
// });
final filteredBookingsProvider = Provider<List<Map<String, dynamic>>>((ref) {
  final state = ref.watch(bookingStateProvider);
  final bookings = state.bookings;
  final selectedFilter = state.selectedFilter;
  final searchQuery = state.searchQuery;
  final selectedDate = state.selectedDate;

  return bookings.where((b) {
    // Status filter
    final matchesFilter = selectedFilter == "All" ||
        b["status"].toString().toLowerCase() == selectedFilter.toLowerCase();
    
    // Search filter
    final matchesSearch = searchQuery.isEmpty ||
        b["hospital"].toString().toLowerCase().contains(searchQuery.toLowerCase()) ||
        b["doctor"].toString().toLowerCase().contains(searchQuery.toLowerCase());
    
    // Date filter - fix this part
    bool matchesDate = true;
    if (selectedDate != null) {
      final bookingDateStr = b["date"]?.toString();
      if (bookingDateStr != null && bookingDateStr != "N/A" && bookingDateStr != "Invalid date") {
        try {
          final bookingDate = DateTime.parse(bookingDateStr);
          matchesDate = bookingDate.year == selectedDate.year &&
                        bookingDate.month == selectedDate.month &&
                        bookingDate.day == selectedDate.day;
        } catch (e) {
          matchesDate = false;
        }
      } else {
        matchesDate = false;
      }
    }
    
    return matchesFilter && matchesSearch && matchesDate;
  }).toList();
});