import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/utils/model.dart';


class ColorSound extends StatefulWidget {
  int index ;

  ColorSound( this.index, {super.key});
  @override
  State<ColorSound> createState() => _ColorSoundState();
}
List<Numbermodel> colorlist =COLOR1();
class _ColorSoundState extends State<ColorSound> {
  final FlutterTts flutterTts = FlutterTts();

  @override
  Widget build(BuildContext context) {
    int i=0;
    Future speak() async{

      print(await flutterTts.getLanguages);
      await flutterTts.setLanguage("en-IN");
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(10.0);
      print(await flutterTts.getVoices);
      int count = widget.index;

      await flutterTts.speak(colorlist[count].Text);

    }
    final controller = PageController();

    return  Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.black),
            elevation: 0,
            title: const Center(child: Text('Color',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd"),
              ),
            ),
            backgroundColor: Colors.orange[50],
          ),
          body: Container(
            height: 650,
            width: 500,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  fit: BoxFit.fitHeight,
                  image: AssetImage("assets/images/Union 12.png")
              ),
            ),
            child: Center(
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Card(
                          margin: const EdgeInsets.all(20),
                          elevation: 5,
                          shadowColor: Colors.redAccent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)
                          ),
                          child: PageView.builder(
                            controller: controller,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount:colorlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                  child: Image.asset(colorlist[widget.index].image,alignment: Alignment.topCenter,),
                                  );
                              },
                          ),
                        ),
                      ),
                      // Image.asset('assets/images/AtoZ/A.png',height: 200),
                      Column(
                          children: [
                            InkWell(
                                onTap: ()=> speak(),
                                child: Image.asset('assets/images/11MaskGroup3.png')),
                            Align(
                              heightFactor: 0.5,
                              child: Center(

                                    child: ListTile(
                                      trailing: InkWell(
                                        onTap: (){

                                          if(widget.index>=0 && widget.index<11){
                                            i++;
                                            print(widget.index);
                                            setState(() {
                                              widget.index++;
                                            });
                                          }
                                          speak();
                                          // changeImage(count);
                                        },
                                        child: const Image(
                                          image: AssetImage('assets/images/11MaskGroup5.png'),
                                        ),
                                      ),

                                      leading: InkWell(
                                        onTap: (){
                                          if(widget.index>0 && widget.index<=11){
                                            i--;
                                            setState(() {
                                              widget.index--;
                                            });
                                          }
                                          speak();
                                        },
                                        child: const Image(
                                          image: AssetImage('assets/images/11MaskGroup4.png'),

                                        ),
                                      ),

                                    ),
                                  ),
                            )
                          ]
                      )
                    ]
                )
            ),
          )
    );
  }
}

