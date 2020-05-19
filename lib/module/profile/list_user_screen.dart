import 'package:flutter/material.dart';
import 'package:whatsup/presentation/theme/theme_color.dart';

import 'widgets/user_item.dart';

class ListUserScreen extends StatefulWidget {
  @override
  _ListUserScreenState createState() => _ListUserScreenState();
}

class _ListUserScreenState extends State<ListUserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColor.primaryColor,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Container(
            color: AppColor.primaryColor,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: List.generate(
                  7,
                  (index) {
                    return UserItem(
                      avatar: 'assets/images/1.jpg',
                      userName: 'Jim Nelson',
                      time: '2h',
                    );
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
