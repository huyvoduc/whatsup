import 'package:flutter/material.dart';

import 'package:whatsup/module/profile/__mock__/observable_history_mock_data.dart';
import 'package:whatsup/module/profile/widgets/observable_history_item.dart';

class ObserverTab extends StatefulWidget {
  final double width;

  const ObserverTab({Key key, @required this.width}) : super(key: key);

  @override
  _ObserverTabState createState() => _ObserverTabState();
}

class _ObserverTabState extends State<ObserverTab> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        width: widget.width,
        child: Column(
          children: observableHistory
              .map<ObservableHistoryItem>(
                (item) => ObservableHistoryItem(
                  item: item,
                  width: widget.width,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
