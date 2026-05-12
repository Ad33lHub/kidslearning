
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kids/core/db/app_database.dart';
import 'package:kids/core/db/quiz_scores_repository.dart';
import 'package:kids/utils/model.dart';
import 'package:motion_toast/motion_toast.dart';
class ABCQuiz extends StatefulWidget{
  const ABCQuiz({super.key});

  @override
  State<ABCQuiz> createState() => _ABCQuizState();
}
List<Numbermodel> kidslist =KidsList1();
class _ABCQuizState extends State<ABCQuiz> {
bool isPressed = false;
bool isselected = false;
// int i;
Color istrue = const Color(0xFFF19335);
Color isWrong = const Color(0xFFFF0000);
Color isselect = Colors.white;
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
                  itemCount:questions.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30.0,
                        ),
                         Image.asset(kidslist[index].image),
                          const Column(
                             crossAxisAlignment: CrossAxisAlignment.center,
                             mainAxisAlignment: MainAxisAlignment.center,
                           ),
                         Expanded(
                           child: GridView.count(
                             padding: const EdgeInsets.all(50),
                             mainAxisSpacing: 20,
                             crossAxisSpacing: 20,
                             physics: const NeverScrollableScrollPhysics(),
                             crossAxisCount: 2,
                             primary: false,
                              children: [
                                for(int i = 0;i<questions [index].answer.length;i++)
                                   MaterialButton(
                                     shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(20.0),side: BorderSide(color: isselect)),
                                           elevation: 10.0,
                                          height: 10,
                                          minWidth: double.infinity,
                                          color: isPressed?questions[index].answer.entries.toList()[i].value?istrue:isWrong:Colors.white,
                                          padding: const EdgeInsets.symmetric(vertical:18.0),
                                          onPressed: isPressed?(){}
                                              :(){
                                            if(questions[index].answer.entries.toList()[i].value){
                                            setState(() {
                                                isPressed = true;
                                                }
                                              );
                                              score +=  1;
                                              print(score);
                                              MotionToast.success(
                                                  borderRadius: 5,
                                                  animationDuration: const Duration(seconds: 2),
                                                  description: const Text("Your Answer is Right",style: TextStyle(fontSize: 20),)).show(context);
                                            }else{
                                              setState(() {
                                                isPressed = true;
                                                }
                                              );
                                              MotionToast.error(
                                                  borderRadius: 5,
                                                  animationDuration: const Duration(seconds: 2),
                                                  description: const Text("Your Answer is Wrong",style: TextStyle(fontSize: 20),)).show(context);
                                            }
                                          },
                                          child: Text(
                                             questions[index].answer.keys.toList()[i],
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
                                heightFactor: 3,
                                child: OutlinedButton(
                                    style: OutlinedButton.styleFrom(
                                      shape: BeveledRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: isPressed ? index + 1== questions.length
                                        ?(){
                                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ResultSrceen(score)));
                                    }
                                        :(){
                                      controller.nextPage(duration: const Duration(microseconds: 500), curve: Curves.linear);
                                    }:null,
                                    child: Text(
                                      index + 1 == questions.length? "See Result":"Next Question",
                                      style: const TextStyle(
                                        fontSize: 20.0,
                                          color: Colors.black,
                                          fontFamily: "arlrdbd",
                                      ),
                                    ),

                                  ),
                              ),
                            ],
                          ),
                      ],
                    );
                  },
                ),
              ),
          ],
        ),
      ),

    );
  }
}
class ResultSrceen extends StatefulWidget{
  final int score;
  const ResultSrceen(this.score, {super.key});
  @override
  _ResultSrceenState createState() => _ResultSrceenState();
}
class _ResultSrceenState extends State<ResultSrceen> {
  @override
  void initState() {
    super.initState();
    _persistScore();
  }

  Future<void> _persistScore() async {
    final db = await AppDatabase.instance.database;
    await QuizScoresRepository(db).record(
      category: 'alphabet',
      score: widget.score,
      total: questions.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Center(child: Text("Congratulation",style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 38.0),)),
          const Center(child: Text("Your Score is:",style: TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 25.0,fontWeight: FontWeight.w500),)),

          const SizedBox(height: 50.0,),
          Center(child: Text("${widget.score}",style: const TextStyle(color: Colors.black,fontFamily: "arlrdbd",fontSize: 80.0),))
        ],
      ),

    );
  }
}