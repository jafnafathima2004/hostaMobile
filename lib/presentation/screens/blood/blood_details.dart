import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hosta/presentation/screens/blood/widgets/delete_alert.dart';
import 'package:hosta/presentation/screens/blood/donate.dart';
import 'package:hosta/providers/blood_details_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyBloodDetailsPage extends ConsumerStatefulWidget {
  final String userId;

  const MyBloodDetailsPage({super.key, required this.userId});

  @override
  ConsumerState<MyBloodDetailsPage> createState() => _MyBloodDetailsPageState();
}

class _MyBloodDetailsPageState extends ConsumerState<MyBloodDetailsPage> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(bloodProvider.notifier).fetchDonor(widget.userId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final donor = ref.watch(bloodProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Blood Details",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth * 0.05,
          ),
        ),
        backgroundColor: Colors.red,
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
      body: donor == null
          ? _noDonorUI(context, screenWidth, screenHeight)
          : _donorUI(context, donor, screenWidth, screenHeight),
    );
  }

  /// 🔹 NO DONOR UI
  Widget _noDonorUI(
    BuildContext context,
    double screenWidth,
    double screenHeight,
  ) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(screenWidth * 0.04),
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.bloodtype, size: screenWidth * 0.15),
              SizedBox(height: screenHeight * 0.0125),
              Text(
                "No Donor Profile Found",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: screenWidth * 0.04,
                ),
              ),
              SizedBox(height: screenHeight * 0.0125),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Donate()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.06,
                    vertical: screenHeight * 0.015,
                  ),
                ),
                child: Text(
                  "Register as Donor",
                  style: TextStyle(fontSize: screenWidth * 0.035),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 DONOR UI
  Widget _donorUI(
    BuildContext context,
    Map<String, dynamic> donor,
    double screenWidth,
    double screenHeight,
  ) {
    return Padding(
      padding: EdgeInsets.all(screenWidth * 0.04),
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.03),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Blood Donation Details",
                style: TextStyle(
                  fontSize: screenWidth * 0.045,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(thickness: screenWidth * 0.0025),
              SizedBox(height: screenHeight * 0.005),
              Text(
                "Blood Group: ${donor['bloodGroup'] ?? '-'}",
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.005),
              Text(
                "Phone: ${donor['phone'] ?? '-'}",
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "DOB: ${donor['dateOfBirth']?.toString().split('T').first ?? '-'}",
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.01),
              Text(
                "Address: ${donor['address']?['place'] ?? ''}, "
                "${donor['address']?['district'] ?? ''}, "
                "${donor['address']?['state'] ?? ''}",
                style: TextStyle(fontSize: screenWidth * 0.04),
              ),
              SizedBox(height: screenHeight * 0.025),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  /// 🔹 DELETE
                  IconButton(
                    icon: Icon(
                      Icons.delete,
                      color: Colors.red,
                      size: screenWidth * 0.06,
                    ),
                    onPressed: () {
                      deleteAlert(
                        context,
                        onConfirm: () async {
                          await ref.read(bloodProvider.notifier).deleteDonor();

                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('bloodId');

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "Deleted Successfully",
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                              backgroundColor: Colors.green,
                            ),
                          );
                        },
                      );
                    },
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
