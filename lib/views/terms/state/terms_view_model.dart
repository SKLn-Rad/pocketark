// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';

// Project imports:
import '../../../constants/application_constants.dart';
import '../../../constants/route_constants.dart';
import '../../../services/service_configuration.dart';

class TermsViewModel extends BaseViewModel with PocketArkServiceMixin {
  Future<void> onTermsAccepted() async {
    await sharedPreferences.setBool(kSharedKeyTermsAccepted, true);
    kRouter.go(kRoutePathEvents);
  }
}
