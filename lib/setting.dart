import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class Setting extends StatefulWidget{
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}
class _SettingState extends State<Setting> {
  Future<void> _openMap() async {
    final uri = Uri.parse(
      'https://play.google.com/store/apps/details?id=com.example.kids',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $uri';
    }
  }

  Future<void> _share() async {
    await Share.share(
      'Check out this Kids Learning App!\nhttps://play.google.com/store/apps/details?id=com.example.kids',
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Responsive header — uses ConstrainedBox instead of fixed height
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 220),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Color(0xFFFEF7F0),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(36),
                        bottomRight: Radius.circular(36))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assets/images/sun.png"),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Good",
                            style: TextStyle(
                              fontSize: 25,
                              fontFamily: "arlrdbd",
                              color: Colors.black,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "Morning!",
                              style: TextStyle(
                                fontSize: 25,
                                fontFamily: "arlrdbd",
                                color: Color(0xFFF19335),
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                  onTap: _openMap,
                child: Container(
                   decoration: BoxDecoration(color: const Color(0xFFE4F2E6),borderRadius: BorderRadius.circular(10)),
                   height: 80,
                   // Use responsive width instead of fixed 300
                   constraints: const BoxConstraints(maxWidth: 400),
                   alignment: Alignment.centerLeft,
                   margin: const EdgeInsets.all(10),
                   child: const Padding(
                     padding: EdgeInsets.all(8.0),
                     child: Text(
                       'Rate Us',
                       textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: true),
                       style: TextStyle(
                           color: Color(0xFF5EA763),
                           fontFamily: "arlrdbd",fontSize: 20,),
                       textAlign: TextAlign.left,),
                   ),
                 ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: _share,
                splashColor: const Color(0xFFF2CF37),
                child: Container(
                  decoration: BoxDecoration(color: const Color(0xFFFEF9E4),borderRadius: BorderRadius.circular(10)),
                  height: 80,
                  // Use responsive width instead of fixed 300
                  constraints: const BoxConstraints(maxWidth: 400),
                  alignment: Alignment.centerLeft,
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text('Share',
                      textHeightBehavior: TextHeightBehavior(applyHeightToFirstAscent: true),
                      style: TextStyle(
                        color: Color(0xFFF2CF37),
                        fontFamily: "arlrdbd",fontSize: 20,),
                      textAlign: TextAlign.left,),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
     );
    }
}