import 'package:flutter/material.dart';

import '../Storage/StorageStructure/Student.dart';

class HistoryScreen extends StatefulWidget {
  Student clickedStudent;
  HistoryScreen({Key? key, required this.clickedStudent}) : super(key: key);

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text("${widget.clickedStudent.screenName}'s History"),
      ),
      body: Center(
        child: Text('History'),
      ),
    );
  }
}
