// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

class MaizeDetailPage extends StatefulWidget {
  const MaizeDetailPage({Key? key}) : super(key: key);

  @override
  _MaizeDetailPageState createState() => _MaizeDetailPageState();
}

class _MaizeDetailPageState extends State<MaizeDetailPage> {
  late PageController _pageController;
  late List<Map<String, dynamic>> tileData;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    tileData = [
{
        'title': AppLocalizations.of(context)?.soilType ?? 'Soil Type',
        'description': AppLocalizations.of(context)?.maize_soil_type_key ??
            'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1PbGI9NTz_eVtHBqgxdNdppvZ7IjvPUhS'
        ],
      },
      {
        'title':
            AppLocalizations.of(context)?.seedRate ?? 'Seed Rate (kg/acre)',
        'description': AppLocalizations.of(context)?.maize_seed_rate_key ??
            'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1emhFc_5q-UMlST8s5Mb9W91rZxrNr927',
        ],
      },
      {
        'title':
            AppLocalizations.of(context)?.seedTreatment ?? 'Seed Treatment',
        'description':
            AppLocalizations.of(context)?.maize_seed_treatment_key ??
                'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1PbGI9NTz_eVtHBqgxdNdppvZ7IjvPUhS'
        ],
      },
      {
        'title':
            AppLocalizations.of(context)?.growingSeason ?? 'Growing Season',
        'description':
            AppLocalizations.of(context)?.maize_growing_season_key ??
                'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1emhFc_5q-UMlST8s5Mb9W91rZxrNr927',
        ],
      },
      {
        'title': AppLocalizations.of(context)?.cropDuration ?? 'Crop Duration',
        'description': AppLocalizations.of(context)?.maize_crop_duration_key ??
            'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1PbGI9NTz_eVtHBqgxdNdppvZ7IjvPUhS'
        ],
      },
      {
        'title': AppLocalizations.of(context)?.irrigationSchedule ??
            'Irrigation Schedule',
        'description':
            AppLocalizations.of(context)?.maize_irrigation_schedule_key ??
                'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1emhFc_5q-UMlST8s5Mb9W91rZxrNr927',
        ],
      },
      {
        'title': AppLocalizations.of(context)?.nutrientManagement ??
            'Nutrient Management(NPK) in Kg',
        'description':
            AppLocalizations.of(context)?.maize_nutrient_requirement_key ??
                'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1PbGI9NTz_eVtHBqgxdNdppvZ7IjvPUhS'
        ],
      },
      {
        'title':
            AppLocalizations.of(context)?.weedManagement ?? 'Weed Management',
        'description':
            AppLocalizations.of(context)?.maize_weed_management_key ??
                'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1emhFc_5q-UMlST8s5Mb9W91rZxrNr927',
        ],
      },
      {
        'title': AppLocalizations.of(context)?.diseaseAndPestManagement ??
            'Disease and Pest Management',
        'description': AppLocalizations.of(context)
                ?.maize_disease_and_pest_management_key ??
            'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1PbGI9NTz_eVtHBqgxdNdppvZ7IjvPUhS'
        ],
      },
      {
        'title': AppLocalizations.of(context)?.harvesting ?? 'Harvesting',
        'description': AppLocalizations.of(context)?.maize_harvesting_key ??
            'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1emhFc_5q-UMlST8s5Mb9W91rZxrNr927',
        ],
      },
      {
        'title':
            AppLocalizations.of(context)?.postHarvesting ?? 'Post Harvesting',
        'description':
            AppLocalizations.of(context)?.maize_post_harvesting_key ??
                'Default Description',
        'imageUrls': [
          'https://drive.google.com/uc?export=view&id=1SGWUDSzRA0-A3Rg2ZuLnQ4n2N8A5TXys',
          'https://drive.google.com/uc?export=view&id=1PbGI9NTz_eVtHBqgxdNdppvZ7IjvPUhS'
        ],
      },
       ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(child: _buildPageView()),
            _buildNavigationBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              AppLocalizations.of(context)?.maize ?? 'Maize',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show info dialog or navigation
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      itemCount: tileData.length,
      onPageChanged: (index) {
        setState(() => _currentPage = index);
      },
      itemBuilder: (context, index) {
        return _buildContentCard(tileData[index]);
      },
    );
  }

Widget _buildContentCard(Map<String, dynamic> data) {
  return Card(
    margin: const EdgeInsets.all(16),
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildImageCarousel(data['imageUrls']),
        Expanded(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data['title'],
                    style: GoogleFonts.poppins(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data['description'],
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildImageCarousel(List<String> imageUrls) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PageView.builder(
        itemCount: imageUrls.length,
        itemBuilder: (context, index) {
          return CachedNetworkImage(
            imageUrl: imageUrls[index],
            fit: BoxFit.cover,
            placeholder: (context, url) => Center(
              child: Lottie.asset('assets/1.json', width: 100, height: 100),
            ),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          );
        },
      ),
    );
  }

  Widget _buildNavigationBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: _currentPage > 0
                ? () => _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    )
                : null,
          ),
          Text(
            '${_currentPage + 1}/${tileData.length}',
            style: GoogleFonts.poppins(fontSize: 16),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_forward_ios),
            onPressed: _currentPage < tileData.length - 1
                ? () => _pageController.nextPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    )
                : null,
          ),
        ],
      ),
    );
  }
}