import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final sheetId = "1I43c-Iy7ycMKRlOg5tSBXpe2a-QVwCvthbH-UWrQ0F0";

  final credentials = {
    "type": "service_account",
    "project_id": "eventresults",
    "private_key_id": "d8495f26c87b1e0f09fd6cbb960aaf9553202e76",
    "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQDME+8qWxnRJN+q\nBA2Lv+d0R5L74X3YEuLIx2iJCcNcg9mXGdVJXiLt/q3q6In80RB8cvLX4eay1Ty9\nwSGbOtkBGcEU37hZQkqZYspa6Xk12sHq87Ff3zCWFX9Ic3mwq3qo7kJxlKnEjde+\nJzAGHRm9OV+UjHv8Pl4BaAfVziQm8Q5KhasIUQTWCadfZWMaSle5ycAvcZxS9x4N\n/FV9orqZjvGqFUb9EDX64TMWyt/FODpaZopGA2Cc7TDuv/yBzMbqapOnI+/DWweh\nx5h1ghDkWVlYV96kQ2fJNs7166Ud0qlvk2oM0sFaGBSjLZScPcd7VOgiP7mHoHuu\n68BPPfk5AgMBAAECgf876554UUdt9pBgMHsfDWRoP/ETA/fEpHGc15qvTK6P+3wS\ntwMTsmWPJmLqa7IYXp+jQB0Nm3FMEPrvZvBMeSWTrSbZeiwms9AzjqOGY1xeSQen\nH5Efv+iu00u2z4Zrg+4AAUqBDvrJ5jFHzo8gkcAnpIZBQlPP5yqy6a4N7k5ZyuaE\nUV3KC1Avg8tWdsv8jZGjdLU8Pkioj5d/CLuBDl2J3GvqBhU8Tjf1TnkKaXV0yvqc\nojBrZ9fsiPJwKF1gXRt4Pg4+Hy2YQJijUw3ilLPOVDZAynKGQgSS+89D1HT0bmp3\nCPJg9EiftZsD5bMc93gVSwjTOwUoEQb81Eb3h8kCgYEA/2nr7Dpg5yxFeZ+vU5lR\nuRL5OpDIIzwDY8XkE3SPlPHjkuRb24gqPnrZW+XoYWwb+dNBOMswOxLrdv5LiiTj\nZ79trXL1XEmNKBpo6OlntpjT+hRtrkxYFeCVvGWGp6pDi9LauQtkE9YxzlStTTgX\nogIHo5j9wnOf1Ds8R3wY73UCgYEAzIvZJlDMAaJnuVHYy46JvlqrA4yp+bVIBQOM\n+mJYRkFLAnJ4JwaXOQOieFmUKacnQfzUQfkVOx8jp93vKHSKoiXSzvth7rGrKkL1\nBRz0l2qiQprAoxDVmyMW95tFlSxrOljGDB636o2Snqi+jb3V1LNxMfgtfWxB33Zx\n1XmMDjUCgYEA0C7b1751wbe6ITphQ/jSPdITRwM/vkhqUua30ovNhI/s+Iwdu0Cv\nfiHQDTHGSbI+01C39rzXYS84sdLwa3dJzASiNyBekYx5+9ga7s1gddr33PzNsaYU\nnjBinB78tKj5SXziPrXkKq8KBa3LXAd+a9TPuS84l0h7XBe0OGgUQwkCgYEAsy5m\n4RuyOlRMTJkYMukAXRIL8SYN2EMnfczoeIYiEhksXk5sVrN9UWKPtqGyGvLkfve9\n8LUEFjBnCaxuzp+YugYsL0kjNvfIm1LgVMRStzmgPnxV+ALNPAN3IRyRzeWFYS1X\nAFMAhaXTJM1pb702TgeLR1zCbLai1eBqQ7kgKWkCgYAeJUgqBpvSmGUBlGDL1Zab\nd+yEAcYF5XOnEY7lcAnoXq4aXHoQo5Wd3z9yH2c7FwMS0QAoNrqCYf9pwOwLT+27\n53gpIWve5m+IrFT5XRhX5n3EjHP0O4YDp2lKOWubsw3vJ9rF7OaYr0+ZF95tAp/c\nEWFZ2Pwf4DvaaPuZqs870Q==\n-----END PRIVATE KEY-----\n",
    "client_email": "event-results@eventresults.iam.gserviceaccount.com",
    "client_id": "113451024596891478050",
    "auth_uri": "https://accounts.google.com/o/oauth2/auth",
    "token_uri": "https://oauth2.googleapis.com/token",
    "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
    "client_x509_cert_url":
        "https://www.googleapis.com/robot/v1/metadata/x509/event-results%40eventresults.iam.gserviceaccount.com",
    "universe_domain": "googleapis.com"
  };

  late final GSheets gsheets;
  // ignore: non_constant_identifier_names
  late Spreadsheet GSheetsController;
  Worksheet? gsheetCrudUserDetails;

  @override
  void initState() {
    super.initState();
    gsheets = GSheets(credentials);
    gsheetsInit();
  }

 List<Map<String, String>>? rows; // Declare rows as a member variable

gsheetsInit() async {
  GSheetsController = await gsheets.spreadsheet(sheetId);
  gsheetCrudUserDetails = GSheetsController.worksheetByTitle('event_results');
  // Once the worksheet is initialized, you can use it to fetch data
  // For example:
  rows = await gsheetCrudUserDetails?.values.map.allRows();
  setState(() {}); // Update the UI after fetching data
}
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: const Text('Google Sheets Data'),
      actions: <Widget>[
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            setState(() {
              gsheetsInit(); // Call your function to fetch data again
            });
          },
        ),
      ],
    ),
    body: Center(
      child: rows != null
          ? ListView.builder(
              itemCount: rows!.length,
              itemBuilder: (context, index) {
                final row = rows![index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(row['Department'] ?? ''), // Replace 'YourColumnName' with your column name
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(row['Score'] ?? ''), // Replace 'AnotherColumnName' with your second column name
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const CircularProgressIndicator(), // Display loading indicator while fetching data
    ),
  );
}
}