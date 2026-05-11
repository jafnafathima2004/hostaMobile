import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hosta/common/top_snackbar.dart';
import 'package:hosta/firebase_msg.dart';
import 'package:hosta/presentation/widgets/bottomnav.dart';
import 'package:hosta/services/api_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpVerification extends StatefulWidget {
  final String phone;
  final String? verificationId; // CHANGE THIS: from backendOtp to verificationId
  final VoidCallback onResendOtp;
  final ApiService apiService;

  const OtpVerification({
    super.key,
    required this.phone,
    this.verificationId, // CHANGE THIS
    required this.onResendOtp,
    required this.apiService,
  });

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  final TextEditingController otpController = TextEditingController();
  int resendAfter = 30;
  bool isVerifying = false;
  bool isOtpFilled = false;
  String? otpError;

  @override
  void initState() {
    super.initState();
    _startResendTimer(); // Moved timer here
  }

  void _startResendTimer() {
    if (resendAfter > 0) {
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted && resendAfter > 0) {
          setState(() => resendAfter--);
          _startResendTimer();
        }
      });
    }
  }

  Future<void> _verifyOtp() async {
    String otp = otpController.text;
    
    if (otp.length != 6) {
      setState(() {
        otpError = "Please enter a valid 6-digit OTP";
      });
      return;
    }

    setState(() {
      isVerifying = true;
      otpError = null;
    });

    try {
      String? token = await FirebaseMsg().token;

      // CHANGED: Use verifyOtp with verificationId
      final Map<String, dynamic> requestData = {
        "phone": widget.phone,
        "otp": otp,
        "FcmToken": token,
      };
      
      // Add verificationId if available
      if (widget.verificationId != null) {
        requestData['verificationId'] = widget.verificationId;
      }

      final response = await widget.apiService.otpUser(requestData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final userData = response.data['userDetails'] ?? response.data;
        
        final userId = userData['_id'] ?? userData['id'];
        final userPhone = userData['phone'] ?? widget.phone;
        final donorId = userData['donorId'];

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', userId);
        await prefs.setString('userPhone', userPhone);

        // Store token if returned
        if (response.data['token'] != null) {
          await prefs.setString('authToken', response.data['token']);
        }

        if (donorId != null && donorId.toString().isNotEmpty) {
          await prefs.setString('bloodId', donorId.toString());
        }

        if (mounted) {
          showTopSnackBar(context, "Login successful!");
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const Bottomnav()),
            (route) => false,
          );
        }
      } else {
        setState(() {
          otpError = response.data["message"] ?? "Invalid OTP. Please try again.";
          isVerifying = false;
        });
      }
    } on DioException catch (dioError) {
      String errorMessage = "Something went wrong";
      if (dioError.response != null) {
        try {
          errorMessage = dioError.response?.data['message'] ?? 
                        dioError.response?.data['error'] ?? 
                        errorMessage;
        } catch (_) {}
      }
      setState(() {
        otpError = errorMessage;
        isVerifying = false;
      });
    } catch (e) {
      log("OTP Verification Error: $e");
      setState(() {
        otpError = "Invalid OTP. Please try again.";
        isVerifying = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.smartphone_rounded,
                color: Colors.green,
                size: 30,
              ),
            ),
            const SizedBox(height: 16),

            const Text(
              "Enter Verification Code",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            Text(
              "Code sent to ${widget.phone}",
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
            const SizedBox(height: 24),

            LayoutBuilder(
              builder: (context, constraints) {
                double fieldWidth = (constraints.maxWidth - 40) / 6;

                return PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: otpController,
                  keyboardType: TextInputType.number,
                  animationType: AnimationType.fade,
                  animationDuration: const Duration(
                    milliseconds: 300,
                  ),
                  autoDismissKeyboard: true,
                  enablePinAutofill: true,
                  autoFocus: true,
                  textStyle: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(12),
                    fieldHeight: 55,
                    fieldWidth: fieldWidth.clamp(35, 50),
                    activeFillColor: Colors.white,
                    selectedFillColor: Colors.white,
                    inactiveFillColor: Colors.grey[50],
                    activeColor: otpError != null ? Colors.red : Colors.green,
                    selectedColor: otpError != null ? Colors.red : Colors.blue,
                    inactiveColor: otpError != null ? Colors.red : Colors.grey[300]!,
                    borderWidth: 2,
                  ),
                  onCompleted: (value) {
                    if (!isVerifying) {
                      _verifyOtp();
                    }
                  },
                  onChanged: (value) {
                    if (otpError != null) {
                      setState(() {
                        otpError = null;
                      });
                    }
                    if (value.length == 6 && !isVerifying && !isOtpFilled) {
                      setState(() => isOtpFilled = true);
                      Future.delayed(const Duration(milliseconds: 800), () {
                        if (mounted && !isVerifying) {
                          _verifyOtp();
                        }
                      });
                    }
                  },
                );
              },
            ),

            if (otpError != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Row(
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 14,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        otpError!,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 24),

            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: isVerifying ? null : _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: isVerifying
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        "Verify & Login",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Didn't receive code? ",
                  style: TextStyle(color: Colors.grey[600]),
                ),
                resendAfter > 0
                    ? TweenAnimationBuilder(
                        tween: Tween<double>(
                          begin: resendAfter.toDouble(),
                          end: 0,
                        ),
                        duration: Duration(seconds: resendAfter),
                        builder: (context, double value, child) {
                          return Text(
                            "Resend in ${value.toInt()}s",
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        },
                      )
                    : GestureDetector(
                        onTap: isVerifying
                            ? null
                            : () {
                                Navigator.pop(context);
                                widget.onResendOtp();
                              },
                        child: const Text(
                          "Resend OTP",
                          style: TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }
}