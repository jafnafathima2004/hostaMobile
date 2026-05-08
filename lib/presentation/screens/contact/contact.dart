import 'package:flutter/material.dart';
import 'package:hosta/services/api_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Contact extends StatefulWidget {
  const Contact({super.key});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  bool isSubmitting = false;
  String? statusMessage;
  bool isSuccess = false;

  final ApiService _apiService = ApiService();

  Future<void> _submitFeedback() async {
    // Validate fields
    if (nameController.text.isEmpty) {
      setState(() {
        statusMessage = "Please enter your name";
        isSuccess = false;
      });
      return;
    }
    
    if (emailController.text.isEmpty) {
      setState(() {
        statusMessage = "Please enter your email";
        isSuccess = false;
      });
      return;
    }
    
    if (!_isValidEmail(emailController.text)) {
      setState(() {
        statusMessage = "Please enter a valid email address";
        isSuccess = false;
      });
      return;
    }
    
    if (messageController.text.isEmpty) {
      setState(() {
        statusMessage = "Please enter your message";
        isSuccess = false;
      });
      return;
    }

    setState(() {
      isSubmitting = true;
      statusMessage = null;
    });

    try {
      // Create beautiful HTML email template
      String htmlContent = _buildEmailTemplate(
        name: nameController.text,
        email: emailController.text,
        message: messageController.text,
      );

      // Prepare data for API
      final emailData = {
        "from": emailController.text,
        "to": "hostahealthcare@gmail.com",
        "subject": "New Contact Form Message from ${nameController.text}",
        "text": htmlContent, // Send HTML content
      };

      // Send email using your API endpoint
      final response = await _apiService.sendEmail(emailData);

      if (response.statusCode == 200) {
        setState(() {
          statusMessage = "✅ Thank you for contacting us! We'll get back to you soon.";
          isSuccess = true;
          nameController.clear();
          emailController.clear();
          messageController.clear();
        });
      } else {
        setState(() {
          statusMessage = "❌ Failed to send message. Please try again.";
          isSuccess = false;
        });
      }
    } catch (e) {
      setState(() {
        statusMessage = "⚠️ Network error. Please check your connection.";
        isSuccess = false;
      });
    }

    setState(() {
      isSubmitting = false;
    });
  }

  // Email validation
  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  // Beautiful HTML email template
  String _buildEmailTemplate({
    required String name,
    required String email,
    required String message,
  }) {
    return '''
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
    </head>
    <body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4;">
      <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f4f4f4; padding: 20px;">
        <tr>
          <td align="center">
            <table width="600" cellpadding="0" cellspacing="0" border="0" style="background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
              
              <!-- Header with Green Background -->
              <tr>
                <td style="background: linear-gradient(135deg, #43a047 0%, #2e7d32 100%); padding: 30px 20px; text-align: center;">
                  <h1 style="color: #ffffff; margin: 0; font-size: 28px; font-weight: 600;">Hosta Healthcare</h1>
                  <p style="color: #e8f5e9; margin: 10px 0 0 0; font-size: 16px;">New Contact Form Submission</p>
                </td>
              </tr>
              
              <!-- Content -->
              <tr>
                <td style="padding: 40px 30px;">
                  <!-- Greeting -->
                  <p style="color: #2e7d32; font-size: 18px; margin: 0 0 20px 0; font-weight: 500;">👋 You have a new message!</p>
                  
                  <!-- Sender Details Card -->
                  <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f1f8e9; border-radius: 10px; margin-bottom: 25px; border-left: 4px solid #43a047;">
                    <tr>
                      <td style="padding: 20px;">
                        <h3 style="color: #2e7d32; margin: 0 0 15px 0; font-size: 18px; font-weight: 600;">📋 Sender Information</h3>
                        <table width="100%" cellpadding="5" cellspacing="0" border="0">
                          <tr>
                            <td width="100" style="color: #558b2f; font-weight: 500;">Name:</td>
                            <td style="color: #333333; font-weight: 500;">$name</td>
                          </tr>
                          <tr>
                            <td style="color: #558b2f; font-weight: 500;">Email:</td>
                            <td style="color: #333333;">
                              <a href="mailto:$email" style="color: #43a047; text-decoration: none; font-weight: 500;">$email</a>
                            </td>
                          </tr>
                        </table>
                      </td>
                    </tr>
                  </table>
                  
                  <!-- Message Card -->
                  <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #ffffff; border-radius: 10px; margin-bottom: 25px; border: 1px solid #e0e0e0;">
                    <tr>
                      <td style="padding: 20px;">
                        <h3 style="color: #2e7d32; margin: 0 0 15px 0; font-size: 18px; font-weight: 600;">💬 Message</h3>
                        <p style="color: #555555; line-height: 1.6; margin: 0; font-size: 15px; background-color: #fafafa; padding: 15px; border-radius: 8px; border-left: 3px solid #43a047;">
                          ${message.replaceAll('\n', '<br>')}
                        </p>
                      </td>
                    </tr>
                  </table>
                  
                  <!-- Reply Button -->
                  <table width="100%" cellpadding="0" cellspacing="0" border="0">
                    <tr>
                      <td align="center">
                        <a href="mailto:$email?subject=Re: Your message to Hosta Healthcare" style="display: inline-block; background: linear-gradient(135deg, #43a047 0%, #2e7d32 100%); color: #ffffff; text-decoration: none; padding: 12px 30px; border-radius: 25px; font-weight: 500; font-size: 16px; margin: 10px 0;">
                          ↩️ Reply to $name
                        </a>
                      </td>
                    </tr>
                  </table>
                </td>
              </tr>
              
              <!-- Footer -->
              <tr>
                <td style="background-color: #f1f8e9; padding: 20px 30px; text-align: center; border-top: 1px solid #c8e6c9;">
                  <p style="color: #558b2b; margin: 0 0 10px 0; font-size: 14px;">This message was sent from the Hosta Healthcare contact form.</p>
                  <p style="color: #558b2b; margin: 0; font-size: 13px;">© ${DateTime.now().year} Hosta Healthcare. All rights reserved.</p>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </body>
    </html>
    ''';
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Could not open $url"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;
    final isSmallScreen = screenWidth < 600;
    final isTablet = screenWidth >= 600 && screenWidth < 1200;
    final isDesktop = screenWidth >= 1200;
    
    // Responsive padding
    final horizontalPadding = isDesktop ? screenWidth * 0.1 : (isTablet ? screenWidth * 0.05 : screenWidth * 0.04);
    final cardPadding = isSmallScreen ? screenWidth * 0.05 : screenWidth * 0.06;
    final fontSize = isSmallScreen ? screenWidth * 0.05 : (isTablet ? screenWidth * 0.055 : screenWidth * 0.06);
    final buttonHeight = isSmallScreen ? screenHeight * 0.068 : screenHeight * 0.073;
    
    return Scaffold(
      backgroundColor: const Color(0xFFECFDF5),
      appBar: AppBar(
        backgroundColor: Colors.green,
        elevation: 2,
        toolbarHeight: isSmallScreen ? kToolbarHeight : (isTablet ? 64 : 72),
        title: Text(
          "Contact Us",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: isSmallScreen ? screenWidth * 0.05 : screenWidth * 0.055,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: isSmallScreen ? screenWidth * 0.05 : screenWidth * 0.06),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: screenHeight * 0.02),
        child: Column(
          children: [
            _buildCard(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isSmallScreen: isSmallScreen,
              cardPadding: cardPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Send Us a Message",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? screenHeight * 0.015 : screenHeight * 0.02),
                  
                  // Name Field
                  _buildInputField(
                    label: "Your Name *",
                    controller: nameController,
                    hint: "Enter your full name",
                    icon: Icons.person_outline,
                    isSmallScreen: isSmallScreen,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  
                  // Email Field
                  _buildInputField(
                    label: "Email Address *",
                    controller: emailController,
                    hint: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                    isSmallScreen: isSmallScreen,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  
                  // Message Field
                  _buildInputField(
                    label: "Your Message *",
                    controller: messageController,
                    hint: "How can we help you?",
                    maxLines: 5,
                    icon: Icons.message_outlined,
                    isSmallScreen: isSmallScreen,
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                  ),
                  
                  SizedBox(height: isSmallScreen ? screenHeight * 0.02 : screenHeight * 0.025),
                  
                  // Submit Button
                  SizedBox(
                    width: double.infinity,
                    height: buttonHeight,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : _submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(screenWidth * 0.025),
                        ),
                        elevation: 2,
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              height: isSmallScreen ? screenWidth * 0.06 : screenWidth * 0.07,
                              width: isSmallScreen ? screenWidth * 0.06 : screenWidth * 0.07,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, color: Colors.white, size: isSmallScreen ? screenWidth * 0.05 : screenWidth * 0.055),
                                SizedBox(width: screenWidth * 0.02),
                                Text(
                                  "Send Message",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? screenWidth * 0.04 : screenWidth * 0.045,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  // Status Message
                  if (statusMessage != null) ...[
                    SizedBox(height: isSmallScreen ? screenHeight * 0.015 : screenHeight * 0.02),
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? screenWidth * 0.03 : screenWidth * 0.035),
                      decoration: BoxDecoration(
                        color: isSuccess 
                            ? Colors.green.withOpacity(0.1) 
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(screenWidth * 0.02),
                        border: Border.all(
                          color: isSuccess ? Colors.green : Colors.red,
                          width: screenWidth * 0.0025,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSuccess ? Icons.check_circle : Icons.error,
                            color: isSuccess ? Colors.green : Colors.red,
                            size: isSmallScreen ? screenWidth * 0.05 : screenWidth * 0.055,
                          ),
                          SizedBox(width: screenWidth * 0.02),
                          Expanded(
                            child: Text(
                              statusMessage!,
                              style: TextStyle(
                                color: isSuccess ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: isSmallScreen ? screenWidth * 0.035 : screenWidth * 0.0375,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ]
                ],
              ),
            ),

            // Social Media Section
            _buildCard(
              screenWidth: screenWidth,
              screenHeight: screenHeight,
              isSmallScreen: isSmallScreen,
              cardPadding: cardPadding,
              child: Column(
                children: [
                  Text(
                    "Get in Touch",
                    style: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.w600,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: isSmallScreen ? screenHeight * 0.025 : screenHeight * 0.03),
                  
                  // Contact Info
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? screenWidth * 0.0375 : screenWidth * 0.045),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(screenWidth * 0.025),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.green, size: isSmallScreen ? screenWidth * 0.05 : screenWidth * 0.055),
                        SizedBox(width: screenWidth * 0.02),
                        Text(
                          "hostahealthcare@gmail.com",
                          style: TextStyle(
                            fontSize: isSmallScreen ? screenWidth * 0.035 : screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? screenHeight * 0.025 : screenHeight * 0.03),
                  
                  // Social Icons - Responsive layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      return Wrap(
                        spacing: isSmallScreen ? screenWidth * 0.05 : (isTablet ? screenWidth * 0.075 : screenWidth * 0.1),
                        runSpacing: screenHeight * 0.02,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildSocialButton(
                            icon: Icons.phone,
                            label: "Call",
                            onTap: () => _openUrl("tel:8714412090"),
                            isSmallScreen: isSmallScreen,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          _buildSocialButton(
                            icon: FontAwesomeIcons.whatsapp,
                            label: "WhatsApp",
                            isFaIcon: true,
                            onTap: () => _openUrl("https://wa.me/918714412090"),
                            isSmallScreen: isSmallScreen,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          _buildSocialButton(
                            icon: FontAwesomeIcons.facebook,
                            label: "Facebook",
                            isFaIcon: true,
                            onTap: () => _openUrl("https://www.facebook.com/profile.php?id=61568947746890&mibextid=LQQJ4d"),
                            isSmallScreen: isSmallScreen,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          _buildSocialButton(
                            icon: FontAwesomeIcons.instagram,
                            label: "Instagram",
                            isFaIcon: true,
                            onTap: () => _openUrl("https://www.instagram.com/hosta_healthcare/?igsh=MnR6d3h0YTJlbXEy"),
                            isSmallScreen: isSmallScreen,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                          _buildSocialButton(
                            icon: Icons.email,
                            label: "Email",
                            onTap: () => _openUrl("mailto:hostahealthcare@gmail.com?subject=Inquiry&body=Hello Hosta,"),
                            isSmallScreen: isSmallScreen,
                            screenWidth: screenWidth,
                            screenHeight: screenHeight,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required dynamic icon,
    required String label,
    required VoidCallback onTap,
    bool isFaIcon = false,
    required bool isSmallScreen,
    required double screenWidth,
    required double screenHeight,
  }) {
    final buttonSize = isSmallScreen ? screenWidth * 0.125 : screenWidth * 0.1375;
    final iconSize = isSmallScreen ? screenWidth * 0.06 : screenWidth * 0.07;
    final fontSize = isSmallScreen ? screenWidth * 0.0275 : screenWidth * 0.03;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(screenWidth * 0.075),
          child: Container(
            width: buttonSize,
            height: buttonSize,
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isFaIcon
                  ? FaIcon(icon, color: Colors.green, size: iconSize)
                  : Icon(icon, color: Colors.green, size: iconSize),
            ),
          ),
        ),
        SizedBox(height: screenHeight * 0.005),
        Text(
          label,
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }

  Widget _buildCard({
    required Widget child,
    required double screenWidth,
    required double screenHeight,
    required bool isSmallScreen,
    required double cardPadding,
  }) {
    final maxWidth = screenWidth > 800 ? 800.0 : double.infinity;
    
    return Center(
      child: Container(
        width: maxWidth,
        margin: EdgeInsets.only(bottom: screenHeight * 0.02),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(screenWidth * 0.04),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: screenWidth * 0.025,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
    required IconData icon,
    required bool isSmallScreen,
    required double screenWidth,
    required double screenHeight,
  }) {
    final fontSize = isSmallScreen ? screenWidth * 0.0375 : screenWidth * 0.04;
    final padding = isSmallScreen ? screenWidth * 0.03 : screenWidth * 0.035;
    final iconSize = isSmallScreen ? screenWidth * 0.05 : screenWidth * 0.055;
    
    return Padding(
      padding: EdgeInsets.only(bottom: screenHeight * 0.02),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.green,
              fontSize: fontSize,
            ),
          ),
          SizedBox(height: screenHeight * 0.0075),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
            style: TextStyle(fontSize: fontSize),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: fontSize - (screenWidth * 0.0025)),
              prefixIcon: Icon(icon, color: Colors.green, size: iconSize),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: maxLines > 1 ? screenHeight * 0.02 : padding,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(screenWidth * 0.025),
                borderSide: const BorderSide(color: Colors.green, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}