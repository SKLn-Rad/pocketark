// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

// Project imports:
import 'package:pocketark/extensions/context_extensions.dart';
import 'package:pocketark/views/app.dart';

void main() {
  testWidgets('Can load localizations from context extension successfully', testLocalizationExtension);
}

// Tests the loading of the ARB files
// Relates to:
//  - https://github.com/SKLn-Rad/pocketark/issues/3
Future<void> testLocalizationExtension(WidgetTester widgetTester) async {
  // Arrange
  final Widget child = App(
    child: Builder(builder: (BuildContext context) {
      final AppLocalizations? localizations = context.localizations;
      return Center(
        child: Text(localizations?.applicationName ?? ''),
      );
    }),
  );

  // Act
  await widgetTester.pumpWidget(child);

  // Assert
  final Finder finder = find.text('PocketArk');
  expect(finder, findsOneWidget);
}
