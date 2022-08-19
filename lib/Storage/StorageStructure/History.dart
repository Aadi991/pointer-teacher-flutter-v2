import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

import '../cloudFirestoreControl.dart';

class History{
  String? timestamp, Reason;
  int? Points;

  History(this.timestamp, this.Reason, this.Points);

  History.empty();
  History.calculateTimestamp(String reason, String date, int points){
    DateTime now = DateTime.now();
    DateFormat formatter = DateFormat("hh:mm aaa z dd/MM/yyyy");
    timestamp = formatter.format(now);
  }

  factory History.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? options,) {
    final data = snapshot.data();
    return History(
        data?[CloudFirestoreControl.keyTimestamp],
        data?[CloudFirestoreControl.keyReason],
        data?[CloudFirestoreControl.keyPoints]
    );
  }

  factory History.fromMap(Map<String, dynamic> data,) {
    return History(
        data[CloudFirestoreControl.keyTimestamp],
        data[CloudFirestoreControl.keyReason],
        data[CloudFirestoreControl.keyPoints]
    );
  }

  Map<String,dynamic> toFirestore(){
    return {
      CloudFirestoreControl.keyTimestamp: timestamp,
      CloudFirestoreControl.keyReason: Reason,
      CloudFirestoreControl.keyPoints: Points,
    };
  }
}