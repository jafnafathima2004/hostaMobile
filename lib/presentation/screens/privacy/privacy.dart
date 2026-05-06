import 'package:flutter/material.dart';

class Privacy extends StatelessWidget {
  const Privacy({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 1,
        title: Text(
          "Privacy Policy for Hosta",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: screenWidth * 0.045,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: screenWidth * 0.055),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      // ✅ REMOVE const here (it blocks rebuild)
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            paragraph(
                "At Hosta, developed by Zorrow Tech IT Solutions, we respect your privacy and are committed to protecting the personal information you share with us. This Privacy Policy explains how we collect, use, and safeguard your data when you use our application.", 
                screenWidth),

            heading("Information We Collect", screenWidth),
            paragraph(
                "Location Data: We access your location to show you the nearest doctors, specialties, hospitals, and ambulances.", 
                screenWidth),
            paragraph(
                "Personal Information: We collect your phone number and blood group if you choose to provide them. These are used to connect users who may need to find people nearby with specific blood groups.", 
                screenWidth),
            paragraph(
                "Healthcare Information: We display details such as doctor names, available specialties, and working hours. This information is for reference only and is not a substitute for medical advice.", 
                screenWidth),

            heading("How We Use Your Information", screenWidth),
            listItem(
                "• To provide healthcare directory services like showing doctors, specialties, and hospitals near you.", 
                screenWidth),
            listItem(
                "• To allow users to discover nearby people with specific blood groups for emergency support.", 
                screenWidth),
            listItem(
                "• To provide ambulance location details to help users in emergencies.", 
                screenWidth),
            listItem(
                "• To communicate with you if needed for support or service updates.", 
                screenWidth),

            heading("Data Sharing and Disclosure", screenWidth),
            paragraph(
                "We do not sell or rent your personal information. Your information may only be shared:", 
                screenWidth),
            listItem(
                "• With nearby users (only blood group and location visibility, if you enable it).", 
                screenWidth),
            listItem(
                "• Authentication: We use Twilio to send OTPs for login. Twilio may temporarily process your phone number only for this purpose and does not use it for any other activity.", 
                screenWidth),
            listItem("• When required by law or government authorities.", screenWidth),
            listItem(
                "• With trusted service providers who help us operate our services, under strict confidentiality agreements.", 
                screenWidth),

            heading("Data Security", screenWidth),
            paragraph(
                "We use industry-standard security measures to protect your information. However, no method of storage or transmission is 100% secure, and we cannot guarantee absolute security.", 
                screenWidth),

            heading("Your Choices", screenWidth),
            paragraph(
                "You can disable location services at any time in your device settings, though some features may not function properly without it.", 
                screenWidth),
            paragraph(
                "Data Deletion Request: If you wish to delete your account or any personal data you have shared with us, you can send an email request to zorrowtech@gmail.com. We will permanently remove your data from our systems within 30 days of receiving your request.", 
                screenWidth),

            heading("Children’s Privacy", screenWidth),
            paragraph(
                "Our app is not intended for children under 13. We do not knowingly collect data from children.", 
                screenWidth),

            heading("Disclaimer", screenWidth),
            paragraph(
                "The Hosta app provides healthcare directory information only and is not a substitute for professional medical advice, diagnosis, or treatment. Always seek the advice of a qualified healthcare provider for medical concerns.", 
                screenWidth),

            heading("Changes to this Privacy Policy", screenWidth),
            paragraph(
                "We may update this policy from time to time. Any changes will be posted on this page with the updated date.", 
                screenWidth),

            heading("Contact Us", screenWidth),
            paragraph(
                "If you have any questions or concerns about this Privacy Policy or your data, please contact us at:", 
                screenWidth),
            paragraph("Zorrow Tech IT Solutions\nEmail: zorrowtech@gmail.com\nPhone: +91-9400517720", screenWidth),

            SizedBox(height: screenHeight * 0.05),
          ],
        ),
      ),
    );
  }

  /// ---------- Helper Text Styles ----------
  Widget heading(String text, double screenWidth) => Padding(
        padding: EdgeInsets.only(top: screenHeight * 0.022, bottom: screenHeight * 0.01),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * 0.045,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
      );

  Widget paragraph(String text, double screenWidth) => Padding(
        padding: EdgeInsets.only(bottom: screenHeight * 0.012),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * 0.038,
            color: const Color(0xFF444444),
            height: 1.5,
          ),
        ),
      );

  Widget listItem(String text, double screenWidth) => Padding(
        padding: EdgeInsets.only(left: screenWidth * 0.025, bottom: screenHeight * 0.0075),
        child: Text(
          text,
          style: TextStyle(
            fontSize: screenWidth * 0.038,
            color: const Color(0xFF444444),
            height: 1.5,
          ),
        ),
      );
}