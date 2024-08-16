import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher_string.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({Key? key, required String privacyPolicyText, required String websiteUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Privacy Policy',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              const SizedBox(height: 16),
              // Privacy policy text
              Text(
                '''Welcome to CropSync (“we,” “our,” “us”). We are committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner. This Privacy Policy outlines how we collect, use, share, and protect your information when you use our IoT-based agro advisory services, purchase seeds and fertilizers, and interact with our mobile application (the “CropSync”).

1. Introduction
CropSync (“we,” “our,” “us”) is committed to protecting your privacy and ensuring that your personal information is handled in a safe and responsible manner. This Privacy Policy outlines how we collect, use, share, and protect your information when you use our IoT-based agro advisory services, purchase seeds and fertilizers, and interact with our mobile application (the “CropSync”).

2. Information We Collect
We may collect the following types of information:

Personal Information:
- Name
- Contact Information (such as email address and phone number)
- Location Data (GPS data for providing location-based advisory services)
- Payment Information (for purchases of seeds and fertilizers)

Non-Personal Information:
- Device Information (e.g., device type, operating system, unique device identifiers)
- Log Information (e.g., IP address, browser type, access times)
- Usage Data (e.g., features used, pages visited within the App)

3. How We Use Your Information
We use the collected information for the following purposes:
- Service Delivery: To provide IoT-based agro advisory services, deliver purchased products, and enhance your experience.
- Personalization: To tailor our services based on your preferences and location.
- Communication: To send you updates, newsletters, and promotional materials. You can opt out of these communications at any time.
- Payment Processing: To process transactions and manage your orders.
- Analytics: To understand how our App is used and improve our services.

4. Information Sharing and Disclosure
We do not sell or rent your personal information to third parties. We may share your information in the following scenarios:
- With Service Providers: We may share your information with third-party service providers who assist us in delivering our services (e.g., payment processors, delivery services).
- Legal Requirements: We may disclose your information if required to do so by law or in response to valid requests by public authorities (e.g., a court or a government agency).
- Business Transfers: In the event of a merger, acquisition, or sale of all or a portion of our assets, your information may be transferred as part of the transaction.

5. Data Security
We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, please note that no method of transmission over the internet or electronic storage is 100% secure.

6. Your Rights
You have the following rights regarding your personal information:
- Access: You can request access to the personal information we hold about you.
- Correction: You can request that we correct or update any inaccurate or incomplete information.
- Deletion: You can request that we delete your personal information, subject to certain legal obligations.
- Objection: You can object to the processing of your personal information under certain circumstances.
- Data Portability: You can request a copy of your personal information in a structured, machine-readable format.

To exercise any of these rights, please contact us at cropsync365@gmail.com.

7. Third-Party Links
Our App may contain links to third-party websites or services. We are not responsible for the privacy practices of these third parties. We encourage you to read the privacy policies of any third-party services you use.

8. Changes to This Privacy Policy
We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy on our App. You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.

9. Contact Us
If you have any questions about this Privacy Policy, please contact us at:
Vivekananda Global University, Jaipur
Email: cropsync365@gmail.com''',
                style: GoogleFonts.poppins(fontSize: 16),
              ),
              const SizedBox(height: 24),
              // Link to the live privacy policy
              GestureDetector(
                onTap: () {
                  launchURL('https://www.cropsync.online/privacy.php'); // Your live URL
                },
                child: Text(
                  'Privacy Policy',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void launchURL(String url) async {
    try {
      await launchUrlString(url);
    } catch (e) {
      // ignore: avoid_print
      print('Error launching URL: $e');
    }
  }
}