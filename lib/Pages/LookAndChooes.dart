

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/Quiz/ABCQuize.dart';
import 'package:kids/Quiz/AnimalQuize.dart';
import 'package:kids/Quiz/BirdQuize.dart';
import 'package:kids/Quiz/ColorQuiz.dart';
import 'package:kids/Quiz/FlowerQuize.dart';
import 'package:kids/Quiz/FruitQuize.dart';
import 'package:kids/Quiz/MonthQuize.dart';
import 'package:kids/Quiz/NumberQuiz.dart';
import 'package:kids/Quiz/ShapeQuiz.dart';
import 'package:kids/Quiz/VegitableQuiz.dart';
import 'package:kids/utils/admob.dart';


class LookAndChooes extends StatelessWidget{
  final int index;
  const LookAndChooes(this.index, {super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(0xFFFEF7F0),
        elevation: 0,
        title: const Center(child: Text('Look And Chooes',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd"),)),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.count(
                padding: const EdgeInsets.all(35),
                mainAxisSpacing: 15,
                crossAxisSpacing: 20,
                crossAxisCount: 2,
                primary: false,
                children: [
                  InkWell(
                    splashColor: Colors.redAccent,
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ABCQuiz()));
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
                                child: const Center(child: Text('ABC Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const Numberquiz()));
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
                                child: const Center(child: Text('Number Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Colorquiz()));
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
                                child: const Center(child: Text('Color Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Shapequiz()));
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
                                child: const Center(child: Text('Shape Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AnimalQuiz()));
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
                                child: const Center(child: Text('Animal Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Birdquiz()));
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
                                child: const Center(child: Text('Bird Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Flowerquiz()));
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
                                child: const Center(child: Text('Flower Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Fruitquiz()));
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
                                child: const Center(child: Text('Fruit Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Monthquiz()));
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
                                child: const Center(child: Text('Month Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const Vegitablequiz()));
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
                                child: const Center(child: Text('Vegetable Songs',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
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



