import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cropsync/controller/language_change_controller.dart'
    as lang_controller;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';
import 'package:cropsync/crop_advisory/bajra.dart';
import 'package:cropsync/crop_advisory/maize.dart';
import 'package:cropsync/crop_advisory/wheat.dart';
import 'package:cropsync/crop_advisory/jowar.dart';
import 'package:cropsync/crop_advisory/barley.dart';
import 'package:cropsync/crop_advisory/mustard.dart';
import 'package:cropsync/crop_advisory/soyabean.dart';
import 'package:cropsync/crop_advisory/grams.dart';
import 'package:cropsync/crop_advisory/chilli.dart';

class CropAdvisoryPage extends StatelessWidget {
  const CropAdvisoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<lang_controller.LanguageChangeController>(
      builder: (context, languageController, child) {
        final appLocalizations = AppLocalizations.of(context)!;
        return Scaffold(
          appBar: AppBar(
            title: Text(appLocalizations.cropAdvisory,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
            backgroundColor: Colors.teal,
            centerTitle: true,
          ),
          drawer: const Sidebar(profileImageUrl: '', userName: ''),
          body: _buildBody(context, appLocalizations),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations appLocalizations) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: CropData.getCropData(context).length,
      itemBuilder: (context, index) {
        final crop = CropData.getCropData(context)[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: ModernCropCard(
            imageUrl: crop.imageUrl,
            label: crop.label,
            onTap: () => NavigationHelper.navigateToCropDetail(context, index),
          ),
        );
      },
    );
  }
}

class ModernCropCard extends StatelessWidget {
  final String imageUrl;
  final String label;
  final VoidCallback onTap;

  const ModernCropCard({
    required this.imageUrl,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 0,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(20)),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.fitHeight,
                placeholder: (context, url) => Lottie.asset(
                  'assets/1.json',
                  fit: BoxFit.cover,
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.image_search),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Tap to learn more',
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: 40,
              height: 40,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CropData {
  final String imageUrl;
  final String label;

  CropData({required this.imageUrl, required this.label});

  static List<CropData> getCropData(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    return [
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1hGfFNKOauGXPrPzfcdi4YTYbR6TuCwKZ',
          label: appLocalizations.bajra),
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1gVNkpNGpLS5v1rxtuZQU1VJ9lCwnOG4q',
          label: appLocalizations.maize),
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1gWJ9F_CKSgeFO3c8Yu-A5wNaSXzqt3mz',
          label: appLocalizations.wheat),
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1gX5qkSOqMLAEJVesehUXs8Dx3tDOdbKA',
          label: appLocalizations.jowar),
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1gcaklCpzS4mhKeRG5kUQzVW8kPOm3lbG',
          label: appLocalizations.barley),
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1gqUV8Np-Ky8Z1mXqjaDAPEv2cr3opstJ',
          label: appLocalizations.mustard),
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1gwB3EY8o1uTev8W3lPly_fennxEsSs2U',
          label: appLocalizations.soyabean),
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1h-i89xs-R8VhhSjFqpfyQqZIf9AkT1_i',
          label: appLocalizations.grams),
      CropData(
          imageUrl:
              'https://drive.google.com/uc?export=view&id=1h9miKi_J3CxLOKb-7fhAbT3POE3VdP0U',
          label: appLocalizations.chilli),
    ];
  }
}

class NavigationHelper {
  static void navigateToCropDetail(BuildContext context, int index) {
    final List<Widget> pages = [
      const BajraDetailPage(),
      const MaizeDetailPage(),
      const WheatDetailPage(),
      const JowarDetailPage(),
      const BarleyDetailPage(),
      const MustardDetailPage(),
      const SoyabeanDetailPage(),
      const GramsDetailPage(),
      const ChilliDetailPage(),
    ];

    Future.delayed(const Duration(milliseconds: 400), () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => pages[index]),
      );
    });
  }
}
