// ignore_for_file: library_private_types_in_public_api, avoid_print

import 'dart:async';
import 'dart:convert';
import 'package:cropsync/controller/veg_list.dart';
import 'package:cropsync/users/sidebar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:cached_network_image/cached_network_image.dart';

void main() {
  runApp(const MaterialApp(
    home: MarketpricesPage(),
  ));
}

class MarketpricesPage extends StatelessWidget {
  const MarketpricesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 0,
        title: Text(
          'Market Prices',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
      ),
      drawer: const Sidebar(
        profileImageUrl: '',
        userName: '',
      ),
      body: const MarketpricesForm(),
    );
  }
}

class MarketpricesForm extends StatefulWidget {
  const MarketpricesForm({Key? key}) : super(key: key);

  @override
  _MarketpricesFormState createState() => _MarketpricesFormState();
}

class _MarketpricesFormState extends State<MarketpricesForm> {
  final TextEditingController stateController = TextEditingController();
  final TextEditingController searchController = TextEditingController();
  final String apiKey = '579b464db66ec23bdd00000178b302e7013b49d67c2084993f975dc9';
  final String format = 'json';
  List<dynamic>? marketPrices;
  List<dynamic>? originalMarketPrices;

  final List<String> indianStates = [
    'Uttar Pradesh', 'Haryana', 'Maharashtra', 'Kerala', 'Punjab', 'Rajasthan', 
    'West Bengal', 'Madhya Pradesh', 'Gujarat', 'Telangana', 'Himachal Pradesh',
    'Tripura', 'Odisha', 'Jammu and Kashmir', 'Karnataka', 'Uttrakhand', 
    'Chattisgarh', 'Tamil Nadu', 'Nagaland', 'Chandigarh', 'NCT of Delhi', 
    'Bihar', 'Meghalaya', 'Andhra Pradesh'
  ];

  String? selectedState;
  bool isLoading = false;
  Timer? _debounce;

  int currentPage = 1;
  int itemsPerPage = 20;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    originalMarketPrices = [];
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (!isLoading && scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            fetchMarketPrices(loadMore: true);
          }
          return true;
        },
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            _buildStateSelection(),
            const SizedBox(height: 20),
            _buildFetchButton(),
            const SizedBox(height: 20),
            _buildSearchBar(),
            const SizedBox(height: 20),
            _buildResultsArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildStateSelection() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.green, width: 2),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          value: selectedState,
          hint: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              AppLocalizations.of(context)?.selectState ?? 'Select State',
              style: GoogleFonts.poppins(fontSize: 16),
            ),
          ),
          icon: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.arrow_drop_down, color: Colors.green),
          ),
          items: indianStates.map((state) {
            return DropdownMenuItem<String>(
              value: state,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(state, style: GoogleFonts.poppins(fontSize: 16)),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              selectedState = value;
              stateController.text = value!;
            });
          },
        ),
      ),
    );
  }

  Widget _buildFetchButton() {
    return ElevatedButton.icon(
      onPressed: () {
        fetchMarketPrices();
      },
      label: Text(
        AppLocalizations.of(context)?.fetchMarketPrices ?? 'Fetch Market Prices',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        border: Border.all(color: Colors.blue, width: 2),
      ),
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          if (_debounce != null) {
            _debounce!.cancel();
          }
          _debounce = Timer(const Duration(milliseconds: 500), () {
            searchDistricts(value);
          });
        },
        decoration: InputDecoration(
          hintText: AppLocalizations.of(context)?.searchDistrictOrMarketName ??
              'Search district or Market name',
          hintStyle: GoogleFonts.poppins(),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: Icon(Icons.search, color: Colors.blue),
          ),
        ),
      ),
    );
  }

  Widget _buildResultsArea() {
    if (isLoading && marketPrices == null) {
      return Center(
        child: Lottie.asset(
          'assets/1.json',
          width: 200,
          height: 200,
        ),
      );
    } else if (marketPrices != null) {
      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: marketPrices!.length + (hasMoreData ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < marketPrices!.length) {
            return _buildDistrictCard(marketPrices![index]);
          } else {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Lottie.asset(
                  'assets/1.json',
                  width: 200,
                  height: 200,
                ),
              ),
            );
          }
        },
      );
    } else {
      return Center(
        child: Text(
          AppLocalizations.of(context)?.noDataAvailable ?? 'No data available',
          style: GoogleFonts.poppins(fontSize: 18),
        ),
      );
    }
  }

  Widget _buildDistrictCard(dynamic marketData) {
    String district = marketData['district'];
    String marketName = marketData['market'];
    String commodityName = marketData['commodity'];
    String? imageUrl = commodityImages[commodityName];

   return Card(
      elevation: 8,
      margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Text(
              '$district - $marketName',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: imageUrl != null
                      ? CachedNetworkImageProvider(imageUrl)
                          as ImageProvider<Object>?
                      : const AssetImage('assets/S.png'),
                  onBackgroundImageError: (_, __) {
                    print('Error loading image');
                  },
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        commodityName,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '₹${marketData['min_price']} - ₹${marketData['max_price']}',
                        style: GoogleFonts.poppins(
                          color: Colors.green,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow('Variety', marketData['variety']),
                _buildInfoRow('Modal Price', '₹${marketData['modal_price']}'),
                _buildInfoRow('Date', marketData['arrival_date']),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> fetchMarketPrices({bool loadMore = false}) async {
    if (!loadMore) {
      currentPage = 1;
      hasMoreData = true;
    }

    if (!hasMoreData) return;

    final String state = stateController.text;
    final int offset = (currentPage - 1) * itemsPerPage;

    final Uri url = Uri.parse(
        'https://api.data.gov.in/resource/9ef84268-d588-465a-a308-a864a43d0070?api-key=$apiKey&format=$format&limit=$itemsPerPage&offset=$offset&filters[state]=$state');

    try {
      setState(() {
        if (!loadMore) marketPrices = null;
        isLoading = true;
      });

      final response = await http.get(url);
      final data = json.decode(response.body);
      final List<dynamic> newMarketPrices = data['records'];

      setState(() {
        if (loadMore) {
          marketPrices!.addAll(newMarketPrices);
        } else {
          marketPrices = newMarketPrices;
          originalMarketPrices = List.from(newMarketPrices);
        }

        if (newMarketPrices.length < itemsPerPage) {
          hasMoreData = false;
        } else {
          currentPage++;
        }
      });
    } catch (e) {
      print('Failed to fetch market prices: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void searchDistricts(String query) {
    List<dynamic>? results = [];
    if (query.isEmpty) {
      results = originalMarketPrices;
    } else {
      results = originalMarketPrices!.where((data) {
        final String district = data['district'].toLowerCase();
        final String marketName = data['market'].toLowerCase();
        return district.contains(query.toLowerCase()) ||
            marketName.contains(query.toLowerCase());
      }).toList();
    }

    setState(() {
      marketPrices = results;
    });
  }

  @override
  void dispose() {
    stateController.dispose();
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}