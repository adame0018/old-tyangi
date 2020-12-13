import 'package:Tyangi/pages/settings/EditProfile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: Text(
          "Settings",
          style: Theme.of(context).textTheme.headline6,
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          InkWell(
            onTap: (){
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => EditProfile()
                )
              );
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
              decoration: BoxDecoration(
                border: Border(
                  //top: BorderSide(width: 1),
                  bottom: BorderSide(width: 1, color: Colors.grey),
                )
              ),
              child: Text(
                "Edit Profile",
                style: TextStyle(
                  fontSize: 20,
                ),  
              )
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
            decoration: BoxDecoration(
              border: Border(
                //top: BorderSide(width: 1),
                bottom: BorderSide(width: 1, color: Colors.grey),
              )
            ),
            child: Text(
              "About",
              style: TextStyle(
                fontSize: 20,
              ),  
            )
          )
        ]
      ),
      
    );
  }
}