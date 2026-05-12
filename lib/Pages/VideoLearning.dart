import 'package:flutter/material.dart';
import 'package:kids/VideoLearning/ABC%20song.dart';
import 'package:kids/VideoLearning/AnimalVideo.dart';
import 'package:kids/VideoLearning/BirdVideo.dart';
import 'package:kids/VideoLearning/FlowerVideo.dart';
import 'package:kids/VideoLearning/FruitVideo.dart';
import 'package:kids/VideoLearning/MonthVideo.dart';
import 'package:kids/VideoLearning/Number%20video.dart';
import 'package:kids/VideoLearning/ShapeVideo.dart';
import 'package:kids/VideoLearning/VegitableVideo.dart';
import 'package:kids/VideoLearning/colorvideo.dart';

class VideoLearning extends StatefulWidget{
  const VideoLearning({super.key});

  @override
  State<VideoLearning> createState() => _VideoLearningState();
}

class _VideoLearningState extends State<VideoLearning> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: const Color(0xFFFEF7F0),
        title: const Center(child: Text('Video Learning',style: TextStyle(color: Color(0xFF000000),fontFamily: "arlrdbd"),)),
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
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ABCVideo()));
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
                                child: const Center(child: Text('ABC Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>const NumberVideo()));
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
                                child: const Center(child: Text('Number Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                       ),
                     ),
                   ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ColorVideo()));
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
                                child: const Center(child: Text('Color Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                        ),
                      ),
                   ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const ShapeVideo()));
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
                                child: const Center(child: Text('Shape Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                      ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const AnimalVideo()));
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
                                child: const Center(child: Text('Animal Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                       ),
                     ),
                   ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const BirdVideo()));
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
                                child: const Center(child: Text('Bird Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                       ),
                     ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const FlowerVideo()));
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
                                child: const Center(child: Text('Flower Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                       ),
                     ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const FruitVideo()));
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
                                child: const Center(child: Text('Fruit Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                       ),
                     ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const MonthVideo()));
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
                                child: const Center(child: Text('Month Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                       ),
                    ),
                  ),
                  InkWell(
                    splashColor: Colors.orange[100],
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> const VegitableVideo()));
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
                                child: const Center(child: Text('Vegetable Video',style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 18),))),                          ]
                       ),
                     ),
                   )
                 ]
              ),
           ),
        ],
      ),
    );
  }
}



