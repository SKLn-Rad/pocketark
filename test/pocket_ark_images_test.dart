import 'dart:io';

import 'package:pocketark/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('pocket_ark_images assets test', () {
    expect(File(PocketArkImages.bgDecoration1).existsSync(), true);
    expect(File(PocketArkImages.bgDecoration2).existsSync(), true);
    expect(File(PocketArkImages.bgDecoration3).existsSync(), true);
    expect(File(PocketArkImages.bgDecoration4).existsSync(), true);
    expect(File(PocketArkImages.bgDecoration5).existsSync(), true);
    expect(File(PocketArkImages.bgDecoration6).existsSync(), true);
    expect(File(PocketArkImages.logo).existsSync(), true);
    expect(File(PocketArkImages.logoFlat).existsSync(), true);
    expect(File(PocketArkImages.logoFull).existsSync(), true);
    expect(File(PocketArkImages.logoLetter).existsSync(), true);
  });
}
