import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te')
  ];

  /// No description provided for @helloWorld.
  ///
  /// In en, this message translates to:
  /// **'Hello world'**
  String get helloWorld;

  /// No description provided for @cropSync.
  ///
  /// In en, this message translates to:
  /// **'CropSync'**
  String get cropSync;

  /// No description provided for @aboutUs.
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// No description provided for @aboutUsDescription.
  ///
  /// In en, this message translates to:
  /// **'CropSync is an agritech startup dedicated to revolutionizing the agricultural sector. Our mission is to empower farmers with innovative solutions and data-driven insights to enhance crop productivity and improve livelihoods.'**
  String get aboutUsDescription;

  /// No description provided for @joinUs.
  ///
  /// In en, this message translates to:
  /// **'Join us on our journey towards sustainable agriculture!'**
  String get joinUs;

  /// No description provided for @ourServices.
  ///
  /// In en, this message translates to:
  /// **'Our Services'**
  String get ourServices;

  /// No description provided for @soilTesting.
  ///
  /// In en, this message translates to:
  /// **'Soil Testing'**
  String get soilTesting;

  /// No description provided for @soilTestingDescription.
  ///
  /// In en, this message translates to:
  /// **'Get detailed analysis of your soil composition to optimize crop yield.'**
  String get soilTestingDescription;

  /// No description provided for @cropAdvisory.
  ///
  /// In en, this message translates to:
  /// **'Crop Advisory'**
  String get cropAdvisory;

  /// No description provided for @cropAdvisoryDescription.
  ///
  /// In en, this message translates to:
  /// **'Receive expert guidance and recommendations for crop management and cultivation.'**
  String get cropAdvisoryDescription;

  /// No description provided for @agriFinance.
  ///
  /// In en, this message translates to:
  /// **'Agri Finance'**
  String get agriFinance;

  /// No description provided for @agriFinanceDescription.
  ///
  /// In en, this message translates to:
  /// **'Explore financing options tailored to the needs of farmers and agriculture businesses.'**
  String get agriFinanceDescription;

  /// No description provided for @farmInputSupplies.
  ///
  /// In en, this message translates to:
  /// **'Farm Input Supplies'**
  String get farmInputSupplies;

  /// No description provided for @farmInputSuppliesDescription.
  ///
  /// In en, this message translates to:
  /// **'Browse a wide range of high-quality farm inputs and supplies for your agricultural needs.'**
  String get farmInputSuppliesDescription;

  /// No description provided for @bajra.
  ///
  /// In en, this message translates to:
  /// **'Bajra'**
  String get bajra;

  /// No description provided for @maize.
  ///
  /// In en, this message translates to:
  /// **'Maize'**
  String get maize;

  /// No description provided for @wheat.
  ///
  /// In en, this message translates to:
  /// **'Wheat'**
  String get wheat;

  /// No description provided for @jowar.
  ///
  /// In en, this message translates to:
  /// **'Jowar'**
  String get jowar;

  /// No description provided for @mustard.
  ///
  /// In en, this message translates to:
  /// **'Mustard'**
  String get mustard;

  /// No description provided for @soyabean.
  ///
  /// In en, this message translates to:
  /// **'Soyabean'**
  String get soyabean;

  /// No description provided for @grams.
  ///
  /// In en, this message translates to:
  /// **'Grams'**
  String get grams;

  /// No description provided for @chilli.
  ///
  /// In en, this message translates to:
  /// **'Chilli'**
  String get chilli;

  /// No description provided for @guar.
  ///
  /// In en, this message translates to:
  /// **'Guar'**
  String get guar;

  /// No description provided for @barley.
  ///
  /// In en, this message translates to:
  /// **'Barley'**
  String get barley;

  /// No description provided for @soilType.
  ///
  /// In en, this message translates to:
  /// **'Soil Type'**
  String get soilType;

  /// No description provided for @seedRate.
  ///
  /// In en, this message translates to:
  /// **'Seed Rate (kg/acre)'**
  String get seedRate;

  /// No description provided for @seedTreatment.
  ///
  /// In en, this message translates to:
  /// **'Seed Treatment'**
  String get seedTreatment;

  /// No description provided for @growingSeason.
  ///
  /// In en, this message translates to:
  /// **'Growing Season'**
  String get growingSeason;

  /// No description provided for @cropDuration.
  ///
  /// In en, this message translates to:
  /// **'Crop Duration'**
  String get cropDuration;

  /// No description provided for @irrigationSchedule.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Schedule'**
  String get irrigationSchedule;

  /// No description provided for @nutrientManagement.
  ///
  /// In en, this message translates to:
  /// **'Nutrient Management(NPK) in Kg'**
  String get nutrientManagement;

  /// No description provided for @weedManagement.
  ///
  /// In en, this message translates to:
  /// **'Weed Management'**
  String get weedManagement;

  /// No description provided for @diseaseAndPestManagement.
  ///
  /// In en, this message translates to:
  /// **'Disease & Pest Management'**
  String get diseaseAndPestManagement;

  /// No description provided for @harvesting.
  ///
  /// In en, this message translates to:
  /// **'Harvesting'**
  String get harvesting;

  /// No description provided for @postHarvesting.
  ///
  /// In en, this message translates to:
  /// **'Post Harvesting'**
  String get postHarvesting;

  /// No description provided for @title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get title;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description:'**
  String get description;

  /// No description provided for @images.
  ///
  /// In en, this message translates to:
  /// **'Image:'**
  String get images;

  /// No description provided for @barley_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'Sandy Loam Soil'**
  String get barley_soil_type_key;

  /// No description provided for @barley_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'20-25 kg/acre'**
  String get barley_seed_rate_key;

  /// No description provided for @barley_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Prevention of Gundia (Ergot Disease):\nSoak seeds in a 20% salt solution for 5 minutes.\nRemove floating seeds and debris, then wash and dry the remaining seeds.\nGeneral Treatment:\nApply 3 grams of thiram per kilogram of seed.\nTermite Control:\nUse 3.3 milliliters of Thiamethoxam 30 FS per kilogram of seed.\nFor Alkaline and Saline Soil:\nSoak seeds in a 1% sodium sulphate solution for 12 hours.\nWash and dry seeds, then treat with fungicide before sowing for better germination.'**
  String get barley_seed_treatment_key;

  /// No description provided for @barley_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'November - December'**
  String get barley_growing_season_key;

  /// No description provided for @barley_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'90-120 days'**
  String get barley_crop_duration_key;

  /// No description provided for @barley_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'Pre-sowing: Ensure soil moisture is sufficient for germination. Pre-irrigation may be necessary if soil moisture is low.\nGermination to Seedling Establishment (1-3 weeks): Irrigate every 7-10 days to support seedling establishment. Apply light irrigation to maintain soil moisture.\nVegetative Growth (4-8 weeks): Increase irrigation frequency to every 10-12 days, depending on soil moisture and rainfall. Provide sufficient water for optimal vegetative growth.\nCritical Growth Stages (Tillering, Booting, Heading): Ensure consistent soil moisture during these stages. Irrigate every 7-10 days or as needed.\nLate Growth Stage (Grain Filling to Maturity): Reduce irrigation frequency as the crop approaches maturity. Avoid excessive irrigation during grain filling to prevent lodging.'**
  String get barley_irrigation_schedule_key;

  /// No description provided for @barley_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N): 40-60 kg\nPhosphorus (P): 20-30 kg\nPotassium (K): 20-30 kg'**
  String get barley_nutrient_requirement_key;

  /// No description provided for @barley_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Cultural Practices: Proper seedbed preparation, crop rotation, and timely sowing help suppress weeds in barley fields.\nMechanical Control: Hand weeding, inter-row cultivation, and shallow tillage can effectively manage weeds in barley crops.\nChemical Control:\nPre-emergence herbicides: Pendimethalin, Metribuzin, and Clodinafop-propargyl are commonly used pre-emergence herbicides for weed control in barley.\nPost-emergence herbicides: Post-emergence herbicides like 2,4-D, Metsulfuron-methyl, and Bromoxynil are used to control emerged weeds in barley fields.'**
  String get barley_weed_management_key;

  /// No description provided for @barley_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Shootfly:\nSymptoms: Wilting and drying of central leaf.\nCultural Control: Adjust planting time, increase seed rate, remove dead heart seedlings.\nChemical Control: Seed treatment with Furadan or imidacloprid, spray with methyl demeton or neem seed kernel extract.\nStem Borer:\nSymptoms: Transparent windows on leaves, stem tunnelling.\nCultural Control: Uproot and burn stubbles, chop stems.\nChemical Control: Apply Malathion or Furadan into whorls, use Carbofuran granules or Metasystox spray.\nShootbug:\nSymptoms: Twisted, dried leaves, plant death.\nChemical Control: Spray with phosphomidon or Dimethoate.\nAphids:\nSymptoms: Yellowing leaves, honeydew production.\nChemical Control: Spray with Metasystox or Dimethoate, treat seeds with imidacloprid or thiamethoxam.\nEar Head Midge:\nSymptoms: Red maggots in grains, grain drying.\nManagement: Spray cypermethrin at flowering and milk stages.\nMites:\nSymptoms: Webbing on leaves, leaf redness and drying.\nManagement: Spray Dimethoate or Dicofol.\nGrainmold Damage:\nSymptoms: Discolored grains, yield loss.\nCultural Control: Timely harvesting and drying.\nChemical Control: Spray with Aureofungin or Captan.\nErgot:\nSymptoms: Honeydew exudation, blackened grains.\nControl: Wash seeds in salt solution, spray with benlate or Propiconazole.\nPlant Rot:\nSymptoms: Black or pink fungus growth on grains.\nManagement: Spray Mancozeb during flowering, soft dough, and ripening stages.\nLeaf Spot:\nSymptoms: Leaf diseases due to rain and humidity.\nManagement: Spray Zaineb or Mancozeb as needed.'**
  String get barley_disease_and_pest_management_key;

  /// No description provided for @barley_intercultivation_key.
  ///
  /// In en, this message translates to:
  /// **'Weeding: Remove weeds manually or with tools to avoid competition for nutrients.\nMulching: Use organic mulch like straw to suppress weeds and conserve moisture.\nInter-row Cultivation: Loosen soil between rows for better aeration and root growth.\nThinning: Remove overcrowded plants to ensure proper spacing and healthy growth.\nIntercropping: Plant compatible crops between barley rows for better land use.\nCompanion Planting: Grow plants that benefit barley, like those that repel pests.\nCrop Rotation: Rotate barley with different crops to maintain soil health.\nWater Management: Use efficient irrigation methods to water barley effectively.\nSoil Conservation: Prevent soil erosion with practices like contour plowing.\nIntegrated Pest Management: Control pests and diseases with natural methods whenever possible.\nMonitoring: Regularly check barley fields for issues and take action promptly.\nConsultation: Seek advice from experts for specific guidance on barley cultivation.'**
  String get barley_intercultivation_key;

  /// No description provided for @barley_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'March - April'**
  String get barley_harvesting_key;

  /// No description provided for @barley_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Drying:\nDry harvested barley in open areas until moisture content is less than 15%.\nAim for a drying duration of 3-4 days to achieve optimal moisture levels for storage.\nShelling:\nUse a sheller to separate barley kernels from the cobs efficiently.\nEnsure kernels are thoroughly dried until moisture content reaches 10-12% for better storage.\nPackaging:\nStore dried barley kernels in clean, labeled gunny bags.\nSeal bags properly and store them in a designated storage area to maintain quality.'**
  String get barley_post_harvesting_key;

  /// No description provided for @weatherTitle.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherTitle;

  /// No description provided for @advisoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Advisory'**
  String get advisoryTitle;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @marketTitle.
  ///
  /// In en, this message translates to:
  /// **'Market'**
  String get marketTitle;

  /// No description provided for @contactTitle.
  ///
  /// In en, this message translates to:
  /// **'Contact'**
  String get contactTitle;

  /// No description provided for @soilTestings.
  ///
  /// In en, this message translates to:
  /// **'Soil Testing'**
  String get soilTestings;

  /// No description provided for @cropAdvisorys.
  ///
  /// In en, this message translates to:
  /// **'Crop Advisory'**
  String get cropAdvisorys;

  /// No description provided for @weatherAlerts.
  ///
  /// In en, this message translates to:
  /// **'Weather Alerts'**
  String get weatherAlerts;

  /// No description provided for @farmInputs.
  ///
  /// In en, this message translates to:
  /// **'Farm Inputs'**
  String get farmInputs;

  /// No description provided for @selectState.
  ///
  /// In en, this message translates to:
  /// **'Select State'**
  String get selectState;

  /// No description provided for @fetchMarketPrices.
  ///
  /// In en, this message translates to:
  /// **'Fetch Market Prices'**
  String get fetchMarketPrices;

  /// No description provided for @searchDistrictOrMarketName.
  ///
  /// In en, this message translates to:
  /// **'Search district or Market name'**
  String get searchDistrictOrMarketName;

  /// No description provided for @commodityLabel.
  ///
  /// In en, this message translates to:
  /// **'Commodity'**
  String get commodityLabel;

  /// No description provided for @varietyLabel.
  ///
  /// In en, this message translates to:
  /// **'Variety'**
  String get varietyLabel;

  /// No description provided for @priceLabel.
  ///
  /// In en, this message translates to:
  /// **'Price'**
  String get priceLabel;

  /// No description provided for @uttarPradesh.
  ///
  /// In en, this message translates to:
  /// **'Uttar Pradesh'**
  String get uttarPradesh;

  /// No description provided for @haryana.
  ///
  /// In en, this message translates to:
  /// **'Haryana'**
  String get haryana;

  /// No description provided for @maharashtra.
  ///
  /// In en, this message translates to:
  /// **'Maharashtra'**
  String get maharashtra;

  /// No description provided for @kerala.
  ///
  /// In en, this message translates to:
  /// **'Kerala'**
  String get kerala;

  /// No description provided for @punjab.
  ///
  /// In en, this message translates to:
  /// **'Punjab'**
  String get punjab;

  /// No description provided for @rajasthan.
  ///
  /// In en, this message translates to:
  /// **'Rajasthan'**
  String get rajasthan;

  /// No description provided for @westBengal.
  ///
  /// In en, this message translates to:
  /// **'West Bengal'**
  String get westBengal;

  /// No description provided for @madhyaPradesh.
  ///
  /// In en, this message translates to:
  /// **'Madhya Pradesh'**
  String get madhyaPradesh;

  /// No description provided for @gujarat.
  ///
  /// In en, this message translates to:
  /// **'Gujarat'**
  String get gujarat;

  /// No description provided for @telangana.
  ///
  /// In en, this message translates to:
  /// **'Telangana'**
  String get telangana;

  /// No description provided for @himachalPradesh.
  ///
  /// In en, this message translates to:
  /// **'Himachal Pradesh'**
  String get himachalPradesh;

  /// No description provided for @tripura.
  ///
  /// In en, this message translates to:
  /// **'Tripura'**
  String get tripura;

  /// No description provided for @odisha.
  ///
  /// In en, this message translates to:
  /// **'Odisha'**
  String get odisha;

  /// No description provided for @jammuandKashmir.
  ///
  /// In en, this message translates to:
  /// **'Jammu and Kashmir'**
  String get jammuandKashmir;

  /// No description provided for @karnataka.
  ///
  /// In en, this message translates to:
  /// **'Karnataka'**
  String get karnataka;

  /// No description provided for @uttarakhand.
  ///
  /// In en, this message translates to:
  /// **'Uttarakhand'**
  String get uttarakhand;

  /// No description provided for @chhattisgarh.
  ///
  /// In en, this message translates to:
  /// **'Chhattisgarh'**
  String get chhattisgarh;

  /// No description provided for @tamilNadu.
  ///
  /// In en, this message translates to:
  /// **'Tamil Nadu'**
  String get tamilNadu;

  /// No description provided for @nagaland.
  ///
  /// In en, this message translates to:
  /// **'Nagaland'**
  String get nagaland;

  /// No description provided for @chandigarh.
  ///
  /// In en, this message translates to:
  /// **'Chandigarh'**
  String get chandigarh;

  /// No description provided for @nctofDelhi.
  ///
  /// In en, this message translates to:
  /// **'National Capital Territory of Delhi'**
  String get nctofDelhi;

  /// No description provided for @bihar.
  ///
  /// In en, this message translates to:
  /// **'Bihar'**
  String get bihar;

  /// No description provided for @meghalaya.
  ///
  /// In en, this message translates to:
  /// **'Meghalaya'**
  String get meghalaya;

  /// No description provided for @andhraPradesh.
  ///
  /// In en, this message translates to:
  /// **'Andhra Pradesh'**
  String get andhraPradesh;

  /// No description provided for @marketPrices.
  ///
  /// In en, this message translates to:
  /// **'Market Prices'**
  String get marketPrices;

  /// No description provided for @temperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get temperature;

  /// No description provided for @humidity.
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// No description provided for @windSpeed.
  ///
  /// In en, this message translates to:
  /// **'WindSpeed'**
  String get windSpeed;

  /// No description provided for @weatherDescription.
  ///
  /// In en, this message translates to:
  /// **'Weather'**
  String get weatherDescription;

  /// No description provided for @precipitationProbability.
  ///
  /// In en, this message translates to:
  /// **'Chance of Rain'**
  String get precipitationProbability;

  /// No description provided for @bajra_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'Sandy Loam Soil, Sandy Soil'**
  String get bajra_soil_type_key;

  /// No description provided for @bajra_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'1.6 Kg/acre'**
  String get bajra_seed_rate_key;

  /// No description provided for @bajra_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Prevention of Gundia (Ergot Disease):\nSoak seeds in 20% salt solution for 5 minutes.\nRemove floating seeds and debris, then wash and dry remaining seeds.\nGeneral Treatment:\nApply 3 g of thiram per kg of seed.\nTermite Control:\nUse 3.3 ml Thiamethoxam 30 FS per kg of seed.\nFor Alkaline and Saline Soil:\nSoak seeds in 1% sodium sulphate solution for 12 hours.\nWash and dry seeds, then treat with fungicide before sowing for better germination.'**
  String get bajra_seed_treatment_key;

  /// No description provided for @bajra_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'June - July'**
  String get bajra_growing_season_key;

  /// No description provided for @bajra_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'90-100 days'**
  String get bajra_crop_duration_key;

  /// No description provided for @bajra_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'Pre-sowing:\nEnsure soil moisture is adequate. Perform land preparation to facilitate water penetration.\nPre-irrigation may be necessary if soil moisture is low.\nGermination to Seedling Establishment (1-3 weeks):\nIrrigate every 5-7 days to maintain soil moisture for seed germination and establishment.\nApply light irrigation to prevent waterlogging.\nVegetative Growth (4-8 weeks):\nIncrease irrigation frequency to every 7-10 days, depending on rainfall and soil moisture.\nApply sufficient water to support vigorous vegetative growth.\nCritical Growth Stages (Tillering, Flowering, Grain Filling):\nMaintain consistent soil moisture during these stages.\nIrrigate every 10-15 days or as needed to prevent moisture stress.\nLate Growth Stage (Maturity):\nGradually reduce irrigation frequency as the crop nears maturity to facilitate drying for harvest.\nAvoid overwatering during this stage to prevent lodging and fungal diseases.'**
  String get bajra_irrigation_schedule_key;

  /// No description provided for @bajra_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N): 20-30 kg\nPhosphorus (P): 10-15 kg\nPotassium (K): 10-15 kg'**
  String get bajra_nutrient_requirement_key;

  /// No description provided for @bajra_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Cultural Practices: Adequate soil preparation, proper row spacing, and timely planting help promote rapid crop establishment and competitiveness against weeds.\nMechanical Control: Hand weeding, inter-row cultivation, and shallow hoeing are effective methods for controlling weeds in bajra fields.\nChemical Control:\nPre-emergence herbicides: Atrazine, Metribuzin, and Pendimethalin are commonly used pre-emergence herbicides for controlling grassy and broadleaf weeds in bajra.\nPost-emergence herbicides: For post-emergence weed control, herbicides like 2,4-D, Metsulfuron-methyl, and Glyphosate can be used, depending on the weed species present.'**
  String get bajra_weed_management_key;

  /// No description provided for @bajra_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Disease\nDowny Mildew:\nSymptoms: Appearance of yellow to whitish powdery growth on the lower surface of leaves.\nChemical Control: The symptoms of the disease appear, Carbendazim 50% WP or thiophenate methyl 70% WP dissolved in 2 grams per litre of water should be sprayed twice at intervals of 10 days.\nErgot: \nSymptoms:\nThis fungal disease affects the bajra flowers, replacing them with dark. These ergots are poisonous to humans and animals.\nChemical Control:\nTo save the crop, spray 1 kg Zineb or 0.6 to 0.8 kg Mancozeb 2-3 times at an interval of 2-3 days at the time of emergence of the head. This will reduce the outbreak.\nRust: \nSymptoms: This fungal disease causes orange-brown pustules on leaves and stems. It can reduce yields and grain quality.\nChemical Control: Spray 2Hexaconazole 75% WG26.7 g/acre to control rust in the standing crop of pearl millet, one month after sowing, keeping the nozzle between the rows 6 inches above the surface.\nPests:\nShoot Fly: \nSymptoms: Infested plants exhibit dead hearts (drying of central leaves).\nChemical control:\nOne of the following chemicals should be sprinkled by dissolving it in 200-240 Litres of water per acre.\nOxydemeton-methyl 25 % EC 400 ml per acre or Imidacloprid 70 % WS 400 ml per acre.\nStem Borers:\nSymptoms: Presence of larvae within the stem, causing wilting and stunting of plants.\nChemical control:\nOne of the following chemicals should be dissolved in 200-240 litres of water per acre and sprayed.\nChlorantraniliprole 18.50 % SC 60ml/acre or Thiamethoxam 25 % WG 40g per acre or Dimethoate 30% EC 0.4 L per acre.\nPest affected plants should be uprooted and destroyed in the initial stage.\nSpraying of NSKE (Neemshat) / 5 % at least 2 times to reduce the number of insects.\nAphids:\nSymptoms: Colonization of aphids on the undersides of leaves, causing stunted growth and yellowing.\nChemical control:\nChlorantraniliprole 18.50% SC: Mix 60 ml of the product per acre with 200-240 litres of water and spray thoroughly on the crop.\nThiamethoxam 25% WG: Apply 40 grams of the product per acre mixed with 200-240 litres of water and spray on the affected plants.\nDimethoate 30% EC: Use 0.4 litres of the product diluted in 200-240 litres of water per acre for spraying.\nArmyworms:\nSymptoms: Presence of caterpillars feeding on leaves and stems.\nChemical control:\nChlorantraniliprole 18.50% SC: Mix 60ml/acre in 200-240 litres of water per acre and spray.\nThiamethoxam 25% WG: Mix 40g/acre in 200-240 litres of water per acre and spray.\nDimethoate 30% EC: Mix 0.4 litres/acre in 200-240 litres of water per acre and spray.'**
  String get bajra_disease_and_pest_management_key;

  /// No description provided for @bajra_intercultivation_key.
  ///
  /// In en, this message translates to:
  /// **'Intercultivation is done twice or thrice at 3, 5 and 7 weeks after sowing to check the weed growth which also helps in conserving soil moisture by providing top soil mulch.'**
  String get bajra_intercultivation_key;

  /// No description provided for @bajra_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'September - October'**
  String get bajra_harvesting_key;

  /// No description provided for @bajra_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Drying:\nBajra cobs are dried in open areas until moisture content is less than 15%.\nOptimal drying duration is 3-4 days for seeds to reach 15% moisture.\nPopcorn varieties should be dried in shade only when seed moisture is between 30-35% to prevent grain cracking.\nShelling:\nUse a sheller to separate kernels from cobs efficiently.\nEnsure kernels are dried until moisture content reaches 10-12% for better storage.\nPackaging:\nStore dried Bajra kernels in clean gunny bags to maintain quality.\nProperly label and seal bags before storing in a designated storage area.'**
  String get bajra_post_harvesting_key;

  /// No description provided for @chilli_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'Sandy Loam Soil, Loamy Soil'**
  String get chilli_soil_type_key;

  /// No description provided for @chilli_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'Direct Sowing: 2.5kg seeds per 1 acre \n TrayMethod: 70gm seeds per 1 acre \nTraditionalMethod: 650gm seeds per 40 sqmt nursery bed'**
  String get chilli_seed_rate_key;

  /// No description provided for @chilli_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Control of sap-sucking insects can be done by treating the seed with Imidacloprid @ 8ml-10ml/kg seed before sowing. Treat the seed with Mancozeb or Carbendazim @ 3gm/kg seed before sowing to control any soil borne diseases like damping off.'**
  String get chilli_seed_treatment_key;

  /// No description provided for @chilli_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'(K) June - July (R) October - November'**
  String get chilli_growing_season_key;

  /// No description provided for @chilli_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'90-120 days'**
  String get chilli_crop_duration_key;

  /// No description provided for @chilli_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'Pre-sowing: Ensure soil moisture is adequate for germination. Pre-irrigation may be necessary if soil moisture is low.\nGermination to Seedling Establishment (1-3 weeks): Irrigate every 5-7 days to support seedling establishment. Apply moderate irrigation to maintain soil moisture.\nVegetative Growth (4-8 weeks): Increase irrigation frequency to every 7-10 days, depending on soil moisture and rainfall. Provide sufficient water for vigorous vegetative growth.\nCritical Growth Stages (Vegetative Growth, Flowering, Fruit Setting): Maintain consistent soil moisture during these stages. Irrigate every 4-5 days or as needed.\nLate Growth Stage (Maturity): Gradually reduce irrigation frequency as the crop matures. Avoid overwatering during maturity to prevent fruit deterioration.'**
  String get chilli_irrigation_schedule_key;

  /// No description provided for @chilli_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N): 80-100 kg\nPhosphorus (P): 40-50 kg\nPotassium (K): 40-50 kg'**
  String get chilli_nutrient_requirement_key;

  /// No description provided for @chilli_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Cultural Practices: Proper seedbed preparation, mulching, and timely weeding help manage weeds in chilli fields.\nMechanical Control: Hand weeding, inter-row cultivation, and mulching with plastic or organic materials are effective methods for weed control in chilli crops.\nChemical Control:\nPre-emergence herbicides: Pendimethalin, Metribuzin, and Oxyfluorfen are commonly used pre-emergence herbicides for weed control in chilli.\nPost-emergence herbicides: Post-emergence herbicides like Glyphosate, Bentazon, and Paraquat are used to control emerged weeds in chilli fields.'**
  String get chilli_weed_management_key;

  /// No description provided for @chilli_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Diseases and Control for Chilli Plants:\nDamping Off\nSymptoms: Rotting of base in nursery plants, patchy plant death.\nControl: Avoid high seed density, treat seeds with Mancozeb, apply Metalaxyl + Mancozeb or Copper Oxychloride sprays.\nCercospora Leaf Spot\nSymptoms: White spots with brown margins on leaves, yellowing under shade.\nControl: Spray Azoxystrobin, Mancozeb + Carbendazim, or Mancozeb (Dithane M-45).\nBacterial Leaf Spot\nSymptoms: Small brown spots with pale yellow rings on leaves.\nControl: Spray Streptocycline + Copper Oxychloride mix.\nDie Back and Fruit Rot\nSymptoms: Brown spots on fruit, overall plant and fruit dryness.\nControl: Treat seeds with Mancozeb or Carbendazim, spray Tebuconazole, Pyraclostrobin + Metiram, Difenoconazole, Copper Hydroxide, Propiconazole, or Azoxystrobin.\nChoanephora Blight\nSymptoms: Stem lesions leading to stem rot.\nControl: Spray Pyraclostrobin + Metiram or Streptocycline + Copper Oxychloride mix.\nWILT\nSymptoms: Sudden wilting, white mycelial growth on stem base.\nControl: Rotate crops, drench with Bordeaux mixture or Copper Oxychloride, apply Trichoderma with manure.\nPowdery Mildew\nSymptoms: White ash spots on leaf undersides, spreading to leaf tops.\nControl: Spray wettable sulphur, Karathane, Myclobutanil, Hexaconazole.\nLeaf Curl Virus\nSymptoms: Wrinkled yellow leaves, curled leaf edges.\nControl: Rotate crops, seed treatment with Imidacloprid, set up yellow sticky traps, spray Acetamiprid, Spiromesifen, Thiomethoxam, or Diafenthiuron.\nCucumber Mosaic Virus\nSymptoms: Thinning pale leaves, black spots on fruits.\nControl: Spray Imidacloprid or Acetamiprid.\nPeanut Bud Necrosis\nSymptoms: Black spots, yellow leaf spots, stunted growth.\nControl: Treat seeds with Imidacloprid, use Neem seed infusion, spray Acetamiprid, Spinosad, Diafenthiuron, or Fipronil.\nIntegrated Management of Virus Diseases\nUse Neem cake, Azadirachtin, and practice Integrated Nutrient Management.\nSpray Neem seed kernel extract or neem leaf extract.\nUse Chilli Garlic Paste or Fermented Buttermilk.\nFollow safety precautions while spraying pesticides.\nInsect Pest Control:\nThrips: Seed treatment with Imidacloprid, spray Acetamiprid or Spinosad.\nMites: Spray wettable sulphur, Propargite, Fenpyroximate, or Spiromesifen.\nWhitefly: Spray Imidachloprid, Acetamiprid, Spiromesifen, Diafenthiuron, or Thiamethoxam.\nAphids: Spray Imidacloprid or Acetamiprid.\nIntegrated Pest Management (POD Borers)\nDeep summer ploughing, sow maize or jowar around the field, use pheromone traps, apply NPV larval equivalents, establish bird perches, and destroy egg masses.\nChilli Midge\nMix Neem oil or spray Chlorantraniliprole.\nSafety Measures:\nRead pesticide labels, check sprayers, wear protective gear, and store pesticides safely.\nDispose of empty pesticide bottles properly.\nFollow indigenous pest management methods like Neem seed kernel or leaf extract, Chilli Garlic Paste, or Fermented Buttermilk.'**
  String get chilli_disease_and_pest_management_key;

  /// No description provided for @chilli_inter_cultivation_key.
  ///
  /// In en, this message translates to:
  /// **'Inter-cultivation with gorru and guntaka 15 days after transplanting, repeated every 15-20 days.\nMaintain weed-free crop up to 60 days after transplanting and 90 days after direct seeding.\nChemical weed control options available.\nPre-emergence application: Pendimethalin 38.7%SC (750ml/acre).\nPost-emergence application for heavy weed infestation: Quizalofop-p-ethyl (Targasuper) 400 ml/acre.'**
  String get chilli_inter_cultivation_key;

  /// No description provided for @chilli_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Follow necessary measures'**
  String get chilli_post_harvesting_key;

  /// No description provided for @chilli_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Avoid pesticide application within 20 days of harvesting.\nHarvest fully ripened pods, avoiding cloudy weather.\nUse clean bags for harvesting and avoid using fertilizer bags.\nHarvest chilli 3-4 times.\nDry harvested fruit by spreading on tarpaulin, turning frequently.\nDrying takes 2-3 weeks in open areas, preferably on elevated places.\nFaster drying on tarpaulin or sand yard, or in a poly house for higher quality.\nCover dried chilli with tarpaulin or palm leaves.\nAvoid water application during packing.\nSeparate mould-infested or light-colored pods from good chilli.\nStore filled bags on elevated surfaces.\nDry chilli to 11% moisture content.'**
  String get chilli_harvesting_key;

  /// No description provided for @grams_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'Loamy soil'**
  String get grams_soil_type_key;

  /// No description provided for @grams_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'6 to 8 kilograms per acre'**
  String get grams_seed_rate_key;

  /// No description provided for @grams_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Insecticides: Control insect pests and diseases in seeds. Examples: Metalaxyl, Carbendazim.\n- Insecticides: Protect seeds from insect pests. Examples: Imidacloprid, Thiamethoxam.\n- Propagator: Include beneficial microorganisms for soil health. Example: Rhizobacteria.\n- Biostimulants: Promote seed germination and plant growth. Contains plant hormones and nutrients.\n- Coating: Improve seed handling and emergence. Contains polymers and nutrients.'**
  String get grams_seed_treatment_key;

  /// No description provided for @grams_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'October - November'**
  String get grams_growing_season_key;

  /// No description provided for @grams_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'100-120 days'**
  String get grams_crop_duration_key;

  /// No description provided for @grams_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'Pre-sowing: Ensure sufficient soil moisture for germination. Pre-sowing irrigation may be necessary if soil moisture is low.\n- Seedling establishment (1-3 weeks): Irrigate every 7-10 days to establish seedlings. Provide moderate irrigation to maintain soil moisture.\n- Plant growth (4-8 weeks): Irrigation will be needed every 10-12 days based on soil moisture and rainfall. Provide adequate water to support root growth.\n- Critical growth stages (plant growth, flowering): Maintain sensitive soil moisture during these stages. Irrigate every 10-15 days or as needed.\n- Late growth stages (from pod development to maturity): Gradually reduce irrigation as the crop matures. Avoid excessive watering during pod development to prevent fungal diseases.'**
  String get grams_irrigation_schedule_key;

  /// No description provided for @grams_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N): 40-60 kilograms\n- Phosphorus (P): 20-30 kilograms\n- Potassium (K): 20-30 kilograms'**
  String get grams_nutrient_requirement_key;

  /// No description provided for @grams_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Cultural practices: Crop rotation, proper bed preparation, and appropriate planting density help suppress weeds in maize fields.\n- Mechanical control: Hand weeding, inter-row cultivation, and shallow tillage can be effective in managing weeds.\n- Chemical control:\n  - Pre-emergence herbicides: Pendimethalin, Metribuzin, and Trifluralin are commonly used to control weeds in maize fields.\n  - Post-emergence herbicides: Imazethapyr, Bentazon, and Metsulfuron-methyl are used to control emerged weeds in maize fields.'**
  String get grams_weed_management_key;

  /// No description provided for @grams_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Disease and Pest Management:\n- Diseases:\n  - White Rust (White Rust/Downy Mildew)\n    - Symptoms: White pustules, swelling of stems. Treat seeds, use sprays, select healthy seeds, control weeds, and practice crop rotation.\n  - Alternaria Leaf Spot\n    - Symptoms: Brown spots, leaf drop. Use sprays, select healthy seeds, and practice crop rotation.\n  - Grain Mould\n    - Symptoms: Discolored grains, reduced yield. Avoid moisture for long periods, timely harvesting, and use fungicide sprays.\n  - Ergot\n    - Symptoms: Black grains, honeydew excretion. Clean seeds mechanically, use fungicide sprays (e.g., Benlate, Propiconazole), and ensure proper field sanitation.\n- Pests:\n  - Aphids\n    - Symptoms: Honeydew on leaves, yellowing, and drying. Use tolerant varieties, aphid traps, apply neem oil, and consider using dimethoate sprays.\n  - Pod Borers\n    - Symptoms: Larvae infested in pods, causing damage to seeds. Regularly monitor fields, handpick affected pods, and consider neem oil sprays.\n  - Pod Sucking Bugs\n    - Symptoms: Drying, shriveling. Early sowing, irrigation, rapid germination, and dimethoate sprays are helpful.\n  - Wireworms\n    - Symptoms: Round holes, drying. Dig in summers, early sowing, irrigation, and apply Karela oil sprays.\n  - Whiteflies\n    - Symptoms: Whiteflies feed on leaves, causing yellowing and drying. Use yellow sticky traps, neem oil sprays, and maintain good crop hygiene.'**
  String get grams_disease_and_pest_management_key;

  /// No description provided for @grams_inter_cultivation_key.
  ///
  /// In en, this message translates to:
  /// **'Weed control: Regular weeding is essential to prevent competition for nutrients and sunlight. Manual weeding or light tillage can be used to control weeds.\n- Intercropping: Intercropping with compatible crops like maize, sorghum, or pigeon pea can help utilize land more efficiently and increase soil fertility.\n- Mulching: Applying mulch helps conserve soil moisture, suppress weed growth, and maintain soil temperature, encouraging better development of black and green gram crops.\n- Crop rotation: Rotating black and green grams with non-leguminous crops can break disease cycles and reduce pest and disease pressure on soil health.\n- Fertilization: Proper fertilization with balanced nutrients is essential for maximum growth. Application of compost or farmyard manure can replenish soil fertility.'**
  String get grams_inter_cultivation_key;

  /// No description provided for @grams_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'February - March'**
  String get grams_harvesting_key;

  /// No description provided for @grams_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Pods are opened to dry the beans inside, preventing them from spoiling.\nDrying: Dry harvested crops to less than 13% moisture to prevent spoilage.\nThreshing: Separate beans from the pods either manually or using a thresher.\nCleaning: Remove any damaged or defective beans from the crop to ensure quality.\nGrading: Grade beans based on size and quality to meet market standards and preferences.\nStorage: Store dried beans in well-ventilated containers to maintain freshness and prevent pest development.\nPacking: Pack beans in sealed bags or containers for preservation, with proper labeling.\nTransportation: Handle beans carefully during transportation to maintain quality and prevent damage.'**
  String get grams_post_harvesting_key;

  /// No description provided for @jowar_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'sandy loam soil, loamy soil.'**
  String get jowar_soil_type_key;

  /// No description provided for @jowar_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'3.6-4 kilos/acre'**
  String get jowar_seed_rate_key;

  /// No description provided for @jowar_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Treat the seed with Thiomethaxam @ 3 g/kg of seed and Thiram or Captan @ 3 g/kg of seed.'**
  String get jowar_seed_treatment_key;

  /// No description provided for @jowar_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'(k) June - July  (re) November - December'**
  String get jowar_growing_season_key;

  /// No description provided for @jowar_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'100-120 days'**
  String get jowar_crop_duration_key;

  /// No description provided for @jowar_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'First, ensure soil moisture with good water from the pre-soaked time. Pre-irrigation may be necessary if moisture is not visible. From the beginning of the pests to the pests (1-3 weeks): To feed the crop, water every 7-10 days without prejudice to the water. The right water should be provided to keep the soil moisture. Vegetative growth (4-8 weeks): More water is needed every 10-12 days, for the right vegetative growth to keep the soil moisture. Critical growth stages (tillering, flowering): Keep the soil moisture evenly during these events. Every 10-15 days or if necessary for irrigation. Late growth stage (maturity): When the crop matures fully, reduce the irrigation frequency actively. Do not moisten the crop a little for crop uptake.'**
  String get jowar_irrigation_schedule_key;

  /// No description provided for @jowar_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N): 40-60 kilos\nPhosphorus (P): 20-30 kilos\nPotassium (K): 20-30 kilos'**
  String get jowar_nutrient_requirement_key;

  /// No description provided for @jowar_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Weed management: General weed management, proper row spacing, timely weed removal helps in weed management in jowar sowing. Mechanical control: Hand weeding, inter-row hoeing, rotary hoeing are adequately used in weed control in jowar sowing. Chemical controls: Pre-emergence herbicides: Atrazine, metribuzin, and pendimethalin pre-emergence herbicides are used to control weeds in jowar sowing. Post-emergence herbicides: 2,4-D, metsulfuron-methyl, and glyphosate are used in post-emergence weed control.'**
  String get jowar_weed_management_key;

  /// No description provided for @jowar_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Shootfly: Symptoms: The larva eats the stem of the plant, the first plant is blown back (dead heart). Technical control: Control planting time to change the path. Increase the seed rate efficiently and remove the dead heart seedlings. Chemical control: Seed treatment with Furadan or Imidacloprid. Spray with Methyl Demeton or Neem Seed Kernel Extract. Stem Borer: Symptoms: Larvae eat their food on the stem, take the shape of a dead heart after the stem is swollen and kill the insect. Technical control: Print in Furadan or Furadan van. Use Carbophuran granules or Metasystox spray. Shootbug: Symptoms: Leaves dry out and the worm dies. Chemical control: Spray with Phosphamidon or Dimethoate. Aphids: Symptoms: Green leaves, small creature production. Chemical control: Spray with Metasystox or Dimethoate. Treat seeds with Imidacloprid or Thiamethoxam. Earhead midge: Symptoms: Red flowers in the ears, start of ears. Management: Spray lightly on flowering and milk. Mites: Symptoms: Webbing on leaves, the leaf ends with red. Management: Spray with Dimethoate or Dicofol. Grainmold damage: Symptoms: Colored grains, gain in it. Technical control: Avoid rain-prone areas, maintain values for timely cutting and drying. Chemical control: Spray with Aureofungin or Captan. Ergot: Symptoms: Black colors with sweet hand. Control: Soak the seeds in salt solution, spray with Benlate or Propiconazole. Plant rot: Symptoms: Drying on the grains, stem grows with day. Management: Spray with Mancozeb during flowering, growth and maturity stage. Leaf spot: Symptoms: Leaf diseases due to rains and humid conditions. Management: Spray with Mancozeb or Mancozeb without the need for covers.'**
  String get jowar_disease_and_pest_management_key;

  /// No description provided for @jowar_inter_cultivation_key.
  ///
  /// In en, this message translates to:
  /// **'Weeds: Hand or tool weed near jowar plants. Mulching: Mulch the soil around jowar for use near jowar and also keep the weeds. Inter-row hoes: Hoe in the middle to prevent water and welcome water. Suckers: Remove others to remove the remaining jowar plants. Intercropping: Grow plants that are favorable in jowar rows. Companion planting: Grow plants that are used in jowar rows to improve the environment. Agricultural cycle: Maintain values for daily and every season to keep jowar with various agricultural practices.'**
  String get jowar_inter_cultivation_key;

  /// No description provided for @jowar_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'(k) September - October  (r) March - April'**
  String get jowar_harvesting_key;

  /// No description provided for @jowar_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Threshing: Harvest the harvested crop and cut the jowar at the stump near the stump with a sickle or mechanical harvester. Threshing: Dry the jowar on dry ground. To reduce the grains, dry the crop completely. Threshing: Separate the harvested jowar plants from the stalks by falling on the mat or mechanical threshers. Winnowing: Use air or fan to separate the grains from the chaff and other impurities. Winnow on a windy day. Cleaning: Use sieves or screens to reduce the grains and separate the grains from other impurities. Storage: Decide to tie the cleaned and dry jowar grains in a gas or plastic tight bag. Report the income from the gas environment and plastics when storing. Packaging: Clean and dry jowar grains in clean labeled sacks or review. Provide date and variety or management labels. Quality control: Take care of the stored jowar grains until they are satisfactory or insect attack.'**
  String get jowar_post_harvesting_key;

  /// No description provided for @maize_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'Loamy soil'**
  String get maize_soil_type_key;

  /// No description provided for @maize_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'6 to 8 kilograms per acre'**
  String get maize_seed_rate_key;

  /// No description provided for @maize_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Seed Treatment:\n- Insecticides: Control insect pests and diseases in seeds. Examples: Metalaxyl, Carbendazim.\n- Insecticides: Protect seeds from insect pests. Examples: Imidacloprid, Thiamethoxam.\n- Propagator: Include beneficial microorganisms for soil health. Example: Rhizobacteria.\n- Biostimulants: Promote seed germination and plant growth. Contains plant hormones and nutrients.\n- Coating: Improve seed handling and emergence. Contains polymers and nutrients.'**
  String get maize_seed_treatment_key;

  /// No description provided for @maize_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'October - November'**
  String get maize_growing_season_key;

  /// No description provided for @maize_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'100-120 days'**
  String get maize_crop_duration_key;

  /// No description provided for @maize_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'Irrigation Schedule:\n- Pre-sowing: Ensure sufficient soil moisture for germination. Pre-sowing irrigation may be necessary if soil moisture is low.\n- Seedling establishment (1-3 weeks): Irrigate every 7-10 days to establish seedlings. Provide moderate irrigation to maintain soil moisture.\n- Plant growth (4-8 weeks): Irrigation will be needed every 10-12 days based on soil moisture and rainfall. Provide adequate water to support root growth.\n- Critical growth stages (plant growth, flowering): Maintain sensitive soil moisture during these stages. Irrigate every 10-15 days or as needed.\n- Late growth stages (from pod development to maturity): Gradually reduce irrigation as the crop matures. Avoid excessive watering during pod development to prevent fungal diseases.'**
  String get maize_irrigation_schedule_key;

  /// No description provided for @maize_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nutrient Requirement:\n- Nitrogen (N): 40-60 kilograms\n- Phosphorus (P): 20-30 kilograms\n- Potassium (K): 20-30 kilograms'**
  String get maize_nutrient_requirement_key;

  /// No description provided for @maize_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Weed Management:\n- Cultural practices: Crop rotation, proper bed preparation, and appropriate planting density help suppress weeds in maize fields.\n- Mechanical control: Hand weeding, inter-row cultivation, and shallow tillage can be effective in managing weeds.\n- Chemical control:\n  - Pre-emergence herbicides: Pendimethalin, Metribuzin, and Trifluralin are commonly used to control weeds in maize fields.\n  - Post-emergence herbicides: Imazethapyr, Bentazon, and Metsulfuron-methyl are used to control emerged weeds in maize fields.'**
  String get maize_weed_management_key;

  /// No description provided for @maize_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Disease and Pest Management:\n- Diseases:\n  - White Rust (White Rust/Downy Mildew)\n    - Symptoms: White pustules, swelling of stems. Treat seeds, use sprays, select healthy seeds, control weeds, and practice crop rotation.\n  - Alternaria Leaf Spot\n    - Symptoms: Brown spots, leaf drop. Use sprays, select healthy seeds, and practice crop rotation.\n  - Grain Mould\n    - Symptoms: Discolored grains, reduced yield. Avoid moisture for long periods, timely harvesting, and use fungicide sprays.\n  - Ergot\n    - Symptoms: Black grains, honeydew excretion. Clean seeds mechanically, use fungicide sprays (e.g., Benlate, Propiconazole), and ensure proper field sanitation.\n- Pests:\n  - Aphids\n    - Symptoms: Honeydew on leaves, yellowing, and drying. Use tolerant varieties, aphid traps, apply neem oil, and consider using dimethoate sprays.\n  - Pod Borers\n    - Symptoms: Larvae infested in pods, causing damage to seeds. Regularly monitor fields, handpick affected pods, and consider neem oil sprays.\n  - Pod Sucking Bugs\n    - Symptoms: Drying, shriveling. Early sowing, irrigation, rapid germination, and dimethoate sprays are helpful.\n  - Wireworms\n    - Symptoms: Round holes, drying. Dig in summers, early sowing, irrigation, and apply Karela oil sprays.\n  - Whiteflies\n    - Symptoms: Whiteflies feed on leaves, causing yellowing and drying. Use yellow sticky traps, neem oil sprays, and maintain good crop hygiene.'**
  String get maize_disease_and_pest_management_key;

  /// No description provided for @maize_inter_cultivation_key.
  ///
  /// In en, this message translates to:
  /// **'Intercultivation:\n- Weed control: Regular weeding is essential to prevent competition for nutrients and sunlight. Manual weeding or light tillage can be used to control weeds.\n- Intercropping: Intercropping with compatible crops like maize, sorghum, or pigeon pea can help utilize land more efficiently and increase soil fertility.\n- Mulching: Applying mulch helps conserve soil moisture, suppress weed growth, and maintain soil temperature, encouraging better development of black and green gram crops.\n- Crop rotation: Rotating black and green grams with non-leguminous crops can break disease cycles and reduce pest and disease pressure on soil health.\n- Fertilization: Proper fertilization with balanced nutrients is essential for maximum growth. Application of compost or farmyard manure can replenish soil fertility.'**
  String get maize_inter_cultivation_key;

  /// No description provided for @maize_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'February - March'**
  String get maize_harvesting_key;

  /// No description provided for @maize_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'After harvesting: Pods are opened to dry the beans inside, preventing them from spoiling.\nDrying: Dry harvested crops to less than 13% moisture to prevent spoilage.\nThreshing: Separate beans from the pods either manually or using a thresher.\nCleaning: Remove any damaged or defective beans from the crop to ensure quality.\nGrading: Grade beans based on size and quality to meet market standards and preferences.\nStorage: Store dried beans in well-ventilated containers to maintain freshness and prevent pest development.\nPacking: Pack beans in sealed bags or containers for preservation, with proper labeling.\nTransportation: Handle beans carefully during transportation to maintain quality and prevent damage.'**
  String get maize_post_harvesting_key;

  /// No description provided for @mustard_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'Sandy Loam Soil'**
  String get mustard_soil_type_key;

  /// No description provided for @mustard_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'1.6 to 2 kg/acre'**
  String get mustard_seed_rate_key;

  /// No description provided for @mustard_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Treat the seeds according to the disease incidence in your region. In areas where stem rot is more prevalent, the seeds should be treated with Carbendazim @ 2g/1kg seed.\nSeed treatment with imidacloprid 70 WS @ 5g/kg of seed provides good control to painted bugs up to 30-35 DAS.'**
  String get mustard_seed_treatment_key;

  /// No description provided for @mustard_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'October - November'**
  String get mustard_growing_season_key;

  /// No description provided for @mustard_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'100-120 days'**
  String get mustard_crop_duration_key;

  /// No description provided for @mustard_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'Pre-sowing: Ensure soil moisture is adequate for germination. Pre-irrigation may be required if soil moisture is low.\nGermination to Seedling Establishment (1-3 weeks): Irrigate every 7-10 days to support seedling establishment. Apply moderate irrigation to maintain soil moisture.\nVegetative Growth (4-8 weeks): Increase irrigation frequency to every 10-12 days, depending on soil moisture and rainfall. Provide sufficient water for vigorous vegetative growth.\nCritical Growth Stages (Vegetative Growth, Flowering): Maintain consistent soil moisture during these stages. Irrigate every 10-15 days or as needed.\nLate Growth Stage (Pod Development to Maturity): Gradually reduce irrigation frequency as the crop matures. Avoid overwatering during pod development to prevent fungal diseases.'**
  String get mustard_irrigation_schedule_key;

  /// No description provided for @mustard_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N): 20-30 kg\nPhosphorus (P): 30-40 kg\nPotassium (K): 20-30 kg'**
  String get mustard_nutrient_requirement_key;

  /// No description provided for @mustard_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Cultural Practices: Proper seedbed preparation, crop rotation, and timely weeding help manage weeds in mustard fields.\nMechanical Control: Hand weeding, inter-row cultivation, and shallow tillage can effectively manage weeds in mustard crops.\nChemical Control:\nPre-emergence herbicides: Pendimethalin, Metribuzin, and Fluchloralin are commonly used pre-emergence herbicides for weed control in mustard.\nPost-emergence herbicides: Post-emergence herbicides like 2,4-D, Metsulfuron-methyl, and Quizalofop-P-ethyl are used to control emerged weeds in mustard fields.'**
  String get mustard_weed_management_key;

  /// No description provided for @mustard_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Pests:\nMustard Aphid\nSymptoms: Sap-sucking leads to leaf curling, stunted growth, and sooty mold. Yellow sticky traps can monitor populations. Soft soap or neem oil sprays are effective.\nManagement: Use tolerant varieties, employ traps, apply neem oil or soap sprays, and consider chemical control like Dimethoate.\nPainted Bug\nSymptoms: Sap-sucking causes wilting and withering. Early sowing and irrigation can reduce damage. Quick threshing and crop burning help prevent spread.\nManagement: Deep plowing, early sowing, irrigation, quick threshing, and Dimethoate sprays are recommended.\nMustard Sawfly\nSymptoms: Larvae feed on leaves, causing shot holes and drying. Summer plowing, early sowing, clean cultivation, and bitter gourd seed oil sprays are effective.\nManagement: Summer plowing, early sowing, irrigation, clean cultivation, and Quinalphos sprays are recommended.\nDiseases:\nWhite Rust / Downy Mildew\nSymptoms: White pustules on leaves, stem swelling, and distortion. Seed treatment and foliar sprays with Bordeaux mixture or copper oxychloride help manage the disease.\nManagement: Seed treatment, foliar sprays, use of disease-free seeds, weed control, and crop rotation.\nAlternaria Leaf Spot\nSymptoms: Circular brown spots on leaves, stem lesions, and defoliation. Use of healthy seeds and foliar sprays with copper oxychloride aid in disease control.\nManagement: Use healthy seeds, foliar sprays, and crop rotation for disease management.'**
  String get mustard_disease_and_pest_management_key;

  /// No description provided for @mustard_inter_cultivation_key.
  ///
  /// In en, this message translates to:
  /// **'Weeding: Remove weeds manually or with tools to prevent competition for nutrients and water.\nMulching: Apply organic mulch around mustard plants to suppress weed growth and conserve soil moisture.\nInter-row Cultivation: Loosen soil between mustard rows to improve root development and water infiltration.\nThinning: Thin out crowded mustard plants to provide adequate space for growth and airflow.\nIntercropping: Plant compatible crops between mustard rows to maximize land productivity and diversity.\nCompanion Planting: Grow companion plants alongside mustard to repel pests and enhance soil health.\nCrop Rotation: Rotate mustard with different crops in successive seasons to prevent disease buildup and improve soil fertility.'**
  String get mustard_inter_cultivation_key;

  /// No description provided for @mustard_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'February - March'**
  String get mustard_harvesting_key;

  /// No description provided for @mustard_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Harvest Timing: Harvest the crop when the pods turn yellowish-brown to ensure optimum maturity.\nAvoid delayed harvesting to prevent shattering and minimize losses.\nPrecautions Against Shattering: Harvest just before the pods open to prevent seed loss due to shattering.\nStacking Before Threshing: Stack the harvested crop on the threshing floor for 5-6 days to allow for drying and curing.\nThreshing Process: Thresh the dried crop to separate grain from husk.\nUtilize slow-moving natural air currents to aid in the separation process.\nHusking Separation: Ensure efficient separation of threshed grain from husk for further processing and storage.'**
  String get mustard_post_harvesting_key;

  /// No description provided for @soyabean_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'Loamy Soil'**
  String get soyabean_soil_type_key;

  /// No description provided for @soyabean_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'16-20 kg/acre'**
  String get soyabean_seed_rate_key;

  /// No description provided for @soyabean_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Fungicides: Use fungicides such as metalaxyl, carbendazim, or thiram to control fungal diseases like seed rot and damping-off.\nInsecticides: Apply insecticides like imidacloprid or thiamethoxam to protect against seed and soil-borne pests such as aphids and bean leaf beetles.\nInoculants: Use rhizobium inoculants to promote nitrogen fixation by forming nodules on soybean roots, improving plant health and yield potential.'**
  String get soyabean_seed_treatment_key;

  /// No description provided for @soyabean_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'October - November'**
  String get soyabean_growing_season_key;

  /// No description provided for @soyabean_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'90-120 days'**
  String get soyabean_crop_duration_key;

  /// No description provided for @soyabean_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'Pre-sowing: Ensure soil moisture is adequate for germination. Pre-irrigation may be necessary if soil moisture is low.\nGermination to Seedling Establishment (1-3 weeks): Irrigate every 7-10 days to support seedling establishment. Apply moderate irrigation to maintain soil moisture.\nVegetative Growth (4-8 weeks): Increase irrigation frequency to every 10-12 days, depending on soil moisture and rainfall. Provide sufficient water for vigorous vegetative growth.\nCritical Growth Stages (Vegetative Growth, Flowering, Pod Development): Maintain consistent soil moisture during these stages. Irrigate every 7-10 days or as needed.\nLate Growth Stage (Pod Development to Maturity): Gradually reduce irrigation frequency as the crop matures. Avoid overwatering during pod development to prevent fungal diseases.'**
  String get soyabean_irrigation_schedule_key;

  /// No description provided for @soyabean_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N): 60-80 kg\nPhosphorus (P): 40-50 kg\nPotassium (K): 30-40 kg'**
  String get soyabean_nutrient_requirement_key;

  /// No description provided for @soyabean_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Cultural Practices: Adequate soil fertility management, proper row spacing, and timely weed removal help manage weeds in soybean cultivation.\nMechanical Control: Hand weeding, inter-row cultivation, and rotary hoeing are effective mechanical methods for weed control in soybean fields.\nChemical Control:\nPre-emergence herbicides: Pendimethalin, Metribuzin, and Imazethapyr are commonly used pre-emergence herbicides for weed control in soybean.\nPost-emergence herbicides: Post-emergence herbicides like Glyphosate, Imazethapyr, and Quizalofop-P-ethyl are used to control emerged weeds in soybean crops.'**
  String get soyabean_weed_management_key;

  /// No description provided for @soyabean_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Diseases:\nWhite Rust / Downy Mildew:\nSymptoms: White pustules on leaves, stem swelling.\nControl: Seed treatment with garlic extract, foliar sprays of Bordeaux mixture, disease-free seeds.\nAlternaria Leaf Spot:\nSymptoms: Circular brown spots on leaves, stem lesions.\nControl: Healthy seeds, copper oxychloride sprays, weed management, crop rotation.\nGrain Mold Damage:\nSymptoms: Discolored grains, reduced yield.\nControl: Avoiding rainy maturation periods, timely harvesting, fungicide sprays, seed treatment.\nErgot:\nSymptoms: Blackened grains, honeydew exudation.\nControl: Mechanical seed cleaning, fungicide sprays (Benlate, Propiconazole), sanitation.\nPests:\nAphids:\nSymptoms: Leaf curling, stunted growth, sooty mold.\nManagement: Use tolerant varieties, sticky traps, neem oil or soap sprays, Dimethoate.\nPainted Bug:\nSymptoms: Wilting, withering due to sap-sucking.\nManagement: Deep plowing, early sowing, irrigation, quick threshing, Dimethoate sprays.\nSawfly:\nSymptoms: Leaves with shot holes, drying.\nManagement: Summer plowing, early sowing, clean cultivation, bitter gourd seed oil, Quinalphos sprays.'**
  String get soyabean_disease_and_pest_management_key;

  /// No description provided for @soyabean_inter_cultivation_key.
  ///
  /// In en, this message translates to:
  /// **'Weeding: Remove weeds manually or with tools to prevent competition for nutrients and space.\nMulching: Cover the soil around soybean plants with organic materials to suppress weeds and conserve moisture.\nInter-row Cultivation: Loosen the soil between rows to enhance root development, improve water infiltration, and reduce weed growth.\nThinning: Remove excess soybean plants to provide adequate spacing for optimal growth and yield.\nIntercropping: Plant compatible crops between soybean rows to maximize land use and diversify farm output.\nCompanion Planting: Grow companion plants alongside soybeans to enhance soil fertility, attract beneficial insects, and repel pests.\nCrop Rotation: Rotate soybeans with different crops in subsequent seasons to break pest and disease cycles and maintain soil health.'**
  String get soyabean_inter_cultivation_key;

  /// No description provided for @soyabean_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'September - October'**
  String get soyabean_harvesting_key;

  /// No description provided for @soyabean_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Harvesting: Pick soybeans when they\'re dry but not yet shedding from the pod.\nDrying: Dry harvested beans until they\'re less than 13% moisture to prevent spoilage.\nThreshing: Separate beans from pods using a thresher or by hand.\nCleaning: Remove any debris or damaged beans from the harvest.\nGrading: Sort beans by size and quality to meet market standards.\nStorage: Store cleaned beans in dry, well-ventilated containers to keep them fresh.\nPackaging: Put beans in sealed bags or containers with proper labeling.\nTransportation: Handle beans carefully during transport to prevent damage.'**
  String get soyabean_post_harvesting_key;

  /// No description provided for @wheat_soil_type_key.
  ///
  /// In en, this message translates to:
  /// **'Loamy Soil'**
  String get wheat_soil_type_key;

  /// No description provided for @wheat_seed_rate_key.
  ///
  /// In en, this message translates to:
  /// **'50 kg/acre'**
  String get wheat_seed_rate_key;

  /// No description provided for @wheat_seed_treatment_key.
  ///
  /// In en, this message translates to:
  /// **'Seed treatment with Carboxin (75 WP @ 2.5 gm/kg seed) or Carbendazim (50 WP @ 2.5 gm/kg seed) or Tebuconazole (2DS @ 1.25 gm/kg seed) or a combination of a reduced dosage of Carboxin (75 WP @ 1.25 gm/kg seed) and a bioagent fungus Trichoderma viride (@ 4 gm/kg seed) is recommended.'**
  String get wheat_seed_treatment_key;

  /// No description provided for @wheat_growing_season_key.
  ///
  /// In en, this message translates to:
  /// **'November - December'**
  String get wheat_growing_season_key;

  /// No description provided for @wheat_crop_duration_key.
  ///
  /// In en, this message translates to:
  /// **'120-150 days'**
  String get wheat_crop_duration_key;

  /// No description provided for @wheat_irrigation_schedule_key.
  ///
  /// In en, this message translates to:
  /// **'Pre-sowing: Ensure adequate soil moisture for seed germination. Pre-irrigation may be necessary in dry soil conditions.\nInitial growth stage (tillering): Irrigate every 10-15 days to support early growth and tiller development.\nJointing to booting stage: Maintain soil moisture with irrigation every 10-12 days.\nHeading to maturity: Irrigate every 10-14 days, adjusting based on weather and soil moisture conditions.\nReduce irrigation: Reduce irrigation frequency during grain filling to avoid lodging and promote grain development.'**
  String get wheat_irrigation_schedule_key;

  /// No description provided for @wheat_nutrient_requirement_key.
  ///
  /// In en, this message translates to:
  /// **'Nitrogen (N): 80-100 kg\nPhosphorus (P): 40-50 kg\nPotassium (K): 30-40 kg'**
  String get wheat_nutrient_requirement_key;

  /// No description provided for @wheat_weed_management_key.
  ///
  /// In en, this message translates to:
  /// **'Cultural Practices: Crop rotation, proper seedbed preparation, and optimal planting density help suppress weeds in wheat fields.\nMechanical Control: Hand weeding, inter-row cultivation, and shallow tillage can effectively manage weeds in wheat crops.\nChemical Control:\nPre-emergence herbicides: Pendimethalin, Metribuzin, and Clodinafop-propargyl are commonly used pre-emergence herbicides for weed control in wheat.\nPost-emergence herbicides: Post-emergence herbicides like 2,4-D, Metsulfuron-methyl, and Bromoxynil are used to control emerged weeds in wheat fields.'**
  String get wheat_weed_management_key;

  /// No description provided for @wheat_disease_and_pest_management_key.
  ///
  /// In en, this message translates to:
  /// **'Disease Management Guidelines:\nRust:\nSymptoms: Yellow or brown powdery pustules on leaves.\nControl: Spray with Propiconazole or Tebuconazole at 0.1% concentration at the initiation of rust using 200 litres of water per acre.\nLoose Smut:\nSymptoms: Ears turn into a black powdery mass.\nControl: Treat seeds with Carboxin, Carbendazim, or Tebuconazole.\nKarnal Bunt:\nSymptoms: Black powder on infected grains.\nControl: Spray Propiconazole at 0.1% concentration at 50% flowering, repeat if needed every 15 days.\nPowdery Mildew:\nSymptoms: White powdery patches on leaves and stems.\nControl: Spray with Propiconazole at 0.1% concentration when disease appears.\nFlag Smut:\nSymptoms: Long black streaks on leaves.\nControl: Follow seed treatment with Carboxin or Tebuconazole.\nPests:\nTermites:\nSymptoms: Damage near sowing and maturity.\nControl: Treat seeds with thiamethoxam or fipronil.\nAphids:\nSymptoms: Discolouration of leaves.\nControl: Foliar spray of Imidacloprid when aphid infestation exceeds economic threshold.\nPink Stem Borer:\nSymptoms: Central shoot killed causing \'dead heart\'.\nControl: Foliar spray of Quinalphos when pink stem borer is seen.\nEar Cockle:\nSymptoms: Swollen base, dark-brown galls instead of grains.\nControl: Use the floatation technique to separate galls, destroy them, and wash seeds thoroughly before sowing.'**
  String get wheat_disease_and_pest_management_key;

  /// No description provided for @wheat_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'March - April'**
  String get wheat_harvesting_key;

  /// No description provided for @wheat_post_harvesting_key.
  ///
  /// In en, this message translates to:
  /// **'Drying:\nDry harvested wheat to 12% moisture or lower.\nAvoid direct sun drying to preserve nutrients.\nCleaning:\nRemove chaff, straw, and weed seeds.\nEnsure wheat is clean for storage.\nStorage:\nStore wheat in dry, ventilated areas.\nUse sealed containers or silos to prevent pests.\nGrading:\nSort wheat based on quality.\nSeparate into different grades for market.\nMilling:\nMill wheat to produce flour.\nUse modern equipment for efficiency.\nPackaging:\nPackage flour in clean, labeled bags.\nInclude production and expiry dates.\nTransportation:\nHandle wheat carefully during transport.\nUse appropriate vehicles and packaging.\nQuality Assurance:\nMonitor quality throughout the process.\nInspect and test for safety and standards.'**
  String get wheat_post_harvesting_key;

  /// No description provided for @noDataAvailable.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get noDataAvailable;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
