// ignore_for_file: library_private_types_in_public_api, non_constant_identifier_names, use_build_context_synchronously, use_super_parameters

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:gsheets/gsheets.dart';

class SheetPage extends StatefulWidget {
  const SheetPage({Key? key}) : super(key: key);

  @override
  _SheetPageState createState() => _SheetPageState();
}
 class _SheetPageState extends State<SheetPage> {
  late final String SheetId;
  late final Map<String, dynamic> credentials;
  late final GSheets gsheets;
  late Spreadsheet GSheetsController;
  List<Map<String, dynamic>> allRows = [];
  late final Map<String, Map<String, String>> sheetImageMap;
  late final String entryKey;

  @override
  void initState() {
    super.initState();

    // Access the credentials and sheet ID from environment variables
    SheetId = dotenv.env['SHEETS_ID']!;

    // Parse the credentials JSON string into a Map
    final credentialsString = dotenv.env['GSHEETS_CREDENTIAL'];
    if (credentialsString != null) {
      credentials = Map<String, dynamic>.from(json.decode(credentialsString));
    } else {
      throw Exception('Google Sheets credentials not found in environment variables.');
    }

    gsheets = GSheets(credentials);
    gsheetsInit();
  }

  void gsheetsInit() async {
    try {
      GSheetsController = await gsheets.spreadsheet(SheetId);

      Map<String, Map<String, String>> sheetImageMap = {
        'Sheet1': {
          'Crop Name': 'assets/images/2.png',
          'Growing Season': 'assets/images/growing_season.png',
          'Soil Type': 'assets/images/soil_type.png',
          'Crop Duration': 'assets/images/crop_duration.png',
          'Nutrient Requirement (NPK) in Kg': 'assets/images/nutrient_requirement.png',
          'Irrigation Schedule': 'assets/images/irrigation_schedule.png',
          'Weed Management': 'assets/images/weed_management.png',
          'Disease & Pest Management': 'assets/images/disease_pest_management.png',
          'Intercultivation': 'assets/images/intercultivation.png',
          'Harvesting': 'assets/images/harvesting.png',
          'Post Harvesting': 'assets/images/post_harvesting.png',
        },
        'Sheet2': {
          'Crop Name': 'assets/images/2.png',
          'Growing Season': 'assets/images/growing_season_2.png',
          'Soil Type': 'assets/images/soil_type_2.png',
          'Crop Duration': 'assets/images/crop_duration_2.png',
          'Nutrient Requirement (NPK) in Kg': 'assets/images/nutrient_requirement_2.png',
          'Irrigation Schedule': 'assets/images/irrigation_schedule_2.png',
          'Weed Management': 'assets/images/weed_management_2.png',
          'Disease & Pest Management': 'assets/images/disease_pest_management_2.png',
          'Intercultivation': 'assets/images/intercultivation_2.png',
          'Harvesting': 'assets/images/harvesting_2.png',
          'Post Harvesting': 'assets/images/post_harvesting_2.png',
        },
        'Sheet3': {
          'Crop Name': 'assets/images/2.png',
          'Growing Season': 'assets/images/growing_season_3.png',
          'Soil Type': 'assets/images/2.png',
          'Crop Duration': 'assets/images/crop_duration_3.png',
          'Nutrient Requirement (NPK) in Kg': 'assets/images/nutrient_requirement_3.png',
          'Irrigation Schedule': 'assets/images/irrigation_schedule_3.png',
          'Weed Management': 'assets/images/weed_management_3.png',
          'Disease & Pest Management': 'assets/images/disease_pest_management_3.png',
          'Intercultivation': 'assets/images/intercultivation_3.png',
          'Harvesting': 'assets/images/harvesting_3.png',
          'Post Harvesting': 'assets/images/post_harvesting_3.png',
        },
        // Add more sheets as needed
      };

      for (var entry in sheetImageMap.entries) {
        Worksheet? sheet = GSheetsController.worksheetByTitle(entry.key);
        if (sheet != null) {
          List<Map<String, String>>? rows = await sheet.values.map.allRows();
          rows?.forEach((row) {
            row['imagePath'] = entry.value[row.keys.first]!;
          });
          allRows.addAll(rows as Iterable<Map<String, dynamic>>);
        }
      }

      setState(() {
        this.sheetImageMap = sheetImageMap;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.amber,
          elevation: 10,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          content: Text(
            'Crop advisory is successfully updated!',
            style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          duration: const Duration(seconds: 1),
        ),
      );
    } catch (e) {
      // ignore: avoid_print
      print('Error fetching data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to fetch data. Please try again later.'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Crop Advisory',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 10,
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: allRows.isNotEmpty
                  ? GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: allRows.length,
                      itemBuilder: (context, index) {
                        final row = allRows[index];
                        return DepartmentCard(
                          cropname: row['Crop Name'] ?? '',
                          growingseason: row['Growing Season'] ?? '',
                          imagePath: row['imagePath'] ?? 'assets/default_image.jpg',
                          soilType: row['Soil Type'] ?? '',
                          cropDuration: row['Crop Duration'] ?? '',
                          nutrientRequirement: row['Nutrient Requirement (NPK) in Kg'] ?? '',
                          irrigationSchedule: row['Irrigation Schedule'] ?? '',
                          weedManagement: row['Weed Management'] ?? '',
                          diseaseAndPestManagement: row['Disease & Pest Management'] ?? '',
                          intercultivation: row['Intercultivation'] ?? '',
                          harvesting: row['Harvesting'] ?? '',
                          postHarvesting: row['Post Harvesting'] ?? '',
                          sheetImageMap: sheetImageMap,
                        );
                      },
                    )
                  : Lottie.asset(
                      'assets/2.json',
                      width: 200,
                      height: 200,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class DepartmentCard extends StatelessWidget {
  final String cropname;
  final String growingseason;
  final String imagePath;
  final String soilType;
  final String cropDuration;
  final String nutrientRequirement;
  final String irrigationSchedule;
  final String weedManagement;
  final String diseaseAndPestManagement;
  final String intercultivation;
  final String harvesting;
  final String postHarvesting;
  final Map<String, Map<String, String>>? sheetImageMap;

  const DepartmentCard({
    Key? key,
    required this.cropname,
    required this.growingseason,
    required this.imagePath,
    required this.soilType,
    required this.cropDuration,
    required this.nutrientRequirement,
    required this.irrigationSchedule,
    required this.weedManagement,
    required this.diseaseAndPestManagement,
    required this.intercultivation,
    required this.harvesting,
    required this.postHarvesting,
    this.sheetImageMap,
    }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DepartmentDetailsPage(
              cropname: cropname,
              growingseason: growingseason,
              additionalData: {
                'Soil Type': {
                  'value': soilType,
                  'imagePath': sheetImageMap?['Soil Type']?[soilType]!,
                },
                'Crop Duration': {
                  'value': cropDuration,
                  'imagePath': sheetImageMap?['Crop Duration']?[cropDuration]!,
                },
                'Nutrient Requirement (NPK) in Kg': {
                  'value': nutrientRequirement,
                  'imagePath': sheetImageMap?['Nutrient Requirement (NPK) in Kg']?[nutrientRequirement]!,
                },
                'Irrigation Schedule': {
                  'value': irrigationSchedule,
                  'imagePath': sheetImageMap?['Irrigation Schedule']?[irrigationSchedule]!,
                },
                'Weed Management': {
                  'value': weedManagement,
                  'imagePath': sheetImageMap?['Weed Management']?[weedManagement]!,
                },
                'Disease & Pest Management': {
                  'value': diseaseAndPestManagement,
                  'imagePath': sheetImageMap?['Disease & Pest Management']?[diseaseAndPestManagement]!,
                },
                'Intercultivation': {
                  'value': intercultivation,
                  'imagePath': sheetImageMap?['Intercultivation']?[intercultivation]!,
                },
                'Harvesting': {
                  'value': harvesting,
                  'imagePath': sheetImageMap?['Harvesting']?[harvesting]!,
                },
                'Post Harvesting': {
                  'value': postHarvesting,
                  'imagePath': sheetImageMap?['Post Harvesting']?[postHarvesting]!,
                },
              },
            ),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                cropname,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class DepartmentDetailsPage extends StatelessWidget {
  final String cropname;
  final String growingseason;
  final Map<String, Map<String, dynamic>> additionalData;

  const DepartmentDetailsPage({
    Key? key,
    required this.cropname,
    required this.growingseason,
    required this.additionalData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          cropname,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: ExpansionPanelListWidget(
          cropname: cropname,
          growingseason: growingseason,
          additionalData: additionalData,
        ),
      ),
    );
  }
}

class ExpansionPanelListWidget extends StatefulWidget {
  final String cropname;
  final String growingseason;
  final Map<String, Map<String, dynamic>> additionalData;

  const ExpansionPanelListWidget({
    Key? key,
    required this.cropname,
    required this.growingseason,
    required this.additionalData,
  }) : super(key: key);

  @override
  _ExpansionPanelListWidgetState createState() =>
      _ExpansionPanelListWidgetState();
}

class _ExpansionPanelListWidgetState extends State<ExpansionPanelListWidget> {
  late final List<Item> _data;
  int _expandedIndex = -1;

  @override
  void initState() {
    super.initState();
    _data = _generateItems(widget.additionalData);

    // Set the first panel to be initially expanded
    if (_data.isNotEmpty) {
      _expandedIndex = 0;
      _data[0].isExpanded = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      child: ExpansionPanelList(
        expandedHeaderPadding: EdgeInsets.zero,
        dividerColor: Colors.transparent,
        elevation: 2,
        animationDuration: const Duration(milliseconds: 300),
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            if (_expandedIndex != index) {
              _data[_expandedIndex].isExpanded = false;
              _data[index].isExpanded = true;
              _expandedIndex = index;
            } else {
              _data[index].isExpanded = !isExpanded;
              _expandedIndex = isExpanded ? -1 : index;
            }
          });
        },
        children: _data.map<ExpansionPanel>((Item item) {
          return ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  item.headerValue,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              );
            },
            body: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.green.shade200, Colors.green.shade100],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (item.imagePath != null)
                    Image.asset(
                      item.imagePath!,
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  const SizedBox(height: 8),
                  Text(
                    item.expandedValue,
                    style: GoogleFonts.poppins(fontSize: 16),
                  ),
                ],
              ),
            ),
            isExpanded: item.isExpanded,
          );
        }).toList(),
      ),
    );
  }
}

class Item {
  Item({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
    this.imagePath,
  });

  final String expandedValue;
  final String headerValue;
  bool isExpanded;
  final String? imagePath;
}

List<Item> _generateItems(Map<String, Map<String, dynamic>> additionalData) {
  List<Item> items = [];
  additionalData.forEach((key, value) {
    String? imagePath = value.containsKey('imagePath') ? value['imagePath'] : null;
    if (imagePath != null) {
      // Add check for image existence (optional)
      // You can use the 'path_provider' package to check file existence
      // ignore: avoid_print
      print("Image Path for $key: $imagePath"); // For debugging purposes
    }
    items.add(Item(
      expandedValue: value['value'],
      headerValue: key,
      isExpanded: false,
      imagePath: imagePath,
    ));
  });
  return items;
}