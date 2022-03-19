import 'dart:io';

import 'package:pocketark/resources/resources.dart';
import 'package:test/test.dart';

void main() {
  test('pocket_ark_images assets test', () {
    expect(File(PocketArkImages.logo).existsSync(), true);
    expect(File(PocketArkImages.logoFlat).existsSync(), true);
    expect(File(PocketArkImages.logoFull).existsSync(), true);
    expect(File(PocketArkImages.logoLetter).existsSync(), true);
  });
}
