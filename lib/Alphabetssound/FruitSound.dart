import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:kids/utils/model.dart';


class FruitSound extends StatefulWidget {
  int index;
  FruitSound( this.index, {super.key});

  @override
  State<FruitSound> createState() => _FruitSoundState();
}
List<Numbermodel> FRUITlist = fruit1();
class _FruitSoundState extends State<FruitSound> {
  final FlutterTts flutterTts = FlutterTts();
  @override
  Widget build(BuildContext context) {
    int i = 0;
    Future speak() async {
      print(await flutterTts.getLanguages);
      await flutterTts.setLanguage("en-US");
      await flutterTts.setPitch(1.0);
      await flutterTts.setVolume(10.0);
      print(await flutterTts.getVoices);
      int count = widget.index;
      await flutterTts.speak(FRUITlist[count].Text);
    }
      final controller = PageController();

      return Scaffold(
          appBar: AppBar(
            elevation: 0,
            title: const Text(
                'Fruit',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd"),
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
                            itemCount: FRUITlist.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Center(
                                child: Image.asset(
                                  FRUITlist[widget.index].image, alignment: Alignment.topCenter,),
                              );
                            },
                          ),
                        ),
                      ),
                      Column(
                          children: [
                            InkWell(
                                onTap: () => speak(),
                                child: Image.asset(
                                    'assets/images/11MaskGroup3.png')),
                            Align(
                              heightFactor: 0.5,
                              child: Center(
                                    child: ListTile(
                                      trailing: InkWell(
                                        onTap: () {
                                          if (widget.index >= 0 && widget.index <
                                              12) {
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
                                          image: AssetImage(
                                              'assets/images/11MaskGroup5.png'),
                                        ),
                                      ),
                                      leading: InkWell(
                                        onTap: () {
                                          if (widget.index > 0 && widget.index <=
                                              12) {
                                            i--;
                                            setState(() {
                                              widget.index--;
                                            });
                                          }
                                          speak();
                                        },
                                        child: const Image(
                                          image: AssetImage(
                                              'assets/images/11MaskGroup4.png'),
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
