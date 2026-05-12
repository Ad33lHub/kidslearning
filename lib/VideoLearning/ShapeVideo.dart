import 'package:flutter/material.dart';
import 'package:kids/utils/model.dart';
import 'package:url_launcher/url_launcher.dart';


class ShapeVideo extends StatefulWidget{
  const ShapeVideo({super.key});


  @override
  State<ShapeVideo> createState() => _ShapeVideoState();
}
List<Numbermodel> shapevideolist = shapevideo1();
List<String> shapevideoURLlist = shapevideoURL();

class _ShapeVideoState extends State<ShapeVideo> {
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
          title: const Center(child: Text('Shape Video Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd"),)),
        ),
        body: Container(
          child: GridView.builder(
            itemCount: shapevideolist.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (BuildContext context, int index,) {
              return   InkWell(
                splashColor: Colors.redAccent,
                onTap: () {
                  _launchYoutubeVideo(shapevideoURLlist[index]);
                  print(shapevideoURLlist[index]);
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
                        Image.asset(shapevideolist[index].image,fit: BoxFit.fill,alignment: Alignment.topCenter,height: 122),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(shapevideolist[index].Text,style: const TextStyle(color: Colors.redAccent,fontFamily: "arlrdbd",fontSize: 15),)),
                        )
                      ]
                  ),
                ),
              );
            },
          ),
        ),
    );
  }
}

