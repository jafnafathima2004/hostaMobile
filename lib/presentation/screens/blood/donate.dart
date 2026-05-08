import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hosta/providers/blood-donateprovider.dart';
import 'package:intl/intl.dart';
import 'package:hosta/common/top_snackbar.dart';

class Donate extends ConsumerStatefulWidget {
  const Donate({super.key});

  @override
  ConsumerState<Donate> createState() => _DonateState();
}

class _DonateState extends ConsumerState<Donate> {
  final _phoneController = TextEditingController();
  final _placeController = TextEditingController();
  final _pincodeController = TextEditingController();
  final _dobController = TextEditingController();
  final _countryController = TextEditingController();
  final _stateController = TextEditingController();
  final _districtController = TextEditingController();

  final List<String> bloodGroups = [
    "A+",
    "A-",
    "B+",
    "B-",
    "O+",
    "O-",
    "AB+",
    "AB-",
  ];

  @override
  void initState() {
    super.initState();
    _loadUserPhone();
  }

  Future<void> _loadUserPhone() async {
    final phoneAsync = await ref.read(userPhoneProvider.future);
    if (phoneAsync != null) {
      _phoneController.text = phoneAsync;
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final dateOfBirth = ref.read(donorFormProvider).dateOfBirth;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: dateOfBirth != null
          ? DateFormat('yyyy-MM-dd').parse(dateOfBirth)
          : DateTime(1990),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(picked);
      ref.read(donorFormProvider.notifier).updateDateOfBirth(formattedDate);
      _dobController.text = formattedDate;
    }
  }

  Future<void> _openSearchModal({
    required String title,
    required List<Map<String, dynamic>> data,
    required Function(Map<String, dynamic>) onSelected,
  }) async {
    String searchQuery = "";
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    
    await showDialog(
      context: context,
      builder: (context) {
        List<Map<String, dynamic>> filtered = data;
        return StatefulBuilder(
          builder: (context, setModalState) {
            filtered = data
                .where(
                  (item) => item['name'].toString().toLowerCase().contains(
                    searchQuery.toLowerCase(),
                  ),
                )
                .toList();

            return Center(
              child: Material(
                color: Colors.transparent,
                child: Container(
                  width: screenWidth * 0.9,
                  height: screenHeight * 0.6,
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(screenWidth * 0.03),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: screenWidth * 0.045,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.close,
                              size: screenWidth * 0.06,
                            ),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                      TextField(
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Icons.search,
                            size: screenWidth * 0.06,
                          ),
                          hintText: "Search...",
                          hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            vertical: screenHeight * 0.0125,
                          ),
                        ),
                        onChanged: (val) {
                          setModalState(() {
                            searchQuery = val;
                          });
                        },
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Expanded(
                        child: filtered.isEmpty
                            ? Center(
                                child: Text(
                                  "No results found",
                                  style: TextStyle(fontSize: screenWidth * 0.04),
                                ),
                              )
                            : ListView.builder(
                                itemCount: filtered.length,
                                itemBuilder: (context, index) {
                                  final item = filtered[index];
                                  return ListTile(
                                    title: Text(
                                      item['name'].toString(),
                                      style: TextStyle(fontSize: screenWidth * 0.04),
                                    ),
                                    onTap: () {
                                      onSelected(item);
                                      Navigator.pop(context);
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onCountrySelected(Map<String, dynamic> country) {
    ref.read(donorFormProvider.notifier).updateSelectedCountry(country);
    _countryController.text = country['name'].toString();
    _stateController.clear();
    _districtController.clear();
  }

  void _onStateSelected(Map<String, dynamic> state) {
    ref.read(donorFormProvider.notifier).updateSelectedState(state);
    _stateController.text = state['name'].toString();
    _districtController.clear();
  }

  void _onDistrictSelected(Map<String, dynamic> district) {
    ref.read(donorFormProvider.notifier).updateSelectedDistrict(district);
    _districtController.text = district['name'].toString();
  }

  Future<void> _submit() async {
    final formState = ref.read(donorFormProvider);
    final phone = _phoneController.text;
    final place = _placeController.text;
    final pincode = _pincodeController.text;

    if (phone.isEmpty ||
        formState.dateOfBirth == null ||
        formState.bloodGroup == null ||
        formState.selectedCountry == null ||
        place.isEmpty ||
        pincode.isEmpty) {
      showTopSnackBar(
        context,
        "Please fill all required fields",
        isError: true,
      );
      return;
    }

    final userId = await ref.read(userIdProvider.future);
    if (userId == null) {
      showTopSnackBar(context, "User not logged in", isError: true);
      return;
    }

    final payload = {
      "phone": phone,
      "dateOfBirth": formState.dateOfBirth,
      "bloodGroup": formState.bloodGroup,
      "address": {
        "country": formState.selectedCountry!['name'].toString(),
        "state": formState.selectedState!['name'].toString(),
        "district": formState.selectedDistrict!['name'].toString(),
        "place": place,
        "pincode": pincode,
      },
      "userId": userId,
    };

    ref.read(donorFormProvider.notifier).setLoading(true);
    
    final result = await ref.read(donorCreationProvider(payload).future);
    
    ref.read(donorFormProvider.notifier).setLoading(false);
    
    if (result) {
      showTopSnackBar(context, "Donor Created Successfully");
      Navigator.pop(context);
    } else {
      final error = ref.read(donorFormProvider).error;
      showTopSnackBar(
        context,
        error ?? 'Donate failed',
        isError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final locationAsync = ref.watch(locationDataProvider);
    final formState = ref.watch(donorFormProvider);
    final isLoading = formState.isLoading;
    final bloodGroup = formState.bloodGroup;
    final countries = locationAsync.value ?? [];
    final states = formState.states;
    final districts = formState.districts;

    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      appBar: AppBar(
        title: Text(
          "Register Blood Donor",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontSize: screenWidth * 0.05,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: screenWidth * 0.055,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: screenWidth > 600 ? 400 : double.infinity),
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                children: [
                  TextField(
                    controller: _phoneController,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                      labelText: "Phone",
                      labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                      prefixIcon: Icon(Icons.phone, size: screenWidth * 0.055),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextField(
                        controller: _dobController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(screenWidth * 0.025),
                          ),
                          labelText: "Date of Birth",
                          labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                          prefixIcon: Icon(Icons.calendar_today, size: screenWidth * 0.055),
                          hintText: "Select DOB",
                          hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.015,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  DropdownButtonFormField<String>(
                    value: bloodGroup,
                    items: bloodGroups
                        .map(
                          (bg) => DropdownMenuItem<String>(
                            value: bg,
                            child: Text(
                              bg,
                              style: TextStyle(fontSize: screenWidth * 0.04),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val != null) {
                        ref.read(donorFormProvider.notifier).updateBloodGroup(val);
                      }
                    },
                    decoration: InputDecoration(
                      labelText: "Blood Group",
                      labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                      prefixIcon: Icon(Icons.bloodtype, size: screenWidth * 0.055),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  if (locationAsync.isLoading)
                    Center(
                      child: CircularProgressIndicator(
                        strokeWidth: screenWidth * 0.008,
                      ),
                    )
                  else if (locationAsync.hasError)
                    Center(
                      child: Text(
                        "Error loading countries",
                        style: TextStyle(fontSize: screenWidth * 0.04),
                      ),
                    )
                  else
                    GestureDetector(
                      onTap: () => _openSearchModal(
                        title: "Select Country",
                        data: countries,
                        onSelected: _onCountrySelected,
                      ),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _countryController,
                          decoration: InputDecoration(
                            labelText: "Country",
                            labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                            prefixIcon: Icon(Icons.public, size: screenWidth * 0.055),
                            hintText: "Select Country",
                            hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.025),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.015),
                  if (states.isNotEmpty)
                    GestureDetector(
                      onTap: () => _openSearchModal(
                        title: "Select State",
                        data: states,
                        onSelected: _onStateSelected,
                      ),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _stateController,
                          decoration: InputDecoration(
                            labelText: "State",
                            labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                            prefixIcon: Icon(Icons.map, size: screenWidth * 0.055),
                            hintText: "Select State",
                            hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.025),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.015),
                  if (districts.isNotEmpty)
                    GestureDetector(
                      onTap: () => _openSearchModal(
                        title: "Select District",
                        data: districts,
                        onSelected: _onDistrictSelected,
                      ),
                      child: AbsorbPointer(
                        child: TextField(
                          controller: _districtController,
                          decoration: InputDecoration(
                            labelText: "District",
                            labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                            prefixIcon: Icon(Icons.location_city, size: screenWidth * 0.055),
                            hintText: "Select District",
                            hintStyle: TextStyle(fontSize: screenWidth * 0.035),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(screenWidth * 0.025),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.03,
                              vertical: screenHeight * 0.015,
                            ),
                          ),
                        ),
                      ),
                    ),
                  SizedBox(height: screenHeight * 0.015),
                  TextField(
                    controller: _placeController,
                    decoration: InputDecoration(
                      labelText: "Place (local)",
                      labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                      prefixIcon: Icon(Icons.location_on, size: screenWidth * 0.055),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  TextField(
                    controller: _pincodeController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    decoration: InputDecoration(
                      labelText: "Pincode",
                      labelStyle: TextStyle(fontSize: screenWidth * 0.035),
                      prefixIcon: Icon(Icons.pin_drop, size: screenWidth * 0.055),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.03,
                        vertical: screenHeight * 0.015,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.08,
                        vertical: screenHeight * 0.015,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(screenWidth * 0.025),
                      ),
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: screenWidth * 0.05,
                            width: screenWidth * 0.05,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: screenWidth * 0.005,
                            ),
                          )
                        : Text(
                            "Create Donor",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.04,
                            ),
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _placeController.dispose();
    _pincodeController.dispose();
    _dobController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _districtController.dispose();
    super.dispose();
  }
}