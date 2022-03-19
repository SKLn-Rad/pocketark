import 'package:inqvine_core_firebase/inqvine_core_firebase.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

class EventService extends InqvineServiceBase {
  static const String kEventCollectionName = 'events';
  static CollectionReference get kEventCollection => inqvine.getFromLocator<FirebaseFirestore>().collection(EventService.kEventCollectionName);
}
