import 'package:cloud_firestore/cloud_firestore.dart';

import '../cloudFirestoreControl.dart';

class Action {
  String reason;
  int points;

  Action(this.reason, this.points);

  factory Action.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Action(data?[CloudFirestoreControl.keyReason],
        data?[CloudFirestoreControl.keyPoints]);
  }

  factory Action.fromMap(Map<String, dynamic> data,) {
    return Action(
        data[CloudFirestoreControl.keyReason],
        data[CloudFirestoreControl.keyPoints]
    );
  }

  Map<String,dynamic> toFirestore() {
    return {
      CloudFirestoreControl.keyReason: reason,
      CloudFirestoreControl.keyPoints: points,
    };
  }
}
