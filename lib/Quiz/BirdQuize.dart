import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/utils/model.dart';
import 'package:motion_toast/motion_toast.dart';
import 'ABCQuize.dart';



class Birdquiz extends StatefulWidget{
  const Birdquiz({super.key});

  @override
  State<Birdquiz> createState() => _BirdquizState();
}
List<Numbermodel> bridslist =BRIDS1();
class _BirdquizState extends State<Birdquiz> {
  bool isPressed = false;
  Color istrue = const Color(0xFFF19335);
  Color isWrong = const Color(0xFFFF0000);
  Color btnColor = Colors.blue;
  int score = 0;
  @override
  Widget build(BuildContext context) {
    PageController controller = PageController(initialPage: 0);
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          backgroundColor: const Color(0xFFFEF7F0),
          title: const Center(child: Text('Alphabet',style: TextStyle(fontFamily: "arlrdbd",color: Colors.black),)),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: PageView.builder(
                  controller: controller,
                  onPageChanged: (page){
                    isPressed = false;
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount:birdquestion.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                        Image.asset(bridslist[index].image,height: 180,),
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                          ],
                        ),
                        Expanded(
                          child: GridView.count(
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(50),
                            mainAxisSpacing: 20,
                            crossAxisSpacing: 20,
                            crossAxisCount: 2,
                            primary: false,
                            children: [
                              for(int i = 0;i<birdquestion [index].answer.length;i++)
                                MaterialButton(
                                  shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20.0),),
                                  elevation: 10.0,
                                  minWidth: double.infinity,
                                  color: isPressed ? birdquestion[index].answer.entries.toList()[i].value?istrue:isWrong:Colors.white,
                                  padding: const EdgeInsets.symmetric(vertical:18.0),
                                  onPressed: isPressed?(){}
                                      :(){
                                    if(birdquestion[index].answer.entries.toList()[i].value){
                                      setState(() {
                                        isPressed = true;
                                      }
                                      );
                                      score +=  1;
                                      print(score);
                                      MotionToast.success(
                                          borderRadius: 5,
                                          animationDuration: const Duration(seconds: 3),
                                          description: const Text("Your Answer is Right",style: TextStyle(fontSize: 20),)).show(context);
                                    }else{
                                      setState(() {
                                        isPressed = true;
                                      }
                                      );
                                      MotionToast.error(
                                          borderRadius: 5,
                                          animationDuration: const Duration(seconds: 3),
                                          description: const Text("Your Answer is Wrong",style: TextStyle(fontSize: 20),)).show(context);
                                    }
                                  },
                                  child: Text(
                                    birdquestion[index].answer.keys.toList()[i],
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontFamily: "arlrdbd",
                                        fontSize: 20.0
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Align(
                              heightFactor: 2.7,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                ),
                                onPressed: isPressed ? index + 1== birdquestion.length
                                    ?(){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultSrceen(score, category: 'birds', total: birdquestion.length)));
                                }
                                    :(){
                                  controller.nextPage(duration: const Duration(microseconds: 500), curve: Curves.linear);
                                }:null,
                                child: Text(
                                  index + 1 == birdquestion.length? "See Result":"Next Question",
                                  style: const TextStyle(
                                    fontSize: 20.0,
                                    color: Colors.black,
                                    fontFamily: "arlrdbd",
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        )
    );
  }
}
