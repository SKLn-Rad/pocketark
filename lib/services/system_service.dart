// Package imports:
import 'package:inqvine_core_main/inqvine_core_main.dart';
import 'package:url_launcher/url_launcher.dart';

class SystemService extends InqvineServiceBase {
  Future<void> openUrl(String url) async {
    'Attempting to open: $url'.logInfo();
    if (await canLaunch(url)) {
      await launch(url);
    }
  }
}
