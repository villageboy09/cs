import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cropsync/controller/language_change_controller.dart';

void main() {
  testWidgets('Language change test', (WidgetTester tester) async {
    // Create a LanguageChangeController instance and initialize it with English
    LanguageChangeController languageController = LanguageChangeController();
    await languageController.initLanguage('en');

    // Build the MyApp widget with the initialized LanguageChangeController

    // Verify that the default language is English
    expect(languageController.appLocale?.languageCode, 'en');

    // Tap on the PopupMenuButton to open the menu
    await tester.tap(find.byType(PopupMenuButton));
    await tester.pumpAndSettle();

    // Tap on the Hindi option in the menu
    await tester.tap(find.text('हिन्दी'));
    await tester.pumpAndSettle();

    // Verify that the language has changed to Hindi
    expect(languageController.appLocale?.languageCode, 'hi');
  });
}
