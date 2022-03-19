import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:inqvine_core_main/inqvine_core_main.dart';

class EventService extends InqvineServiceBase {
  static const String kEventCollectionName = 'events';
  static CollectionReference get kEventCollection => inqvine.getFromLocator<FirebaseFirestore>().collection(EventService.kEventCollectionName);
}
