// import 'package:flutter/material.dart';
// import 'package:hosta/services/api_service.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// class Contact extends StatefulWidget {
//   const Contact({super.key});

//   @override
//   State<Contact> createState() => _ContactState();
// }

// class _ContactState extends State<Contact> {
//   final TextEditingController nameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController messageController = TextEditingController();

//   bool isSubmitting = false;
//   String? statusMessage;
//   bool isSuccess = false;

//   final ApiService _apiService = ApiService();

//   Future<void> _submitFeedback() async {
//     // Validate fields
//     if (nameController.text.isEmpty) {
//       setState(() {
//         statusMessage = "Please enter your name";
//         isSuccess = false;
//       });
//       return;
//     }
    
//     if (emailController.text.isEmpty) {
//       setState(() {
//         statusMessage = "Please enter your email";
//         isSuccess = false;
//       });
//       return;
//     }
    
//     if (!_isValidEmail(emailController.text)) {
//       setState(() {
//         statusMessage = "Please enter a valid email address";
//         isSuccess = false;
//       });
//       return;
//     }
    
//     if (messageController.text.isEmpty) {
//       setState(() {
//         statusMessage = "Please enter your message";
//         isSuccess = false;
//       });
//       return;
//     }

//     setState(() {
//       isSubmitting = true;
//       statusMessage = null;
//     });

//     try {
//       // Create beautiful HTML email template
//       String htmlContent = _buildEmailTemplate(
//         name: nameController.text,
//         email: emailController.text,
//         message: messageController.text,
//       );

//       // Prepare data for API
//       final emailData = {
//         "from": emailController.text,
//         "to": "hostahealthcare@gmail.com",
//         "subject": "New Contact Form Message from ${nameController.text}",
//         "text": htmlContent, // Send HTML content
//       };

//       // Send email using your API endpoint
//       final response = await _apiService.sendEmail(emailData);

//       if (response.statusCode == 200) {
//         setState(() {
//           statusMessage = "✅ Thank you for contacting us! We'll get back to you soon.";
//           isSuccess = true;
//           nameController.clear();
//           emailController.clear();
//           messageController.clear();
//         });
//       } else {
//         setState(() {
//           statusMessage = "❌ Failed to send message. Please try again.";
//           isSuccess = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         statusMessage = "⚠️ Network error. Please check your connection.";
//         isSuccess = false;
//       });
//     }

//     setState(() {
//       isSubmitting = false;
//     });
//   }

//   // Email validation
//   bool _isValidEmail(String email) {
//     return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
//   }

//   // Beautiful HTML email template
//   String _buildEmailTemplate({
//     required String name,
//     required String email,
//     required String message,
//   }) {
//     return '''
//     <!DOCTYPE html>
//     <html>
//     <head>
//       <meta charset="UTF-8">
//       <meta name="viewport" content="width=device-width, initial-scale=1.0">
//     </head>
//     <body style="margin: 0; padding: 0; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f4f4;">
//       <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f4f4f4; padding: 20px;">
//         <tr>
//           <td align="center">
//             <table width="600" cellpadding="0" cellspacing="0" border="0" style="background-color: #ffffff; border-radius: 12px; overflow: hidden; box-shadow: 0 4px 12px rgba(0,0,0,0.1);">
              
//               <!-- Header with Green Background -->
//               <tr>
//                 <td style="background: linear-gradient(135deg, #43a047 0%, #2e7d32 100%); padding: 30px 20px; text-align: center;">
//                   <h1 style="color: #ffffff; margin: 0; font-size: 28px; font-weight: 600;">Hosta Healthcare</h1>
//                   <p style="color: #e8f5e9; margin: 10px 0 0 0; font-size: 16px;">New Contact Form Submission</p>
//                 </td>
//               </tr>
              
//               <!-- Content -->
//               <tr>
//                 <td style="padding: 40px 30px;">
//                   <!-- Greeting -->
//                   <p style="color: #2e7d32; font-size: 18px; margin: 0 0 20px 0; font-weight: 500;">👋 You have a new message!</p>
                  
//                   <!-- Sender Details Card -->
//                   <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #f1f8e9; border-radius: 10px; margin-bottom: 25px; border-left: 4px solid #43a047;">
//                     <tr>
//                       <td style="padding: 20px;">
//                         <h3 style="color: #2e7d32; margin: 0 0 15px 0; font-size: 18px; font-weight: 600;">📋 Sender Information</h3>
//                         <table width="100%" cellpadding="5" cellspacing="0" border="0">
//                           <tr>
//                             <td width="100" style="color: #558b2f; font-weight: 500;">Name:</td>
//                             <td style="color: #333333; font-weight: 500;">$name</td>
//                           </tr>
//                           <tr>
//                             <td style="color: #558b2f; font-weight: 500;">Email:</td>
//                             <td style="color: #333333;">
//                               <a href="mailto:$email" style="color: #43a047; text-decoration: none; font-weight: 500;">$email</a>
//                             </td>
//                           </tr>
//                         </table>
//                       </td>
//                     </tr>
//                   </table>
                  
//                   <!-- Message Card -->
//                   <table width="100%" cellpadding="0" cellspacing="0" border="0" style="background-color: #ffffff; border-radius: 10px; margin-bottom: 25px; border: 1px solid #e0e0e0;">
//                     <tr>
//                       <td style="padding: 20px;">
//                         <h3 style="color: #2e7d32; margin: 0 0 15px 0; font-size: 18px; font-weight: 600;">💬 Message</h3>
//                         <p style="color: #555555; line-height: 1.6; margin: 0; font-size: 15px; background-color: #fafafa; padding: 15px; border-radius: 8px; border-left: 3px solid #43a047;">
//                           ${message.replaceAll('\n', '<br>')}
//                         </p>
//                       </td>
//                     </tr>
//                   </table>
                  
//                   <!-- Reply Button -->
//                   <table width="100%" cellpadding="0" cellspacing="0" border="0">
//                     <tr>
//                       <td align="center">
//                         <a href="mailto:$email?subject=Re: Your message to Hosta Healthcare" style="display: inline-block; background: linear-gradient(135deg, #43a047 0%, #2e7d32 100%); color: #ffffff; text-decoration: none; padding: 12px 30px; border-radius: 25px; font-weight: 500; font-size: 16px; margin: 10px 0;">
//                           ↩️ Reply to $name
//                         </a>
//                       </td>
//                     </tr>
//                   </table>
//                 </td>
//               </tr>
              
//               <!-- Footer -->
//               <tr>
//                 <td style="background-color: #f1f8e9; padding: 20px 30px; text-align: center; border-top: 1px solid #c8e6c9;">
//                   <p style="color: #558b2b; margin: 0 0 10px 0; font-size: 14px;">This message was sent from the Hosta Healthcare contact form.</p>
//                   <p style="color: #558b2b; margin: 0; font-size: 13px;">© ${DateTime.now().year} Hosta Healthcare. All rights reserved.</p>
//                 </td>
//               </tr>
//             </table>
//           </td>
//         </tr>
//       </table>
//     </body>
//     </html>
//     ''';
//   }

//   Future<void> _openUrl(String url) async {
//     final uri = Uri.parse(url);
//     if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//             content: Text("Could not open $url"),
//             backgroundColor: Colors.red,
//           ),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFFECFDF5),
//       appBar: AppBar(
//         backgroundColor: Colors.green,
//         elevation: 2,
//         title: const Text(
//           "Contact Us",
//           style: TextStyle(
//             color: Colors.white,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//           onPressed: () => Navigator.pop(context),
//         ),
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildCard(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Send Us a Message",
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.green),
//                   ),
//                   const SizedBox(height: 12),
                  
//                   // Name Field
//                   _buildInputField(
//                     label: "Your Name *",
//                     controller: nameController,
//                     hint: "Enter your full name",
//                     icon: Icons.person_outline,
//                   ),
                  
//                   // Email Field
//                   _buildInputField(
//                     label: "Email Address *",
//                     controller: emailController,
//                     hint: "Enter your email",
//                     keyboardType: TextInputType.emailAddress,
//                     icon: Icons.email_outlined,
//                   ),
                  
//                   // Message Field
//                   _buildInputField(
//                     label: "Your Message *",
//                     controller: messageController,
//                     hint: "How can we help you?",
//                     maxLines: 5,
//                     icon: Icons.message_outlined,
//                   ),
                  
//                   const SizedBox(height: 16),
                  
//                   // Submit Button
//                   SizedBox(
//                     width: double.infinity,
//                     height: 52,
//                     child: ElevatedButton(
//                       onPressed: isSubmitting ? null : _submitFeedback,
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.green,
//                         foregroundColor: Colors.white,
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10),
//                         ),
//                         elevation: 2,
//                       ),
//                       child: isSubmitting
//                           ? const SizedBox(
//                               height: 24,
//                               width: 24,
//                               child: CircularProgressIndicator(
//                                 strokeWidth: 2,
//                                 color: Colors.white,
//                               ),
//                             )
//                           : const Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Icon(Icons.send, color: Colors.white, size: 20),
//                                 SizedBox(width: 8),
//                                 Text(
//                                   "Send Message",
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 16,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                     ),
//                   ),
                  
//                   // Status Message
//                   if (statusMessage != null) ...[
//                     const SizedBox(height: 12),
//                     Container(
//                       padding: const EdgeInsets.all(12),
//                       decoration: BoxDecoration(
//                         color: isSuccess 
//                             ? Colors.green.withOpacity(0.1) 
//                             : Colors.red.withOpacity(0.1),
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(
//                           color: isSuccess ? Colors.green : Colors.red,
//                           width: 1,
//                         ),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             isSuccess ? Icons.check_circle : Icons.error,
//                             color: isSuccess ? Colors.green : Colors.red,
//                             size: 20,
//                           ),
//                           const SizedBox(width: 8),
//                           Expanded(
//                             child: Text(
//                               statusMessage!,
//                               style: TextStyle(
//                                 color: isSuccess ? Colors.green : Colors.red,
//                                 fontWeight: FontWeight.w500,
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ]
//                 ],
//               ),
//             ),

//             // Social Media Section
//             _buildCard(
//               child: Column(
//                 children: [
//                   const Text(
//                     "Get in Touch",
//                     style: TextStyle(
//                         fontSize: 20,
//                         fontWeight: FontWeight.w600,
//                         color: Colors.green),
//                   ),
//                   const SizedBox(height: 20),
                  
//                   // Contact Info
//                   Container(
//                     padding: const EdgeInsets.all(15),
//                     decoration: BoxDecoration(
//                       color: const Color(0xFFF1F8E9),
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: const Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         Icon(Icons.email, color: Colors.green, size: 20),
//                         SizedBox(width: 8),
//                         Text(
//                           "hostahealthcare@gmail.com",
//                           style: TextStyle(
//                             fontSize: 14,
//                             fontWeight: FontWeight.w500,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
                  
//                   const SizedBox(height: 20),
                  
//                   // Social Icons
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _buildSocialButton(
//                         icon: Icons.phone,
//                         label: "Call",
//                         onTap: () => _openUrl("tel:8714412090"),
//                       ),
//                       _buildSocialButton(
//                         icon: FontAwesomeIcons.whatsapp,
//                         label: "WhatsApp",
//                         isFaIcon: true,
//                         onTap: () => _openUrl("https://wa.me/918714412090"),
//                       ),
//                       _buildSocialButton(
//                         icon: FontAwesomeIcons.facebook,
//                         label: "Facebook",
//                         isFaIcon: true,
//                         onTap: () => _openUrl("https://www.facebook.com/profile.php?id=61568947746890&mibextid=LQQJ4d"),
//                       ),
//                       _buildSocialButton(
//                         icon: FontAwesomeIcons.instagram,
//                         label: "Instagram",
//                         isFaIcon: true,
//                         onTap: () => _openUrl("https://www.instagram.com/hosta_healthcare/?igsh=MnR6d3h0YTJlbXEy"),
//                       ),
//                       _buildSocialButton(
//                         icon: Icons.email,
//                         label: "Email",
//                         onTap: () => _openUrl("mailto:hostahealthcare@gmail.com?subject=Inquiry&body=Hello Hosta,"),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSocialButton({
//     required dynamic icon,
//     required String label,
//     required VoidCallback onTap,
//     bool isFaIcon = false,
//   }) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         InkWell(
//           onTap: onTap,
//           borderRadius: BorderRadius.circular(30),
//           child: Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.green.withOpacity(0.1),
//               shape: BoxShape.circle,
//             ),
//             child: Center(
//               child: isFaIcon
//                   ? FaIcon(icon, color: Colors.green, size: 24)
//                   : Icon(icon, color: Colors.green, size: 24),
//             ),
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(label, style: const TextStyle(fontSize: 11)),
//       ],
//     );
//   }

//   Widget _buildCard({required Widget child}) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 16),
//       padding: const EdgeInsets.all(20),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.green.withOpacity(0.1),
//             blurRadius: 10,
//             offset: const Offset(0, 4),
//           )
//         ],
//       ),
//       child: child,
//     );
//   }

//   Widget _buildInputField({
//     required String label,
//     required TextEditingController controller,
//     String? hint,
//     TextInputType? keyboardType,
//     int maxLines = 1,
//     required IconData icon,
//   }) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: const TextStyle(
//               fontWeight: FontWeight.w500,
//               color: Colors.green,
//               fontSize: 15,
//             ),
//           ),
//           const SizedBox(height: 6),
//           TextField(
//             controller: controller,
//             keyboardType: keyboardType,
//             maxLines: maxLines,
//             textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
//             decoration: InputDecoration(
//               hintText: hint,
//               prefixIcon: Icon(icon, color: Colors.green, size: 20),
//               filled: true,
//               fillColor: const Color(0xFFF8FAFC),
//               contentPadding: const EdgeInsets.symmetric(
//                 horizontal: 16,
//                 vertical: 12,
//               ),
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide.none,
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: BorderSide.none,
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10),
//                 borderSide: const BorderSide(color: Colors.green, width: 1.5),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }




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
    final horizontalPadding = isDesktop ? screenWidth * 0.1 : (isTablet ? screenWidth * 0.05 : 16.0);
    final cardPadding = isSmallScreen ? 20.0 : 24.0;
    final fontSize = isSmallScreen ? 20.0 : (isTablet ? 22.0 : 24.0);
    final buttonHeight = isSmallScreen ? 52.0 : 56.0;
    
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
            fontSize: isSmallScreen ? 20 : 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.white, size: isSmallScreen ? 20 : 24),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: 16),
        child: Column(
          children: [
            _buildCard(
              screenWidth: screenWidth,
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
                  SizedBox(height: isSmallScreen ? 12 : 16),
                  
                  // Name Field
                  _buildInputField(
                    label: "Your Name *",
                    controller: nameController,
                    hint: "Enter your full name",
                    icon: Icons.person_outline,
                    isSmallScreen: isSmallScreen,
                  ),
                  
                  // Email Field
                  _buildInputField(
                    label: "Email Address *",
                    controller: emailController,
                    hint: "Enter your email",
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                    isSmallScreen: isSmallScreen,
                  ),
                  
                  // Message Field
                  _buildInputField(
                    label: "Your Message *",
                    controller: messageController,
                    hint: "How can we help you?",
                    maxLines: 5,
                    icon: Icons.message_outlined,
                    isSmallScreen: isSmallScreen,
                  ),
                  
                  SizedBox(height: isSmallScreen ? 16 : 20),
                  
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
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: isSubmitting
                          ? SizedBox(
                              height: isSmallScreen ? 24 : 28,
                              width: isSmallScreen ? 24 : 28,
                              child: const CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.send, color: Colors.white, size: isSmallScreen ? 20 : 22),
                                SizedBox(width: 8),
                                Text(
                                  "Send Message",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: isSmallScreen ? 16 : 18,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ),
                  
                  // Status Message
                  if (statusMessage != null) ...[
                    SizedBox(height: isSmallScreen ? 12 : 16),
                    Container(
                      padding: EdgeInsets.all(isSmallScreen ? 12 : 14),
                      decoration: BoxDecoration(
                        color: isSuccess 
                            ? Colors.green.withOpacity(0.1) 
                            : Colors.red.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSuccess ? Colors.green : Colors.red,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            isSuccess ? Icons.check_circle : Icons.error,
                            color: isSuccess ? Colors.green : Colors.red,
                            size: isSmallScreen ? 20 : 22,
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              statusMessage!,
                              style: TextStyle(
                                color: isSuccess ? Colors.green : Colors.red,
                                fontWeight: FontWeight.w500,
                                fontSize: isSmallScreen ? 14 : 15,
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
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Contact Info
                  Container(
                    padding: EdgeInsets.all(isSmallScreen ? 15 : 18),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F8E9),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.green, size: isSmallScreen ? 20 : 22),
                        SizedBox(width: 8),
                        Text(
                          "hostahealthcare@gmail.com",
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  SizedBox(height: isSmallScreen ? 20 : 24),
                  
                  // Social Icons - Responsive layout
                  LayoutBuilder(
                    builder: (context, constraints) {
                      // Determine if we should wrap or not
                      final shouldWrap = constraints.maxWidth < 500;
                      return Wrap(
                        spacing: isSmallScreen ? 20 : (isTablet ? 30 : 40),
                        runSpacing: 16,
                        alignment: WrapAlignment.center,
                        children: [
                          _buildSocialButton(
                            icon: Icons.phone,
                            label: "Call",
                            onTap: () => _openUrl("tel:8714412090"),
                            isSmallScreen: isSmallScreen,
                          ),
                          _buildSocialButton(
                            icon: FontAwesomeIcons.whatsapp,
                            label: "WhatsApp",
                            isFaIcon: true,
                            onTap: () => _openUrl("https://wa.me/918714412090"),
                            isSmallScreen: isSmallScreen,
                          ),
                          _buildSocialButton(
                            icon: FontAwesomeIcons.facebook,
                            label: "Facebook",
                            isFaIcon: true,
                            onTap: () => _openUrl("https://www.facebook.com/profile.php?id=61568947746890&mibextid=LQQJ4d"),
                            isSmallScreen: isSmallScreen,
                          ),
                          _buildSocialButton(
                            icon: FontAwesomeIcons.instagram,
                            label: "Instagram",
                            isFaIcon: true,
                            onTap: () => _openUrl("https://www.instagram.com/hosta_healthcare/?igsh=MnR6d3h0YTJlbXEy"),
                            isSmallScreen: isSmallScreen,
                          ),
                          _buildSocialButton(
                            icon: Icons.email,
                            label: "Email",
                            onTap: () => _openUrl("mailto:hostahealthcare@gmail.com?subject=Inquiry&body=Hello Hosta,"),
                            isSmallScreen: isSmallScreen,
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
  }) {
    final buttonSize = isSmallScreen ? 50.0 : 55.0;
    final iconSize = isSmallScreen ? 24.0 : 28.0;
    final fontSize = isSmallScreen ? 11.0 : 12.0;
    
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
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
        SizedBox(height: 4),
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
    required bool isSmallScreen,
    required double cardPadding,
  }) {
    final maxWidth = screenWidth > 800 ? 800.0 : double.infinity;
    
    return Center(
      child: Container(
        width: maxWidth,
        margin: const EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(cardPadding),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              blurRadius: 10,
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
  }) {
    final fontSize = isSmallScreen ? 15.0 : 16.0;
    final padding = isSmallScreen ? 12.0 : 14.0;
    final iconSize = isSmallScreen ? 20.0 : 22.0;
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
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
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            keyboardType: keyboardType,
            maxLines: maxLines,
            textInputAction: maxLines == 1 ? TextInputAction.next : TextInputAction.newline,
            style: TextStyle(fontSize: fontSize),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(fontSize: fontSize - 1),
              prefixIcon: Icon(icon, color: Colors.green, size: iconSize),
              filled: true,
              fillColor: const Color(0xFFF8FAFC),
              contentPadding: EdgeInsets.symmetric(
                horizontal: padding,
                vertical: maxLines > 1 ? 16 : padding,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.green, width: 1.5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}