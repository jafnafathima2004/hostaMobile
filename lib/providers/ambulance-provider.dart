import 'dart:convert';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/api_service.dart';

// Provider for ApiService
final apiServiceProvider = Provider<ApiService>((ref) => ApiService());

// Provider for ambulance list (state notifier)
final ambulanceListProvider = StateNotifierProvider<AmbulanceNotifier, List<dynamic>>(
  (ref) => AmbulanceNotifier(ref, ref.read(apiServiceProvider)),
);

// Providers for UI state
final isLoadingProvider = StateProvider<bool>((ref) => true);
final searchQueryProvider = StateProvider<String>((ref) => '');
final selectedCountryProvider = StateProvider<String>((ref) => '');
final selectedStateProvider = StateProvider<String>((ref) => '');
final selectedDistrictProvider = StateProvider<String>((ref) => '');
final selectedPlaceProvider = StateProvider<String>((ref) => '');
final ambulanceIdProvider = StateProvider<String?>((ref) => null);

class AmbulanceNotifier extends StateNotifier<List<dynamic>> {
  final Ref _ref;
  final ApiService _apiService;

  AmbulanceNotifier(this._ref, this._apiService) : super([]);

  Future<void> fetchAmbulances() async {
    List<dynamic> newData = [];
    try {
      final searchQuery = _ref.read(searchQueryProvider);
      final country = _normalize(_ref.read(selectedCountryProvider));
      final state = _normalize(_ref.read(selectedStateProvider));
      final district = _normalize(_ref.read(selectedDistrictProvider));
      final place = _normalize(_ref.read(selectedPlaceProvider));

      final response = await _apiService.getAllAmbulances(
        serviceName: searchQuery.isEmpty ? null : searchQuery,
        country: country.isEmpty ? null : country,
        state: state.isEmpty ? null : state,
        district: district.isEmpty ? null : district,
        place: place.isEmpty ? null : place,
      );
 log("🔍 SEARCH QUERY: $searchQuery");
      if (response.statusCode == 200 && response.data != null) {
        newData = response.data is List
            ? response.data
            : response.data['data'] ?? [];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_ambulances', jsonEncode(newData));
      } else {
        newData = [];
      }
    } catch (e) {
      log("❌ API failed → loading from cache");
      final prefs = await SharedPreferences.getInstance();
      final cached = prefs.getString('cached_ambulances');
      newData = cached != null
          ? List<Map<String, dynamic>>.from(jsonDecode(cached))
          : [];
    } finally {
      this.state = newData;   // assign only once
      _ref.read(isLoadingProvider.notifier).state = false;
    }
  }

  String _normalize(String? value) {
    if (value == null || value.trim().isEmpty) return '';
    final trimmed = value.trim();
    return trimmed[0].toUpperCase() + trimmed.substring(1).toLowerCase();
  }
}