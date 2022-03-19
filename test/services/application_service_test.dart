import 'package:flutter_test/flutter_test.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:pocketark/services/application_service.dart';

void main() {
  test('Can register ApplicationService in locator', testRegistration);
  test('Can read environment property when set in locator', testEnvironmentProperty);
  test('Environment property defaults to development when not set in locator', testEnvironmentPropertyNotSet);
}

Future<void> testEnvironmentPropertyNotSet() async {
  // Arrange
  final ApplicationService applicationService = ApplicationService();

  // Act
  await inqvine.resetLocator();

  // Assert
  expect(applicationService.environment, ApplicationEnvironment.development);
}

Future<void> testEnvironmentProperty() async {
  // Arrange
  final ApplicationService applicationService = ApplicationService();
  const ApplicationEnvironment applicationEnvironment = ApplicationEnvironment.production;

  // Act
  await inqvine.resetLocator();
  inqvine.registerInLocator(applicationEnvironment);

  // Assert
  expect(applicationService.environment, applicationEnvironment);
}

Future<void> testRegistration() async {
  // Arrange
  final ApplicationService applicationService = ApplicationService();

  // Act
  await inqvine.resetLocator();
  await inqvine.registerService(applicationService);

  // Assert
  final ApplicationService newApplicationService = inqvine.getFromLocator();
  expect(applicationService.hashCode, newApplicationService.hashCode);
}
