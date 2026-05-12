import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/ListenGuessSongs/Alphabet.dart';
import 'package:kids/ListenGuessSongs/Animal.dart';
import 'package:kids/ListenGuessSongs/Brid.dart';
import 'package:kids/ListenGuessSongs/Color.dart';
import 'package:kids/ListenGuessSongs/Flower.dart';
import 'package:kids/ListenGuessSongs/Fruit.dart';
import 'package:kids/ListenGuessSongs/Month.dart';
import 'package:kids/ListenGuessSongs/Number.dart';
import 'package:kids/ListenGuessSongs/Shapes.dart';
import 'package:kids/ListenGuessSongs/Vegitable.dart';
import 'package:kids/utils/admob.dart';


class ListenGuess extends StatefulWidget{
  const ListenGuess({super.key});

  @override
  State<ListenGuess> createState() => _ListenGuessState();
}
class _ListenGuessState extends State<ListenGuess> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final FlutterTts flutterTts = FlutterTts();
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        title: const Center(child: Text('Listen And Guess',style: TextStyle( color: Colors.black,fontFamily: "arlrdbd"),),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
                padding: const EdgeInsets.all(35),
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                children: [
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('Apple');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AlphabetSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Alphabet.png',height: 90,),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Alphabet',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('Zero');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const NumberSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Numbers.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Number',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('AQUA');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ColorSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Color.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Color',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('ARROW');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ShapesSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Shapes.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Shape',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('BEER');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AnimalsSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Animals.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Animal',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('ARARAT');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const BirdsSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Birds.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Bird',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('BLACK ROSE');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const FlowerSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Flowers.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Flower',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('APPLE');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const FruitSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Fruit.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Fruit',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('JANUARY');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const MonthSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Month.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Month',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      flutterTts.speak('BELL PEPPER');
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const VegitableSong()));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.orange[50],
                      ),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/Vegitable.png',height: 90),
                            Container(
                                height: 45,
                                width: 200,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.orange[100]
                                ),
                                child: const Center(child: Text('Vegetable',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  )
                ]
            ),
          ),
        ],
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



