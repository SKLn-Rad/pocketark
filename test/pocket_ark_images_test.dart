// Dart imports:
import 'dart:io';

// Package imports:
import 'package:test/test.dart';

// Project imports:
import 'package:pocketark/resources/resources.dart';

void main() {
  test('pocket_ark_images assets test', () {
    expect(File(PocketArkImages.logo).existsSync(), true);
    expect(File(PocketArkImages.logoFlat).existsSync(), true);
    expect(File(PocketArkImages.logoFull).existsSync(), true);
  });
}
