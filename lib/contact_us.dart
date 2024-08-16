import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gsheets/gsheets.dart';
import 'package:mailto/mailto.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


class ContactUsPage extends StatefulWidget {
  const ContactUsPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name, _email, _message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'CropSync',
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),

      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)?.addressTitle??'Address:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  AppLocalizations.of(context)?.address ??'Vivekananda Global University, Jaipur, Rajasthan - 303012',
                  style: GoogleFonts.poppins(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)?.phoneTitle ??'Phone:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(AppLocalizations.of(context)?.phoneNumber ??'9182867605', style: GoogleFonts.poppins()),
                const SizedBox(height: 8),
                Text(AppLocalizations.of(context)?.emailTitle ??'Email:',
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(AppLocalizations.of(context)?.emailAddress ??'agrico247@gmail.com', style: GoogleFonts.poppins()),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)?.followUsTitle ??"Follow us on:",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: SocialIconButton(
                        imageUrl: 'assets/mail.png',
                        url: 'mailto:agrico247@gmail.com',
                        onTap: () {
                          launchMail('agrico247@gmail.com');
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SocialIconButton(
                        imageUrl: 'assets/insta.png',
                        url: 'https://www.instagram.com/cropsync_official/',
                        onTap: () {
                          launchURL(
                              'https://www.instagram.com/cropsync_official/');
                        },
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SocialIconButton(
                        imageUrl: 'assets/linkedin.png',
                        url: 'https://www.linkedin.com/company/cropsync/',
                        onTap: () {
                          launchURL(
                              'https://www.linkedin.com/company/cropsync/');
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(AppLocalizations.of(context)?.shareFeedbackTitle ??"Share your feedback :",
                    style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)?.nameLabel ??'Name',
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintStyle: GoogleFonts.poppins(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter your name';
                            }
                            return null;
                          },
                          onSaved: (value) => _name = value!,
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            floatingLabelAlignment:
                                FloatingLabelAlignment.start,
                            hintText:AppLocalizations.of(context)?.emailLabel ?? 'Email',
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintStyle: GoogleFonts.poppins(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty || !value.contains('@')) {
                              return AppLocalizations.of(context)?.emailError ??'Please enter a valid email';
                            }
                            return null;
                          },
                          onSaved: (value) => _email = value!,
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: AppLocalizations.of(context)?.messageLabel ??'Message',
                            border: const OutlineInputBorder(),
                            enabledBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                            ),
                            hintStyle: GoogleFonts.poppins(),
                          ),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return AppLocalizations.of(context)?.messageError ??'Please enter a message';
                            }
                            return null;
                          },
                          onSaved: (value) => _message = value!,
                          maxLines: 4,
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            child: Text(AppLocalizations.of(context)?.sendButtonLabel ??'Send Message',
                                style: GoogleFonts.poppins()),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                _formKey.currentState!.save();
                                await _sendToGoogleSheets(
                                    _name, _email, _message);
                                _formKey.currentState!.reset();
                                // ignore: use_build_context_synchronously
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    backgroundColor: Colors.yellow
                                        .shade600, // Custom background color
                                    content: Text(
                                      // ignore: use_build_context_synchronously
                                      AppLocalizations.of(context)?.messageSentSnackBar ??'Message sent',
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Colors.black, // Custom text color
                                      ),
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

// Function to launch email
  void launchMail(String email) async {
    final mailtoLink = Mailto(
      to: [email],
    );
    try {
      await launchUrlString('$mailtoLink');
    } catch (e) {
      // ignore: avoid_print
      print('Error launching email: $e');
    }
  }

  void launchURL(String url) async {
    try {
      await launchUrlString(url);
    } catch (e) {
      // ignore: avoid_print
      print('Error launching URL: $e');
    }
  }

  Future<void> _sendToGoogleSheets(
      String name, String email, String message) async {
    try {
      final credentials = {
        "type": "service_account",
        "project_id": "cropsync-419318",
        "private_key_id": "a9618acecdf28c648ece9c7e07f546ea49274ca6",
        "private_key":
            "-----BEGIN PRIVATE KEY-----\nMIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDbXJ8gf8UA2ozJ\nMyxtmemiQt/+STYkaGicBtlwKWB288eFjMRCReDy42hHInfFuG3rF7PehOrVysoq\nvQ5i9hWnnLSf7TC88o72KmfgmrCATr37+/TEbxvb0ZpTUjS9QNwL44rEgqe2OvNG\nWYMyfrzG0dR5T9P8wVZ2IHc6dbC12Xi75tK9QrPbFkUURAYIc5unhfSA47ibCzqi\nqzHC3kh+9bITS/P4Jat5M2dbGSSdfOEPjsaPpsJniPzhf7me7SXwz4AjH7MhWJeC\nnkaFmO+Ris7OGcyagitruDq0DvoJJjWoIfbyTI7A12zN6YkxHKCgsSe5J0bsZ8+N\noDs29hIfAgMBAAECggEABheAY8qokel/12aQaUrI7jSlO86UrlYn8Y1PJIpBn4wN\nmkviV2TRZm1iS/dtFBSXGNxDpn5SdzV2f9FYQO9MkqcLbRWNMPIbfkKXN+mT1Txa\nklDg70OWpngfrQivZkIS2lGrXOGz/p+MefuqZRCX9X2GRQgufupvmEA2j20NRz+B\nrQomqbBcvFnQ743wv6qG5Ailp+JGAg19/KvwTSOctEYlzoj/jqv4ChIzWM/CzrhH\nuVZg4WdjnEnylnSvC7bRctpT/xw9jlb1FBNfphJnkDySq7k1KAPdO8dqPNHsHHKy\nqyNBInk/KsAnsC7KPCk9w/qhEg9f5bMQWaUEmLaxoQKBgQDwSUJbvUZkWiW7ckuV\nkzgZK+3bGIDkIashzucnW8+v6hgYE4gEy8wTSfZ3QB2NbDPY52WZx9hQFVzE9RBS\nnWC7MpjLORBSML93raxzYzF/jtbVJzvoYU5EKp/a2WbxoP8wPjlHqMrTnq3bK74I\nd6rZ2bhjQEjqmZZdD1JVmoxGPQKBgQDptQ7YW9UlxKjm1nQtRzK14p8tBn9CJHzJ\nMOSJaDHIa/Rgg5cxDFimhrHEW8/CKql2NM5HQUxVq/m9Nj494KdCj4vTqDK7KVow\n2NHLDdw8cGXsG1mMR7ASEJ3/nC5fSD/mxek1g6+i8L7jKxrYpLNVg/Zeia9i7JB0\npO8PAKmbiwKBgCSye5D5OjvvTJ3xGbwRTNsDS4NPnbe5sKIsMD9hlTl/nghnSzm4\nSkWT4TFbOGg140E4Ldsrm0y3xoBKESEc6f4M/yriXyy+Ry+m9ZR1zMR3czYAlPSr\nj8F3ZQyOcVtrxC2BA0x/aeKh9Flpt88hP5Wf27pEwh4aMM2rnl52iP/dAoGAYIzn\ndCUEOtUzPiKM3oPShGf6gLx1aJrwXqHvWIEOSBGpZRIYLTA/k5SD7m5Lt5iuZ+JK\n8g8c/SvOQggd0Kx2DT6GcsvDIaVk2FdK3Mt+GA4LXW6zIQwgxmXNEGOymLSdibZr\nsSsVLYiuI+WT8rqgSAz7hHT3WzQGPdpB1P3eFB8CgYEAvbs3nsRDpZg5fkHXyTOS\n8RmxzMVfVTyVMxSeZA0FjrndkbRJOGDg1OnpjjjM+3gCfIJ2OBBKXzdU+xmAmSdz\noNFzb67u21kNfaayPR/Oruw0tJNjX7BZMVS9RPRe6xQFbP/yLqQNU0AqJAKlaGqp\nRjjQLMCzWcIfRK9Z+yrxad4=\n-----END PRIVATE KEY-----\n",
        "client_email": "cropsync@cropsync-419318.iam.gserviceaccount.com",
        "client_id": "114537892275223410551",
        "auth_uri": "https://accounts.google.com/o/oauth2/auth",
        "token_uri": "https://oauth2.googleapis.com/token",
        "auth_provider_x509_cert_url":
            "https://www.googleapis.com/oauth2/v1/certs",
        "client_x509_cert_url":
            "https://www.googleapis.com/robot/v1/metadata/x509/cropsync%40cropsync-419318.iam.gserviceaccount.com",
        "universe_domain": "googleapis.com"
      };

      final gsheets = GSheets(credentials);
      final spreadsheet = await gsheets
          .spreadsheet('1KCs5EXSX6bh1S5yr4R7O6KcOR06QiYMqmkKr8kqbK7c');
      final sheet = spreadsheet.worksheetByTitle('Sheet1');

      await sheet?.values.appendRow([name, email, message]);
    } catch (e) {
      // ignore: avoid_print
      print('Error sending data to Google Sheets: $e');
    }
  }
}

class SocialIconButton extends StatelessWidget {
  final String imageUrl;
  final String url;
  final void Function()? onTap;

  const SocialIconButton({
    required this.imageUrl,
    required this.url,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () {},
      child: Image.asset(
        imageUrl,
        width: 50,
        height: 50,
      ),
    );
  }
}
