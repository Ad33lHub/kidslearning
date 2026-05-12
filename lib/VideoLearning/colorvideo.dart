import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/utils/admob.dart';
import 'package:kids/utils/model.dart';
import 'package:url_launcher/url_launcher.dart';

class ColorVideo extends StatefulWidget{
  const ColorVideo({super.key});

  @override
  State<ColorVideo> createState() => _ColorVideoState();
}
List<Numbermodel> colorvideolist = colorvideo1();
List<String> colorvideoURLlist = colorvideoURL();

class _ColorVideoState extends State<ColorVideo> {
  Future<void> _launchYoutubeVideo(String url) async {
    await launch(url);
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
          title: const Center(child: Text('Colors Video Songs',style: TextStyle( color: Colors.black,fontFamily: "arlrdbd"),)),
        ),
        body: Container(
          child: GridView.builder(
            itemCount: colorvideolist.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index,) {
              return   InkWell(
                splashColor: Colors.redAccent,
                onTap: () {
                  _launchYoutubeVideo(colorvideoURLlist[index]);
                  print(colorvideoURLlist[index]);
                },
                child: Card(
                  color: const Color(0xFFEBE8FD),
                  elevation: 5,
                  margin: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  shadowColor: Colors.redAccent,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(colorvideolist[index].image,fit: BoxFit.fill,alignment: Alignment.topCenter,height: 122),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(colorvideolist[index].Text,style: const TextStyle(color: Colors.redAccent,fontFamily: "arlrdbd",fontSize: 15),)),
                        )
                      ]
                  ),
                ),
              );
            },
          ),
        ),
      bottomNavigationBar: SizedBox(
        height: MediaQuery.of(context).size.width *0.13,
        width: 25,
        child: AdWidget(
          ad:AdmobHelper.getBannerAd()..load(),
        ),
      ),
    );
  }
}

