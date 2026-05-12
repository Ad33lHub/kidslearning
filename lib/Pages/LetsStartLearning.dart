import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kids/Learning/Alphabet.dart';
import 'package:kids/Learning/Animals.dart';
import 'package:kids/Learning/Brids.dart';
import 'package:kids/Learning/Colors.dart';
import 'package:kids/Learning/Flowers.dart';
import 'package:kids/Learning/Fruit.dart';
import 'package:kids/Learning/Month.dart';
import 'package:kids/Learning/Number.dart';
import 'package:kids/Learning/Shapes.dart';
import 'package:kids/Learning/Vegitable.dart';
import 'package:kids/utils/admob.dart';

class LetsStartLearning extends StatefulWidget{
  final int index;
  const LetsStartLearning(this.index, {super.key});

  @override
  State<LetsStartLearning> createState() => _LetsStartLearningState();
}

class _LetsStartLearningState extends State<LetsStartLearning> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.orange[50],
        elevation: 0,
        title: const Text("PreSchool Kids Learning", style: TextStyle(color: Colors.black,fontFamily: "arlrdbd"),),
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
                        onTap: (){
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>const Alphabet()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.orange[50],
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset("assets/images/number.png",height: 90,),
                                Container(
                                        height: 40,
                                        width: 200,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          color: Colors.orange[100]
                                        ),
                                          child: const Center(child: Text('Alphabet',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                                ],
                             ),
                          ),
                        ),
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const Numbers()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange[50],
                              borderRadius: BorderRadius.circular(10.0)
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
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Color(widget.index)));
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
                                    child: const Center(child: Text('Color',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                              ]
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Shapes()));
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
                                    child: const Center(child: Text('Shape',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                              ]
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Animal()));
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
                                    child: const Center(child: Text('Animal',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),
                              ]
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Brids()));
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
                                    child: const Center(child: Text('Bird',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                              ]
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Flower()));
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
                                    child: const Center(child: Text('Flower',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                              ]
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Fruits()));
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
                                    child: const Center(child: Text('Fruit',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                              ]
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Month()));
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
                                    child: const Center(child: Text('Month',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                              ]
                          ),
                        ),
                      ),
                      InkWell(
                        splashColor: Colors.redAccent,
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> const Vegitable()));
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
                                    child: const Center(child: Text('Vegetable',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                              ]
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



